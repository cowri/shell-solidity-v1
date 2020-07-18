pragma solidity ^0.5.0;

import "../../interfaces/IERC20.sol";
import "../../interfaces/IERC20NoBool.sol";

import "./mocks/erc20NoBool.sol";
import "./mocks/erc20.sol";

import "./storage.sol";

contract StablecoinSetup is StorageSetup {

    function setupStablecoinsMainnet () public {

        dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
        usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
        usdt = IERC20NoBool(0xdAC17F958D2ee523a2206206994597C13D831ec7);
        susd = IERC20(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51);

        aaveLpCore = 0x3dfd23A6c5E8BbcFc9581d2E864a68feb6a076d3;

    }

    function setupStablecoinsKovan() public {

        dai = IERC20(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa);
        usdc = IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF);
        usdt = IERC20NoBool(0x13512979ADE267AB5100878E2e0f485B568328a4);
        susd = IERC20(0xD868790F57B39C9B2B51b12de046975f986675f9);

        aaveLpCore = 0x95D1189Ed88B380E319dF73fF00E479fcc4CFa45;

    }

    event log_addr(bytes32, address);

    function setupStablecoinsLocal () public {

        dai = IERC20(address(new ERC20Mock("dai", "dai", 18, uint256(-1)/2)));

        usdc = IERC20(address(new ERC20Mock("usdc", "usdc", 6, uint256(-1)/2)));

        usdt = IERC20NoBool(address(new ERC20NoBoolMock("usdt", "usdt", 6, uint256(-1)/2)));

        susd = IERC20(address(new ERC20Mock("susd", "susd", 18, uint256(-1)/2)));

        aaveLpCore = 0x95D1189Ed88B380E319dF73fF00E479fcc4CFa45; // just for tests bootstrap

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