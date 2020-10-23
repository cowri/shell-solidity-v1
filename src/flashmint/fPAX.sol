pragma solidity ^0.5.0;

import "./base/FlashERC20.sol";

contract fPAX is FlashERC20 {
    constructor() FlashERC20(ERC20(0x8E870D67F660D95d5be530380D0eC0bd388289E1)) public { }
}
