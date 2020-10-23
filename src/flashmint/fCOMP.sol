pragma solidity ^0.5.0;

import "./base/FlashERC20.sol";

contract fCOMP is FlashERC20 {
    constructor() FlashERC20(ERC20(0xc00e94Cb662C3520282E6f5717214004A7f26888)) public { }
}
