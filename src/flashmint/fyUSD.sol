pragma solidity ^0.5.0;

import "./base/FlashERC20.sol";

contract fsUSD is FlashERC20 {
    constructor() FlashERC20(ERC20(0x5dbcF33D8c2E976c6b560249878e6F1491Bca25c)) public { }
}
