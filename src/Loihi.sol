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

import "./Assimilators.sol";

import "./Orchestrator.sol";

import "./Liquidity.sol";

import "./PartitionedLiquidity.sol";

import "./ProportionalLiquidity.sol";

import "./SelectiveLiquidity.sol";

import "./Shells.sol";

import "./Swaps.sol";

contract Loihi {

    string  public constant name = "Shells";
    string  public constant symbol = "SHL";
    uint8   public constant decimals = 18;

    struct Shell {
        int128 alpha;
        int128 beta;
        int128 delta;
        int128 epsilon;
        int128 lambda;
        int128 omega;
        int128[] weights;
        uint totalSupply;
        mapping (address => uint) balances;
        mapping (address => mapping (address => uint)) allowances;
        Assimilator[] reserves;
        Assimilator[] numeraires;
        mapping (address => Assimilator) assimilators;
        bool testHalts;
    }

    struct Assimilator {
        address addr;
        uint8 ix;
    }

    Shell public shell;

    struct PartitionTicket {
        uint[] claims;
        bool active;
    }

    mapping (address => PartitionTicket) public partitionTickets;

    address[] public numeraires;

    bool public partitioned = false;
    bool public frozen = false;

    address public owner;
    bool internal notEntered = true;

    uint public maxFee;

    event Approval(address indexed _owner, address indexed spender, uint256 value);

    event ParametersSet(uint256 alpha, uint256 beta, uint256 delta, uint256 epsilon, uint256 lambda, uint omega);

    event AssetIncluded(address indexed numeraire, address indexed reserve, uint weight);

    event AssimilatorIncluded(address indexed derivative, address indexed numeraire, address indexed reserve, address assimilator);

    event PartitionRedeemed(address indexed token, address indexed redeemer, uint value);

    event PoolPartitioned(bool partitioned);

    event OwnershipTransfered(address indexed previousOwner, address indexed newOwner);

    event FrozenSet(bool isFrozen);

    event Trade(address indexed trader, address indexed origin, address indexed target, uint256 originAmount, uint256 targetAmount);

    event Transfer(address indexed from, address indexed to, uint256 value);

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


    constructor () public {

        owner = msg.sender;
        emit OwnershipTransfered(address(0), msg.sender);
        shell.testHalts = true;

    }

    function setParams (uint _alpha, uint _beta, uint _deltaDerivative, uint _epsilon, uint _lambda, uint[] calldata _weights) external onlyOwner {

        maxFee = Orchestrator.setParams(shell, _alpha, _beta, _deltaDerivative, _epsilon, _lambda, _weights);

    }

    function includeAsset (address _numeraire, address _nAssim, address _reserve, address _rAssim, uint _weight) external onlyOwner {

        Orchestrator.includeAsset(shell, numeraires, _numeraire, _nAssim, _reserve, _rAssim, _weight);

    }

    function includeAssimilator (address _derivative, address _numeraire, address _reserve, address _assimilator) external onlyOwner {

        Orchestrator.includeAssimilator(shell, _derivative, _numeraire, _reserve, _assimilator);

    }

    function excludeAssimilator (address _assimilator) external onlyOwner {

        delete shell.assimilators[_assimilator];

    }

    function viewShell () external view returns (
        uint alpha_,
        uint beta_,
        uint delta_,
        uint epsilon_,
        uint lambda_,
        uint omega_
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

    function prime () external {

        Orchestrator.prime(shell);

    }

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


    function originSwapTo (
        address _origin,
        address _target,
        uint _originAmount,
        uint _minTargetAmount,
        uint _deadline,
        address _recipient
    ) external deadline(_deadline) transactable nonReentrant returns (
        uint targetAmount_
    ) {

        targetAmount_ = Swaps.originSwap(shell, _origin, _target, _originAmount, _recipient);

        require(targetAmount_ > _minTargetAmount, "Shell/below-min-target-amount");

    }

    function viewOriginSwap (
        address _origin,
        address _target,
        uint _originAmount
    ) external view transactable returns (
        uint targetAmount_
    ) {

        targetAmount_ = Swaps.viewOriginSwap(shell, _origin, _target, _originAmount);

    }


    // / @author james foley http://github.com/realisation
    // / @notice swap a dynamic origin amount for a fixed target amount
    // / @param _origin the address of the origin
    // / @param _target the address of the target
    // / @param _maxOriginAmount the maximum origin amount
    // / @param _targetAmount the target amount
    // / @param _deadline deadline in block number after which the trade will not execute
    // / @return originAmount_ the amount of origin that has been swapped for the target
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

    // / @author james foley http://github.com/realisation
    // / @notice transfer a dynamic origin amount into a fixed target amount at the recipients address
    // / @param _origin the address of the origin
    // / @param _target the address of the target
    // / @param _maxOriginAmount the maximum origin amount
    // / @param _targetAmount the target amount
    // / @param _deadline deadline in block number after which the trade will not execute
    // / @param _recipient the address of the recipient of the target
    // / @return originAmount_ the amount of origin that has been swapped for the target
    function targetSwapTo (
        address _origin,
        address _target,
        uint _maxOriginAmount,
        uint _targetAmount,
        uint _deadline,
        address _recipient
    ) external deadline(_deadline) transactable nonReentrant returns (
        uint originAmount_
    ) {

        originAmount_ = Swaps.targetSwap(shell, _origin, _target, _targetAmount, _recipient);

        require(originAmount_ < _maxOriginAmount, "Shell/above-max-origin-amount");

    }

    // / @author james foley http://github.com/realisation
    // / @notice view how much of the origin currency the target currency will take
    // / @param _origin the address of the origin
    // / @param _target the address of the target
    // / @param _targetAmount the target amount
    // / @return originAmount_ the amount of target that has been swapped for the origin
    function viewTargetSwap (
        address _origin,
        address _target,
        uint _targetAmount
    ) external view transactable returns (
        uint originAmount_
    ) {

        originAmount_ = Swaps.viewTargetSwap(shell, _origin, _target, _targetAmount);

    }

    // / @author james foley http://github.com/realisation
    // / @notice selectively deposit any supported stablecoin flavor into the contract in return for corresponding amount of shell tokens
    // / @param _derivatives an array containing the addresses of the flavors being deposited into
    // / @param _amounts an array containing the values of the flavors you wish to deposit into the contract. each amount should have the same index as the flavor it is meant to deposit
    // / @param _minShells minimum acceptable amount of shells
    // / @param _deadline deadline for tx
    // / @return shellsToMint_ the amount of shells to mint for the deposited stablecoin flavors
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

    // / @author james folew http://github.com/realisation
    // / @notice view how many shell tokens a deposit will mint
    // / @param _derivatives an array containing the addresses of the flavors being deposited into
    // / @param _amounts an array containing the values of the flavors you wish to deposit into the contract. each amount should have the same index as the flavor it is meant to deposit
    // / @return shellsToMint_ the amount of shells to mint for the deposited stablecoin flavors
    function viewSelectiveDeposit (
        address[] calldata _derivatives,
        uint[] calldata _amounts
    ) external view transactable returns (
        uint shellsToMint_
    ) {

        shellsToMint_ = SelectiveLiquidity.viewSelectiveDeposit(shell, _derivatives, _amounts);

    }

    // / @author james foley http://github.com/realisation
    // / @notice deposit into the pool with no slippage from the numeraire assets the pool supports
    // / @param  _deposit the full amount you want to deposit into the pool which will be divided up evenly amongst the numeraire assets of the pool
    // / @return shellsToMint_ the amount of shells you receive in return for your deposit
    function proportionalDeposit (
        uint _deposit,
        uint _deadline
    ) external deadline(_deadline) transactable nonReentrant returns (
        uint shellsMinted_,
        uint[] memory deposits_
    ) {

        return ProportionalLiquidity.proportionalDeposit(shell, _deposit);

    }

    function viewProportionalDeposit (
        uint _deposit
    ) external view transactable returns (
        uint shellsToMint_,
        uint[] memory deposits_
    ) {

        return ProportionalLiquidity.viewProportionalDeposit(shell, _deposit);

    }

    // / @author james foley http://github.com/realisation
    // / @notice selectively withdrawal any supported stablecoin flavor from the contract by burning a corresponding amount of shell tokens
    // / @param _derivatives an array of flavors to withdraw from the reserves
    // / @param _amounts an array of amounts to withdraw that maps to _flavors
    // / @return shellsBurned_ the corresponding amount of shell tokens to withdraw the specified amount of specified flavors
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

    // / @author james foley http://github.com/realisation
    // / @notice view how many shell tokens a withdraw will consume
    // / @param _derivatives an array of flavors to withdraw from the reserves
    // / @param _amounts an array of amounts to withdraw that maps to _flavors
    // / @return shellsBurned_ the corresponding amount of shell tokens to withdraw the specified amount of specified flavors
    function viewSelectiveWithdraw (
        address[] calldata _derivatives,
        uint[] calldata _amounts
    ) external view transactable returns (
        uint shellsToBurn_
    ) {

        shellsToBurn_ = SelectiveLiquidity.viewSelectiveWithdraw(shell, _derivatives, _amounts);

    }

    // / @author  james foley http://github.com/realisation
    // / @notice  withdrawas amount of shell tokens from the the pool equally from the numeraire assets of the pool with no slippage
    // / @param   _withdrawal the full amount you want to withdraw from the pool which will be withdrawn from evenly amongst the numeraire assets of the pool
    function proportionalWithdraw (
        uint _shellsToBurn,
        uint _deadline
    ) external deadline(_deadline) unpartitioned nonReentrant returns (
        uint[] memory withdrawals_
    ) {

        return ProportionalLiquidity.proportionalWithdraw(shell, _shellsToBurn);

    }

    function viewProportionalWithdraw (
        uint _shellsToBurn
    ) external view unpartitioned returns (
        uint[] memory withdrawals_
    ) {

        return ProportionalLiquidity.viewProportionalWithdraw(shell, _shellsToBurn);

    }

    function partition () external onlyOwner {

        PartitionedLiquidity.partition(shell, partitionTickets);

        partitioned = true;

    }

    function partitionedWithdraw (
        address[] calldata _tokens,
        uint256[] calldata _amounts
    ) external isPartitioned returns (
        uint256[] memory withdrawals_
    ) {

        return PartitionedLiquidity.partitionedWithdraw(shell, partitionTickets, _tokens, _amounts);

    }

    function viewPartitionClaims (
        address _addr
    ) external view isPartitioned returns (
        uint[] memory claims_
    ) {

        return PartitionedLiquidity.viewPartitionClaims(shell, partitionTickets, _addr);

    }

    function transfer (address _recipient, uint _amount) public nonReentrant returns (bool success_) {

        success_ = Shells.transfer(shell, _recipient, _amount);

    }

    function transferFrom (address _sender, address _recipient, uint _amount) public nonReentrant returns (bool success_) {

        success_ = Shells.transferFrom(shell, _sender, _recipient, _amount);

    }

    function approve (address _spender, uint _amount) public nonReentrant returns (bool success_) {

        success_ = Shells.approve(shell, _spender, _amount);

    }

    function increaseAllowance(address _spender, uint _addedValue) public returns (bool success_) {

        success_ = Shells.increaseAllowance(shell, _spender, _addedValue);

    }

    function decreaseAllowance(address _spender, uint _subtractedValue) public returns (bool success_) {

        success_ = Shells.decreaseAllowance(shell, _spender, _subtractedValue);

    }

    function balanceOf (address _account) public view returns (uint balance_) {

        balance_ = shell.balances[_account];

    }

    function totalSupply () public view returns (uint totalSupply_) {

        totalSupply_ = shell.totalSupply;

    }

    function allowance (address _owner, address _spender) public view returns (uint allowance_) {

        allowance_ = shell.allowances[_owner][_spender];

    }

    function liquidity () public view returns (
        uint total_,
        uint[] memory individual_
    ) {

        return Liquidity.liquidity(shell);

    }

    function TEST_setTestHalts (bool toTestOrNotToTest) external {

        shell.testHalts = toTestOrNotToTest;

    }

}