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

// import "./LoihiDelegators.sol";
// import "./LoihiMath.sol";
// import "./LoihiRoot.sol";

// library LoihiLiquidity {

//     using LoihiDelegators for address;
//     using LoihiMath for uint256;

//     event Transfer(address indexed from, address indexed to, uint256 value);
//     event ShellsMinted(address indexed minter, uint256 amount, address[] indexed coins, uint256[] amounts);
//     event ShellsBurned(address indexed burner, uint256 amount, address[] indexed coins, uint256[] amounts);

//     uint256 constant OCTOPUS = 1e18;

//     /// @dev selective the withdrawal of any supported stablecoin flavor. refer to Loihi.bin selectiveWithdraw for detailed explanation of parameters
//     /// @return shellsBurned_ amount of shell tokens to withdraw the specified amount of specified flavors
//     function executeSelectiveWithdraw (LoihiRoot.Shell storage shell, address[] memory _flvrs, uint256[] memory _amts, uint256 _maxShells, uint256 _deadline) internal returns (uint256 shellsBurned_) {
//         // require(_deadline >= now, "deadline has passed for this transaction");

//         // // LoihiRoot.Assimilator[] memory _assims = 

//         // ( uint256[] memory _balances, uint256[] memory _withdrawals ) = getBalancesAndAmounts(shell, _flvrs, _amts);

//         // ( shellsBurned_, shell.omega ) = calculateShellsToBurn(shell, _balances, _withdrawals);

//         // require(shellsBurned_ <= shell.balances[msg.sender], "withdrawal amount exceeds balance");

//         // require(shellsBurned_ <= _maxShells, "withdrawal exceeds max shells limit");

//         // for (uint8 i = 0; i < _flvrs.length; i++) if (_amts[i] > 0) shell.assimilators[_flvrs[i]].addr.outputRaw(msg.sender, _amts[i]);

//         // _burn(shell, msg.sender, shellsBurned_);

//         // emit ShellsBurned(msg.sender, shellsBurned_, _flvrs, _amts);

//         // return shellsBurned_;

//     }

//     function viewSelectiveWithdraw (LoihiRoot.Shell storage shell, address[] memory _flvrs, uint256[] memory _amts) internal returns (uint256 shellsToBurn_) {

//         // ( uint256[] memory _balances, uint256[] memory _withdrawals ) = getBalancesAndAmounts(shell, _flvrs, _amts);

//         // ( shellsToBurn_, ) = calculateShellsToBurn(shell, _balances, _withdrawals);

//     }

//     /// @dev this function calculates the amount of shells to burn by taking the balances and numeraire deposits of the reserve tokens being deposited into
//     /// @return shellsToBurn_ the amount of shells the withdraw will burn
//     /// @return psi_ the new fee
//     function calculateShellsToBurn (LoihiRoot.Shell storage shell, uint256[] memory _balances, uint256[] memory _withdrawals) internal returns (uint256 shellsToBurn_, uint256 psi_) {

//         // uint256 _nSum; uint256 _oSum;
//         // for (uint8 i = 0; i < _balances.length; i++) {
//         //     _oSum += _balances[i];
//         //     _nSum += _balances[i] = _balances[i].sub(_withdrawals[i]);
//         // }

//         // {
//         //     uint256 _alpha = shell.alpha;
//         //     for (uint8 i = 0; i < _balances.length; i++) {
//         //         uint256 _nBal = _balances[i];
//         //         uint256 _nIdeal = _nSum.omul(shell.weights[i]);

//         //         if (_nBal > _nIdeal) {
//         //             uint256 _nHalt = _nIdeal.omul(OCTOPUS + _alpha);
//         //             uint256 _oHalt = 0; // TODO
//         //             uint256 _oBal = 0; // TODO

//         //             if (_nBal > _nHalt) {
//         //                 if (_oBal < _oHalt || _nBal - _nHalt > _oBal - _oHalt) revert("upper-halt");
//         //             }

