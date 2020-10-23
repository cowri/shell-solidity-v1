pragma solidity ^0.5.0;

import "./base/FlashERC20.sol";

contract fUSDT is FlashERC20 {
    constructor() FlashERC20(ERC20(0xdac17f958d2ee523a2206206994597c13d831ec7)) { }
}
