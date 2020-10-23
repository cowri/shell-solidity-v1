pragma solidity ^0.5.0;

import "./base/FlashERC20.sol";

contract fDAI is FlashERC20 {
    constructor() FlashERC20(ERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F)) public { }
}
