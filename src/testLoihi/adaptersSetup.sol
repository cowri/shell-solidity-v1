pragma solidity ^0.5.6;

import "../adapters/chai.sol";
import "../adapters/cdai.sol";
import "../adapters/dai.sol";
import "../adapters/cusdc.sol";
import "../adapters/usdc.sol";
import "../adapters/usdt.sol";
import "./flavorsSetup.sol";


contract AdaptersSetup is FlavorsSetup {
    address chaiAdapter;
    address cdaiAdapter;
    address cusdcAdapter;
    address daiAdapter;
    address usdcAdapter;
    address usdtAdapter;

    function setupAdapters() public {
        usdcAdapter = address(new UsdcAdapter());
        chaiAdapter = address(new ChaiAdapter());
        cdaiAdapter = address(new cDaiAdapter());
        cusdcAdapter = address(new cUsdcAdapter());
        daiAdapter = address(new DaiAdapter());
        usdtAdapter = address(new UsdtAdapter());
    }



}