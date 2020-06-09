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

import "abdk-libraries-solidity/ABDKMath64x64.sol";

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

    int128 constant ONE = 0x10000000000000000;

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    using Assimilators for Assimilators.Assimilator;

    using Shells for Shell;

    using SafeERC20Arithmetic for uint256;

    event Transfer(address indexed from, address indexed to, uint256 value);

    struct Shell {
        int128 alpha;
        int128 beta;
        int128 delta;
        int128 epsilon;
        int128 lambda;
        int128 omega;
        int128 max;
        int128[] weights;
        Assimilators.Assimilator[] numeraires;
        Assimilators.Assimilator[] reserves;
        mapping (address => Assimilators.Assimilator) assimilators;
        mapping (address => uint256) balances;
        mapping (address => mapping (address => uint256)) allowances;
        uint256 totalSupply;
    }

    event log_int(bytes32, int256);
    event log_uint(bytes32, uint256);

    function calculateFee (
        Shell storage shell,
        int128[] memory _bals,
        int128 _grossLiq
    ) internal returns (int128 psi_) {

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
    ) internal returns (int128 fee_) {

        if (_bal < _ideal) {

            int128 _threshold = _ideal.mul(ONE - _beta);

            if (_bal < _threshold) {

                int128 _feeSection = _threshold.sub(_bal);

                fee_ = _feeSection.div(_ideal);
                fee_ = fee_.mul(_delta);

                if (fee_ > .25e18) fee_ = .25e18;

                fee_ = fee_.mul(_feeSection);

            } else fee_ = 0;

        } else {

            int128 _threshold = _ideal.mul(ONE + _beta);

            if (_bal > _threshold) {

                int128 _feeSection = _bal.sub(_threshold);

                fee_ = _feeSection.div(_ideal);
                fee_ = fee_.mul(_delta);

                if (fee_ > .25e18) fee_ = .25e18;

                fee_ = fee_.mul(_feeSection);

            } else fee_ = 0;

        }

    }


    function calculateTargetTrade (
        Shell storage shell,
        Assimilators.Assimilator[] memory assims_
    ) internal returns (Assimilators.Assimilator[] memory, int128 psi_) {

        (   int128 _oGLiq,
            int128 _nGLiq,
            int128[] memory _oBals,
            int128[] memory _nBals  ) = shell.getPoolData(assims_);

        {

            int128 _lambda = shell.lambda;
            int128 _omega = shell.omega;
            uint256 _oIx = assims_[0].ix;

            for (uint i = 0; i < 10; i++) {

                psi_ = shell.calculateFee(_nBals, _nGLiq);

                int128 _prev = assims_[0].amt;
                int128 _next = assims_[0].amt = _omega < psi_
                    ? ( assims_[1].amt.sub(psi_.sub(_omega)) ).neg()
                    : ( assims_[1].amt.add(_lambda.mul(_omega.sub(psi_))) ).neg();

                _nGLiq = _oGLiq.add(assims_[1].amt).add(_next);

                _nBals[_oIx] = _oBals[_oIx].add(_next);

                if (_prev / 1e14 == _next / 1e14) break;

            }


        }

        shell.enforceHalts(_oGLiq, _nGLiq, _oBals, _nBals);

        assims_[0].amt = assims_[0].amt.mul(ONE.add(shell.epsilon));

        return (assims_, psi_);

    }

    function calculateOriginTrade (
        Shell storage shell,
        Assimilators.Assimilator[] memory assims_
    ) internal returns (Assimilators.Assimilator[] memory, int128 psi_) {

        (   int128 _oGLiq,
            int128 _nGLiq,
            int128[] memory _oBals,
            int128[] memory _nBals  ) = shell.getPoolData(assims_);

        {
            int128 _lambda = shell.lambda;
            int128 _omega = shell.omega;
            uint256 _tIx = assims_[1].ix;

            for (uint i = 0; i < 10; i++) {

                psi_ = shell.calculateFee(_nBals, _nGLiq);

                int128 _prev = assims_[1].amt;
                int128 _next = assims_[1].amt = _omega < psi_
                    ? ( assims_[0].amt + _omega - psi_ ).neg()
                    : ( assims_[0].amt + _lambda.mul(_omega - psi_) ).neg();

                _nGLiq = _oGLiq + assims_[0].amt + _next;

                _nBals[_tIx] = _oBals[_tIx].add(_next);

                if (_prev / 1e14 == _next / 1e14) break;

            }

        }

        shell.enforceHalts(_oGLiq, _nGLiq, _oBals, _nBals);

        assims_[1].amt = assims_[1].amt.mul(ONE.sub(shell.epsilon));

        return (assims_, psi_);

    }


    function getPoolData (
        Shell storage shell,
        Assimilators.Assimilator[] memory _assims
    ) internal returns (int128 oGLiq_, int128 nGLiq_, int128[] memory, int128[] memory) {

        int128[] memory oBals_ = new int128[](shell.reserves.length);
        int128[] memory nBals_ = new int128[](shell.reserves.length);

        for (uint i = 0; i <= _assims.length; i++) {

            for (uint j = 0; j < shell.reserves.length; j++) {

                if (i < _assims.length && _assims[i].ix == j) {

                    if (nBals_[j] == 0) {

                        int128 _bal = _assims[i].bal;
                        nBals_[j] = oBals_[j] = _bal;
                        oGLiq_ = oGLiq_.add(_bal);
                        nGLiq_ = nGLiq_.add(_bal);

                    }

                    int128 _amt = _assims[i].amt;
                    oGLiq_ = oGLiq_.sub(_amt);
                    oBals_[j] = oBals_[j].sub(_amt);

                    break;

                } else if (i == _assims.length && nBals_[j] == 0 && oBals_[j] == 0) {

                    int128 _bal = shell.reserves[j].viewNumeraireBalance();

                    nBals_[j] = oBals_[j] = _bal;
                    nGLiq_ = nGLiq_.add(_bal);
                    oGLiq_ = oGLiq_.add(_bal);

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
    ) internal returns (int128 shells_, int128 psi_) {

        psi_ = shell.calculateFee(_bals, _nGLiq);

        int128 _omega = shell.omega;
        int128 _feeDiff = psi_.sub(_omega);
        int128 _liqDiff = _nGLiq.sub(_oGLiq);
        int128 _oUtil = _oGLiq.sub(_omega);

        if (_feeDiff >= 0) {

            if (_oGLiq == 0) shells_ = _nGLiq.sub(psi_);
            else shells_ = _liqDiff.sub(_feeDiff).div(_oUtil);

        } else {

            if (_oGLiq == 0) shells_ = _nGLiq.sub(psi_);
            else shells_ = _liqDiff.sub(shell.lambda.mul(_feeDiff)).div(_oUtil);

        }

        if ( shell.totalSupply != 0 ) shells_ = shells_.mul(shell.totalSupply.divu(1e18));

    }

    function calculateSelectiveDeposit (
        Shells.Shell storage shell,
        Assimilators.Assimilator[] memory _assims
    ) internal returns (uint256 shells_, int128 omega_) {

        (   int128 _oGLiq,
            int128 _nGLiq,
            int128[] memory _oBals,
            int128[] memory _nBals  ) = shell.getPoolData(_assims);

        shell.enforceHalts(_oGLiq, _nGLiq, _oBals, _nBals);

        int128 _shells;

        ( _shells, omega_ ) = shell.calculateLiquidityMembrane(_oGLiq, _nGLiq, _nBals);

        shells_ = _shells.mulu(1e18);

    }

    function calculateSelectiveWithdraw (
        Shells.Shell storage shell,
        Assimilators.Assimilator[] memory _assims
    ) internal returns (uint256 shells_, int128 omega_) {

        (   int128 _oGLiq,
            int128 _nGLiq,
            int128[] memory _oBals,
            int128[] memory _nBals  ) = shell.getPoolData(_assims);

        shell.enforceHalts(_oGLiq, _nGLiq, _oBals, _nBals);

        int128 _shells;

        ( _shells, omega_ ) = shell.calculateLiquidityMembrane(_oGLiq, _nGLiq, _nBals);

        shells_ = _shells.abs().mul(ONE.add(shell.epsilon)).mulu(1e18);

    }

    function enforceHalts (
        Shell storage shell,
        int128 _oGLiq,
        int128 _nGLiq,
        int128[] memory _oBals,
        int128[] memory _nBals
    ) internal {

        int128 _alpha = shell.alpha;

        for (uint i = 0; i < _nBals.length; i++) {

            int128 _nIdeal = _nGLiq.mul(shell.weights[i]);

            if (_nBals[i] > _nIdeal) {

                int128 _upperAlpha = ONE.add(_alpha);

                int128 _nHalt = _nIdeal.mul(_upperAlpha);

                if (_nBals[i] > _nHalt){

                    int128 _oHalt = _oGLiq.mul(shell.weights[i]).mul(_upperAlpha);

                    if (_oBals[i] < _oHalt) revert("Shell/upper-halt");
                    if (_nBals[i] - _nHalt > _oBals[i] - _oHalt) revert("Shell/upper-halt");

                }

            } else {

                int128 _lowerAlpha = ONE.sub(_alpha);

                int128 _nHalt = _nIdeal.mul(_lowerAlpha);

                if (_nBals[i] < _nHalt){

                    int128 _oHalt = _oGLiq.mul(shell.weights[i]).mul(_lowerAlpha);

                    if (_oBals[i] > _oHalt) revert("Shell/lower-halt");
                    if (_nHalt - _nBals[i] > _oHalt - _oBals[i]) revert("Shel/lower-halt");

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