// // This program is free software: you can redistribute it and/or modify
// // it under the terms of the GNU General Public License as published by
// // the Free Software Foundation, either version 3 of the License, or
// // (at your option) any later version.

// // This program is distributed in the hope that it will be useful,
// // but WITHOUT ANY WARRANTY; without even the implied warranty of
// // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// // GNU General Public License for more details.

// // You should have received a copy of the GNU General Public License
// // along with this program.  If not, see <http://www.gnu.org/licenses/>.

// pragma solidity ^0.5.0;

// import "./LoihiRoot.sol";
// import "./LoihiDelegators.sol";
// import "./LoihiMath.sol";

// library LoihiExchange {

//     using LoihiDelegators for address;
//     using LoihiMath for uint256;
    
//     event Trade(address indexed trader, address indexed origin, address indexed target, uint256 originAmount, uint256 targetAmount);

//     uint256 constant OCTOPUS = 1e18;

//     event log_uint(bytes32, uint256);
//     event log_addr(bytes32, address);
//     event log_uints(bytes32, uint256[]);
//     event log_addrs(bytes32, address[]);

//     /// @dev executes the origin trade. refer to Loihi.bin swapByOrigin and transferByOrigin for detailed explanation of paramters
//     /// @return tAmt_ the target amount
//     function executeOriginTrade (LoihiRoot.Shell storage shell, address _origin, address _target, uint256 _oAmt, uint256 _mTAmt, uint256 _dline, address _rcpnt) internal returns (uint256 tAmt_) {
//         emit log_uint("deadline", _dline);
//         require(_dline >= now, "deadline has passed for this trade");

//         // LoihiRoot.Assimilator[] memory _assims = [
//         //     shell.assimilators[_origin],
//         //     shell.assimilators[_target]
//         // ];

//         // require(_assims[0].addr != address(0), "origin flavor not supported");
//         // require(_assims[1].addr != address(0), "target flavor not supported");

//         // if (_assims[0].ix == _assims[1].ix) {
//         //     uint256 _oNAmt = _assims[0].addr.intakeRaw(_oAmt);
//         //     uint256 tAmt_ = _assims[1].addr.outputNumeraire(_rcpnt, _oNAmt);
//         //     emit Trade(msg.sender, _origin, _target, _oAmt, tAmt_);
//         //     return tAmt_;
//         // }

//         // ( uint256[] memory _balances, uint256 _grossLiq ) = getBalancesAndGrossLiq(shell);

//         // uint256 _oNAmt = _o.addr.intakeRaw(_oAmt);

//         // ( tAmt_, shell.omega ) = calculateTargetAmount(_grossLiq, _oNAmt, shell, _o.ix, _t.ix, _balances);

//         // tAmt_ = _t.addr.outputNumeraire(_rcpnt, tAmt_);

//         // emit Trade(msg.sender, _origin, _target, _oAmt, tAmt_);

//         // return tAmt_;

//     }

//     function viewOriginTrade (LoihiRoot.Shell storage shell, address _origin, address _target, uint256 _oAmt) internal returns (uint256) {

//         // LoihiRoot.Assimilator memory _o = shell.assimilators[_origin];
//         // LoihiRoot.Assimilator memory _t = shell.assimilators[_target];

//         // require(_o.addr != address(0), "origin flavor not supported");
//         // require(_t.addr != address(0), "target flavor not supported");

//         // if (_o.ix == _t.ix) {
//         //     uint256 _oNAmt = _o.addr.viewNumeraireAmount(_oAmt);
//         //     return _t.addr.viewRawAmount(_oNAmt);
//         // }

//         // ( uint256[] memory _balances, uint256 _grossLiq ) = getBalancesAndGrossLiq(shell);

//         // uint256 _oNAmt = _o.addr.viewNumeraireAmount(_oAmt);

//         // ( uint256 _tNAmt, ) = calculateTargetAmount(_grossLiq, _oNAmt, shell, _o.ix, _t.ix, _balances);

//         // return _t.addr.viewRawAmount(_tNAmt);

//     }

//     /// @dev executes the target trade. refer to Loihi.bin swapByTarget and transferByTarget for detailed explanation of parameters
//     /// @return oAmt_ origin amount
//     function executeTargetTrade (LoihiRoot.Shell storage shell, address _origin, address _target, uint256 _maxOAmt, uint256 _tAmt, uint256 _dline, address _recipient) internal returns (uint256 oAmt_) {
//         // require(_dline >= now, "deadline has passed for this trade");

//         // LoihiRoot.Assimilator memory _o = shell.assimilators[_origin];
//         // LoihiRoot.Assimilator memory _t = shell.assimilators[_target];

