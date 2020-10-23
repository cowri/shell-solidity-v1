pragma solidity ^0.5.0;

import "./base/FlashERC20.sol";

contract fCRV is FlashERC20 {
    constructor() FlashERC20(ERC20(0xD533a949740bb3306d119CC777fa900bA034cd52)) public { }
}
