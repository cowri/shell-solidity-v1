pragma solidity ^0.5.0;

import "./base/FlashERC20.sol";

contract frenBTC is FlashERC20 {
    constructor() FlashERC20(ERC20(0xEB4C2781e4ebA804CE9a9803C67d0893436bB27D)) public { }
}
