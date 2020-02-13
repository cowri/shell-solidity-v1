pragma solidity ^0.5.6;

import "./flavorsSetup.sol";

contract AdaptersSetup is FlavorsSetup {
    address chaiAdapter;
    address cdaiAdapter;
    address cusdcAdapter;
    address daiAdapter;
    address usdcAdapter;
    address usdtAdapter;

    function setupAdapters() public {
        usdcAdapter = 0x48464546c3383c6406A7F50168341B058328Ec4F;
        chaiAdapter = 0x2AAe5a105b1c01F9988E292Ddea70a1ED460dD7a;
        cdaiAdapter = 0xF78959a72133eE311A4a6e55eb4c0b8566E32d40;
        cusdcAdapter = 0x8Af8fA7C15f8bd82614b68B5B9bADDb6389B423d;
        daiAdapter = 0x6F6af1af6d420AF759Db59a8879696377Ff26200;
        usdtAdapter = 0xFD3138fD4825DA71e08bBeBb39f9B6aeE670F1d0;
    }

}