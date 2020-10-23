pragma solidity ^0.5.0;

import "./base/FlashERC20.sol";

contract fWBTC is FlashERC20 {
    constructor() FlashERC20(ERC20(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599)) public { }
}
