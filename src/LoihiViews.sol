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

pragma solidity ^0.5.15;

import "./LoihiRoot.sol";
import "./LoihiDelegators.sol";

contract LoihiViews is LoihiRoot, LoihiDelegators {

    function viewTargetAmount (uint256 _oAmt, address _oAdptr, address _tAdptr, address _this, address[] memory _rsrvs, address _oRsrv, address _tRsrv, uint256[] memory _weights, uint256[] memory _globals) public view returns (uint256 tNAmt_) {

        require(_oAdptr != address(0), "origin flavor not supported");
        require(_tAdptr != address(0), "target flavor not supported");

        if (_oRsrv == _tRsrv) {
            uint256 _oNAmt = dViewNumeraireAmount(_oAdptr, _oAmt);
            return dViewRawAmount(_tAdptr, _oNAmt);
        }

        uint256 _oNAmt = dViewNumeraireAmount(_oAdptr, _oAmt);

        uint256 _grossLiq;
        uint256[] memory _balances = new uint256[](_rsrvs.length);
        for (uint i = 0; i < _rsrvs.length; i++) {
            _balances[i] = dViewNumeraireBalance(_rsrvs[i], _this);
            _grossLiq += _balances[i];
        }

        tNAmt_ = wmul(_oNAmt, WAD-_globals[3]);
        uint256 _oNFAmt = tNAmt_;
        uint256 _psi;
        uint256 _nGLiq;
        for (uint j = 0; j < 10; j++) {
            _psi = 0;
            _nGLiq = _grossLiq + _oNAmt - tNAmt_;
            for (uint i = 0; i < _balances.length; i++) {
                if (_rsrvs[i] == _oRsrv) _psi += makeFee(add(_balances[i], _oNAmt), wmul(_nGLiq, _weights[i]), _globals[1], _globals[2]);
                else if (_rsrvs[i] == _tRsrv) _psi += makeFee(sub(_balances[i], tNAmt_), wmul(_nGLiq, _weights[i]), _globals[1], _globals[2]);
                else _psi += makeFee(_balances[i], wmul(_nGLiq, _weights[i]), _globals[1], _globals[2]);
            }

            if (_globals[5] < _psi) {
                if ((tNAmt_ = _oNFAmt + _globals[5] - _psi) / 10000000000 == tNAmt_ / 10000000000) break;
            } else {
                if ((tNAmt_ = _oNFAmt + wmul(_globals[4], _globals[5] - _psi)) / 10000000000 == tNAmt_ / 10000000000) break;
            }

        }

        for (uint i = 0; i < _balances.length; i++) {
            uint256 _ideal = wmul(_nGLiq, _weights[i]);
            if (_rsrvs[i] == _oRsrv) require(_balances[i] + _oNAmt < wmul(_ideal, WAD + _globals[0]), "origin halt check");
            if (_rsrvs[i] == _tRsrv) require(_balances[i] - tNAmt_ > wmul(_ideal, WAD - _globals[0]), "target halt check");
        }

        tNAmt_ = wmul(tNAmt_, WAD-_globals[3]);

        return dViewRawAmount(_tAdptr, tNAmt_);

    }

    function viewOriginAmount (uint256 _tAmt, address _tAdptr, address _oAdptr, address _this, address[] memory _rsrvs, address _tRsrv, address _oRsrv, uint256[] memory _weights, uint256[] memory _globals) public view returns (uint256 oNAmt_) {


        require(_oAdptr != address(0), "origin flavor not supported");
        require(_tAdptr != address(0), "target flavor not supported");

        if (_oRsrv == _tRsrv) {
            uint256 _tNAmt = dViewNumeraireAmount(_tAdptr, _tAmt);
            return dViewRawAmount(_oAdptr, _tNAmt);
        }

        uint256 _tNAmt = dViewNumeraireAmount(_tAdptr, _tAmt);

        uint256 _grossLiq;
        uint256[] memory _balances = new uint256[](_rsrvs.length);
        for (uint i = 0; i < _rsrvs.length; i++) {
            _balances[i] = dViewNumeraireBalance(_rsrvs[i], _this);
            _grossLiq += _balances[i];
        }

        oNAmt_ = wmul(_tNAmt, WAD+_globals[3]);
        uint256 _tNFAmt = oNAmt_;
        uint256 _psi;
        uint256 _nGLiq;
        for (uint j = 0; j < 10; j++) {
            _psi = 0;
            _nGLiq = _grossLiq + oNAmt_ - _tNAmt;
            for (uint i = 0; i < _rsrvs.length; i++) {
                if (_rsrvs[i] == _oRsrv) _psi += makeFee(add(_balances[i], oNAmt_), wmul(_nGLiq, _weights[i]), _globals[1], _globals[2]);
                else if (_rsrvs[i] == _tRsrv) _psi += makeFee(sub(_balances[i], _tNAmt), wmul(_nGLiq, _weights[i]), _globals[1], _globals[2]);
                else _psi += makeFee(_balances[i], wmul(_nGLiq, _weights[i]), _globals[1], _globals[2]);
            }

            if (_globals[5] < _psi) {
                if ((oNAmt_ = _tNFAmt + _psi - _globals[5]) / 10000000000 == oNAmt_ / 10000000000) break;
            } else {
                if ((oNAmt_ = _tNFAmt - wmul(_globals[4], _globals[5] - _psi)) / 10000000000 == oNAmt_ / 10000000000) break;
            }

        }

        for (uint i = 0; i < _balances.length; i++) {
            uint256 _ideal = wmul(_nGLiq, _weights[i]);
            if (_rsrvs[i] == _oRsrv) require(_balances[i] + oNAmt_ < wmul(_ideal, WAD + _globals[0]), "origin halt check");
            if (_rsrvs[i] == _tRsrv) require(_balances[i] - _tNAmt > wmul(_ideal, WAD - _globals[0]), "target halt check");
        }

        oNAmt_ = wmul(oNAmt_, WAD+_globals[3]);

        return dViewRawAmount(_oAdptr, oNAmt_);

    }

    function makeFee (uint256 _bal, uint256 _ideal, uint256 _beta, uint256 _delta) internal view returns (uint256 _fee) {

        uint256 threshold;
        if (_bal < (threshold = wmul(_ideal, WAD-_beta))) {
            _fee = wdiv(_delta, _ideal);
            _fee = wmul(_fee, (threshold = sub(threshold, _bal)));
            _fee = wmul(_fee, threshold);
        } else if (_bal > (threshold = wmul(_ideal, WAD+_beta))) {
            _fee = wdiv(_delta, _ideal);
            _fee = wmul(_fee, (threshold = sub(_bal, threshold)));
            _fee = wmul(_fee, threshold);
        } else _fee = 0;

    }

    function viewSelectiveWithdraw (address[] calldata _rsrvs, address[] calldata _flvrs, uint256[] calldata _amts, address _this, uint256[] calldata _weights, uint256[] calldata _globals) external view returns (uint256) {

        (uint256[] memory _balances, uint256[] memory _withdrawals) = viewBalancesAndAmounts(_rsrvs, _flvrs, _amts, _this);

        uint256 shellsBurned_;

        uint256 _nSum; uint256 _oSum;
        for (uint i = 0; i < _balances.length; i++) {
            _nSum = add(_nSum, sub(_balances[i], _withdrawals[i]));
            _oSum = add(_oSum, _balances[i]);
        }

        uint256 _psi = viewBurnFees(_balances, _withdrawals, _globals, _weights, _nSum, _oSum);

        if (_globals[5] < _psi) {
            uint256 _oUtil = sub(_oSum, _globals[5]);
            uint256 _nUtil = sub(_nSum, _psi);
            if (_oUtil == 0) return wmul(_nUtil, WAD+_globals[3]);
            shellsBurned_ = wdiv(wmul(sub(_oUtil, _nUtil), _globals[6]), _oUtil);
        } else {
            uint256 _oUtil = sub(_oSum, _globals[5]);
            uint256 _nUtil = sub(_nSum, wmul(_psi, _globals[4]));
            if (_oUtil == 0) return wmul(_nUtil, WAD+_globals[3]);
            uint256 _oUtilPrime = wmul(_globals[5], _globals[4]);
            _oUtilPrime = sub(_oSum, _oUtilPrime);
            shellsBurned_ = wdiv(wmul(sub(_oUtilPrime, _nUtil), _globals[6]), _oUtil);
        }

        return wmul(shellsBurned_, WAD+_globals[3]);

    }

    function viewSelectiveDeposit (address[] calldata _rsrvs, address[] calldata _flvrs, uint256[] calldata _amts, address _this, uint256[] calldata _weights, uint256[] calldata _globals) external view returns (uint256) {

        (uint256[] memory _balances, uint256[] memory _deposits) = viewBalancesAndAmounts(_rsrvs, _flvrs, _amts, _this);

        uint256 shellsMinted_;

        uint256 _nSum; uint256 _oSum;
        for (uint i = 0; i < _balances.length; i++) {
            _nSum = add(_nSum, add(_balances[i], _deposits[i]));
            _oSum = add(_oSum, _balances[i]);
        }

        require(_oSum < _nSum, "insufficient-deposit");

        uint256 _psi = viewMintFees(_balances, _deposits, _globals, _weights, _nSum, _oSum);

        if (_globals[5] < _psi) {
            uint256 _oUtil = sub(_oSum, _globals[5]);
            uint256 _nUtil = sub(_nSum, _psi);
            if (_oUtil == 0 || _globals[6] == 0) return wmul(_nUtil, WAD-_globals[3]);
            shellsMinted_ = wdiv(wmul(sub(_nUtil, _oUtil), _globals[6]), _oUtil);
        } else {
            uint256 _oUtil = sub(_oSum, _globals[5]);
            uint256 _nUtil = sub(_nSum, wmul(_psi, _globals[4]));
            if (_oUtil == 0 || _globals[6] == 0) return wmul(_nUtil, WAD-_globals[3]);
            uint256 _oUtilPrime = wmul(_globals[5], _globals[4]);
            _oUtilPrime = sub(_oSum, _oUtilPrime);
            shellsMinted_ = wdiv(wmul(sub(_nUtil, _oUtilPrime), _globals[6]), _oUtil);
        }

        return wmul(shellsMinted_, WAD-_globals[3]);
    }

    function viewMintFees (uint256[] memory _balances, uint256[] memory _deposits, uint256[] memory _globals, uint256[] memory _weights, uint256 _nSum, uint256 _oSum) public view returns (uint256 psi_) {

        for (uint i = 0; i < _balances.length; i++) {
            uint256 _nBal = add(_balances[i], _deposits[i]);
            uint256 _nIdeal = wmul(_nSum, _weights[i]);
            require(_nBal <= wmul(_nIdeal, WAD + _globals[0]), "deposit upper halt check");
            require(_nBal >= wmul(_nIdeal, WAD - _globals[0]), "deposit lower halt check");
            psi_ += makeFee(_nBal, _nIdeal, _globals[1], _globals[2]);
        }

    }

    function viewBurnFees (uint256[] memory _balances, uint256[] memory _withdrawals, uint256[] memory _globals, uint256[] memory _weights, uint256 _nSum, uint256 _oSum) public view returns (uint256 psi_) {

        for (uint i = 0; i < _balances.length; i++) {
            uint256 _nBal = sub(_balances[i], _withdrawals[i]);
            uint256 _nIdeal = wmul(_nSum, _weights[i]);
            require(_nBal <= wmul(_nIdeal, WAD + _globals[0]), "withdraw upper halt check");
            require(_nBal >= wmul(_nIdeal, WAD - _globals[0]), "withdraw lower halt check");
            psi_ += makeFee(_nBal, _nIdeal, _globals[1], _globals[2]);
        }

    }


    function viewBalancesAndAmounts (address[] memory _rsrvs, address[] memory _flvrs, uint256[] memory _amts, address _this) private view returns (uint256[] memory, uint256[] memory) {

        uint256[] memory balances_ = new uint256[](_rsrvs.length);
        uint256[] memory amounts_ = new uint256[](_rsrvs.length);

        for (uint i = 0; i < _flvrs.length/2; i++) {
            require(_flvrs[i*2] != address(0), "flavor not supported");
            for (uint j = 0; j < _rsrvs.length; j++) {
                if (balances_[j] == 0) balances_[j] = dViewNumeraireBalance(_rsrvs[j], _this);
                if (_rsrvs[j] == _flvrs[i*2+1] && _amts[i] > 0) amounts_[j] += dViewNumeraireAmount(_flvrs[i*2], _amts[i]);
            }
        }

        return (balances_, amounts_);

    }

    function totalReserves (address[] calldata _reserves, address _addr) external view returns (uint256, uint256[] memory) {
        uint256 totalBalance_;
        uint256[] memory balances_ = new uint256[](_reserves.length);
        for (uint i = 0; i < _reserves.length; i++) {
            balances_[i] = dViewNumeraireBalance(_reserves[i], _addr);
            totalBalance_ += balances_[i];
        }
        return (totalBalance_, balances_);
    }

}