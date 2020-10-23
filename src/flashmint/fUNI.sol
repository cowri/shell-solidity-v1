pragma solidity ^0.5.0;

import "./base/FlashERC20.sol";

contract fUNI is FlashERC20 {
    constructor() FlashERC20(ERC20(0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984)) public { }
}
