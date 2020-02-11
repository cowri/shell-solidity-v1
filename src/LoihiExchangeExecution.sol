pragma solidity ^0.5.12;

import "./LoihiCallAdapters.sol";
import "./LoihiRoot.sol";

contract LoihiExchangeExecution is LoihiRoot, LoihiCallAdapters {

    function swapByTarget (address origin, address target, uint256 maxOriginAmount, uint256 targetAmount, uint256 deadline) public returns (uint256) {
        return executeTargetTrade(origin, target, maxOriginAmount, targetAmount, deadline, msg.sender);
    }

    function transferByTarget (address origin, address target, uint256 maxOriginAmount, uint256 targetAmount, uint256 deadline, address recipient) public returns (uint256) {
        return executeTargetTrade(origin, target, maxOriginAmount, targetAmount, deadline, recipient);
    }
    
    function swapByOrigin (address origin, address target, uint256 originAmount, uint256 minTargetAmount, uint256 deadline) public returns (uint256) {
        return executeOriginTrade(origin, target, originAmount, minTargetAmount, deadline, msg.sender);
    }

    function transferByOrigin (address origin, address target, uint256 originAmount, uint256 minTargetAmount, uint256 deadline, address recipient) public returns (uint256) {
        return executeOriginTrade(origin, target, originAmount, minTargetAmount, deadline, recipient);
    }

    /// @author james foley http://github.com/realisation
    /// @notice given an origin amount this function will find the corresponding target amount according to the contracts state and make the swap between the two
    /// @param _origin the address of the origin flavor
    /// @param _target the address of the target flavor
    /// @param _oAmt the raw amount of the origin flavor - will be converted to numeraire amount
    /// @param _minTAmt the minimum target amount you are willing to accept for this trade
    /// @param _deadline the block by which this transaction is no longer valid
    /// @param _recipient the address for where to send the resultant target amount
    /// @return tNAmt_ the target numeraire amount
    function executeOriginTrade (address _origin, address _target, uint256 _oAmt, uint256 _minTAmt, uint256 _deadline, address _recipient) public returns (uint256) {

        Flavor memory _o = flavors[_origin]; // origin adapter + weight
        Flavor memory _t = flavors[_target]; // target adapter + weight

        ( uint256 _oNAmt,
          uint256 _oBal,
          uint256 _tBal,
          uint256 _tNAmt,
          uint256 _grossLiq ) = getOriginTradeVariables(_o, _t, _oAmt);

        _oNAmt = calculateOriginTradeOriginAmount(_o.weight, _oBal, _oNAmt, _grossLiq);
        _tNAmt = calculateOriginTradeTargetAmount(_t.weight, _tBal, _oNAmt, _grossLiq);

        dIntakeRaw(_o.adapter, _oNAmt);
        return dOutputNumeraire(_t.adapter, _recipient, _tNAmt);

    }

    /// @author james foley http://github.com/realisation
    /// @notice builds the relevant variables for a target trade
    /// @param _o the record for the origin flavor containing the address of its adapter and its reserve
    /// @param _t the record for the target flavor containing the address of its adapter and its reserve
    /// @param _oAmt the raw amount of the origin flavor to be converted into numeraire
    /// @return oNAmt_ the numeraire amount of the origin flavor
    /// @return oBal_ the new origin numeraire balance including the origin numeraire amount
    /// @return tBal_ the current numereraire balance of the contracts reserve for the target
    /// @return tNAmt_ empty value to be filled in when the target fee is calculated
    /// @return grossLiq_ total numeraire value across all reserves in the contract
    function getOriginTradeVariables (Flavor memory _o, Flavor memory _t, uint256 _oAmt) private returns (uint, uint, uint, uint, uint) {

        uint oNAmt_;
        uint oBal_;
        uint tBal_;
        uint tNAmt_;
        uint grossLiq_;

        for (uint i = 0; i < reserves.length; i++) {
            if (reserves[i] == _o.reserve) {
                oNAmt_ = dGetNumeraireAmount(_o.adapter, _oAmt);
                oBal_ = dGetNumeraireBalance(_o.adapter);
                grossLiq_ += oBal_;
                oBal_ = add(oBal_, oNAmt_);
            } else if (reserves[i] == _t.reserve) {
                tBal_ = dGetNumeraireBalance(_t.adapter);
                grossLiq_ += tBal_;
            } else {
                grossLiq_ += dGetNumeraireBalance(reserves[i]);
            }
        }

        return (oNAmt_, oBal_, tBal_, tNAmt_, grossLiq_);

    }

    /// @author james foley http://github.com/realisation
    /// @notice calculates the origin amount in an origin trade including the fees
    /// @param _oWeight the balance weighting of the origin flavor
    /// @param _oBal the new numeraire balance of the origin reserve including the origin amount being swapped
    /// @param _oNAmt the origin numeraire amount being swapped
    /// @param _grossLiq the numeraire amount across all stablecoin reserves in the contract
    /// @return oNAmt_ the origin numeraire amount for the swap with fees applied
    function calculateOriginTradeOriginAmount (uint256 _oWeight, uint256 _oBal, uint256 _oNAmt, uint256 _grossLiq) private view returns (uint256) {

        require(_oBal <= wmul(_oWeight, wmul(_grossLiq, alpha + WAD)), "origin swap origin halt check");

        uint256 oNAmt_;

        uint256 _feeThreshold = wmul(_oWeight, wmul(_grossLiq, beta + WAD));
        if (_oBal <= _feeThreshold) {

            oNAmt_ = _oNAmt;

        } else if (sub(_oBal, _oNAmt) >= _feeThreshold) {

            uint256 _fee = wdiv(
                sub(_oBal, _feeThreshold),
                wmul(_oWeight, _grossLiq)
            );
            _fee = wmul(_fee, feeDerivative);
            oNAmt_ = wmul(_oNAmt, WAD - _fee);

        } else {

            uint256 _fee = wmul(feeDerivative, wdiv(
                sub(_oBal, _feeThreshold),
                wmul(_oWeight, _grossLiq)
            ));
            oNAmt_ = add(
                sub(_feeThreshold, sub(_oBal, _oNAmt)),
                wmul(sub(_oBal, _feeThreshold), WAD - _fee)
            );

        }

        return oNAmt_;

    }

    /// @author james foley http://github.com/realisation
    /// @notice calculates the fees to apply to the target amount in an origin trade
    /// @param _tWeight the balance weighting of the target flavor
    /// @param _tBal the current balance of the target in the reserve
    /// @param _grossLiq the current total balance across all the reserves in the contract
    /// @return tNAmt_ the target numeraire amount including any applied fees
    function calculateOriginTradeTargetAmount (uint256 _tWeight, uint256 _tBal, uint256 _tNAmt, uint256 _grossLiq) private view returns (uint256 tNAmt_) {

        require(sub(_tBal, _tNAmt) >= wmul(_tWeight, wmul(_grossLiq, WAD - alpha)), "origin swap target halt check");

        uint256 _feeThreshold = wmul(_tWeight, wmul(_grossLiq, WAD - beta));
        if (sub(_tBal, _tNAmt) >= _feeThreshold) {

            tNAmt_ = wmul(_tNAmt, WAD - feeBase);

        } else if (_tBal <= _feeThreshold) {

            uint256 _fee = wdiv(
                sub(_feeThreshold, sub(_tBal, _tNAmt)),
                wmul(_tWeight, _grossLiq)
            );
            _fee = wmul(_fee, feeDerivative);
            _tNAmt = wmul(_tNAmt, WAD - _fee);
            tNAmt_ = wmul(_tNAmt, WAD - feeBase);

        } else {

            uint256 _fee = wmul(feeDerivative, wdiv(
                sub(_feeThreshold, sub(_tBal, _tNAmt)),
                wmul(_tWeight, _grossLiq)
            ));
            tNAmt_ = wmul(add(
                sub(_tBal, _feeThreshold),
                wmul(sub(_feeThreshold, sub(_tBal, _tNAmt)), WAD - _fee)
            ), WAD - feeBase);

        }

        return tNAmt_;

    }

    /// @author james foley http://github.com/realisation
    /// @notice given an origin amount this function will find the corresponding target amount according to the contracts state and make the swap between the two
    /// @param _origin the address of the origin flavor
    /// @param _target the address of the target flavor
    /// @param _oAmt the raw amount of the origin flavor - will be converted to numeraire amount
    /// @return tNAmt_ the target numeraire amount
    function viewOriginTrade (address _origin, address _target, uint256 _oAmt) public view returns (uint256) {

        Flavor memory _o = flavors[_origin]; // origin adapter + weight
        Flavor memory _t = flavors[_target]; // target adapter + weight

        ( uint256 _oNAmt,
          uint256 _oBal,
          uint256 _tBal,
          uint256 _tNAmt,
          uint256 _grossLiq ) = getOriginViewVariables(_o, _t, _oAmt);

        _oNAmt = calculateOriginTradeOriginAmount(_o.weight, _oBal, _oNAmt, _grossLiq);
        _tNAmt = calculateOriginTradeTargetAmount(_t.weight, _tBal, _oNAmt, _grossLiq);

        return dViewRawAmount(_t.adapter, _tNAmt);

    }

    /// @author james foley http://github.com/realisation
    /// @notice builds the relevant variables for viewing the origin price
    /// @param _o the record for the origin flavor containing the address of its adapter and its reserve
    /// @param _t the record for the target flavor containing the address of its adapter and its reserve
    /// @param _oAmt the raw amount of the origin flavor to be converted into numeraire
    /// @return oNAmt_ the numeraire amount of the origin flavor
    /// @return oBal_ the new origin numeraire balance including the origin numeraire amount
    /// @return tBal_ the current numereraire balance of the contracts reserve for the target
    /// @return tNAmt_ empty value to be filled in when the target fee is calculated
    /// @return grossLiq_ total numeraire value across all reserves in the contract
    function getOriginViewVariables (Flavor memory _o, Flavor memory _t, uint256 _oAmt) private view returns (uint, uint, uint, uint, uint) {

        uint oNAmt_;
        uint oBal_;
        uint tBal_;
        uint tNAmt_;
        uint grossLiq_;

        for (uint i = 0; i < reserves.length; i++) {
            if (reserves[i] == _o.reserve) {
                oNAmt_ = dViewNumeraireAmount(_o.adapter, _oAmt);
                oBal_ = dViewNumeraireBalance(_o.adapter);
                grossLiq_ += oBal_;
                oBal_ = add(oBal_, oNAmt_);
            } else if (reserves[i] == _t.reserve) {
                tBal_ = dViewNumeraireBalance(_t.adapter);
                grossLiq_ += tBal_;
            } else {
                grossLiq_ += dViewNumeraireBalance(reserves[i]);
            }
        }

        return (oNAmt_, oBal_, tBal_, tNAmt_, grossLiq_);

    }

    /// @author james foley http://github.com/realisation
    /// @notice given an amount of the target currency this function will derive the corresponding origin amount according to the current state of the contract
    /// @param _origin the address of the origin stablecoin flavor
    /// @param _target the address of the target stablecoin flavor
    /// @param _maxOAmt the highest amount of the origin stablecoin flavor you are willing to trade
    /// @param _tAmt the raw amount of the target stablecoin flavor to be converted into numeraire amount
    /// @param _deadline the block number at which this transaction is no longer valid
    /// @param _recipient the address for where to send the target amount
    function executeTargetTrade (address _origin, address _target, uint256 _maxOAmt, uint256 _tAmt, uint256 _deadline, address _recipient) private returns (uint256) {

        Flavor memory _o = flavors[_origin];
        Flavor memory _t = flavors[_target];

        ( uint256 _oNAmt,
          uint256 _oBal,
          uint256 _tBal,
          uint256 _tNAmt,
          uint256 _grossLiq ) = getTargetTradeVariables(_o, _t, _tAmt) ;

        _tNAmt = calculateTargetTradeTargetAmount(_t.weight, _tBal, _tNAmt, _grossLiq);
        _oNAmt = calculateTargetTradeOriginAmount(_o.weight, _oBal, _tNAmt, _grossLiq);

        dOutputRaw(_t.adapter, _recipient, _tAmt);
        return dIntakeNumeraire(_o.adapter, _oNAmt);

    }

    /// @author james foley http://github.com/realisation
    /// @notice builds the relevant variables for the target trade. total liquidity, numeraire amounts and new balances
    /// @param _o the record of the origin flavor containing its adapter and reserve address
    /// @param _t the record of the target flavor containing its adapter and reserve address
    /// @param _tAmt the raw target amount to be converted into numeraire amount
    /// @return tNAmt_ the target numeraire amount
    /// @return tBal_ the new numeraire balance of the target
    /// @return oBal_ the numeraire balance of the origin
    /// @return oNAmt_ empty uint to be filled in as target and origin fees are calculated
    /// @return grossLiq_ the total liquidity in all the reserves of the pool
    function getTargetTradeVariables (Flavor memory _o, Flavor memory _t, uint256 _tAmt) private returns (uint, uint, uint, uint, uint) {

        uint tNAmt_;
        uint tBal_;
        uint oBal_;
        uint oNAmt_;
        uint grossLiq_;

        for (uint i = 0; i < reserves.length; i++) {
            if (reserves[i] == _o.reserve) {
                oBal_ = dGetNumeraireBalance(_o.adapter);
                grossLiq_ += oBal_;
            } else if (reserves[i] == _t.reserve) {
                tNAmt_ = dGetNumeraireAmount(_t.adapter, _tAmt);
                tBal_ = dGetNumeraireBalance(_t.adapter);
                grossLiq_ += tBal_;
                tBal_ = sub(tBal_, tNAmt_);
            } else grossLiq_ += dGetNumeraireBalance(reserves[i]);
        }

        return (oNAmt_, oBal_, tBal_, tNAmt_, grossLiq_);

    }

    /// @author james foley http://github.com/realisation
    /// @notice this function applies fees to the target amount according to how balanced it is relative to its weight
    /// @param _tWeight the weighted balance point of the target token
    /// @param _tBal the contract's balance of the target
    /// @param _tNAmt the numeraire value of the target amount being traded
    /// @param _grossLiq the total numeraire value of all liquidity across all the reserves of the contract
    /// @return tNAmt_ the target numeraire amount after applying fees
    function calculateTargetTradeTargetAmount(uint256 _tWeight, uint256 _tBal, uint256 _tNAmt, uint256 _grossLiq) private view returns (uint256 tNAmt_) {

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
    function calculateTargetTradeOriginAmount (uint256 _oWeight, uint256 _oBal, uint256 _oNAmt, uint256 _grossLiq) private view returns (uint256 oNAmt_) {

        require(add(_oBal, _oNAmt) <= wmul(_oWeight, wmul(_grossLiq, WAD + alpha)), "origin halt check for target trade");

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

        return oNAmt_;

    }

    /// @author james foley http://github.com/realisation
    /// @notice given an amount of the target currency this function will view the origin amount that would procure
    /// @param _origin the address of the origin stablecoin flavor
    /// @param _target the address of the target stablecoin flavor
    /// @param _tAmt the raw amount of the target stablecoin flavor to be converted into numeraire amount
    function viewTargetTrade (address _origin, address _target, uint256 _tAmt) public view returns (uint256) {

        Flavor memory _o = flavors[_origin];
        Flavor memory _t = flavors[_target];

        ( uint256 _oNAmt,
          uint256 _oBal,
          uint256 _tBal,
          uint256 _tNAmt,
          uint256 _grossLiq ) = getTargetViewVariables(_o, _t, _tAmt) ;

        _oNAmt = calculateTargetTradeTargetAmount(_t.weight, _tBal, _tNAmt, _grossLiq);
        _oNAmt = calculateTargetTradeOriginAmount(_o.weight, _oBal, _oNAmt, _grossLiq);

        return dViewRawAmount(_o.adapter, _oNAmt);

    }

    /// @author james foley http://github.com/realisation
    /// @notice builds the relevant variables for the target trade. total liquidity, numeraire amounts and new balances
    /// @param _o the record of the origin flavor containing its adapter and reserve address
    /// @param _t the record of the target flavor containing its adapter and reserve address
    /// @param _tAmt the raw target amount to be converted into numeraire amount
    /// @return tNAmt_ the target numeraire amount
    /// @return tBal_ the new numeraire balance of the target
    /// @return oBal_ the numeraire balance of the origin
    /// @return oNAmt_ empty uint to be filled in as target and origin fees are calculated
    /// @return grossLiq_ the total liquidity in all the reserves of the pool
    function getTargetViewVariables (Flavor memory _o, Flavor memory _t, uint256 _tAmt) private view returns (uint, uint, uint, uint, uint) {

        uint tNAmt_;
        uint tBal_;
        uint oBal_;
        uint oNAmt_;
        uint grossLiq_;

        for (uint i = 0; i < reserves.length; i++) {
            if (reserves[i] == _o.reserve) {
                oBal_ = dViewNumeraireBalance(_o.adapter);
                grossLiq_ += oBal_;
            } else if (reserves[i] == _t.reserve) {
                tNAmt_ = dViewNumeraireAmount(_t.adapter, _tAmt);
                tBal_ = dViewNumeraireBalance(_t.adapter);
                grossLiq_ += tBal_;
                tBal_ = sub(tBal_, tNAmt_);
            } else grossLiq_ += dViewNumeraireBalance(reserves[i]);
        }

        return (oNAmt_, oBal_, tBal_, tNAmt_, grossLiq_);

    }


}