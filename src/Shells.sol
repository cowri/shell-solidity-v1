// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

import "./Assimilators.sol";

pragma solidity >0.4.13;

library SafeERC20Arithmetic {

    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "add-overflow");
    }

    function sub(uint x, uint y, string memory _errorMessage) internal pure returns (uint z) {
        require((z = x - y) <= x, _errorMessage);
    }

}

library Shells {

    int128 constant ZEN = 18446744073709551616000000;

    using ABDKMath64x64 for int128;

    using Assimilators for Assimilators.Assimilator;

    using Shells for Shell;

    using SafeERC20Arithmetic for uint256;

    event ShellsMinted(address indexed minter, uint256 amount, address[] indexed coins, uint256[] amounts);
    event ShellsBurned(address indexed burner, uint256 amount, address[] indexed coins, uint256[] amounts);
    event Trade(address indexed trader, address indexed origin, address indexed target, uint256 originAmount, uint256 targetAmount);

    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);

    struct Shell {
        int128 alpha;
        int128 beta;
        int128 delta;
        int128 epsilon;
        int128 lambda;
        int128 omega;
        int128[] weights;
        address[] numeraires;
        Assimilators.Assimilator[] reserves;
        mapping (address => Assimilators.Assimilator) assimilators;
        mapping (address => uint256) balances;
        mapping (address => mapping (address => uint256)) allowances;
        uint256 totalSupply;
    }

    function calculateFee (
        Shell storage shell,
        int128[] memory _bals,
        int128 _grossLiq
    ) internal view returns (int128 psi_) {

        int128 _beta = shell.beta;
        int128 _delta = shell.delta;
        int128[] memory _weights = shell.weights;

        for (uint i = 0; i < _weights.length; i++) {
            int128 _ideal = _grossLiq.mul(_weights[i]);
            psi_ += calculateMicroFee(_bals[i], _ideal, _beta, _delta);
        }

    }

    function calculateMicroFee (
        int128 _bal,
        int128 _ideal,
        int128 _beta,
        int128 _delta
    ) internal pure returns (int128 fee_) {

        if (_bal < _ideal) {

            int128 _threshold = _ideal.mul(ZEN - _beta);

            if (_bal < _threshold) {
                int128 _feeSection = _threshold.sub(_bal);
                fee_ = _feeSection.div(_ideal);
                fee_ = fee_.mul(_delta);
                if (fee_ > 25e16) fee_ = 25e16;
                fee_ = fee_.mul(_feeSection);
            } else fee_ = 0;

        } else {

            int128 _threshold = _ideal.mul(ZEN + _beta);

            if (_bal > _threshold) {
                int128 _feeSection = _bal.sub(_threshold);
                fee_ = _feeSection.div(_ideal);
                fee_ = fee_.mul(_delta);
                if (fee_ > 25e16) fee_ = 25e16;
                fee_ = fee_.mul(_feeSection);
            } else fee_ = 0;

        }

    }

    function calculateTargetTrade (
        Shell storage shell,
        Assimilators.Assimilator[] memory assims_
    ) internal view returns (Assimilators.Assimilator[] memory, int128 psi_) {

        (   int128 _oGLiq,
            int128 _nGLiq,
            int128[] memory _oBals,
            int128[] memory _nBals  ) = shell.getPoolData(assims_);

        {

            int128 _lambda = shell.lambda;
            int128 _omega = shell.omega;
            uint256 _oIx = assims_[0].ix;
            uint256 _tIx = assims_[1].ix;

            for (uint8 i = 0; i < 10; i++) {

                psi_ = shell.calculateFee(_nBals, _nGLiq);

                int128 _prev = _nBals[_oIx];
                int128 _next = _nBals[_oIx] = _omega < psi_
                    ? _nBals[_tIx] + psi_ - _omega
                    : _nBals[_tIx] - _lambda.mul(_omega - psi_);

                _nGLiq = _oGLiq + _prev - _next;

                if (_prev / 1e14 == _next / 1e14) break;

            }

            assims_[0].amt = _nBals[_oIx];

        }

        shell.enforceHalts(_oGLiq, _nGLiq, _oBals, _nBals);


        return (assims_, psi_);

    }

    function calculateOriginTrade (
        Shell storage shell,
        Assimilators.Assimilator[] memory assims_
    ) internal view returns (Assimilators.Assimilator[] memory, int128 psi_) {

        (   int128 _oGLiq,
            int128 _nGLiq,
            int128[] memory _oBals,
            int128[] memory _nBals  ) = shell.getPoolData(assims_);

        {

            int128 _lambda = shell.lambda;
            int128 _omega = shell.omega;
            uint256 _oIx = assims_[0].ix;
            uint256 _tIx = assims_[1].ix;

            for (uint8 i = 0; i < 10; i++) {

                psi_ = shell.calculateFee(_nBals, _nGLiq);

                int128 _prev = _nBals[_tIx];
                int128 _next = _nBals[_tIx] = _omega < psi_
                    ? _nBals[_oIx] + _omega - psi_
                    : _nBals[_oIx] + _lambda.mul(_omega - psi_);

                _nGLiq = _oGLiq + _prev - _next;

                if (_prev / 1e14 == _next / 1e14) break;

            }

            assims_[1].amt = _nBals[_tIx];

        }

        shell.enforceHalts(_oGLiq, _nGLiq, _oBals, _nBals);


        return (assims_, psi_);

    }

    function getPoolData (
        Shell storage shell,
        Assimilators.Assimilator[] memory _inputs
    ) internal view returns (int128 oGLiq_, int128 nGLiq_, int128[] memory, int128[] memory) {

        int128[] memory oBals_ = new int128[](shell.reserves.length);
        int128[] memory nBals_ = new int128[](shell.reserves.length);

        for (uint8 i = 0; i < _inputs.length; i++) {
            for (uint j = 0; j < shell.reserves.length; j++) {
                if (_inputs[i].ix == j) {

                    if (oBals_[j] == 0) {
                        oGLiq_ += oBals_[j] = shell.reserves[j].viewNumeraireBalance();
                        nGLiq_ += nBals_[j] = oBals_[j];
                    }

                    nBals_[j] = nBals_[j].add(_inputs[i].amt);
                    nGLiq_ = nGLiq_.add(_inputs[i].amt);

                    break;
                }
            }
        }

        return (oGLiq_, nGLiq_, oBals_, nBals_);

    }

    function calculateLiquidityMembrane (
        Shell storage shell,
        int128 _oGLiq,
        int128 _nGLiq,
        int128[] memory _bals
    ) internal view returns (int128 shells_, int128 psi_) {

        psi_ = shell.calculateFee(_bals, _nGLiq);

        int128 _omega = shell.omega;
        int128 _feeDiff = psi_.sub(_omega);
        int128 _liqDiff = _nGLiq.sub(_oGLiq);
        int128 _oUtil = _oGLiq.sub(_omega);

        if (_feeDiff > 0) {

            if (_oGLiq == 0) shells_ = _nGLiq.sub(psi_);
            else shells_ = _liqDiff.sub(_feeDiff).div(_oGLiq.sub(_oUtil));

        } else {

            if (_oGLiq == 0) shells_ = _nGLiq.sub(psi_);
            else shells_ = _liqDiff.sub(shell.lambda.mul(_feeDiff)).div(_oUtil);

        }

    }

    function enforceHalts (
        Shell storage shell,
        int128 _oGLiq,
        int128 _nGLiq,
        int128[] memory _oBals,
        int128[] memory _nBals
    ) internal view {

        int128 _alpha = shell.alpha;

        for (uint i = 0; i < _nBals.length; i++) {

            int128 _nIdeal = _nGLiq.mul(shell.weights[i]);

            if (_nBals[i] > _nIdeal) {

                int128 _nHalt = _nIdeal.mul(ZEN + _alpha);

                if (_nBals[i] > _nHalt){

                    int128 _oHalt = _oGLiq.mul(shell.weights[i]).mul(ZEN + _alpha);

                    if (_oBals[i] < _oHalt) revert("upper-halt");
                    if (_nBals[i] - _nHalt > _oBals[i] - _oHalt) revert("upper-halt");

                }

            } else {

                int128 _nHalt = _nIdeal.mul(ZEN - _alpha);

                if (_nBals[i] < _nHalt){

                    int128 _oHalt = _oGLiq.mul(shell.weights[i]).mul(ZEN - _alpha);

                    if (_oBals[i] < _oHalt) revert("upper-halt");
                    if (_nHalt - _nBals[i] > _oHalt - _oBals[i]) revert("upper-halt");

                }
            }
        }
    }

    function burn (Shell storage shell, address account, uint256 amount) internal {

        shell.balances[account] = shell.balances[account].sub(amount, "Shell/insufficient-shell-balance");

        shell.totalSupply = shell.totalSupply.sub(amount, "Shell/insufficient-total-supply");

        emit Transfer(msg.sender, address(0), amount);

    }

    function mint (Shell storage shell, address account, uint256 amount) internal {

        shell.totalSupply = shell.totalSupply.add(amount);

        shell.balances[account] = shell.balances[account].add(amount);

        emit Transfer(address(0), msg.sender, amount);

    }

}