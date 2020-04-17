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

    /// @dev executes the origin trade. refer to Loihi.bin swapByOrigin and transferByOrigin for detailed explanation of paramters
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

        uint256[] memory _weights = weights;
        address[] memory _reserves = reserves;

        (uint256[] memory _balances, uint256 _grossLiq) = getBalancesAndGrossLiq(_reserves);

        uint256 _oNAmt = dViewNumeraireAmount(_o.adapter, _oAmt);
        uint256 _tNAmt = getTargetAmount(_grossLiq, _o.reserve, _t.reserve, _oNAmt, _balances, _weights, _reserves);

        require(dViewRawAmount(_t.adapter, _tNAmt) >= _minTAmt, "target amount is less than min target amount");

        dIntakeRaw(_o.adapter, _oAmt);
        uint256 tAmt_ = dOutputNumeraire(_t.adapter, _recipient, _tNAmt);
        emit Trade(msg.sender, _origin, _target, _oAmt, tAmt_);

        return tAmt_;

    }

    /// @dev executes the target trade. refer to Loihi.bin swapByTarget and transferByTarget for detailed explanation of parameters
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

        uint256 _tNAmt;
        uint256 _oNAmt;

        {
            uint256[] memory _weights = weights;
            address[] memory _reserves = reserves;

            (uint256[] memory _balances, uint256 _grossLiq) = getBalancesAndGrossLiq(_reserves);

            _tNAmt = dViewNumeraireAmount(_t.adapter, _tAmt);
            _oNAmt = getOriginAmount(_grossLiq, _o.reserve, _t.reserve, _tNAmt, _balances, _weights, _reserves);
        }

        require(dViewRawAmount(_o.adapter, _oNAmt) <= _maxOAmt, "origin amount is greater than max origin amount");

        dOutputRaw(_t.adapter, _recipient, _tAmt);
        uint256 oAmt_ = dIntakeNumeraire(_o.adapter, _oNAmt);

        emit Trade(msg.sender, _origin, _target, oAmt_, _tAmt);

        return oAmt_;

    }

    /// @dev this function figures out the origin amount
    /// @return tNAmt_ target amount
    function getTargetAmount (uint256 _grossLiq, address _oRsrv, address _tRsrv, uint256 _oNAmt, uint256[] memory _balances, uint256[] memory _weights, address[] memory _reserves) internal returns (uint256 tNAmt_) {

        tNAmt_ = omul(_oNAmt, OCTOPUS-epsilon);
        
        uint256 _oNFAmt = tNAmt_;
        uint256 _psi;
        uint256 _nGLiq;
        uint256 _omega = omega; // 1787 gas savings
        uint256 _lambda = lambda;
        for (uint j = 0; j < 10; j++) {

            _psi = 0;
            _nGLiq = _grossLiq + _oNAmt - tNAmt_;

            for (uint i = 0; i < _reserves.length; i++) {
                address _rsrv = _reserves[i];
                uint256 _nIdeal = omul(_nGLiq, _weights[i]);
                if (_rsrv == _oRsrv) _psi += makeFee(_balances[i] + _oNAmt, _nIdeal);
                else if (_rsrv == _tRsrv) _psi += makeFee(_balances[i] - tNAmt_, _nIdeal);
                else _psi += makeFee(_balances[i], _nIdeal);
            }

            if (_omega < _psi) { // 32.7k gas savings against 10^13/10^14 vs 10^10
                if ((tNAmt_ = _oNFAmt + _omega - _psi) / 100000000000000 == tNAmt_ / 100000000000000) break;
            } else {
                if ((tNAmt_ = _oNFAmt + omul(_lambda, _omega - _psi)) / 100000000000000 == tNAmt_ / 100000000000000) break;
            }
        }

        omega = _psi;

        {
            uint256 _alpha = alpha; // 400-800 gas savings
            for (uint i = 0; i < _balances.length; i++) {
                if (_reserves[i] == _oRsrv) {
                    require(add(_balances[i], _oNAmt) < omul(omul(_nGLiq, _weights[i]), OCTOPUS + _alpha), "origin halt check");
                    continue; // 480 - 1415 gas savings
                } else if (_reserves[i] == _tRsrv) require(sub(_balances[i], tNAmt_) > omul(omul(_nGLiq, _weights[i]), OCTOPUS - _alpha), "target halt check");
            }
        }

        tNAmt_ = omul(tNAmt_, OCTOPUS-epsilon);

    }

    /// @dev this function figures out the origin amount
    /// @return oNAmt_ origin amount
    function getOriginAmount (uint256 _grossLiq, address _oRsrv, address _tRsrv, uint256 _tNAmt, uint256[] memory _balances, uint256[] memory _weights, address[] memory _reserves) internal returns (uint256 oNAmt_) {

        oNAmt_ = omul(_tNAmt, OCTOPUS+epsilon);

        uint256 _tNFAmt = oNAmt_;
        uint256 _psi;
        uint256 _nGLiq;
        uint256 _omega = omega;
        uint256 _lambda = lambda;
        for (uint j = 0; j < 10; j++) {

            _psi = 0;
            _nGLiq = _grossLiq + oNAmt_ - _tNAmt;

            for (uint i = 0; i < _reserves.length; i++) {
                address _rsrv = _reserves[i];
                uint256 _nIdeal = omul(_nGLiq, _weights[i]);
                if (_rsrv == _oRsrv) _psi += makeFee(_balances[i] + oNAmt_, _nIdeal);
                else if (_rsrv == _tRsrv) _psi += makeFee(_balances[i] - _tNAmt, _nIdeal);
                else _psi += makeFee(_balances[i], _nIdeal);
            }

            if (_omega < _psi) {
                if ((oNAmt_ = _tNFAmt + _psi - _omega) / 100000000000000 == oNAmt_ / 100000000000000) break;
            } else {
                if ((oNAmt_ = _tNFAmt - omul(_lambda, _omega - _psi)) / 100000000000000 == oNAmt_ / 100000000000000) break;
            }
        }

        omega = _psi;

        {
            uint256 _alpha = alpha;
            for (uint i = 0; i < _balances.length; i++) {
                if (_reserves[i] == _oRsrv) {
                    require(add(_balances[i], oNAmt_) < omul(omul(_nGLiq, _weights[i]), OCTOPUS + _alpha), "origin halt check");
                    continue;
                } else if (_reserves[i] == _tRsrv) require(sub(_balances[i], _tNAmt) > omul(omul(_nGLiq, _weights[i]), OCTOPUS - _alpha), "target halt check");
            }
        }

        oNAmt_ = omul(oNAmt_, OCTOPUS+epsilon);

    }

    /// @notice this function makes our fees!
    /// @return fee_ the fee.
    function makeFee (uint256 _bal, uint256 _ideal) internal view returns (uint256 fee_) {

        uint256 _threshold;
        uint256 _beta = beta;
        uint256 _delta = delta;
        if (_bal < (_threshold = omul(_ideal, OCTOPUS-_beta))) {
            fee_ = odiv(_delta, _ideal);
            fee_ = omul(fee_, (_threshold = sub(_threshold, _bal)));
            fee_ = omul(fee_, _threshold);
        } else if (_bal > (_threshold = omul(_ideal, OCTOPUS+_beta))) {
            fee_ = odiv(_delta, _ideal);
            fee_ = omul(fee_, (_threshold = sub(_bal, _threshold)));
            fee_ = omul(fee_, _threshold);
        } else fee_ = 0;

    }

    function getBalancesAndGrossLiq (address[] memory _reserves) internal returns (uint256[] memory, uint256 grossLiq_) {
        uint256[] memory balances_ = new uint256[](_reserves.length);
        for (uint i = 0; i < _reserves.length; i++) {
            address _rsrv = _reserves[i];
            balances_[i] = dViewNumeraireBalance(_rsrv, address(this));
            grossLiq_ += balances_[i];
        }
        return (balances_, grossLiq_);
    }

}