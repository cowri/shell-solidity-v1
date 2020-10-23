pragma solidity ^0.5.0;

import "./base/FlashERC20.sol";

contract fMKR is FlashERC20 {
    constructor() FlashERC20(ERC20(0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2)) public { }
}
