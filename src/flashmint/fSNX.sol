pragma solidity ^0.5.0;

import "./base/FlashERC20.sol";

contract fSNX is FlashERC20 {
    constructor() FlashERC20(ERC20(0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F)) public { }
}
