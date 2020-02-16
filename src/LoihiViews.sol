pragma solidity ^0.5.12;

import "./LoihiRoot.sol";
import "./LoihiDelegators.sol";

contract LoihiViews is LoihiRoot, LoihiDelegators {

    event log_uint(bytes32, uint256);
    // / @author james foley http://github.com/realisation
    // / @notice given an origin amount this function will find the corresponding target amount according to the contracts state and make the swap between the two
    // / @param _origin the address of the origin flavor
    // / @param _target the address of the target flavor
    // / @param _oAmt the raw amount of the origin flavor - will be converted to numeraire amount
    // / @return tNAmt_ the target numeraire amount
    function viewOriginTrade (address _this, address _o, address _t, uint256 _oAmt, uint256 _alpha, uint256 _beta, uint256 _feeBase, uint256 _feeDerivative) external returns (uint256) {

        // emit log_address("hello", _this);

        // ( uint256 _NAmt,
        //   uint256 _oBal,
        //   uint256 _tBal,
        //   uint256 _grossLiq ) = getOriginViewVariables(_this, _o, _t, _oAmt);

        //   emit log_uint("_NAmt", _NAmt);
        //   emit log_uint("_oBal", _oBal);
        //   emit log_uint("_tBal", _tBal);
        //   emit log_uint("_grossLiq", _grossLiq);

        // _NAmt = calculateOriginTradeOriginAmount(_o.weight, _oBal, _NAmt, _grossLiq, _alpha, _beta, _feeBase, _feeDerivative);
        // _NAmt = calculateOriginTradeTargetAmount(_t.weight, _tBal, _NAmt, _grossLiq, _alpha, _beta, _feeBase, _feeDerivative);

        // emit log_uint("_NAMT", _NAmt);

        // emit log_address("origin", _o.adapter);
        // emit log_address("target", _t.adapter);
        // emit log_uint("_oAmt", _oAmt);

        // return dViewRawAmount(_t.adapter, _NAmt);

    }

    event log_uints(bytes32, uint256[]);

    function getOriginViewVariables (address _this, address[] calldata _rsrvs, address _oAdptr, address _oRsrv, address _tAdptr, address _tRsrv,  uint256 _oAmt) external returns (uint256[] memory) {

        uint256[] memory viewVars = new uint256[](4);

        viewVars[0] = dViewNumeraireAmount(_oAdptr, _oAmt);
        viewVars[1] = dViewNumeraireBalance(_oAdptr, _this);
        viewVars[3] += viewVars[1];
        viewVars[1] += viewVars[0];

        viewVars[2] = dViewNumeraireBalance(_tAdptr, _this);
        viewVars[3] += viewVars[2];

        for (uint i = 0; i < _rsrvs.length; i++) {
            if (_rsrvs[i] != _oRsrv && _rsrvs[i] != _tRsrv) {
                viewVars[3] += dViewNumeraireBalance(_rsrvs[i], _this);
            }
        }

        return viewVars;

    }



    /// @author james foley http://github.com/realisation
    /// @notice calculates the origin amount in an origin trade including the fees
    /// @param _oWeight the balance weighting of the origin flavor
    /// @param _oBal the new numeraire balance of the origin reserve including the origin amount being swapped
    /// @param _oNAmt the origin numeraire amount being swapped
    /// @param _grossLiq the numeraire amount across all stablecoin reserves in the contract
    /// @return oNAmt_ the origin numeraire amount for the swap with fees applied
    function calculateOriginTradeOriginAmount (uint256 _oWeight, uint256 _oBal, uint256 _oNAmt, uint256 _grossLiq, uint256 _alpha, uint256 _beta, uint256 _feeBase, uint256 _feeDerivative) external returns (uint256) {

        require(_oBal <= wmul(_oWeight, wmul(_grossLiq, _alpha + WAD)), "origin swap origin halt check");

        uint256 oNAmt_;

        uint256 _feeThreshold = wmul(_oWeight, wmul(_grossLiq, _beta + WAD));
        if (_oBal <= _feeThreshold) {

            oNAmt_ = _oNAmt;

        } else if (sub(_oBal, _oNAmt) >= _feeThreshold) {

            uint256 _fee = wdiv(
                sub(_oBal, _feeThreshold),
                wmul(_oWeight, _grossLiq)
            );
            _fee = wmul(_fee, _feeDerivative);
            oNAmt_ = wmul(_oNAmt, WAD - _fee);

        } else {

            uint256 _fee = wdiv(
                sub(_oBal, _feeThreshold),
                wmul(_oWeight, _grossLiq)
            );

            _fee = wmul(_feeDerivative, _fee);

            oNAmt_ = add(
                sub(_feeThreshold, sub(_oBal, _oNAmt)),
                wmul(sub(_oBal, _feeThreshold), WAD - _fee)
            );

        }

        emit log_uint("oNAmt_", oNAmt_);

        return oNAmt_;

    }

    /// @author james foley http://github.com/realisation
    /// @notice calculates the fees to apply to the target amount in an origin trade
    /// @param _tWeight the balance weighting of the target flavor
    /// @param _tBal the current balance of the target in the reserve
    /// @param _grossLiq the current total balance across all the reserves in the contract
    /// @return tNAmt_ the target numeraire amount including any applied fees
    function calculateOriginTradeTargetAmount (address _tAdptr, uint256 _tWeight, uint256 _tBal, uint256 _tNAmt, uint256 _grossLiq, uint256 _alpha, uint256 _beta, uint256 _feeBase, uint256 _feeDerivative) external returns (uint256 tNAmt_) {

        require(sub(_tBal, _tNAmt) >= wmul(_tWeight, wmul(_grossLiq, WAD - _alpha)), "origin swap target halt check");

        uint256 _feeThreshold = wmul(_tWeight, wmul(_grossLiq, WAD - _beta));
        if (sub(_tBal, _tNAmt) >= _feeThreshold) {

            tNAmt_ = wmul(_tNAmt, WAD - _feeBase);

        } else if (_tBal <= _feeThreshold) {

            uint256 _fee = wdiv(
                sub(_feeThreshold, sub(_tBal, _tNAmt)),
                wmul(_tWeight, _grossLiq)
            );
            _fee = wmul(_fee, _feeDerivative);
            _tNAmt = wmul(_tNAmt, WAD - _fee);
            tNAmt_ = wmul(_tNAmt, WAD - _feeBase);

        } else {

            uint256 _fee = wdiv(
                sub(_feeThreshold, sub(_tBal, _tNAmt)),
                wmul(_tWeight, _grossLiq)
            );

            _fee = wmul(_feeDerivative, _fee);

            tNAmt_ = add(
                sub(_tBal, _feeThreshold),
                wmul(sub(_feeThreshold, sub(_tBal, _tNAmt)), WAD - _fee)
            );
            
            tNAmt_ = wmul(tNAmt_, WAD - _feeBase);

        }

        emit log_uint("tNAmt_", tNAmt_);

        return dViewRawAmount(_tAdptr, tNAmt_);

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
    function viewTargetTrade (address _origin, address _target, uint256 _tAmt) external view returns (uint256) {

        Flavor memory _o = flavors[_origin];
        Flavor memory _t = flavors[_target];

        ( uint256 _NAmt,
          uint256 _oBal,
          uint256 _tBal,
          uint256 _grossLiq ) = getTargetViewVariables(_o, _t, _tAmt) ;

        _NAmt = calculateTargetTradeTargetAmount(_t.weight, _tBal, _NAmt, _grossLiq);
        _NAmt = calculateTargetTradeOriginAmount(_o.weight, _oBal, _NAmt, _grossLiq);

        return dViewRawAmount(_o.adapter, _NAmt);

    }

    /// @author james foley http://github.com/realisation
    /// @notice builds the relevant variables for the target trade. total liquidity, numeraire amounts and new balances
    /// @param _o the record of the origin flavor containing its adapter and reserve address
    /// @param _t the record of the target flavor containing its adapter and reserve address
    /// @param _tAmt the raw target amount to be converted into numeraire amount
    /// @return NAmt_ numeraire amount for trade before target and origin fees are applied
    /// @return tBal_ the new numeraire balance of the target
    /// @return oBal_ the numeraire balance of the origin
    /// @return grossLiq_ the total liquidity in all the reserves of the pool
    function getTargetViewVariables (Flavor memory _o, Flavor memory _t, uint256 _tAmt) private view returns (uint, uint, uint, uint) {

        uint NAmt_;
        uint tBal_;
        uint oBal_;
        uint grossLiq_;

        // for (uint i = 0; i < reserves.length; i++) {
        //     if (reserves[i] == _o.reserve) {
        //         // oBal_ = dViewNumeraireBalance(_o.adapter);
            //     grossLiq_ += oBal_;
            // } else if (reserves[i] == _t.reserve) {
                // NAmt_ = dViewNumeraireAmount(_t.adapter, _tAmt);
                // tBal_ = dViewNumeraireBalance(_t.adapter);
        //         grossLiq_ += tBal_;
        //         tBal_ = sub(tBal_, NAmt_);
        //     } else grossLiq_ += dViewNumeraireBalance(reserves[i]);
        // }

        return (NAmt_, oBal_, tBal_, grossLiq_);

    }


}