//         //         } else {
//         //             if (_nBal < _nHalt) {
//         //                 if (_oBal > _nHalt || _nHalt - _nBal > _oHalt - _nHalt) revert("lower-halt");
//         //             }
//         //         }

//         //         psi_ += makeFee(shell, _nBal, _nIdeal);
//         //     }
//         // }

//         // {
//         //     uint256 _omega = shell.omega;
//         //     uint256 _oUtil = _oSum.sub(_omega);
//         //     if (_omega < psi_) {
//         //         uint256 _nUtil = _nSum.sub(psi_);
//         //         if (_oUtil == 0) shellsToBurn_ = _nUtil;
//         //         else shellsToBurn_ = _oUtil.sub(_nUtil).omul(shell.totalSupply).odiv(_oUtil);
//         //     } else {
//         //         uint256 _lambda = shell.lambda;
//         //         uint256 _nUtil = _nSum.sub(psi_.omul(_lambda));
//         //         if (_oUtil == 0) shellsToBurn_ = _nUtil;
//         //         else {
//         //             uint256 _oUtilPrime = _oSum.sub(_omega.omul(_lambda));
//         //             shellsToBurn_ = _oUtilPrime.sub(_nUtil).omul(shell.totalSupply).odiv(_oUtil);
//         //         }
//         //     }
//         // }

//         // shellsToBurn_ = shellsToBurn_.omul(OCTOPUS + shell.epsilon);

//     }

//     /// @dev selective depositing of any supported stablecoin flavor into the contract in return for corresponding shell tokens
//     /// @return shellsMinted_ the amount of shells to mint for the deposited stablecoin flavors
//     function executeSelectiveDeposit (LoihiRoot.Shell storage shell, address[] memory _flvrs, uint256[] memory _amts, uint256 _minShells, uint256 _deadline) internal returns (uint256 shellsMinted_) {
//         // require(_deadline >= now, "deadline has passed for this transaction");

//         // ( uint256[] memory _balances, uint256[] memory _deposits ) = getBalancesAndAmounts(shell, _flvrs, _amts);

//         // ( shellsMinted_, shell.omega ) = calculateShellsToMint(shell, _balances, _deposits);

//         // require(shellsMinted_ >= _minShells, "minted shells less than minimum shells");

//         // _mint(shell, msg.sender, shellsMinted_);

//         // for (uint8 i = 0; i < _flvrs.length; i++) if (_amts[i] > 0) shell.assimilators[_flvrs[i]].addr.intakeRaw(_amts[i]);

//         // emit ShellsMinted(msg.sender, shellsMinted_, _flvrs, _amts);

//         // return shellsMinted_;

//     }

//     function viewSelectiveDeposit (LoihiRoot.Shell storage shell, address[] memory _flvrs, uint256[] memory _amts) internal returns (uint256 shellsToMint_) {

//         // ( uint256[] memory _balances, uint256[] memory _withdrawals ) = getBalancesAndAmounts(shell, _flvrs, _amts);

//         // ( shellsToMint_, ) = calculateShellsToMint(shell, _balances, _withdrawals);

//     }

//     /// @dev this function calculates the amount of shells to mint by taking the balances and numeraire deposits of the reserve tokens being deposited into
//     /// @return shellsToMint_ the amount of shells the deposit will mint
//     /// @return psi_ the new fee
//     function calculateShellsToMint (LoihiRoot.Shell storage shell, uint256[] memory _balances, uint256[] memory _deposits) internal returns (uint256 shellsToMint_, uint256 psi_) {

//         // uint256 _nSum; uint256 _oSum;
//         // for (uint8 i = 0; i < _balances.length; i++) {
//         //     _oSum += _balances[i];
//         //     _nSum += _balances[i] = _balances[i].add(_deposits[i]);
//         // }

//         // require(_oSum < _nSum, "insufficient-deposit");