//         // require(_o.addr != address(0), "origin flavor not supported");
//         // require(_t.addr != address(0), "target flavor not supported");

//         // if (_o.ix == _t.ix) {
//         //     uint256 _tNAmt = _t.addr.outputRaw(_recipient, _tAmt);
//         //     uint256 oAmt_ = _o.addr.intakeNumeraire(_tNAmt);
//         //     emit Trade(msg.sender, _origin, _target, oAmt_, _tAmt);
//         //     return oAmt_;
//         // }

//         // ( uint256[] memory _balances, uint256 _grossLiq ) = getBalancesAndGrossLiq(shell);

//         // uint256 _tNAmt = _t.addr.outputRaw(_recipient, _tAmt);

//         // ( oAmt_, shell.omega ) = calculateOriginAmount(_grossLiq, _tNAmt, shell, _o.ix, _t.ix, _balances);

//         // oAmt_ = _o.addr.intakeNumeraire(oAmt_);

//         // require(oAmt_ <= _maxOAmt, "origin amount is greater than max origin amount");

//         // emit Trade(msg.sender, _origin, _target, oAmt_, _tAmt);

//         // return oAmt_;

//     }

//     function viewTargetTrade (LoihiRoot.Shell storage shell, address _origin, address _target, uint256 _tAmt) internal returns (uint256) {

//         // LoihiRoot.Assimilator memory _o = shell.assimilators[_origin];
//         // LoihiRoot.Assimilator memory _t = shell.assimilators[_target];

//         // require(_o.addr != address(0), "origin flavor not supported");
//         // require(_t.addr != address(0), "target flavor not supported");

//         // if (_o.ix == _t.ix) {
//         //     uint256 _tNAmt = _t.addr.viewNumeraireAmount(_tAmt);
//         //     return _o.addr.viewRawAmount(_tNAmt);
//         // }

//         // ( uint256[] memory _balances, uint256 _grossLiq ) = getBalancesAndGrossLiq(shell);

//         // uint256 _tNAmt = _t.addr.viewNumeraireAmount(_tAmt);

//         // ( uint256 _oNAmt, ) = calculateOriginAmount(_grossLiq, _tNAmt, shell, _o.ix, _t.ix, _balances);

//         // return _o.addr.viewRawAmount(_oNAmt);

//     }


//     /// @dev this function figures out the origin amount
//     /// @return tNAmt_ target amount
//     function calculateTargetAmount (uint256 _grossLiq, uint256 _oNAmt, LoihiRoot.Shell storage shell, uint8 _oIndex, uint8 _tIndex, uint256[] memory _balances) internal returns (uint256 tNAmt_, uint256 psi_) {

//         // tNAmt_ = _oNAmt.omul(OCTOPUS - shell.epsilon);

//         // uint256 _oNFAmt = tNAmt_;
//         // uint256 _nGLiq;
//         // uint256[] memory _weights = shell.weights;
//         // uint256 _omega = shell.omega;
//         // uint256 _lambda = shell.lambda;
//         // for (uint8 j = 0; j < 10; j++) {

//         //     psi_ = 0;
//         //     _nGLiq = _grossLiq + _oNAmt - tNAmt_;

//         //     for (uint8 i = 0; i < _weights.length; i++) {

//         //         uint256 _bal;
//         //         uint256 _nIdeal = _nGLiq.omul(_weights[i]);

//         //         if (i == _oIndex) _bal = _balances[i] + _oNAmt;
//         //         else if (i == _tIndex) _bal = _balances[i] - tNAmt_;
//         //         else _bal = _balances[i];

//         //         {
//         //             psi_ += makeFee(shell, _bal, _nIdeal);
//         //         }

//         //     }

//         //     if (_omega < psi_) { // 32.7k gas savings against 10^13/10^14 vs 10^10
//         //         if ((tNAmt_ = _oNFAmt + _omega - psi_) / 1e14 == tNAmt_ / 1e14) break;
//         //     } else {
//         //         if ((tNAmt_ = _oNFAmt + _lambda.omul(_omega - psi_)) / 1e14 == tNAmt_ / 1e14) break;
//         //     }

//         // }

//         // tNAmt_ = tNAmt_.omul(OCTOPUS - shell.epsilon);

//         // {
//         //     uint256 _alpha = shell.alpha;
//         //     for (uint8 i = 0; i < _balances.length; i++) {

//         //         uint256 _nBal;
//         //         if (i == _oIndex) _nBal = _balances[i].add(_oNAmt);
//         //         if (i == _tIndex) _nBal = _balances[i].sub(tNAmt_);
//         //         else _nBal = _balances[i];

//         //         uint256 _ideal = _nGLiq.omul(_weights[i]);

