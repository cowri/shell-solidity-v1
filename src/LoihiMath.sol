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

pragma solidity >0.4.13;

import "./LoihiRoot.sol";

library LoihiMath {

    function calculateFee (LoihiRoot.Shell storage shell, uint256[] memory _bals, uint256 _grossLiq) internal returns (uint util_) {

        // uint256 _beta = shell.beta;
        // uint256 _delta = shell.delta;
        // uint256[] memory _weights = shell.weights;

        // for (uint i = 0; i < _weights.length; i++) {
        //     uint256 _ideal = _grossLiq.omul(_weights[i]);
        //     util_ += calculateMicroFee(_bals[i], _ideal, _beta, _delta);
        // }

    }

    function calculateMicroFee (uint256 _bal, uint256 _ideal, uint256 _beta, uint256 _delta) internal returns (uint fee_) {

        // if (_bal < _ideal) {
            
        //     uint256 _threshold = _ideal.omul(OCTOPUS - _beta);

        //     if (_bal < _threshold) {
        //         uint256 _feeSection = _threshold.sub(_bal);
        //         fee_ = _feeSection.odiv(_ideal);
        //         fee_ = fee_.omul(_delta);
        //         if (fee_ > 25e16) fee_ = 25e16;
        //         fee_ = fee_.omul(_feeSection);
        //     } else fee_ = 0;

        // } else {

        //     uint256 _threshold = _ideal.omul(OCTOPUS + _beta);

        //     if (_bal > _threshold) {
        //         uint256 _feeSection = _bal.sub(_threshold);
        //         fee_ = _feeSection.odiv(_ideal);
        //         fee_ = fee_.omul(_delta);
        //         if (fee_ > 25e16) fee_ = 25e16;
        //         fee_ = fee_.omul(_feeSection);
        //     } else fee_ = 0;

        // }

    }

    function calculateSwap (LoihiRoot.Shell storage shell, uint256[] memory _bals, uint256 _nGLiq, uint256 _oIx, uint256 _tIx, bool _origin) internal returns (uint256, uint256) {

        // uint256 psi_;
        // uint256 _omega = shell.omega;
        // uint256 _lambda = shell.lambda;

        // for (uint8 i = 0; i < 10; i++) {

        //     psi_ = shell.calculateFee(_bals, _nGLiq);

        //     uint256 _prev;
        //     uint256 _next;

        //     if (_origin) {
        //         _prev = _bals[_tIx];
        //         _next = _bals[_tIx] = _bals[_oIx] + _omega - psi_;
        //     } else {
        //         _prev = _bals[_oIx];
        //         _next = _bals[_oIx] = _bals[_tIx] - _omega + psi_;
        //     }

        //     _nGLiq += _prev - _next;
        //     if (_prev / 1e14 == _next / 1e14) break;
            
        // }

        // if (_origin) return (_bals[_oIx], psi_);
        // else return (_bals[_tIx], psi_);

    }

    function getTxData (LoihiRoot.Shell storage shell, LoihiRoot.Assimilator[] memory _inputs, bool _additive) internal returns (uint256, uint256, uint256[] memory, uint256[] memory) {

        // uint256 oGLiq_;
        // uint256 nGLiq_;
        // uint256[] memory oBals_ = new uint256[](shell.reserves.length);
        // uint256[] memory nBals_ = new uint256[](shell.reserves.length);

        // for (uint8 i = 0; i < _inputs.length; i++) {
        //     for (uint j = 0; j < shell.reserves.length; j++) {
        //         if (_inputs[i].ix == j) {

        //             if (oBals_[j] == 0) {
        //                 oGLiq_ += oBals_[j] = shell.reserves[j].viewNumeraireBalance();
        //                 nGLiq_ += nBals_[j] = oBals[j];
        //             }

        //             uint256 _amount = _inputs[i].addr.viewNumeraireAmount(_inputs[i].amount);

        //             nBals_[j] += _additive ? (_amount) : (-_amount);
        //             nGLiq += _additive ? _amount : (-_amount);

        //         }
        //     }
        // }

        // return (oGLiq_, nGLiq_, oBals_, nBals_);

    }
    
    function calculateMembrane (LoihiRoot.Shell storage shell, uint256[] memory _bals, uint256 _oGLiq, uint256 _nGLiq) internal returns (int256 shells_, int256 _psi) {

        // psi_ = shell.calculateFee(_bals, _nGLiq);

        // int256 _omega = shell.omega;
        // int256 _feeDiff = psi_ - _omega;
        // int256 _liqDiff = _nGLiq - _oGLiq;
        // int256 _oUtil = _oSum.sub(_omega);

        // if (_feeDiff > 0) {

        //     if (_oGLiq == 0) shells_ = _nGLiq.sub(psi_);
        //     else shells_ = _liqDiff.sub(_feeDiff).div(_oGLiq.sub(_omega));

        // } else {

        //     if (_oGLiq == 0) shells_ = _nGLiq.sub(psi_);
        //     else shells_ = _liqDiff.sub(shell.lambda.omul(_feeDiff)).div(_oGLiq.sub(_omega));
            
        // }

    }

    function enforceHalts (LoihiRoot.Shell storage shell, uint256 _oGLiq, uint256 _nGLiq, uint256[] memory _oBals, uint256[] memory _nBals) internal {

        // uint256 _alpha = shell.alpha;
        // for (uint i = 0; i < _nBals.length; i++) {
        //     uint256 _nIdeal = _nGLiq.omul(shell.weights[i]);

        //     if (_nBals[i] > _nIdeal) {

        //         uint256 _nHalt = _nIdeal.omul(OCTOPUS + _alpha);

        //         if (_nBals[i] > _nHalt){
        //             uint256 _oHalt = _oGLiq.omul(shell.weights).omul(OCTOPUS + _alpha);
        //             if (_oBal < _oHalt) revert("upper-halt");
        //             if (_nBal - _nHalt > _oBal - _oHalt) revert("upper-halt");
        //         }

        //     } else {

        //         uint256 _nHalt = _nIdeal.omul(OCTOPUS - _alpha);

        //         if (_nBals[i] < _nHalt){
        //             uint256 _oHalt = _oGLiq.omul(shell.weights[i]).omul(OCTOPUS - _alpha);
        //             if (_oBal < _oHalt) revert("upper-halt");
        //             if (_nHalt - _nBal > _oHalt - oBal) revert("upper-halt");
        //         }

        //     }
        // }
    }

    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "loihi-math-add-overflow");
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, "loihi-math-sub-underflow");
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "loihi-math-mul-overflow");
    }

    uint constant OCTOPUS = 1e18;

    function omul(uint x, uint y) internal pure returns (uint z) {
        z = ((x*y) + (OCTOPUS/2)) / OCTOPUS;
    }

    function odiv(uint x, uint y) internal pure returns (uint z) {
        z = ((x*OCTOPUS) + (y/2)) / y;
    }

    function somul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), OCTOPUS / 2) / OCTOPUS;
    }

    function sodiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, OCTOPUS), y / 2) / y;
    }

}