//         // {
//         //     uint256 _alpha = shell.alpha;
//         //     uint256[] memory _weights = shell.weights;
//         //     for (uint8 i = 0; i < _balances.length; i++) {
//         //         uint256 _nBal = _balances[i];
//         //         uint256 _nIdeal = _weights[i].omul(_nSum);
//         //         if (_nBal > _nIdeal) require(_nBal <= _nIdeal.omul(OCTOPUS + _alpha), "deposit upper halt check");
//         //         else require(_nBal >= _nIdeal.omul(OCTOPUS - _alpha), "deposit lower halt check");
//         //         psi_ += makeFee(shell, _nBal, _nIdeal);
//         //     }
//         // }

//         // {
//         //     uint256 _omega = shell.omega;
//         //     uint256 _totalSupply = shell.totalSupply;
//         //     uint256 _oUtil = _oSum - _omega;
//         //     if (_omega < psi_) {
//         //         uint256 _nUtil = _nSum - psi_;
//         //         if (_oUtil == 0 || _totalSupply == 0) shellsToMint_ = _nUtil;
//         //         else shellsToMint_ = (_nUtil - _oUtil).omul(_totalSupply).odiv(_oUtil);
//         //     } else {
//         //         uint256 _lambda = shell.lambda;
//         //         uint256 _nUtil = _nSum - psi_.omul(_lambda);
//         //         if (_oUtil == 0 || _totalSupply == 0) shellsToMint_ = _nUtil;
//         //         else {
//         //             uint256 _oUtilPrime = _oSum - _omega.omul(_lambda);
//         //             shellsToMint_ = (_nUtil - _oUtilPrime).omul(_totalSupply).odiv(_oUtil);
//         //         }
//         //     }
//         // }

//         // shellsToMint_ = shellsToMint_.omul(OCTOPUS - shell.epsilon);

//     }

//     /// @dev get the current balances and incoming/outgoing token amounts for the deposit/withdraw
//     /// @return two arrays the length of the number of reserves containing the current balances and incoming/outgoing token amounts
//     function getBalancesAndAmounts (LoihiRoot.Shell storage shell, uint256[] memory _fIxs, uint256[] memory _amts) internal returns (uint256[] memory, uint256[] memory) {

//         // address[] memory _reserves = shell.reserves;
//         // uint256[] memory balances_ = new uint256[](_reserves.length);
//         // uint256[] memory amounts_ = new uint256[](_reserves.length);

//         // for (uint8 i = 0; i < _flvrs.length; i++) {

//         //     LoihiRoot.Assimilator memory _a = shell.assimilators[_flvrs[i]]; // withdrawing adapter + weight

//         //     require(_a.addr != address(0), "flavor not supported");

//         //     amounts_[_a.ix] += _a.addr.viewNumeraireAmount(_amts[i]);

//         //     if (balances_[_a.ix] == 0) balances_[_a.ix] = _a.addr.viewNumeraireBalance(address(this));

//         // }

//         // return (balances_, amounts_);
//     }

//     /// @notice this function makes our fees!
//     /// @return fee_ the fee.
//     function makeFee (LoihiRoot.Shell storage shell, uint256 _bal, uint256 _ideal) internal view returns (uint256 fee_) {

//         // uint256 _threshold;
//         // uint256 _beta = shell.beta;
//         // uint256 _delta = shell.delta;
//         // if (_bal < (_threshold = _ideal.omul(OCTOPUS - _beta))) {
//         //     fee_ = _delta.odiv(_ideal);
//         //     fee_ = fee_.omul(_threshold = _threshold - _bal);
//         //     fee_ = fee_.omul(_threshold);
//         // } else if (_bal > (_threshold = _ideal.omul(OCTOPUS + _beta))) {
//         //     fee_ = _delta.odiv(_ideal);
//         //     fee_ = fee_.omul(_threshold = _bal - _threshold);
//         //     fee_ = fee_.omul(_threshold);
//         // } else fee_ = 0;