//         //         if (_nBal < _ideal) require(_nBal > _ideal.omul(OCTOPUS - _alpha), "Loihi/lower-halt-check");
//         //         else require(_nBal < _ideal.omul(OCTOPUS + _alpha), "Loihi/upper-halt-check");

//         //     }
//         // }

//         // emit log_uint("end of calculate target amount", gasleft());

//     }

//     /// @dev this function figures out the origin amount
//     /// @return oNAmt_ origin amount
//     function calculateOriginAmount (uint256 _grossLiq, uint256 _tNAmt, LoihiRoot.Shell storage shell, uint8 _oIndex, uint8 _tIndex, uint256[] memory _balances) internal returns (uint256 oNAmt_, uint256 psi_) {

//         // oNAmt_ = _tNAmt.omul(OCTOPUS + shell.epsilon);

//         // uint256 _tNFAmt = oNAmt_;
//         // uint256 _nGLiq;
//         // uint256[] memory _weights = shell.weights;
//         // uint256 _omega = shell.omega;
//         // uint256 _lambda = shell.lambda;
//         // for (uint8 j = 0; j < 10; j++) {

//         //     psi_ = 0;
//         //     _nGLiq = _grossLiq + oNAmt_ - _tNAmt;

//         //     for (uint8 i = 0; i < _weights.length; i++) {

//         //         uint256 _bal;
//         //         uint256 _nIdeal = _nGLiq.omul(_weights[i]);

//         //         if (i == _oIndex) _bal = _balances[i] + oNAmt_;
//         //         else if (i == _tIndex) _bal = _balances[i] - _tNAmt;
//         //         else _bal = _balances[i];

//         //         psi_ += makeFee(shell, _bal, _nIdeal);

//         //     }

//         //     if (_omega < psi_) {
//         //         if ((oNAmt_ = _tNFAmt + psi_ - _omega) / 1e14 == oNAmt_ / 1e14) break;
//         //     } else {
//         //         if ((oNAmt_ = _tNFAmt - _lambda.omul(_omega - psi_)) / 1e14 == oNAmt_ / 1e14) break;
//         //     }

//         // }

//         // oNAmt_ = oNAmt_.omul(OCTOPUS + shell.epsilon);

//         // {
//         //     uint256 _alpha = shell.alpha;
//         //     for (uint8 i = 0; i < _balances.length; i++) {

//         //         uint256 _nBal;
//         //         if (i == _oIndex) _nBal = _balances[i].add(oNAmt_);
//         //         if (i == _tIndex) _nBal = _balances[i].sub(_tNAmt);
//         //         else _nBal = _balances[i];

//         //         uint256 _ideal = _nGLiq.omul(_weights[i]);

//         //         if (_nBal < _ideal) require(_nBal > _ideal.omul(OCTOPUS - _alpha), "Loihi/lower-halt-check");
//         //         else require(_nBal < _ideal.omul(OCTOPUS + _alpha), "Loihi/upper-halt-check");


//         //     }
//         // }

//     }

//     /// @notice this function makes our fees!
//     /// @return fee_ the fee.
//     function makeFee (LoihiRoot.Shell storage shell, uint256 _bal, uint256 _ideal) internal view returns (uint256 fee_) {

//         // uint256 _threshold;
//         // uint256 _beta = shell.beta;
//         // uint256 _delta = shell.delta;
//         // if (_bal < _ideal) {

//         //     if (_bal < (_threshold = _ideal.omul(OCTOPUS-_beta))) {
//         //         fee_ = _delta.odiv(_ideal);
//         //         fee_ = fee_.omul(_threshold = _threshold.sub(_bal));
//         //         if (fee_ > 25e16) fee_ = 25e16 - 1;
//         //         fee_ = fee_.omul(_threshold);
//         //     } else fee_ = 0;

//         // } else {

//         //     if (_bal > (_threshold = _ideal.omul(OCTOPUS+_beta))) {
//         //         fee_ = _delta.odiv(_ideal);
//         //         fee_ = fee_.omul(_threshold = _bal.sub(_threshold));
//         //         if (fee_ > 25e16) fee_ = 25e16 - 1;
//         //         fee_ = fee_.omul(_threshold);
//         //     } else fee_ = 0;

//         // }

//     }

//     function getBalancesAndGrossLiq (LoihiRoot.Shell storage shell) internal view returns (uint256[] memory, uint256 grossLiq_) {
//         // uint256[] memory balances_ = new uint256[](shell.reserves.length);
//         // for (uint8 i = 0; i < shell.reserves.length; i++) {
//         //     balances_[i] = shell.reserves[i].viewNumeraireBalance(address(this));
//         //     grossLiq_ = grossLiq_.add(balances_[i]);
//         // }
//         // return (balances_, grossLiq_);
//     }

// }