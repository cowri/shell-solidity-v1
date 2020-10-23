pragma solidity ^0.5.0;

import "./base/FlashERC20.sol";

contract fBUSD is FlashERC20 {
    constructor() FlashERC20(ERC20(0x4Fabb145d64652a948d72533023f6E7A623C7C53)) public { }
}
