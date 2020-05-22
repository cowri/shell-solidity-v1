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

    function calculateFee (
        LoihiRoot.Shell storage shell,
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

            int128 _threshold = _ideal.mul(OCTOPUS - _beta);

            if (_bal < _threshold) {
                int128 _feeSection = _threshold.sub(_bal);
                fee_ = _feeSection.odiv(_ideal);
                fee_ = fee_.mul(_delta);
                if (fee_ > 25e16) fee_ = 25e16;
                fee_ = fee_.mul(_feeSection);
            } else fee_ = 0;

        } else {

            int128 _threshold = _ideal.mul(OCTOPUS + _beta);

            if (_bal > _threshold) {
                int128 _feeSection = _bal.sub(_threshold);
                fee_ = _feeSection.odiv(_ideal);
                fee_ = fee_.mul(_delta);
                if (fee_ > 25e16) fee_ = 25e16;
                fee_ = fee_.mul(_feeSection);
            } else fee_ = 0;

        }

    }

    function calculateTargetSwap (
        LoihiRoot.Shell storage shell,
        int128[] memory _bals,
        int128 _oGLiq,
        int128 _nGLiq,
        uint256 _oIx,
        uint256 _tIx,
        int128 _lambda,
        int128 _omega
    ) internal view returns (int128, int128 psi_) {

        for (uint8 i = 0; i < 10; i++) {

            psi_ = shell.calculateFee(_bals, _nGLiq);

            int128 _prev = _bals[_oIx];
            int128 _next = _bals[_oIx] = _omega < psi
                ? _bals[_tIx] + psi_ - _omega
                : _bals[_tIx] - _lambda.mul(_omega - psi_);

            _nGLiq = _oGLiq + _prev - _next;

            if (_prev / 1e14 == _next / 1e14) break;

        }

        return (_bals[_oIx], psi_);

    }

    function calculateOriginSwap (
        LoihiRoot.Shell storage shell,
        int128[] memory _bals,
        int128 _oGLiq,
        int128 _nGLiq,
        uint256 _oIx,
        uint256 _tIx,
        int128 _lambda,
        int128 _omega
    ) internal view returns (int128, int128 psi_) {

        for (uint8 i = 0; i < 10; i++) {

            psi_ = shell.calculateFee(_bals, _nGLiq);

            int128 _prev = _bals[_tIx];
            int128 _next = _bals[_tIx] = _omega < psi_
                ? _bals[_oIx] + _omega - psi_
                : _bals[_oIx] + _lambda.mul(_omega - psi_);

            _nGLiq = _oGLiq + _prev - _next;

            if (_prev / 1e14 == _next / 1e14) break;

        }

        return (_bals[_tIx], psi_);

    }

    function getPoolData (
        LoihiRoot.Shell storage shell,
        LoihiRoot.Assimilator[] memory _inputs
    ) internal view returns (int128 oGLiq_, int128 nGLiq_, int128[] memory, int128[] memory) {

        int128[] memory oBals_ = new int128[](shell.reserves.length);
        int128[] memory nBals_ = new int128[](shell.reserves.length);

        for (uint8 i = 0; i < _inputs.length; i++) {
            for (uint j = 0; j < shell.reserves.length; j++) {
                if (_inputs[i].ix == j) {

                    if (oBals_[j] == 0) {
                        oGLiq_ += oBals_[j] = shell.reserves[j].viewNumeraireBalance();
                        nGLiq_ += nBals_[j] = oBals[j];
                    }

                    nBals_[j] = nBals_[j].add(_inputs[i].amount);
                    nGLiq_ = nGLiq_.add(_inputs[i].amount);

                    break;
                }
            }
        }

        return (oGLiq_, nGLiq_, oBals_, nBals_);

    }

    function calculateLiquidityMembrane (
        LoihiRoot.Shell storage shell,
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
        LoihiRoot.Shell storage shell,
        int128 _oGLiq,
        int128 _nGLiq,
        int128[] memory _oBals,
        int128[] memory _nBals
    ) internal view {

        int128 _alpha = shell.alpha;
        for (uint i = 0; i < _nBals.length; i++) {
            int128 _nIdeal = _nGLiq.mul(shell.weights[i]);

            if (_nBals[i] > _nIdeal) {

                int128 _nHalt = _nIdeal.mul(OCTOPUS + _alpha);

                if (_nBals[i] > _nHalt){
                    int128 _oHalt = _oGLiq.mul(shell.weights).mul(OCTOPUS + _alpha);
                    if (_oBal < _oHalt) revert("upper-halt");
                    if (_nBal - _nHalt > _oBal - _oHalt) revert("upper-halt");
                }

            } else {

                int128 _nHalt = _nIdeal.mul(OCTOPUS - _alpha);

                if (_nBals[i] < _nHalt){
                    int128 _oHalt = _oGLiq.mul(shell.weights[i]).mul(OCTOPUS - _alpha);
                    if (_oBal < _oHalt) revert("upper-halt");
                    if (_nHalt - _nBal > _oHalt - oBal) revert("upper-halt");
                }
            }
        }

    }

}
