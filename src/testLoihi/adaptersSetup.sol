pragma solidity ^0.5.6;

import "../adapters/chai.sol";
import "../adapters/cdai.sol";
import "../adapters/dai.sol";
import "../adapters/cusdc.sol";
import "../adapters/usdc.sol";
import "../adapters/usdt.sol";
import "./flavorsSetup.sol";

contract PotMock {
    constructor () public { }
    function rho () public returns (uint256) { return now - 500; }
    function drip () public returns (uint256) { return (10 ** 18) * 2; }
    function chi () public returns (uint256) { return (10 ** 18) * 2; }
}

contract AdaptersSetup is FlavorsSetup {
    address chaiAdapter;
    address cdaiAdapter;
    address cusdcAdapter;
    address daiAdapter;
    address usdcAdapter;
    address usdtAdapter;

    function setupAdapters() public {
        usdcAdapter = address(new UsdcAdapter(usdc, cusdc));
        chaiAdapter = address(new ChaiAdapter(dai, address(new PotMock()), chai));
        cdaiAdapter = address(new cDaiAdapter(dai, cdai, chai));
        cusdcAdapter = address(new cUsdcAdapter(cusdc, usdc));
        daiAdapter = address(new DaiAdapter(dai, chai));
        usdtAdapter = address(new UsdtAdapter(usdt));
    }



}