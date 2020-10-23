pragma solidity ^0.5.0;

import "./base/FlashERC20.sol";

contract fAAVE is FlashERC20 {
    constructor() FlashERC20(ERC20(0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9)) public { }
}
