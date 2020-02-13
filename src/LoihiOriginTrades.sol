// pragma solidity ^0.5.12;

// import "./LoihiRoot.sol";
// import "./LoihiDelegators.sol";

// contract LoihiTargetTrades is LoihiRoot, LoihiDelegators {

//     /// @author james foley http://github.com/realisation
//     /// @notice given an origin amount this function will find the corresponding target amount according to the contracts state and make the swap between the two
//     /// @param _origin the address of the origin flavor
//     /// @param _target the address of the target flavor
//     /// @param _oAmt the raw amount of the origin flavor - will be converted to numeraire amount
//     /// @param _minTAmt the minimum target amount you are willing to accept for this trade
//     /// @param _deadline the block by which this transaction is no longer valid
//     /// @param _recipient the address for where to send the resultant target amount
//     /// @return tNAmt_ the target numeraire amount
//     function executeOriginTrade (address _origin, address _target, uint256 _oAmt, uint256 _minTAmt, uint256 _deadline, address _recipient) external returns (uint256) {

//         Flavor memory _o = flavors[_origin]; // origin adapter + weight
//         Flavor memory _t = flavors[_target]; // target adapter + weight

//         ( uint256 _NAmt,
//           uint256 _oBal,
//           uint256 _tBal,
//           uint256 _grossLiq ) = getOriginTradeVariables(_o, _t, _oAmt);

//         _NAmt = calculateOriginTradeOriginAmount(_o.weight, _oBal, _NAmt, _grossLiq);
//         _NAmt = calculateOriginTradeTargetAmount(_t.weight, _tBal, _NAmt, _grossLiq);

//         require(dViewRawAmount(_t.adapter, _NAmt) >= _minTAmt, "target amount is less than minimum target amount");

//         dIntakeRaw(_o.adapter, _oAmt);
//         uint256 tAmt_ = dOutputNumeraire(_t.adapter, _recipient, _NAmt);

//         emit Trade(msg.sender, _origin, _target, _oAmt, tAmt_);

//         return tAmt_;

//     }

//     /// @author james foley http://github.com/realisation
//     /// @notice builds the relevant variables for a target trade
//     /// @param _o the record for the origin flavor containing the address of its adapter and its reserve
//     /// @param _t the record for the target flavor containing the address of its adapter and its reserve
//     /// @param _oAmt the raw amount of the origin flavor to be converted into numeraire
//     /// @return NAmt_ the numeraire amount of the trade before origin and target fees are applied
//     /// @return oBal_ the new origin numeraire balance including the origin numeraire amount
//     /// @return tBal_ the current numereraire balance of the contracts reserve for the target
//     /// @return grossLiq_ total numeraire value across all reserves in the contract
//     function getOriginTradeVariables (Flavor memory _o, Flavor memory _t, uint256 _oAmt) private returns (uint, uint, uint, uint) {

//         uint NAmt_;
//         uint oBal_;
//         uint tBal_;
//         uint grossLiq_;

//         for (uint i = 0; i < reserves.length; i++) {
//             if (reserves[i] == _o.reserve) {
//                 NAmt_ = dGetNumeraireAmount(_o.adapter, _oAmt);
//                 oBal_ = dGetNumeraireBalance(_o.adapter);
//                 grossLiq_ += oBal_;
//                 oBal_ = add(oBal_, NAmt_);
//             } else if (reserves[i] == _t.reserve) {
//                 tBal_ = dGetNumeraireBalance(_t.adapter);
//                 grossLiq_ += tBal_;
//             } else {
//                 grossLiq_ += dGetNumeraireBalance(reserves[i]);
//             }
//         }

//         return (NAmt_, oBal_, tBal_, grossLiq_);

//     }

//     /// @author james foley http://github.com/realisation
//     /// @notice calculates the origin amount in an origin trade including the fees
//     /// @param _oWeight the balance weighting of the origin flavor
//     /// @param _oBal the new numeraire balance of the origin reserve including the origin amount being swapped
//     /// @param _oNAmt the origin numeraire amount being swapped
//     /// @param _grossLiq the numeraire amount across all stablecoin reserves in the contract
//     /// @return oNAmt_ the origin numeraire amount for the swap with fees applied
//     function calculateOriginTradeOriginAmount (uint256 _oWeight, uint256 _oBal, uint256 _oNAmt, uint256 _grossLiq) private view returns (uint256) {

//         require(_oBal <= wmul(_oWeight, wmul(_grossLiq, alpha + WAD)), "origin swap origin halt check");

//         uint256 oNAmt_;

//         uint256 _feeThreshold = wmul(_oWeight, wmul(_grossLiq, beta + WAD));
//         if (_oBal <= _feeThreshold) {

//             oNAmt_ = _oNAmt;

//         } else if (sub(_oBal, _oNAmt) >= _feeThreshold) {

//             uint256 _fee = wdiv(
//                 sub(_oBal, _feeThreshold),
//                 wmul(_oWeight, _grossLiq)
//             );
//             _fee = wmul(_fee, feeDerivative);
//             oNAmt_ = wmul(_oNAmt, WAD - _fee);

//         } else {

