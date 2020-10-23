pragma solidity ^0.5.0;

import "./base/FlashERC20.sol";

contract fREN is FlashERC20 {
    constructor() FlashERC20(ERC20(0x408e41876cCCDC0F92210600ef50372656052a38)) public { }
}
