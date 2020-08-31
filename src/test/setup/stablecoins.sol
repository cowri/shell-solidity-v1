pragma solidity ^0.5.0;

import "../../interfaces/IERC20.sol";
import "../../interfaces/IERC20NoBool.sol";

import "./mocks/erc20NoBool.sol";
import "./mocks/erc20.sol";

import "./storage.sol";

contract StablecoinSetup is StorageSetup {

    function setupStablecoinsKovan() public {

        dai = IERC20(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa);
        usdc = IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF);
        usdt = IERC20NoBool(0x13512979ADE267AB5100878E2e0f485B568328a4);
        susd = IERC20(0xD868790F57B39C9B2B51b12de046975f986675f9);

    }

    function approve (address token, address l) public {
        uint256 approved = IERC20(token).allowance(address(this), l);
        if (approved > 0) IERC20(token).approve(l, 0);
        IERC20(token).approve(l, uint256(-1));
    }

    function approveBad (address token, address l) public {
        uint256 approved = IERC20NoBool(token).allowance(address(this), l);
        if (approved > 0) IERC20NoBool(token).approve(l, 0);
        IERC20NoBool(token).approve(l, uint256(-1));
    }

}