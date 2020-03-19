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

    event log_addr(bytes32, address);

    function viewOriginTrade (address _origin, address _target, uint256 _oAmt) external view returns (uint256) {

        // Flavor memory _o = flavors[_origin];
        // Flavor memory _t = flavors[_target];

        // require(_o.adapter != address(0), "origin flavor not supported");
        // require(_t.adapter != address(0), "target flavor not supported");

        // if (_o.reserve == _t.reserve) {
        //     uint256 _oNAmt = dViewNumeraireAmount(_o.adapter, _oAmt);
        //     return dViewRawAmount(_t.adapter, _oNAmt);
        // }

        // (uint256[] memory _balances, uint256 _grossLiq) = viewBalancesAndGrossLiq();

        // uint256 _oNAmt = dViewNumeraireAmount(_o.adapter, _oAmt);
        // _oNAmt = wmul(_oNAmt, WAD-(epsilon/2));
        // uint256 _tNAmt = getTargetAmount(_o.reserve, _t.reserve, _oNAmt, _balances, _grossLiq);
        // _tNAmt = wmul(_tNAmt, WAD-(epsilon/2));

        // return dViewRawAmount(_t.adapter, _tNAmt);

    }

    /// @notice given an origin amount this function will find the corresponding target amount according to the contracts state and make the swap between the two
    /// @param _origin the address of the origin flavor
    /// @param _target the address of the target flavor
    /// @param _oAmt the raw amount of the origin flavor - will be converted to numeraire amount
    /// @param _minTAmt the minimum target amount you are willing to accept for this trade
    /// @param _deadline the block by which this transaction is no longer valid
    /// @param _recipient the address for where to send the resultant target amount
    /// @return tNAmt_ the target numeraire amount
    function executeOriginTrade (uint256 _deadline, uint256 _minTAmt, address _recipient, address _origin, address _target, uint256 _oAmt) external returns (uint256) {

        Flavor memory _o = flavors[_origin]; // origin adapter + reserve + weight
        Flavor memory _t = flavors[_target]; // target adapter + weight

        require(_o.adapter != address(0), "origin flavor not supported");
        require(_t.adapter != address(0), "target flavor not supported");

        if (_o.reserve == _t.reserve) {
            uint256 _oNAmt = dIntakeRaw(_o.adapter, _oAmt);
            uint256 tAmt_ = dOutputNumeraire(_t.adapter, _recipient, _oNAmt);
            emit Trade(msg.sender, _origin, _target, _oAmt, tAmt_);
            return tAmt_;
        }

        (uint256[] memory _balances, uint256 _grossLiq) = getBalancesAndGrossLiq();

        uint256 _oNAmt = dGetNumeraireAmount(_o.adapter, _oAmt);
        // emit log_uint("_oNAmt before fee", _oNAmt);
        // _oNAmt = wmul(_oNAmt, WAD-(epsilon/2));
        // _oNAmt = wmul(_oNAmt, WAD-(epsilon));
        // emit log_uint("_oNAmt after fee", _oNAmt);
        uint256 _tNAmt = getTargetAmount(_o.reserve, _t.reserve, _oNAmt, _balances, _grossLiq);
        // emit log_uint("_tNAmt before fee", _tNAmt);
        // _tNAmt = wmul(_tNAmt, WAD-(epsilon/2));
        // _tNAmt = wmul(_tNAmt, WAD-(epsilon));
        // emit log_uint("_tNAmt after fee", _tNAmt);

        dIntakeRaw(_o.adapter, _oAmt);
        uint256 tAmt_ = dOutputNumeraire(_t.adapter, _recipient, _tNAmt);
        emit Trade(msg.sender, _origin, _target, _oAmt, tAmt_);
        return tAmt_;

    }


    /// @author james foley http://github.com/realisation
    /// @notice given an amount of the target currency this function will derive the corresponding origin amount according to the current state of the contract
    /// @param _deadline the block number at which this transaction is no longer valid
    /// @param _origin the address of the origin stablecoin flavor
    /// @param _target the address of the target stablecoin flavor
    /// @param _maxOAmt the highest amount of the origin stablecoin flavor you are willing to trade
    /// @param _tAmt the raw amount of the target stablecoin flavor to be converted into numeraire amount
    /// @param _recipient the address for where to send the target amount
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

        uint256 _tNAmt = dGetNumeraireAmount(_t.adapter, _tAmt);
        uint256 _oNAmt = getOriginAmount(_o.reserve, _t.reserve, _tNAmt, _balances, _grossLiq);

        require(dViewRawAmount(_o.adapter, _oNAmt) <= _maxOAmt, "origin amount is greater than max origin amount");

        dOutputRaw(_t.adapter, _recipient, _tAmt);
        uint256 oAmt_ = dIntakeNumeraire(_o.adapter, _oNAmt);

        emit Trade(msg.sender, _origin, _target, oAmt_, _tAmt);

        return oAmt_;

    }

    function viewTargetTrade (address _origin, address _target, uint256 _tAmt) external view returns (uint256) {

        // Flavor memory _o = flavors[_origin];
        // Flavor memory _t = flavors[_target];

        // require(_o.adapter != address(0), "origin flavor not supported");
        // require(_t.adapter != address(0), "target flavor not supported");

        // if (_o.reserve == _t.reserve) {
        //     uint256 _tNAmt = dViewNumeraireAmount(_t.adapter, _tAmt);
        //     return dViewRawAmount(_o.adapter, _tNAmt);
        // }

        // (uint256[] memory _balances, uint256 _grossLiq) = viewBalancesAndGrossLiq();

        // uint256 _tNAmt = dViewNumeraireAmount(_t.adapter, _tAmt);
        // uint256 _oNAmt = getOriginAmount(_o.reserve, _t.reserve, _tNAmt, _balances, _grossLiq);
        // _oNAmt = wmul(_oNAmt, WAD + epsilon);

        // return dViewRawAmount(_o.adapter, _oNAmt);

    }

    event log_uints (bytes32, uint256[]);
    function getTargetAmount (address _oRsrv, address _tRsrv, uint256 _oNAmt, uint256[] memory _balances, uint256 _grossLiq) internal returns (uint256 tNAmt_) {
        
        tNAmt_ = wmul(_oNAmt, WAD-(epsilon/2));
        uint256 _oNFAmt = tNAmt_;
        uint256 _oFees;
        uint256 _nFees;
        uint256 _nGLiq;
        for (uint j = 0; j < 10; j++) {
            _nFees = 0;
            for (uint i = 0; i < reserves.length; i++) {
                if (j == 0) _oFees += makeFee(_balances[i], wmul(_grossLiq, weights[i]));
                if (i == 0) _nGLiq = _grossLiq + _oNAmt - tNAmt_;
                uint256 _nIdeal = wmul(_nGLiq, weights[i]);
                if (reserves[i] == _oRsrv) _nFees += makeFee(_balances[i] + _oNAmt, _nIdeal);
                else if (reserves[i] == _tRsrv) _nFees += makeFee(_balances[i] - tNAmt_, _nIdeal);
                else _nFees += makeFee(_balances[i], _nIdeal);
            }
            if ((tNAmt_ = _oNFAmt + _oFees - _nFees) / 10000000000 == tNAmt_ / 10000000000) break;
        }

        if (_oFees > _nFees) tNAmt_ = add(_oNFAmt, wmul(lambda, sub(_oFees, _nFees)));

        for (uint i = 0; i < _balances.length; i++) {
            uint256 _ideal = wmul(_nGLiq, weights[i]);
            if (reserves[i] == _oRsrv) require(_balances[i] + _oNAmt < wmul(_ideal, WAD + alpha), "origin halt check");
            if (reserves[i] == _tRsrv) require(_balances[i] - tNAmt_ > wmul(_ideal, WAD - alpha), "target halt check");
        }

        tNAmt_ = wmul(tNAmt_, WAD-(epsilon/2));

    }

    function getOriginAmount (address _oRsrv, address _tRsrv, uint256 _tNAmt, uint256[] memory _balances, uint256 _grossLiq) internal returns (uint256 oNAmt_) {

        oNAmt_ = wmul(_tNAmt, WAD+(epsilon/2));
        uint256 _tNFAmt = oNAmt_;
        uint256 _oFees;
        uint256 _nFees;
        uint256 _nGLiq;
        for (uint j = 0; j < 10; j++) {
            _nFees = 0;
            for (uint i = 0; i < reserves.length; i++) {
                if (j == 0) _oFees += makeFee(_balances[i], wmul(_grossLiq, weights[i]));
                if (i == 0) _nGLiq = _grossLiq + oNAmt_ - _tNAmt;
                uint256 _nIdeal = wmul(_nGLiq, weights[i]);
                if (reserves[i] == _oRsrv) _nFees += makeFee(_balances[i] + oNAmt_, _nIdeal);
                else if (reserves[i] == _tRsrv) _nFees += makeFee(_balances[i] - _tNAmt, _nIdeal);
                else _nFees += makeFee(_balances[i], _nIdeal);
            }
            if ((oNAmt_ = _tNFAmt + _nFees - _oFees) / 10000000000 == oNAmt_ / 10000000000) break;
        }

        if (_oFees > _nFees) oNAmt_ = sub(_tNFAmt, wmul(lambda, sub(_oFees, _nFees)));

        for (uint i = 0; i < _balances.length; i++) {
            uint256 _ideal = wmul(_nGLiq, weights[i]);
            if (reserves[i] == _oRsrv) require(_balances[i] + oNAmt_ < wmul(_ideal, WAD + alpha), "origin halt check");
            if (reserves[i] == _tRsrv) require(_balances[i] - _tNAmt > wmul(_ideal, WAD - alpha), "target halt check");
        }

        oNAmt_ = wmul(oNAmt_, WAD+(epsilon/2));

    }

    event log_uint(bytes32, uint256);

    function makeFee (uint256 _bal, uint256 _ideal) public returns (uint256 _fee) {

        uint256 threshold;
        if (_bal < (threshold = wmul(_ideal, WAD-beta))) {
            _fee = wdiv(delta, _ideal);
            _fee = wmul(_fee, (threshold = sub(threshold, _bal)));
            _fee = wmul(_fee, threshold);
        } else if (_bal > (threshold = wmul(_ideal, WAD+beta))) {
            _fee = wdiv(delta, _ideal);
            _fee = wmul(_fee, (threshold = sub(_bal, threshold)));
            _fee = wmul(_fee, threshold);
        } else _fee = 0;

    }

    function getBalancesAndGrossLiq () internal returns (uint256[] memory, uint256 grossLiq_) {
        uint256[] memory balances_ = new uint256[](reserves.length);
        for (uint i = 0; i < reserves.length; i++) {
            balances_[i] = dGetNumeraireBalance(reserves[i]);
            grossLiq_ += balances_[i];
        }
        return (balances_, grossLiq_);
    }

    function viewBalancesAndGrossLiq () internal view returns (uint256[] memory, uint256 grossLiq_) {
        uint256[] memory balances_ = new uint256[](reserves.length);
        for (uint i = 0; i < reserves.length; i++) {
            balances_[i] = dViewNumeraireBalance(reserves[i], address(this));
            grossLiq_ += balances_[i];
        }
    }

}