//             uint256 _fee = wmul(feeDerivative, wdiv(
//                 sub(_oBal, _feeThreshold),
//                 wmul(_oWeight, _grossLiq)
//             ));
//             oNAmt_ = add(
//                 sub(_feeThreshold, sub(_oBal, _oNAmt)),
//                 wmul(sub(_oBal, _feeThreshold), WAD - _fee)
//             );

//         }

//         return oNAmt_;

//     }

//     /// @author james foley http://github.com/realisation
//     /// @notice calculates the fees to apply to the target amount in an origin trade
//     /// @param _tWeight the balance weighting of the target flavor
//     /// @param _tBal the current balance of the target in the reserve
//     /// @param _grossLiq the current total balance across all the reserves in the contract
//     /// @return tNAmt_ the target numeraire amount including any applied fees
//     function calculateOriginTradeTargetAmount (uint256 _tWeight, uint256 _tBal, uint256 _tNAmt, uint256 _grossLiq) private view returns (uint256 tNAmt_) {

//         require(sub(_tBal, _tNAmt) >= wmul(_tWeight, wmul(_grossLiq, WAD - alpha)), "origin swap target halt check");

//         uint256 _feeThreshold = wmul(_tWeight, wmul(_grossLiq, WAD - beta));
//         if (sub(_tBal, _tNAmt) >= _feeThreshold) {

//             tNAmt_ = wmul(_tNAmt, WAD - feeBase);

//         } else if (_tBal <= _feeThreshold) {

//             uint256 _fee = wdiv(
//                 sub(_feeThreshold, sub(_tBal, _tNAmt)),
//                 wmul(_tWeight, _grossLiq)
//             );
//             _fee = wmul(_fee, feeDerivative);
//             _tNAmt = wmul(_tNAmt, WAD - _fee);
//             tNAmt_ = wmul(_tNAmt, WAD - feeBase);

//         } else {

//             uint256 _fee = wmul(feeDerivative, wdiv(
//                 sub(_feeThreshold, sub(_tBal, _tNAmt)),
//                 wmul(_tWeight, _grossLiq)
//             ));
//             tNAmt_ = wmul(add(
//                 sub(_tBal, _feeThreshold),
//                 wmul(sub(_feeThreshold, sub(_tBal, _tNAmt)), WAD - _fee)
//             ), WAD - feeBase);

//         }

//         return tNAmt_;

//     }

//     /// @author james foley http://github.com/realisation
//     /// @notice given an origin amount this function will find the corresponding target amount according to the contracts state and make the swap between the two
//     /// @param _origin the address of the origin flavor
//     /// @param _target the address of the target flavor
//     /// @param _oAmt the raw amount of the origin flavor - will be converted to numeraire amount
//     /// @return tNAmt_ the target numeraire amount
//     function viewOriginTrade (address _origin, address _target, uint256 _oAmt) external view returns (uint256) {

//         Flavor memory _o = flavors[_origin]; // origin adapter + weight
//         Flavor memory _t = flavors[_target]; // target adapter + weight

//         ( uint256 _NAmt,
//           uint256 _oBal,
//           uint256 _tBal,
//           uint256 _grossLiq ) = getOriginViewVariables(_o, _t, _oAmt);

//         _NAmt = calculateOriginTradeOriginAmount(_o.weight, _oBal, _NAmt, _grossLiq);
//         _NAmt = calculateOriginTradeTargetAmount(_t.weight, _tBal, _NAmt, _grossLiq);

//         return dViewRawAmount(_t.adapter, _NAmt);

//     }

//     /// @author james foley http://github.com/realisation
//     /// @notice builds the relevant variables for viewing the origin price
//     /// @param _o the record for the origin flavor containing the address of its adapter and its reserve
//     /// @param _t the record for the target flavor containing the address of its adapter and its reserve
//     /// @param _oAmt the raw amount of the origin flavor to be converted into numeraire
//     /// @return NAmt_ numeraire amount for trade before target and origin fees are applied
//     /// @return oBal_ the new origin numeraire balance including the origin numeraire amount
//     /// @return tBal_ the current numereraire balance of the contracts reserve for the target
//     /// @return grossLiq_ total numeraire value across all reserves in the contract
//     function getOriginViewVariables (Flavor memory _o, Flavor memory _t, uint256 _oAmt) private view returns (uint, uint, uint, uint) {

//         uint NAmt_;
//         uint oBal_;
//         uint tBal_;
//         uint grossLiq_;

//         for (uint i = 0; i < reserves.length; i++) {
//             if (reserves[i] == _o.reserve) {
//                 NAmt_ = dViewNumeraireAmount(_o.adapter, _oAmt);
//                 oBal_ = dViewNumeraireBalance(_o.adapter);
//                 grossLiq_ += oBal_;
//                 oBal_ = add(oBal_, NAmt_);
//             } else if (reserves[i] == _t.reserve) {
//                 tBal_ = dViewNumeraireBalance(_t.adapter);
//                 grossLiq_ += tBal_;
//             } else {
//                 grossLiq_ += dViewNumeraireBalance(reserves[i]);
//             }
//         }

//         return (NAmt_, oBal_, tBal_, grossLiq_);

//     }

// }