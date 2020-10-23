pragma solidity ^0.5.0;

import "./base/FlashERC20.sol";

contract fSRM is FlashERC20 {
    constructor() FlashERC20(ERC20(0x476c5E26a75bd202a9683ffD34359C0CC15be0fF)) public { }
}
