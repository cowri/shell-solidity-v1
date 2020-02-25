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

pragma solidity ^0.5.16;

import "./LoihiRoot.sol";
import "./LoihiDelegators.sol";

contract LoihiViews is LoihiRoot, LoihiDelegators {

    function getOriginViewVariables (address _this, address[] calldata _rsrvs, address _oAdptr, address _oRsrv, address _tAdptr, address _tRsrv,  uint256 _oAmt) external view returns (uint256[] memory) {

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
    function calculateOriginTradeOriginAmount (uint256 _oWeight, uint256 _oBal, uint256 _oNAmt, uint256 _grossLiq, uint256 _alpha, uint256 _beta, uint256 _feeBase, uint256 _feeDerivative) external view returns (uint256) {

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

        return oNAmt_;

    }

    /// @author james foley http://github.com/realisation
    /// @notice calculates the fees to apply to the target amount in an origin trade
    /// @param _tWeight the balance weighting of the target flavor
    /// @param _tBal the current balance of the target in the reserve
    /// @param _grossLiq the current total balance across all the reserves in the contract
    /// @return tNAmt_ the target numeraire amount including any applied fees
    function calculateOriginTradeTargetAmount (address _tAdptr, uint256 _tWeight, uint256 _tBal, uint256 _tNAmt, uint256 _grossLiq, uint256 _alpha, uint256 _beta, uint256 _feeBase, uint256 _feeDerivative) external view returns (uint256 tNAmt_) {

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

        require(sub(_tBal, tNAmt_) >= wmul(_tWeight, wmul(_grossLiq, WAD - _alpha)), "origin swap target halt check");

        return dViewRawAmount(_tAdptr, tNAmt_);

    }

    function getTargetViewVariables (address _this, address[] calldata _rsrvs, address _oAdptr, address _oRsrv, address _tAdptr, address _tRsrv, uint256 _tAmt) external view returns (uint256[] memory) {

        uint256[] memory viewVars = new uint256[](4);

        viewVars[0] = dViewNumeraireAmount(_tAdptr, _tAmt);
        viewVars[1] = dViewNumeraireBalance(_tAdptr, _this);
        viewVars[3] += viewVars[1];
        viewVars[1] -= viewVars[0];

        viewVars[2] = dViewNumeraireBalance(_oAdptr, _this);
        viewVars[3] += viewVars[2];

        for (uint i = 0; i < _rsrvs.length; i++) {
            if (_rsrvs[i] != _oRsrv && _rsrvs[i] != _tRsrv) {
                viewVars[3] += dViewNumeraireBalance(_rsrvs[i], _this);
            }
        }

        return viewVars;

    }

    /// @author james foley http://github.com/realisation
    /// @notice this function applies fees to the target amount according to how balanced it is relative to its weight
    /// @param _tWeight the weighted balance point of the target token
    /// @param _tBal the contract's balance of the target
    /// @param _tNAmt the numeraire value of the target amount being traded
    /// @param _grossLiq the total numeraire value of all liquidity across all the reserves of the contract
    /// @return tNAmt_ the target numeraire amount after applying fees
    function calculateTargetTradeTargetAmount(uint256 _tWeight, uint256 _tBal, uint256 _tNAmt, uint256 _grossLiq, uint256 _alpha, uint256 _beta, uint256 _feeBase, uint256 _feeDerivative) external view returns (uint256 tNAmt_) {

        require(_tBal >= wmul(_tWeight, wmul(_grossLiq, WAD - _alpha)), "target halt check for target trade");

        uint256 _feeThreshold = wmul(_tWeight, wmul(_grossLiq, WAD - _beta));
        if (_tBal >= _feeThreshold) {

            tNAmt_ = wmul(_tNAmt, WAD + _feeBase);

        } else if (add(_tBal, _tNAmt) <= _feeThreshold) {

            uint256 _fee = wdiv(sub(_feeThreshold, _tBal), wmul(_tWeight, _grossLiq));
            _fee = wmul(_fee, _feeDerivative);
            _tNAmt = wmul(_tNAmt, WAD + _fee);
            tNAmt_ = wmul(_tNAmt, WAD + _feeBase);

        } else {

            uint256 _fee = wmul(_feeDerivative, wdiv(
                    sub(_feeThreshold, _tBal),
                    wmul(_tWeight, _grossLiq)
            ));

            _tNAmt = add(
                sub(add(_tBal, _tNAmt), _feeThreshold),
                wmul(sub(_feeThreshold, _tBal), WAD + _fee)
            );

            tNAmt_ = wmul(_tNAmt, WAD + _feeBase);

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
    function calculateTargetTradeOriginAmount (address _oAdptr, uint256 _oWeight, uint256 _oBal, uint256 _oNAmt, uint256 _grossLiq, uint256 _alpha, uint256 _beta, uint256 _feeBase, uint256 _feeDerivative) external view returns (uint256 oNAmt_) {

        uint256 _feeThreshold = wmul(_oWeight, wmul(_grossLiq, WAD + _beta));
        if (_oBal + _oNAmt <= _feeThreshold) {

            oNAmt_ = _oNAmt;

        } else if (_oBal >= _feeThreshold) {

            uint256 _fee = wdiv(
                sub(add(_oNAmt, _oBal), _feeThreshold),
                wmul(_oWeight, _grossLiq)
            );
            _fee = wmul(_fee, _feeDerivative);
            oNAmt_ = wmul(_oNAmt, WAD + _fee);

        } else {

            uint256 _fee = wmul(_feeDerivative, wdiv(
                sub(add(_oBal, _oNAmt), _feeThreshold),
                wmul(_oWeight, _grossLiq)
            ));

            oNAmt_ = add(
                sub(_feeThreshold, _oBal),
                wmul(sub(add(_oBal, _oNAmt), _feeThreshold), WAD + _fee)
            );

        }

        require(add(_oBal, oNAmt_) <= wmul(_oWeight, wmul(_grossLiq, WAD + _alpha)), "origin halt check for target trade");

        return dViewRawAmount(_oAdptr, oNAmt_);

    }

    function totalReserves (address[] calldata _reserves, address _addr) external view returns (uint256, uint256[] memory) {
        uint256 totalBalance;
        uint256[] memory balances = new uint256[](_reserves.length);
        for (uint i = 0; i < _reserves.length; i++) {
            balances[i] = dViewNumeraireBalance(_reserves[i], _addr);
            totalBalance += balances[i];
        }
        return (totalBalance, balances);
    }


}