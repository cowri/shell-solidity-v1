pragma solidity ^0.5.0;

import "./base/FlashERC20.sol";

contract fUSDC is FlashERC20 {
    constructor() FlashERC20(ERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48)) public { }
}
