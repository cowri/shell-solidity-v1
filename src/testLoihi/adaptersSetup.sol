pragma solidity ^0.5.6;

import "./flavorsSetup.sol";

import "../adapters/local/localChaiAdapter.sol";
import "../adapters/local/localCDaiAdapter.sol";
import "../adapters/local/localDaiAdapter.sol";
import "../adapters/local/localCUsdcAdapter.sol";
import "../adapters/local/localUsdcAdapter.sol";
import "../adapters/local/localUsdtAdapter.sol";

import "../adapters/kovan/kovanChaiAdapter.sol";
import "../adapters/kovan/kovanCDaiAdapter.sol";
import "../adapters/kovan/kovanDaiAdapter.sol";
import "../adapters/kovan/kovanCUsdcAdapter.sol";
import "../adapters/kovan/kovanUsdcAdapter.sol";
import "../adapters/kovan/kovanUsdtAdapter.sol";

contract AdaptersSetup is FlavorsSetup {
    address chaiAdapter;
    address cdaiAdapter;
    address cusdcAdapter;
    address daiAdapter;
    address usdcAdapter;
    address usdtAdapter;

    function setupAdapters() public { 
        // setupLocalAdapters();
        setupKovanAdapters();
    }

    function setupLocalAdapters() public {
        usdcAdapter = address(new LocalUsdcAdapter());
        chaiAdapter = address(new LocalChaiAdapter());
        cdaiAdapter = address(new LocalCDaiAdapter());
        cusdcAdapter = address(new LocalCUsdcAdapter());
        daiAdapter = address(new LocalDaiAdapter());
        usdtAdapter = address(new LocalUsdtAdapter());
    }

    function setupKovanAdapters () public {
        usdcAdapter = address(new KovanUsdcAdapter());
        chaiAdapter = address(new KovanChaiAdapter());
        cdaiAdapter = address(new KovanCDaiAdapter());
        cusdcAdapter = address(new KovanCUsdcAdapter());
        daiAdapter = address(new KovanDaiAdapter());
        usdtAdapter = address(new KovanUsdtAdapter());
    }

    function setupMainnetAdapters () public {

    }



}