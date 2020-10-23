pragma solidity ^0.5.0;

import "./base/FlashERC20.sol";

contract fUSDT is FlashERC20 {
    constructor() FlashERC20(ERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7)) public { }
}
