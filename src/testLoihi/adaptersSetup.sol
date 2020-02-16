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
        usdcAdapter = 0x0CCb2Df4109140Afd8BaeBa7f9AeD3795EfEb0eC;
        chaiAdapter = 0x73562E7B8bfB32131D6ee346f23FBA5055Ac5139;
        cdaiAdapter = 0x5FD4D707841B19Bc957cb109928BC387f1d6644f;
        cusdcAdapter = 0x7058f0fa65b4C7eD0E8cf5560823ceDF3893640b;
        daiAdapter = 0x766CD84c9ee817C61e9769CA567C4Fc8B2Fa901c;
        usdtAdapter = 0x24f0b5Ae5E1B2BbD5e07da8eDd08b0843815dD67;
        // usdcAdapter = 0x48464546c3383c6406A7F50168341B058328Ec4F;
        // chaiAdapter = 0xaDE199E54dED77DB57D3BEc61569377523a23606;
        // cdaiAdapter = 0x75FF1c9DA8D0683281BD1567FCb69c390F8Cc7a1;
        // cusdcAdapter = 0x2a838e487cf5DA86c87871A684915Ee9ADf5e976;
        // daiAdapter = 0x6F6af1af6d420AF759Db59a8879696377Ff26200;
        // usdtAdapter = 0xFD3138fD4825DA71e08bBeBb39f9B6aeE670F1d0;
    }

}