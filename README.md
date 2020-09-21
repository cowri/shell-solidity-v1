# Lo'ihi
Lo'ihi is a stablecoin automated market maker designed to have no slippage beyond the liquidity fee and to pass arbitrage profits on to the liquidity providers.

It can take any groupings of stablecoins into the pool and can facilitate trading between any flavor of stablecoin derivatives.

It is named Lo'ihi after the submarine volcano of the same name destined to be the sixth Hawaiian island.


## Methods

### swapByOrigin(address origin, address target, uint256 originAmount, uint256 minimumTargetAmount, uint256 deadline) returns (uint256 targetAmount)

Swap a given amount of the origin stablecoin for the target stablecoin.
Limit the transaction by setting the minimum target amount and deadline for execution.
Returns the target amount

### transferByOrigin(address origin, address target, uint256 originAmount, uint256 minimumTargetAmount. uint256 deadline, address recipient) returns (uint256 targetAmount)

Same as swapByOrigin except it sends target amount to specified recipient

### viewOriginTrade(address origin, address target, uint256 originAmount) view returns (uint256 targetAmount)

Returns the target amount for the given origin amount

### swapByTarget(address origin, address target, uint256 maximumOriginAmount, uint256 targetAmount, uint256 deadline) returns (uint256 originAmount)

Swap a given amount of the target stablecoin for the origin stablecoin
Limit the transaction by setting the maximum origin amount and deadline for execution
Returns the origin amount

### transferByOrigin(address origin, address target, uint256 maximumOriginAmount, uint256 targetAmount, uint256 deadline, address recipient) returns (uint256 originAmount)

Same as swapByTarget except it sends target amount to specified recipient


### proportionalDeposit(uint256 totalStablecoins) returns (uint256 shellsMinted)

Specify a total amount of stablecoins that will be divided according to the 
weight of the given numeraire (dai, usdc, usdt, susd) and deposited into the 
pool in return for the corresponding amount of shell tokens.

For instance a deposit of 100 will deposit 30 Dai, 30 Usdc, 30 Usdt and 10 Susd 
for a pool 30% Dai, 30% Usdc, 30% Usdt and 10% Susd as the numeraire assets.

Returns the amount of shell tokens minted by the deposit.

### selectiveDeposit(address[] flavors, uint256[] amounts, uint256 minimumShellTokens, uint256 deadline) returns (uint256 mintedShellTokens)

Allows the deposit of an arbitrary number and type of stablecoins in return
for shell tokens.

The first argument is an array of stablecoin flavors to deposit. The second 
argument is an array of uint256s whose indexes correspond to the indexes of 
the first argument of an array of addresses.

The function computes the amount of shell tokens the deposit mint, including
any fees, and returns the amount of shell tokens minted to the users address.

Is limited by minimum shell tokens and block number deadline.

### proportionalWithdraw(uint256 totalShellTokensToBurn) returns (uint256[] withdrawnStablecoins)

This function accepts a total amount of shell tokens to redeem for the underlying
stableocins. It burns the shell tokens according to the current proportions
of the reserves.

The shell tokens to burn are denominated in raw shell tokens, not the numeraire
value of the shell tokens. 

### selectiveWithdraw(address[] flavors, uint256[] amounts, uint256 maxShellsToBurn, uint256 deadline) returns (uint256 burntShellTokens)

Allows the withdrawal of arbitrary amounts of arbitrary stablecoins in the shell

The first argument is an array of addresses. The second argument is an array of 
uint256s whose indexes map to the addresses of the first argument of an array of
stablecoin addresses.

The amount of shell tokens burnt is computed using these inputs and is returned
to the user after the corresponding tokens are transferred.

Can be limited by maxShellsToBurn and the deadline of the block number.

Returns the amount of shell tokens burned.

Mainnet Deployment Addresses: 
------------------------------------------------------------------------
* DAI: 0x6B175474E89094C44Da98b954EedeAC495271d0F
* [Dai adapter](https://etherscan.io/address/0xe3925debc22b49891542a5990e781e30e15a97a3#code)

------------------------------------------------------------------------
* CHAI: 0x06AF07097C9Eeb7fD685c692751D5C66dB49c215
* [Chai adapter](https://etherscan.io/address/0xc12b8e0ac01040633a935b5b13586a033000983d#code)
------------------------------------------------------------------------
* CDAI: 0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643
* [CDai adapter](https://etherscan.io/address/0x5152d6817952e66cb7a0422a2f5b944d45f08e1b#code)
------------------------------------------------------------------------
* USDC: 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
* [Usdc adapter](https://etherscan.io/address/0xe14a8eb97731a9107c9e144026765bd65350eac7#code)
------------------------------------------------------------------------
* CUSDC: 0x39AA39c021dfbaE8faC545936693aC917d5E7563
* [CUsdc adapter](https://etherscan.io/address/0xf643f7a20a18557e2aa9af413dfa6d3626e641f8#code)
------------------------------------------------------------------------
* USDT: 0xdAC17F958D2ee523a2206206994597C13D831ec7
* [Usdt adapter](https://etherscan.io/address/0x6d05e9e964ec858ad239755c18d288315badfc10#code)
------------------------------------------------------------------------
* AUSDT: 0x71fc860F7D3A592A4a98740e39dB31d25db65ae8
* [AUSdt adapter](https://etherscan.io/address/0xdce7e3af11c3867327a7ab786dedfb05ef53bea5#code)
------------------------------------------------------------------------
* SUSD: 0x57Ab1ec28D129707052df4dF418D58a2D46d5f51
* [SUsd adapter](https://etherscan.io/address/0x7a06041ee5140eaf6119ada8fa0362df1ced9d81#code)
------------------------------------------------------------------------
* ASUSD: 0x625aE63000f46200499120B906716420bd059240
* [ASUsd adapter](https://etherscan.io/address/0xe302a5e54c9e837cd1b5891f94eb6d6df3464610#code)
------------------------------------------------------------------------

[Shell Exchange](https://etherscan.io/address/0xb40b60cd9687dae6fe7043e8c62bb8ec692632a3#code)

------------------------------------------------------------------------

[Shell Views](https://etherscan.io/address/0x04a6cf4e770a9af7e6b6733462d72e238b8ab140#code)

------------------------------------------------------------------------

[Shell Liqudity](https://etherscan.io/address/0x7db66490d3436717f90d4681bf8297a2f2b8774a#code)

------------------------------------------------------------------------
[Shell ERC20](https://etherscan.io/address/0xffa473d58c9f15e97b86ad281f876d9dbf96241c#code)
