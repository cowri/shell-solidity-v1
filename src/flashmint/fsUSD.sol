pragma solidity ^0.5.0;

import "./base/FlashERC20.sol";

contract fsUSD is FlashERC20 {
    constructor() FlashERC20(ERC20(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51)) public { }
}
