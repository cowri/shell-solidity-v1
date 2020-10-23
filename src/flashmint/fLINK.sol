pragma solidity ^0.5.0;

import "./base/FlashERC20.sol";

contract fLINK is FlashERC20 {
    constructor() FlashERC20(ERC20(0x514910771AF9Ca656af840dff83E8264EcF986CA)) public { }
}
