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
    int128 constant MAX = 0x4000000000000000;

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
        bool testHalts;
    }

    event log(bytes32);
    event log_int(bytes32, int256);
    event log_ints(bytes32, int256[]);
    event log_uint(bytes32, uint256);
    event log_uints(bytes32, uint256[]);

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

                if (fee_ > MAX) fee_ = MAX;

                fee_ = fee_.mul(_feeSection);

            } else fee_ = 0;

        } else {

            int128 _threshold = _ideal.mul(ONE + _beta);

            if (_bal > _threshold) {

                int128 _feeSection = _bal.sub(_threshold);

                fee_ = _feeSection.div(_ideal);
                fee_ = fee_.mul(_delta);

                if (fee_ > MAX) fee_ = MAX;

                fee_ = fee_.mul(_feeSection);

            } else fee_ = 0;

        }

    }

    function calculateTargetTrade (
        Shell storage shell,
        uint _oIx,
        int128 _tAmt,
        int128 _oGLiq,
        int128 _nGLiq,
        int128[] memory _oBals,
        int128[] memory _nBals
    ) internal returns (int128 oAmt_ , int128 psi_) {

        oAmt_ = _tAmt;

        {

            int128 _lambda = shell.lambda;
            int128 _omega = shell.omega;

            for (uint i = 0; i < 10; i++) {

                psi_ = shell.calculateFee(_nBals, _nGLiq);

                int128 _prev = oAmt_;
                int128 _next = oAmt_ = _omega < psi_
                    ? ( _tAmt.sub(psi_.sub(_omega))).neg()
                    : ( _tAmt.add(_lambda.mul(_omega.sub(psi_)))).neg();

                _nGLiq = _oGLiq.add(_tAmt).add(_next);

                _nBals[_oIx] = _oBals[_oIx].add(_next);

                if (_prev / 1e14 == _next / 1e14) break;

            }


        }

        shell.enforceHalts(_oGLiq, _nGLiq, _oBals, _nBals);

        oAmt_ = oAmt_.mul(ONE + shell.epsilon);

    }


    function calculateOriginTrade (
        Shell storage shell,
        uint _tIx,
        int128 _oAmt,
        int128 _oGLiq,
        int128 _nGLiq,
        int128[] memory _oBals,
        int128[] memory _nBals
    ) internal returns (int128 tAmt_, int128 psi_) {

        tAmt_ = _oAmt;

        {

            int128 _lambda = shell.lambda;
            int128 _omega = shell.omega;

            for (uint i = 0; i < 10; i++) {

                psi_ = shell.calculateFee(_nBals, _nGLiq);

                int128 _prev = tAmt_;
                int128 _next = tAmt_ = _omega < psi_
                    ? ( _oAmt + _omega - psi_ ).neg()
                    : ( _oAmt + _lambda.mul(_omega - psi_)).neg();

                _nGLiq = _oGLiq + _oAmt + _next;

                _nBals[_tIx] = _oBals[_tIx].add(_next);

                if (_prev / 1e14 == _next / 1e14) break;

            }

        }

        shell.enforceHalts(_oGLiq, _nGLiq, _oBals, _nBals);

        tAmt_ = tAmt_.mul(ONE.sub(shell.epsilon));

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
        int128 _oGLiq,
        int128 _nGLiq,
        int128[] memory _oBals,
        int128[] memory _nBals
    ) internal returns (uint256 shells_, int128 omega_) {

        shell.enforceHalts(_oGLiq, _nGLiq, _oBals, _nBals);

        int128 _shells;

        ( _shells, omega_ ) = shell.calculateLiquidityMembrane(_oGLiq, _nGLiq, _nBals);

        shells_ = _shells.mulu(1e18);

    }

    function calculateSelectiveWithdraw (
        Shells.Shell storage shell,
        int128 _oGLiq,
        int128 _nGLiq,
        int128[] memory _oBals,
        int128[] memory _nBals
    ) internal returns (uint256 shells_, int128 omega_) {

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

        if (!shell.testHalts) {
            // emit log("skipping halts");
            return;
        }

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