//     }

    // /// @dev see Loihi.bin proportionalDeposit for a detailed explanation of parameter
    // /// @return shellsMinted_ the amount of shells you receive in return for your deposit
    // function executeProportionalDeposit (LoihiRoot.Shell storage shell, uint256 _deposit) internal returns (uint256 shellsMinted_) {

    //     uint256[] memory _amounts = new uint256[](shell.numeraires.length);
    //     uint256 _oSum;

    //     for (uint8 i = 0; i < shell.reserves.length; i++) {
    //         uint256 _oBal = shell.reserves[i].viewNumeraireBalance(address(this));
    //         _amounts[i] = _oBal;
    //         _oSum += _oBal;
    //     }

    //     if (_oSum == 0) {

    //         for (uint8 i = 0; i < shell.reserves.length; i++) {
    //             LoihiRoot.Assimilator memory _a = shell.assimilators[shell.numeraires[i]];
    //             _amounts[i] = _a.addr.intakeNumeraire(_deposit.omul(shell.weights[i]));
    //         }

    //     } else {

    //         uint256 _multiplier = _deposit.odiv(_oSum);
    //         for (uint8 i = 0; i < shell.reserves.length; i++) {
    //             LoihiRoot.Assimilator memory _a = shell.assimilators[shell.numeraires[i]];
    //             uint256 _value = _amounts[i].omul(_multiplier);
    //             _amounts[i] = _a.addr.intakeNumeraire(_value);
    //         }

    //         shell.omega = shell.omega.omul(OCTOPUS + _multiplier);

    //     }

    //     shellsMinted_ = _deposit.omul(OCTOPUS - shell.epsilon);

    //     if (shell.totalSupply > 0) shellsMinted_ = shellsMinted_.odiv(_oSum).omul(shell.totalSupply);

    //     _mint(shell, msg.sender, shellsMinted_);

    //     emit ShellsMinted(msg.sender, shellsMinted_, shell.numeraires, _amounts);

    //     return shellsMinted_;

    // }

    /// @dev see Loihi.bin proportionalWithdraw for a detailed explanation of parameter
    /// @return withdrawnAmts_ the amount withdrawn from each of the numeraire assets
    // function executeProportionalWithdraw (LoihiRoot.Shell storage shell, uint256 _withdrawal) internal returns (uint256[] memory) {

    //     require(_withdrawal <= shell.balances[msg.sender], "withdrawal amount exceeds your balance");

    //     uint256 _oSum;
    //     uint256[] memory withdrawals_ = new uint256[](shell.reserves.length);

    //     for (uint8 i = 0; i < shell.reserves.length; i++) {
    //         withdrawals_[i] = shell.reserves[i].viewNumeraireBalance(address(this));
    //         _oSum += withdrawals_[i];
    //     }

    //     uint256 _multiplier = _withdrawal.omul(OCTOPUS - shell.epsilon).odiv(shell.totalSupply);

    //     for (uint8 i = 0; i < shell.reserves.length; i++) {
    //         uint256 _value = withdrawals_[i].omul(_multiplier);
    //         LoihiRoot.Assimilator memory _a = shell.assimilators[shell.numeraires[i]];
    //         withdrawals_[i] = _a.addr.outputNumeraire(msg.sender, _value);
    //     }

    //     shell.omega = shell.omega.omul(OCTOPUS - _multiplier);

    //     _burn(shell, msg.sender, _withdrawal);

    //     emit ShellsBurned(msg.sender, _withdrawal, shell.numeraires, withdrawals_);

    //     return withdrawals_;

    // }

//     function _burn(LoihiRoot.Shell storage shell, address account, uint256 amount) internal {
//         // shell.balances[account] = shell.balances[account].sub(amount);
//         // shell.totalSupply = shell.totalSupply.sub(amount);
//         // emit Transfer(msg.sender, address(0), amount);
//     }

//     function _mint(LoihiRoot.Shell storage shell, address account, uint256 amount) internal {
//         // shell.totalSupply = shell.totalSupply.add(amount);
//         // shell.balances[account] = shell.balances[account].add(amount);
//         // emit Transfer(address(0), msg.sender, amount);
//     }

// }