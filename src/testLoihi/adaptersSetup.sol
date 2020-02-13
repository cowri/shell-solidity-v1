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
    address erc20;
    address liquidity;
    address exchange;

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
        usdcAdapter = 0x48464546c3383c6406A7F50168341B058328Ec4F;
        chaiAdapter = 0x2AAe5a105b1c01F9988E292Ddea70a1ED460dD7a;
        cdaiAdapter = 0xF78959a72133eE311A4a6e55eb4c0b8566E32d40;
        cusdcAdapter = 0x8Af8fA7C15f8bd82614b68B5B9bADDb6389B423d;
        daiAdapter = 0x6F6af1af6d420AF759Db59a8879696377Ff26200;
        usdtAdapter = 0xFD3138fD4825DA71e08bBeBb39f9B6aeE670F1d0;
        erc20 = 0x96CBce6Cc6A1b8730C4F4bc474B86daF18107A9b;
        liquidity = 0x5B60Be197a2c81A5D4990144E7c7443a1E1a3b21;
        exchange = 0x8A5C3088a9eCB996f49341004f2df56a8994c653;
    }

    function setupMainnetAdapters () public {

    }



}