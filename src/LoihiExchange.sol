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

contract LoihiExchange is LoihiRoot, LoihiDelegators {

    /// @dev executes the origin trade
    /// @return tAmt_ the target amount
    function executeOriginTrade (uint256 _deadline, uint256 _minTAmt, address _recipient, address _origin, address _target, uint256 _oAmt) external returns (uint256) {

        Flavor memory _o = flavors[_origin];
        Flavor memory _t = flavors[_target];

        require(_o.adapter != address(0), "origin flavor not supported");
        require(_t.adapter != address(0), "target flavor not supported");

        if (_o.reserve == _t.reserve) {
            uint256 _oNAmt = dIntakeRaw(_o.adapter, _oAmt);
            uint256 tAmt_ = dOutputNumeraire(_t.adapter, _recipient, _oNAmt);
            emit Trade(msg.sender, _origin, _target, _oAmt, tAmt_);
            return tAmt_;
        }

        (uint256[] memory _balances, uint256 _grossLiq) = getBalancesAndGrossLiq();

        uint256 _oNAmt = dViewNumeraireAmount(_o.adapter, _oAmt);
        uint256 _tNAmt = getTargetAmount(_o.reserve, _t.reserve, _oNAmt, _balances, _grossLiq);

        require(dViewRawAmount(_t.adapter, _tNAmt) >= _minTAmt, "target amount is less than min target amount");

        dIntakeRaw(_o.adapter, _oAmt);
        uint256 tAmt_ = dOutputNumeraire(_t.adapter, _recipient, _tNAmt);
        emit Trade(msg.sender, _origin, _target, _oAmt, tAmt_);

        return tAmt_;

    }

    /// @author james foley http://github.com/realisation
    /// @dev executes the target trade
    /// @return oAmt_ origin amount
    function executeTargetTrade (uint256 _deadline, address _origin, address _target, uint256 _maxOAmt, uint256 _tAmt, address _recipient) external returns (uint256) {
        require(_deadline >= now, "deadline has passed for this trade");

        Flavor memory _o = flavors[_origin];
        Flavor memory _t = flavors[_target];

        require(_o.adapter != address(0), "origin flavor not supported");
        require(_t.adapter != address(0), "target flavor not supported");

        if (_o.reserve == _t.reserve) {
            uint256 _tNAmt = dOutputRaw(_t.adapter, _recipient, _tAmt);
            uint256 oAmt_ = dIntakeNumeraire(_o.adapter, _tNAmt);
            emit Trade(msg.sender, _origin, _target, oAmt_, _tAmt);
            return oAmt_;
        }

        (uint256[] memory _balances, uint256 _grossLiq) = getBalancesAndGrossLiq();

        uint256 _tNAmt = dViewNumeraireAmount(_t.adapter, _tAmt);
        uint256 _oNAmt = getOriginAmount(_o.reserve, _t.reserve, _tNAmt, _balances, _grossLiq);

        require(dViewRawAmount(_o.adapter, _oNAmt) <= _maxOAmt, "origin amount is greater than max origin amount");

        dOutputRaw(_t.adapter, _recipient, _tAmt);
        uint256 oAmt_ = dIntakeNumeraire(_o.adapter, _oNAmt);

        emit Trade(msg.sender, _origin, _target, oAmt_, _tAmt);

        return oAmt_;

    }

    /// @author james foley http://github.com/realisation
    /// @dev this function figures out the origin amount
    function getTargetAmount (address _oRsrv, address _tRsrv, uint256 _oNAmt, uint256[] memory _balances, uint256 _grossLiq) internal returns (uint256 tNAmt_) {

        tNAmt_ = wmul(_oNAmt, WAD-epsilon);
        uint256 _oNFAmt = tNAmt_;
        uint256 _psi;
        uint256 _nGLiq;
        for (uint j = 0; j < 10; j++) {

            _psi = 0;
            _nGLiq = _grossLiq + _oNAmt - tNAmt_;

            for (uint i = 0; i < reserves.length; i++) {
                uint256 _nIdeal = wmul(_nGLiq, weights[i]);
                if (reserves[i] == _oRsrv) _psi += makeFee(add(_balances[i], _oNAmt), _nIdeal);
                else if (reserves[i] == _tRsrv) _psi += makeFee(sub(_balances[i], tNAmt_), _nIdeal);
                else _psi += makeFee(_balances[i], _nIdeal);
            }

            if (omega < _psi) {
                if ((tNAmt_ = _oNFAmt + omega - _psi) / 10000000000 == tNAmt_ / 10000000000) break;
            } else {
                if ((tNAmt_ = _oNFAmt + wmul(lambda, omega - _psi)) / 10000000000 == tNAmt_ / 10000000000) break;
            }
        }

        omega = _psi;

        for (uint i = 0; i < _balances.length; i++) {
            if (reserves[i] == _oRsrv) require(add(_balances[i], _oNAmt) < wmul(wmul(_nGLiq, weights[i]), WAD + alpha), "origin halt check");
            if (reserves[i] == _tRsrv) require(sub(_balances[i], tNAmt_) > wmul(wmul(_nGLiq, weights[i]), WAD - alpha), "target halt check");
        }

        tNAmt_ = wmul(tNAmt_, WAD-epsilon);

    }

    /// @author james foley http://github.com/realisation
    /// @dev this function figures out the origin amount
    function getOriginAmount (address _oRsrv, address _tRsrv, uint256 _tNAmt, uint256[] memory _balances, uint256 _grossLiq) internal returns (uint256 oNAmt_) {

        oNAmt_ = wmul(_tNAmt, WAD+epsilon);
        uint256 _tNFAmt = oNAmt_;
        uint256 _psi;
        uint256 _nGLiq;
        for (uint j = 0; j < 10; j++) {

            _psi = 0;
            _nGLiq = _grossLiq + oNAmt_ - _tNAmt;

            for (uint i = 0; i < reserves.length; i++) {
                uint256 _nIdeal = wmul(_nGLiq, weights[i]);
                if (reserves[i] == _oRsrv) _psi += makeFee(add(_balances[i], oNAmt_), _nIdeal);
                else if (reserves[i] == _tRsrv) _psi += makeFee(sub(_balances[i], _tNAmt), _nIdeal);
                else _psi += makeFee(_balances[i], _nIdeal);
            }

            if (omega < _psi) {
                if ((oNAmt_ = _tNFAmt + _psi - omega) / 10000000000 == oNAmt_ / 10000000000) break;
            } else {
                if ((oNAmt_ = _tNFAmt - wmul(lambda, omega - _psi)) / 10000000000 == oNAmt_ / 10000000000) break;
            }
        }

        omega = _psi;

        for (uint i = 0; i < _balances.length; i++) {
            if (reserves[i] == _oRsrv) require(add(_balances[i], oNAmt_) < wmul(wmul(_nGLiq, weights[i]), WAD + alpha), "origin halt check");
            if (reserves[i] == _tRsrv) require(sub(_balances[i], _tNAmt) > wmul(wmul(_nGLiq, weights[i]), WAD - alpha), "target halt check");
        }

        oNAmt_ = wmul(oNAmt_, WAD+epsilon);

    }

    /// @author james foley http://github.com/realisation
    /// @notice this function makes our fees!
    /// @return fee_ the fee.
    function makeFee (uint256 _bal, uint256 _ideal) internal view returns (uint256 fee_) {

        uint256 _threshold;
        if (_bal < (_threshold = wmul(_ideal, WAD-beta))) {
            fee_ = wdiv(delta, _ideal);
            fee_ = wmul(fee_, (_threshold = sub(_threshold, _bal)));
            fee_ = wmul(fee_, _threshold);
        } else if (_bal > (_threshold = wmul(_ideal, WAD+beta))) {
            fee_ = wdiv(delta, _ideal);
            fee_ = wmul(fee_, (_threshold = sub(_bal, _threshold)));
            fee_ = wmul(fee_, _threshold);
        } else fee_ = 0;

    }

    function getBalancesAndGrossLiq () internal returns (uint256[] memory, uint256 grossLiq_) {
        uint256[] memory balances_ = new uint256[](reserves.length);
        for (uint i = 0; i < reserves.length; i++) {
            balances_[i] = dViewNumeraireBalance(reserves[i], address(this));
            grossLiq_ += balances_[i];
        }
        return (balances_, grossLiq_);
    }

}