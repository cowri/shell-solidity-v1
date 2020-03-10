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

    /// @author james foley http://github.com/realisation
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

        uint256 _nAmt = dGetNumeraireAmount(_o.adapter, _oAmt);

        (uint256 _oBal, uint256 _tBal, uint256 _grossLiq) = getBalancesAndGrossLiq(_o.reserve, _t.reserve);

        (uint256 _oFee, uint256 _nFee) = getOriginFees(_oBal, _nAmt, _o.weight, _grossLiq);
        // (uint256 _oFee, uint256 _nFee) = getFees(_oBal, _oBal + _nAmt, _o.weight, _grossLiq);
        if (_oFee > _nFee) _nAmt = add(_nAmt, wmul(arbPiece, sub(_oFee, _nFee)));
        else if (_nFee < _oFee + _nAmt) _nAmt = sub(add(_nAmt, _oFee), _nFee);

        (_oFee, _nFee) = getTargetFees(_tBal, _nAmt, _t.weight, _grossLiq);
        // (_oFee, _nFee) = getFees(_tBal, _tBal - _nAmt, _t.weight, _grossLiq);
        if (_oFee > _nFee) _nAmt = add(_nAmt, wmul(arbPiece, sub(_oFee, _nFee)));
        else if (_nFee < _nAmt - _oFee) _nAmt = sub(add(_nAmt, _oFee), _nFee);

        emit log_uint("_nAmt before fee", _nAmt);
        _nAmt = wmul(_nAmt, WAD - feeBase);
        emit log_uint("_nAmt after fee", _nAmt);

        require(dViewRawAmount(_t.adapter, _nAmt) >= _minTAmt, "target amount is less than minimum target amount");

        dIntakeRaw(_o.adapter, _oAmt);
        uint256 tAmt_ = dOutputNumeraire(_t.adapter, _recipient, _nAmt);
        emit Trade(msg.sender, _origin, _target, _oAmt, tAmt_);
        return tAmt_;

    }

    function getBalancesAndGrossLiq (address _oRsrv, address _tRsrv) private returns (uint256 oBal_, uint256 tBal_, uint256 grossLiq_) {
        for (uint i = 0; i < reserves.length; i++) {
            uint256 _bal = dGetNumeraireBalance(reserves[i]);
            if (reserves[i] == _oRsrv) oBal_ = _bal;
            if (reserves[i] == _tRsrv) tBal_ = _bal;
            grossLiq_ += _bal;
        }
    }

    function getOriginFees (uint256 _oBal, uint256 _nAmt, uint256 _weight, uint256 _grossLiq) private returns (uint256 oFee_, uint256 nFee_) {

        uint256 threshold;

        if (_oBal < (threshold = wmul(_weight, wmul(_grossLiq, WAD-beta)))) {
            oFee_ = wdiv(feeDerivative, wmul(_grossLiq, _weight));
            oFee_ = wmul(oFee_, sub(threshold, _oBal));
            oFee_ = wmul(oFee_, sub(threshold, _oBal));
        } else if (_oBal > (threshold = wmul(_weight, wmul(_grossLiq, WAD+beta)))) {
            oFee_ = wdiv(feeDerivative, wmul(_grossLiq, _weight));
            oFee_ = wmul(oFee_, sub(_oBal, threshold));
            oFee_ = wmul(oFee_, sub(_oBal, threshold));
        } else oFee_ = 0;

        if (_oBal + _nAmt < (threshold = wmul(_weight, wmul(_grossLiq + _nAmt, WAD-beta)))) {
            nFee_ = wdiv(feeDerivative, wmul(_grossLiq + _nAmt, _weight));
            nFee_ = wmul(nFee_, sub(threshold, _oBal + _nAmt));
            nFee_ = wmul(nFee_, sub(threshold, _oBal + _nAmt));
        } else if (_oBal + _nAmt > (threshold = wmul(_weight, wmul(_grossLiq + _nAmt, WAD+beta)))) {
            nFee_ = wdiv(feeDerivative, wmul(_grossLiq + _nAmt, _weight));
            nFee_ = wmul(nFee_, sub(_oBal + _nAmt, threshold));
            nFee_ = wmul(nFee_, sub(_oBal + _nAmt, threshold));
        } else nFee_ = 0;
        
    }
    function getTargetFees (uint256 _oBal, uint256 _nAmt, uint256 _weight, uint256 _grossLiq) private returns (uint256 oFee_, uint256 nFee_) {

        uint256 threshold;

        if (_oBal < (threshold = wmul(_weight, wmul(_grossLiq + _nAmt, WAD-beta)))) {
            oFee_ = wdiv(feeDerivative, wmul(_grossLiq + _nAmt, _weight));
            oFee_ = wmul(oFee_, sub(threshold, _oBal));
            oFee_ = wmul(oFee_, sub(threshold, _oBal));
        } else if (_oBal > (threshold = wmul(_weight, wmul(_grossLiq + _nAmt, WAD+beta)))) {
            oFee_ = wdiv(feeDerivative, wmul(_grossLiq + _nAmt, _weight));
            oFee_ = wmul(oFee_, sub(_oBal, threshold));
            oFee_ = wmul(oFee_, sub(_oBal, threshold));
        } else oFee_ = 0;

        if (_oBal - _nAmt < (threshold = wmul(_weight, wmul(_grossLiq, WAD-beta)))) {
            nFee_ = wdiv(feeDerivative, wmul(_grossLiq, _weight));
            nFee_ = wmul(nFee_, sub(threshold, _oBal - _nAmt));
            nFee_ = wmul(nFee_, sub(threshold, _oBal - _nAmt));
        } else if (_oBal - _nAmt > (threshold = wmul(_weight, wmul(_grossLiq, WAD+beta)))) {
            nFee_ = wdiv(feeDerivative, wmul(_grossLiq, _weight));
            nFee_ = wmul(nFee_, sub(_oBal - _nAmt, threshold));
            nFee_ = wmul(nFee_, sub(_oBal - _nAmt, threshold));
        } else nFee_ = 0;
        
    }
    function getFees (uint256 _oBal, uint256 _nBal, uint256 _weight, uint256 _grossLiq) private returns (uint256 oFee_, uint256 nFee_) {

        uint256 threshold;

        if (_oBal < (threshold = wmul(_weight, wmul(_grossLiq, WAD-beta)))) {
            oFee_ = wdiv(feeDerivative, wmul(_grossLiq, _weight));
            oFee_ = wmul(oFee_, sub(threshold, _oBal));
            oFee_ = wmul(oFee_, sub(threshold, _oBal));
        } else if (_oBal > (threshold = wmul(_weight, wmul(_grossLiq, WAD+beta)))) {
            oFee_ = wdiv(feeDerivative, wmul(_grossLiq, _weight));
            oFee_ = wmul(oFee_, sub(_oBal, threshold));
            oFee_ = wmul(oFee_, sub(_oBal, threshold));
        } else oFee_ = 0;

        if (_nBal < (threshold = wmul(_weight, wmul(_grossLiq, WAD-beta)))) {
            nFee_ = wdiv(feeDerivative, wmul(_grossLiq, _weight));
            nFee_ = wmul(nFee_, sub(threshold, _nBal));
            nFee_ = wmul(nFee_, sub(threshold, _nBal));
        } else if (_nBal > (threshold = wmul(_weight, wmul(_grossLiq, WAD+beta)))) {
            nFee_ = wdiv(feeDerivative, wmul(_grossLiq, _weight));
            nFee_ = wmul(nFee_, sub(_nBal, threshold));
            nFee_ = wmul(nFee_, sub(_nBal, threshold));
        } else nFee_ = 0;
        
    }

    /// @author james foley http://github.com/realisation
    /// @notice builds the relevant variables for a target trade
    /// @param _o the record for the origin flavor containing the address of its adapter and its reserve
    /// @param _t the record for the target flavor containing the address of its adapter and its reserve
    /// @param _oAmt the raw amount of the origin flavor to be converted into numeraire
    /// @return NAmt_ the numeraire amount of the trade before origin and target fees are applied
    /// @return oBal_ the new origin numeraire balance including the origin numeraire amount
    /// @return tBal_ the current numereraire balance of the contracts reserve for the target
    /// @return grossLiq_ total numeraire value across all reserves in the contract
    function getOriginTradeVariables (Flavor memory _o, Flavor memory _t, uint256 _oAmt) private returns (uint, uint, uint, uint) {

        uint oNAmt_ = dGetNumeraireAmount(_o.adapter, _oAmt);
        uint oBal_ = dGetNumeraireBalance(_o.adapter);
        uint tBal_ = dGetNumeraireBalance(_t.adapter);
        uint grossLiq_ = add(oBal_, tBal_);
        oBal_ = add(oBal_, oNAmt_);

        for (uint i = 0; i < reserves.length; i++) {
            if (reserves[i] != _o.reserve && reserves[i] != _t.reserve){
                grossLiq_ += dGetNumeraireBalance(reserves[i]);
            }
        }

        return (oNAmt_, oBal_, tBal_, grossLiq_);

    }

    /// @author james foley http://github.com/realisation
    /// @notice given an amount of the target currency this function will derive the corresponding origin amount according to the current state of the contract
    /// @param _origin the address of the origin stablecoin flavor
    /// @param _target the address of the target stablecoin flavor
    /// @param _maxOAmt the highest amount of the origin stablecoin flavor you are willing to trade
    /// @param _tAmt the raw amount of the target stablecoin flavor to be converted into numeraire amount
    /// @param _deadline the block number at which this transaction is no longer valid
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

        uint256 _nAmt = dGetNumeraireAmount(_t.adapter, _tAmt);
        emit log_uint("_nAmt before fee", _nAmt);
        _nAmt = wmul(_nAmt, WAD + feeBase);
        emit log_uint("_nAmt after fee", _nAmt);

        (uint256 _oBal, uint256 _tBal, uint256 _grossLiq) = getBalancesAndGrossLiq(_o.reserve, _t.reserve);

        (uint256 _oFee, uint256 _nFee) = getFees(_tBal, _tBal - _nAmt, _t.weight, _grossLiq);
        if (_oFee > _nFee) _nAmt = sub(_nAmt, wmul(arbPiece, sub(_oFee, _nFee)));
        else _nAmt = sub(add(_nAmt, _nFee), _oFee);
        
        (_oFee, _nFee) = getFees(_oBal, _oBal + _nAmt, _o.weight, _grossLiq);
        if (_oFee > _nFee) _nAmt = sub(_nAmt, wmul(arbPiece, sub(_oFee, _nFee)));
        else _nAmt = sub(add(_nAmt, _nFee), _oFee);

        require(dViewRawAmount(_o.adapter, _nAmt) <= _maxOAmt, "origin amount is greater than max origin amount");

        dOutputRaw(_t.adapter, _recipient, _tAmt);
        uint256 oAmt_ = dIntakeNumeraire(_o.adapter, _nAmt);
        emit log_uint("oAmt_", oAmt_);

        // emit Trade(msg.sender, _origin, _target, oAmt_, _tAmt);

        return oAmt_;

    }

    event log_uint(bytes32, uint256);

    /// @author james foley http://github.com/realisation
    /// @notice builds the relevant variables for the target trade. total liquidity, numeraire amounts and new balances
    /// @param _o the record of the origin flavor containing its adapter and reserve address
    /// @param _t the record of the target flavor containing its adapter and reserve address
    /// @param _tAmt the raw target amount to be converted into numeraire amount
    /// @return NAmt_ numeraire amount for trade before target and origin fees are applied
    /// @return tBal_ the new numeraire balance of the target
    /// @return oBal_ the numeraire balance of the origin
    /// @return grossLiq_ the total liquidity in all the reserves of the pool
    function getTargetTradeVariables (Flavor memory _o, Flavor memory _t, uint256 _tAmt) private returns (uint, uint, uint, uint) {

        uint tNAmt_ = dGetNumeraireAmount(_t.adapter, _tAmt);
        uint tBal_ = dGetNumeraireBalance(_t.adapter);
        uint oBal_ = dGetNumeraireBalance(_o.adapter);
        uint grossLiq_ = add(tBal_, oBal_);
        tBal_ = sub(tBal_, tNAmt_);

        for (uint i = 0; i < reserves.length; i++) {
            if (reserves[i] != _o.reserve && reserves[i] != _t.reserve) {
                grossLiq_ += dGetNumeraireBalance(reserves[i]);
            }
        }

        return (tNAmt_, oBal_, tBal_, grossLiq_);

    }

    /// @author james foley http://github.com/realisation
    /// @notice this function applies fees to the target amount according to how balanced it is relative to its weight
    /// @param _tWeight the weighted balance point of the target token
    /// @param _tBal the contract's balance of the target
    /// @param _tNAmt the numeraire value of the target amount being traded
    /// @param _grossLiq the total numeraire value of all liquidity across all the reserves of the contract
    /// @return tNAmt_ the target numeraire amount after applying fees
    function calculateTargetTradeTargetAmount(uint256 _tWeight, uint256 _tBal, uint256 _tNAmt, uint256 _grossLiq) private returns (uint256 tNAmt_) {

        require(_tBal >= wmul(_tWeight, wmul(_grossLiq, WAD - alpha)), "target halt check for target trade");

        uint256 _feeThreshold = wmul(_tWeight, wmul(_grossLiq, WAD - beta));

        if (_tBal >= _feeThreshold) {

            tNAmt_ = wmul(_tNAmt, WAD + feeBase);

        } else if (add(_tBal, _tNAmt) <= _feeThreshold) {

            uint256 _fee = wdiv(sub(_feeThreshold, _tBal), wmul(_tWeight, _grossLiq));
            _fee = wmul(_fee, feeDerivative);
            _tNAmt = wmul(_tNAmt, WAD + _fee);
            tNAmt_ = wmul(_tNAmt, WAD + feeBase);

        } else {

            uint256 _fee = wmul(feeDerivative, wdiv(
                    sub(_feeThreshold, _tBal),
                    wmul(_tWeight, _grossLiq)
            ));

            _tNAmt = add(
                sub(add(_tBal, _tNAmt), _feeThreshold),
                wmul(sub(_feeThreshold, _tBal), WAD + _fee)
            );

            tNAmt_ = wmul(_tNAmt, WAD + feeBase);

        }

        return tNAmt_;

    }

    /// @author james foley http://github.com/realisation
    /// @notice this function applies fees to the origin amount according to how balanced it is relative to its weight
    /// @param _oWeight the weighted balance point of the origin token
    /// @param _oBal the contract's balance of the origin
    /// @param _oNAmt the numeraire value for the origin amount being traded
    /// @param _grossLiq the total numeraire value of all liquidity across all the reserves of the contract
    /// @return oNAmt_ the origin numeraire amount after applying fees
    function calculateTargetTradeOriginAmount (uint256 _oWeight, uint256 _oBal, uint256 _oNAmt, uint256 _grossLiq) private returns (uint256 oNAmt_) {


        uint256 _feeThreshold = wmul(_oWeight, wmul(_grossLiq, WAD + beta));
        if (_oBal + _oNAmt <= _feeThreshold) {

            oNAmt_ = _oNAmt;

        } else if (_oBal >= _feeThreshold) {

            uint256 _fee = wdiv(
                sub(add(_oNAmt, _oBal), _feeThreshold),
                wmul(_oWeight, _grossLiq)
            );
            _fee = wmul(_fee, feeDerivative);
            oNAmt_ = wmul(_oNAmt, WAD + _fee);

        } else {

            uint256 _fee = wmul(feeDerivative, wdiv(
                sub(add(_oBal, _oNAmt), _feeThreshold),
                wmul(_oWeight, _grossLiq)
            ));

            oNAmt_ = add(
                sub(_feeThreshold, _oBal),
                wmul(sub(add(_oBal, _oNAmt), _feeThreshold), WAD + _fee)
            );

        }

        require(add(_oBal, oNAmt_) <= wmul(_oWeight, wmul(_grossLiq, WAD + alpha)), "origin halt check for target trade");

        return oNAmt_;

    }

}