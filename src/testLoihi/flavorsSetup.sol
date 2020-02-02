pragma solidity ^0.5.6;

import "./mockFlavors/chai.sol";
import "./mockFlavors/cdai.sol";
import "./mockFlavors/dai.sol";
import "./mockFlavors/cusdc.sol";
import "./mockFlavors/usdc.sol";
import "./mockFlavors/usdt.sol";
import "../ERC20I.sol";

contract FlavorsSetup {
    address chai;
    address dai;
    address cusdc;
    address usdt;
    address usdc;
    address cdai;

    function setupFlavors() public {
        uint256 tokenAmount = 10000000000000 * (10 ** 18);
        dai = address(new DaiMock("dai", "dai", 18, tokenAmount));
        chai = address(new ChaiMock(dai, "chai", "chai", 18, tokenAmount));
        cdai = address(new cDaiMock(dai, "cDai", "cdai", 18, tokenAmount));
        usdc = address(new UsdcMock("usdc", "usdc", 18, tokenAmount));
        cusdc = address(new cUsdcMock(usdc, "cusdc", "cusdc", 18, tokenAmount));
        usdt = address(new UsdtMock("usdt", "usdt", 18, tokenAmount));
    }

}