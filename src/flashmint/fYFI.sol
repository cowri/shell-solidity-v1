pragma solidity ^0.5.0;

import "./base/FlashERC20.sol";

contract fYFI is FlashERC20 {
    constructor() FlashERC20(ERC20(0x0bc529c00C6401aEF6D220BE8C6Ea1667F6Ad93e)) public { }
}
