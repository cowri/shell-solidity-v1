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
        chaiAdapter = 0xaDE199E54dED77DB57D3BEc61569377523a23606;
        cdaiAdapter = 0x75FF1c9DA8D0683281BD1567FCb69c390F8Cc7a1;
        cusdcAdapter = 0x2a838e487cf5DA86c87871A684915Ee9ADf5e976;
        daiAdapter = 0x6F6af1af6d420AF759Db59a8879696377Ff26200;
        usdtAdapter = 0xFD3138fD4825DA71e08bBeBb39f9B6aeE670F1d0;
    }

}