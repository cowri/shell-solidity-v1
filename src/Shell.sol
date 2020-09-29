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

pragma solidity ^0.5.0;

import "abdk-libraries-solidity/ABDKMath64x64.sol";

import "./Orchestrator.sol";

import "./PartitionedLiquidity.sol";

import "./ProportionalLiquidity.sol";

import "./SelectiveLiquidity.sol";

import "./Shells.sol";

import "./Swaps.sol";

import "./ViewLiquidity.sol";

import "./ShellStorage.sol";

import "./interfaces/IFreeFromUpTo.sol";

contract Shell is ShellStorage {

    event Approval(address indexed _owner, address indexed spender, uint256 value);

    event ParametersSet(uint256 alpha, uint256 beta, uint256 delta, uint256 epsilon, uint256 lambda);

    event AssetIncluded(address indexed numeraire, address indexed reserve, uint weight);

    event AssimilatorIncluded(address indexed derivative, address indexed numeraire, address indexed reserve, address assimilator);

    event PartitionRedeemed(address indexed token, address indexed redeemer, uint value);

    event PoolPartitioned(bool partitioned);

    event OwnershipTransfered(address indexed previousOwner, address indexed newOwner);

    event FrozenSet(bool isFrozen);

    event Trade(address indexed trader, address indexed origin, address indexed target, uint256 originAmount, uint256 targetAmount);

    event Transfer(address indexed from, address indexed to, uint256 value);

    IFreeFromUpTo public constant chi = IFreeFromUpTo(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);

    modifier discountCHI {
        uint256 gasStart = gasleft();
        _;
        uint256 gasSpent = 21000 + gasStart - gasleft() + 16 * msg.data.length;
        chi.freeFromUpTo(msg.sender, (gasSpent + 14154) / 41130);
    }

    modifier onlyOwner() {

        require(msg.sender == owner, "Shell/caller-is-not-owner");
        _;

    }

    modifier nonReentrant() {

        require(notEntered, "Shell/re-entered");
        notEntered = false;
        _;
        notEntered = true;

    }

    modifier transactable () {

        require(!frozen, "Shell/frozen-only-allowing-proportional-withdraw");
        _;

    }

    modifier unpartitioned () {

        require(!partitioned, "Shell/pool-partitioned");
        _;

    }

    modifier isPartitioned () {

        require(partitioned, "Shell/pool-not-partitioned");
        _;

    }

    modifier deadline (uint _deadline) {

        require(block.timestamp < _deadline, "Shell/tx-deadline-passed");
        _;

    }

    constructor (
        address[] memory _assets,
        uint[] memory _assetWeights,
        address[] memory _derivativeAssimilators
    ) public {
        
        owner = msg.sender;
        emit OwnershipTransfered(address(0), msg.sender);
        
        Orchestrator.initialize(
            shell,
            numeraires,
            reserves,
            derivatives,
            _assets,
            _assetWeights,
            _derivativeAssimilators
        );

    }

    /// @notice sets the parameters for the pool
    /// @param _alpha the value for alpha (halt threshold) must be less than or equal to 1 and greater than 0
    /// @param _beta the value for beta must be less than alpha and greater than 0
    /// @param _feeAtHalt the maximum value for the fee at the halt point
    /// @param _epsilon the base fee for the pool
    /// @param _lambda the value for lambda must be less than or equal to 1 and greater than zero
    function setParams (
        uint _alpha,
        uint _beta, 
        uint _feeAtHalt,
        uint _epsilon,
        uint _lambda
    ) external onlyOwner {

        Orchestrator.setParams(shell, _alpha, _beta, _feeAtHalt, _epsilon, _lambda);

    }

    /// @notice excludes an assimilator from the shell
    /// @param _derivative the address of the assimilator to exclude
    function excludeDerivative (
        address _derivative
    ) external onlyOwner {

        uint _length = numeraires.length; 

        for (uint i = 0; i < numeraires.length; i++) {
            
            if (_derivative == numeraires[i]) revert("Shell/cannot-delete-numeraire");
            if (_derivative == reserves[i]) revert("Shell/cannot-delete-reserve");
            
        }

        delete shell.assimilators[_derivative];

    }

    /// @notice view the current parameters of the shell
    /// @return alpha_ the current alpha value
    /// @return beta_ the current beta value
    /// @return delta_ the current delta value
    /// @return epsilon_ the current epsilon value
    /// @return lambda_ the current lambda value
    /// @return omega_ the current omega value
    function viewShell () external view returns (
        uint alpha_,
        uint beta_,
        uint delta_,
        uint epsilon_,
        uint lambda_
    ) {

        return Orchestrator.viewShell(shell);

    }

    function setFrozen (bool _toFreezeOrNotToFreeze) external onlyOwner {

        emit FrozenSet(_toFreezeOrNotToFreeze);

        frozen = _toFreezeOrNotToFreeze;

    }

    function transferOwnership (address _newOwner) external onlyOwner {

        emit OwnershipTransfered(owner, _newOwner);

        owner = _newOwner;

    }

    /// @author james foley http://github.com/realisation
    /// @notice swap a dynamic origin amount for a fixed target amount
    /// @param _origin the address of the origin
    /// @param _target the address of the target
    /// @param _originAmount the origin amount
    /// @param _minTargetAmount the minimum target amount
    /// @param _deadline deadline in block number after which the trade will not execute
    /// @return targetAmount_ the amount of target that has been swapped for the origin amount
    function originSwap (
        address _origin,
        address _target,
        uint _originAmount,
        uint _minTargetAmount,
        uint _deadline
    ) external deadline(_deadline) transactable nonReentrant returns (
        uint targetAmount_
    ) {

        targetAmount_ = Swaps.originSwap(shell, _origin, _target, _originAmount, msg.sender);

        require(targetAmount_ > _minTargetAmount, "Shell/below-min-target-amount");

    }

    function originSwapDiscountCHI (
        address _origin,
        address _target,
        uint _originAmount,
        uint _minTargetAmount,
        uint _deadline
    ) external deadline(_deadline) transactable nonReentrant discountCHI returns (
        uint targetAmount_
    ) {

        targetAmount_ = Swaps.originSwap(shell, _origin, _target, _originAmount, msg.sender);

        require(targetAmount_ > _minTargetAmount, "Shell/below-min-target-amount");

    }

    /// @author james foley http://github.com/realisation
    /// @notice view how much target amount a fixed origin amount will swap for
    /// @param _origin the address of the origin
    /// @param _target the address of the target
    /// @param _originAmount the origin amount
    /// @return targetAmount_ the target amount that would have been swapped for the origin amount
    function viewOriginSwap (
        address _origin,
        address _target,
        uint _originAmount
    ) external view transactable returns (
        uint targetAmount_
    ) {

        targetAmount_ = Swaps.viewOriginSwap(shell, _origin, _target, _originAmount);

    }

    /// @author james foley http://github.com/realisation
    /// @notice swap a dynamic origin amount for a fixed target amount
    /// @param _origin the address of the origin
    /// @param _target the address of the target
    /// @param _maxOriginAmount the maximum origin amount
    /// @param _targetAmount the target amount
    /// @param _deadline deadline in block number after which the trade will not execute
    /// @return originAmount_ the amount of origin that has been swapped for the target
    function targetSwap (
        address _origin,
        address _target,
        uint _maxOriginAmount,
        uint _targetAmount,
        uint _deadline
    ) external deadline(_deadline) transactable nonReentrant returns (
        uint originAmount_
    ) {

        originAmount_ = Swaps.targetSwap(shell, _origin, _target, _targetAmount, msg.sender);

        require(originAmount_ < _maxOriginAmount, "Shell/above-max-origin-amount");

    }

    /// @author james foley http://github.com/realisation
    /// @notice view how much of the origin currency the target currency will take
    /// @param _origin the address of the origin
    /// @param _target the address of the target
    /// @param _targetAmount the target amount
    /// @return originAmount_ the amount of target that has been swapped for the origin
    function viewTargetSwap (
        address _origin,
        address _target,
        uint _targetAmount
    ) external view transactable returns (
        uint originAmount_
    ) {

        originAmount_ = Swaps.viewTargetSwap(shell, _origin, _target, _targetAmount);

    }

    /// @author james foley http://github.com/realisation
    /// @notice selectively deposit any supported stablecoin flavor into the contract in return for corresponding amount of shell tokens
    /// @param _derivatives an array containing the addresses of the flavors being deposited into
    /// @param _amounts an array containing the values of the flavors you wish to deposit into the contract. each amount should have the same index as the flavor it is meant to deposit
    /// @param _minShells minimum acceptable amount of shells
    /// @param _deadline deadline for tx
    /// @return shellsToMint_ the amount of shells to mint for the deposited stablecoin flavors
    function selectiveDeposit (
        address[] calldata _derivatives,
        uint[] calldata _amounts,
        uint _minShells,
        uint _deadline
    ) external deadline(_deadline) transactable nonReentrant returns (
        uint shellsMinted_
    ) {

        shellsMinted_ = SelectiveLiquidity.selectiveDeposit(shell, _derivatives, _amounts, _minShells);

    }

    /// @author james folew http://github.com/realisation
    /// @notice view how many shell tokens a deposit will mint
    /// @param _derivatives an array containing the addresses of the flavors being deposited into
    /// @param _amounts an array containing the values of the flavors you wish to deposit into the contract. each amount should have the same index as the flavor it is meant to deposit
    /// @return shellsToMint_ the amount of shells to mint for the deposited stablecoin flavors
    function viewSelectiveDeposit (
        address[] calldata _derivatives,
        uint[] calldata _amounts
    ) external view transactable returns (
        uint shellsToMint_
    ) {

        shellsToMint_ = SelectiveLiquidity.viewSelectiveDeposit(shell, _derivatives, _amounts);

    }

    /// @author james foley http://github.com/realisation
    /// @notice deposit into the pool with no slippage from the numeraire assets the pool supports
    /// @param  _deposit the full amount you want to deposit into the pool which will be divided up evenly amongst the numeraire assets of the pool
    /// @return shellsToMint_ the amount of shells you receive in return for your deposit
    /// @return deposits_ the amount deposited for each numeraire
    function proportionalDeposit (
        uint _deposit,
        uint _deadline
    ) external deadline(_deadline) transactable nonReentrant returns (
        uint shellsMinted_,
        uint[] memory deposits_
    ) {

        return ProportionalLiquidity.proportionalDeposit(shell, _deposit);

    }

    /// @author james foley http://github.com/realisation
    /// @notice view deposits and shells minted a given deposit would return
    /// @param _deposit the full amount of stablecoins you want to deposit. Divided evenly according to the prevailing proportions of the numeraire assets of the pool
    /// @return shellsToMint_ the amount of shells you receive in return for your deposit
    /// @return deposits_ the amount deposited for each numeraire
    function viewProportionalDeposit (
        uint _deposit
    ) external view transactable returns (
        uint shellsToMint_,
        uint[] memory depositsToMake_
    ) {

        return ProportionalLiquidity.viewProportionalDeposit(shell, _deposit);

    }

    /// @author james foley http://github.com/realisation
    /// @notice selectively withdrawal any supported stablecoin flavor from the contract by burning a corresponding amount of shell tokens
    /// @param _derivatives an array of flavors to withdraw from the reserves
    /// @param _amounts an array of amounts to withdraw that maps to _flavors
    /// @param _maxShells the maximum amount of shells you want to burn
    /// @param _deadline timestamp after which the transaction is no longer valid
    /// @return shellsBurned_ the corresponding amount of shell tokens to withdraw the specified amount of specified flavors
    function selectiveWithdraw (
        address[] calldata _derivatives,
        uint[] calldata _amounts,
        uint _maxShells,
        uint _deadline
    ) external deadline(_deadline) transactable nonReentrant returns (
        uint shellsBurned_
    ) {

        shellsBurned_ = SelectiveLiquidity.selectiveWithdraw(shell, _derivatives, _amounts, _maxShells);

    }

    /// @author james foley http://github.com/realisation
    /// @notice view how many shell tokens a withdraw will consume
    /// @param _derivatives an array of flavors to withdraw from the reserves
    /// @param _amounts an array of amounts to withdraw that maps to _flavors
    /// @return shellsBurned_ the corresponding amount of shell tokens to withdraw the specified amount of specified flavors
    function viewSelectiveWithdraw (
        address[] calldata _derivatives,
        uint[] calldata _amounts
    ) external view transactable returns (
        uint shellsToBurn_
    ) {

        shellsToBurn_ = SelectiveLiquidity.viewSelectiveWithdraw(shell, _derivatives, _amounts);

    }

    /// @author  james foley http://github.com/realisation
    /// @notice  withdrawas amount of shell tokens from the the pool equally from the numeraire assets of the pool with no slippage
    /// @param   _shellsToBurn the full amount you want to withdraw from the pool which will be withdrawn from evenly amongst the numeraire assets of the pool
    /// @return withdrawals_ the amonts of numeraire assets withdrawn from the pool
    function proportionalWithdraw (
        uint _shellsToBurn,
        uint _deadline
    ) external deadline(_deadline) unpartitioned nonReentrant returns (
        uint[] memory withdrawals_
    ) {

        return ProportionalLiquidity.proportionalWithdraw(shell, _shellsToBurn);

    }

    function supportsInterface (
        bytes4 _interface
    ) public view returns (
        bool supports_
    ) { 

        supports_ = this.supportsInterface.selector == _interface  // erc165
            || bytes4(0x7f5828d0) == _interface                   // eip173
            || bytes4(0x36372b07) == _interface;                 // erc20
        
    }

    /// @author  james foley http://github.com/realisation
    /// @notice  withdrawals amount of shell tokens from the the pool equally from the numeraire assets of the pool with no slippage
    /// @param   _shellsToBurn the full amount you want to withdraw from the pool which will be withdrawn from evenly amongst the numeraire assets of the pool
    /// @return withdrawalsToHappen_ the amonts of numeraire assets withdrawn from the pool
    function viewProportionalWithdraw (
        uint _shellsToBurn
    ) external view unpartitioned returns (
        uint[] memory withdrawalsToHappen_
    ) {

        return ProportionalLiquidity.viewProportionalWithdraw(shell, _shellsToBurn);

    }

    function partition () external onlyOwner {

        require(frozen, "Shell/must-be-frozen");

        PartitionedLiquidity.partition(shell, partitionTickets);

        partitioned = true;

    }
    
    /// @author  james foley http://github.com/realisation
    /// @notice  withdraws amount of shell tokens from the the pool equally from the numeraire assets of the pool with no slippage
    /// @param _tokens an array of the numeraire assets you will withdraw
    /// @param _amounts an array of the amounts in terms of partitioned shels you want to withdraw from that numeraire partition
    /// @return withdrawals_ the amounts of the numeraire assets withdrawn
    function partitionedWithdraw (
        address[] calldata _tokens,
        uint256[] calldata _amounts
    ) external isPartitioned returns (
        uint256[] memory withdrawals_
    ) {

        return PartitionedLiquidity.partitionedWithdraw(shell, partitionTickets, _tokens, _amounts);

    }

    /// @author  james foley http://github.com/realisation
    /// @notice  views the balance of the users partition ticket
    /// @param _addr the address whose balances in partitioned shells to be seen
    /// @return claims_ the remaining claims in terms of partitioned shells the address has in its partition ticket
    function viewPartitionClaims (
        address _addr
    ) external view isPartitioned returns (
        uint[] memory claims_
    ) {

        return PartitionedLiquidity.viewPartitionClaims(shell, partitionTickets, _addr);

    }

    /// @notice transfers shell tokens
    /// @param _recipient the address of where to send the shell tokens
    /// @param _amount the amount of shell tokens to send
    /// @return success_ the success bool of the call
    function transfer (
        address _recipient,
        uint _amount
    ) public nonReentrant returns (
        bool success_
    ) {

        require(!partitionTickets[msg.sender].initialized, "Shell/no-transfers-once-partitioned");

        success_ = Shells.transfer(shell, _recipient, _amount);

    }

    /// @notice transfers shell tokens from one address to another address
    /// @param _sender the account from which the shell tokens will be sent
    /// @param _recipient the account to which the shell tokens will be sent
    /// @param _amount the amount of shell tokens to transfer
    /// @return success_ the success bool of the call
    function transferFrom (
        address _sender,
        address _recipient,
        uint _amount
    ) public nonReentrant returns (
        bool success_
    ) {

        require(!partitionTickets[_sender].initialized, "Shell/no-transfers-once-partitioned");

        success_ = Shells.transferFrom(shell, _sender, _recipient, _amount);

    }

    /// @notice approves a user to spend shell tokens on their behalf
    /// @param _spender the account to allow to spend from msg.sender
    /// @param _amount the amount to specify the spender can spend
    /// @return success_ the success bool of this call
    function approve (address _spender, uint _amount) public nonReentrant returns (bool success_) {

        success_ = Shells.approve(shell, _spender, _amount);

    }

    /// @notice view the shell token balance of a given account
    /// @param _account the account to view the balance of  
    /// @return balance_ the shell token ballance of the given account
    function balanceOf (
        address _account
    ) public view returns (
        uint balance_
    ) {

        balance_ = shell.balances[_account];

    }

    /// @notice views the total shell supply of the pool
    /// @return totalSupply_ the total supply of shell tokens
    function totalSupply () public view returns (uint totalSupply_) {

        totalSupply_ = shell.totalSupply;

    }

    /// @notice views the total allowance one address has to spend from another address
    /// @param _owner the address of the owner 
    /// @param _spender the address of the spender
    /// @return allowance_ the amount the owner has allotted the spender
    function allowance (
        address _owner,
        address _spender
    ) public view returns (
        uint allowance_
    ) {

        allowance_ = shell.allowances[_owner][_spender];

    }

    /// @notice views the total amount of liquidity in the shell in numeraire value and format - 18 decimals
    /// @return total_ the total value in the shell
    /// @return individual_ the individual values in the shell
    function liquidity () public view returns (
        uint total_,
        uint[] memory individual_
    ) {

        return ViewLiquidity.viewLiquidity(shell);

    }
    
    /// @notice view the assimilator address for a derivative
    /// @return assimilator_ the assimilator address
    function assimilator (
        address _derivative
    ) public view returns (
        address assimilator_
    ) {

        assimilator_ = shell.assimilators[_derivative].addr;

    }

}