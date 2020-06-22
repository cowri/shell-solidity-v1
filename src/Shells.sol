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
        int128 _gLiq,
        int128[] memory _bals,
        int128 _beta,
        int128 _delta,
        int128[] memory _weights
    ) internal pure returns (int128 psi_) {

        for (uint i = 0; i < _weights.length; i++) {
            int128 _ideal = _gLiq.unsafe_mul(_weights[i]);
            psi_ += calculateMicroFee(_bals[i], _ideal, _beta, _delta);
        }

    }

    function calculateMicroFee (
        int128 _bal,
        int128 _ideal,
        int128 _beta,
        int128 _delta
    ) internal pure returns (int128 fee_) {

        // emit log('~<>~<>~<>~<>~<>~<>~<>~');

        // emit log_int("_bal", _bal.muli(1e6));
        // emit log_int("_ideal", _ideal.muli(1e6));
        // emit log_int("_beta", _beta.muli(1e6));
        // emit log_int("_delta", _delta.muli(1e6));

        if (_bal < _ideal) {

            int128 _threshold = _ideal.unsafe_mul(ONE - _beta);

            if (_bal < _threshold) {

                int128 _feeSection = _threshold - _bal;

                fee_ = _feeSection.unsafe_div(_ideal);
                fee_ = fee_.unsafe_mul(_delta);

                if (fee_ > MAX) fee_ = MAX;

                fee_ = fee_.unsafe_mul(_feeSection);

            } else fee_ = 0;

        } else {

            int128 _threshold = _ideal.unsafe_mul(ONE + _beta);

            if (_bal > _threshold) {

                int128 _feeSection = _bal - _threshold;

                fee_ = _feeSection.unsafe_div(_ideal);
                fee_ = fee_.unsafe_mul(_delta);

                if (fee_ > MAX) fee_ = MAX;

                fee_ = fee_.unsafe_mul(_feeSection);

            } else fee_ = 0;

        }

    }

    function calculateTrade (
        Shell storage shell,
        int128 _oGLiq,
        int128 _nGLiq,
        int128[] memory _oBals,
        int128[] memory _nBals,
        int128 _lAmt,
        uint _rIx
    ) internal returns (int128 rAmt_ , int128 psi_) {

        rAmt_ = _lAmt;

        int128 _lambda = shell.lambda;
        int128 _omega = shell.omega;
        int128 _beta = shell.beta;
        int128 _delta = shell.delta;
        int128[] memory _weights = shell.weights;

        for (uint i = 0; i < 32; i++) {

            psi_ = calculateFee(_nGLiq, _nBals, _beta, _delta, _weights);

            if ( ( rAmt_ = _omega < psi_
                    ? - ( _lAmt + _omega - psi_ )
                    : - ( _lAmt + _lambda.unsafe_mul(_omega - psi_))
                 ) / 1e13 == rAmt_ / 1e13 ) {

                _nGLiq = _oGLiq + _lAmt + rAmt_;

                _nBals[_rIx] = _oBals[_rIx] + rAmt_;

                enforceHalts(shell, _oGLiq, _nGLiq, _oBals, _nBals, _weights);

                return ( rAmt_, psi_ );

            } else {

                _nGLiq = _oGLiq + _lAmt + rAmt_;

                _nBals[_rIx] = _oBals[_rIx].add(rAmt_);

            }

        }

        revert("Shell/swap-convergence-failed");

    }

    function calculateLiquidityMembrane (
        Shell storage shell,
        int128 _oGLiq,
        int128 _nGLiq,
        int128[] memory _oBals,
        int128[] memory _nBals
    ) internal returns (int128 shells_, int128 psi_) {

        shell.enforceHalts(_oGLiq, _nGLiq, _oBals, _nBals, shell.weights);

        psi_ = calculateFee(_nGLiq, _nBals, shell.beta, shell.delta, shell.weights);

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

    function enforceHalts (
        Shell storage shell,
        int128 _oGLiq,
        int128 _nGLiq,
        int128[] memory _oBals,
        int128[] memory _nBals,
        int128[] memory _weights
    ) internal {

        // emit log("enforce halts");
        // emit log_int("MAX", MAX.muli(1e18));

        // emit log_int("_oGLiq", _oGLiq.muli(1e18));
        // for (uint i = 0; i < _oBals.length; i++) emit log_int("_oBals[i]", _oBals[i].muli(1e18));
        // emit log_int("_nGLiq", _nGLiq.muli(1e18));
        // for (uint i = 0; i < _nBals.length; i++) emit log_int("_nBals[i]", _nBals[i].muli(1e18));

        // if (!shell.testHalts) {
        //     // emit log("skipping halts");
        //     return;
        // }

        uint256 _length = _nBals.length;
        int128 _alpha = shell.alpha;

        for (uint i = 0; i < _length; i++) {

            int128 _nIdeal = _nGLiq.unsafe_mul(_weights[i]);

            if (_nBals[i] > _nIdeal) {

                int128 _upperAlpha = ONE + _alpha;

                int128 _nHalt = _nIdeal.unsafe_mul(_upperAlpha);

                if (_nBals[i] > _nHalt){

                    int128 _oHalt = _oGLiq.unsafe_mul(_weights[i]).unsafe_mul(_upperAlpha);

                    if (_oBals[i] < _oHalt) revert("Shell/upper-halt");
                    if (_nBals[i] - _nHalt > _oBals[i] - _oHalt) revert("Shell/upper-halt");

                }

            } else {

                int128 _lowerAlpha = ONE - _alpha;

                int128 _nHalt = _nIdeal.unsafe_mul(_lowerAlpha);

                if (_nBals[i] < _nHalt){

                    int128 _oHalt = _oGLiq.unsafe_mul(_weights[i]).unsafe_mul(_lowerAlpha);

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