pragma solidity ^0.5.0;

import "./base/FlashERC20.sol";

contract fBAL is FlashERC20 {
    constructor() FlashERC20(ERC20(0xba100000625a3754423978a60c9317c58a424e3D)) public { }
}
