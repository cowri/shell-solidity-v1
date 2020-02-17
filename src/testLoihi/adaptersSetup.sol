pragma solidity ^0.5.6;

import "./flavorsSetup.sol";
import "../ILoihi.sol";

import "../adapters/kovan/KovanUsdcAdapter.sol";
import "../adapters/kovan/KovanUsdtAdapter.sol";
import "../adapters/kovan/KovanCUsdcAdapter.sol";
import "../adapters/kovan/KovanDaiAdapter.sol";
import "../adapters/kovan/KovanCDaiAdapter.sol";
import "../adapters/kovan/KovanChaiAdapter.sol";
import "../adapters/kovan/KovanASUsdAdapter.sol";

contract AdaptersSetup is FlavorsSetup {
    address chaiAdapter;
    address cdaiAdapter;
    address cusdcAdapter;
    address daiAdapter;
    address usdcAdapter;
    address usdtAdapter;
    address asusdAdapter;

    function setupAdapters() public {
        setupAdaptersLocal();
    }

    function setupAdaptersKovan () public {
        usdcAdapter = 0x0CCb2Df4109140Afd8BaeBa7f9AeD3795EfEb0eC;
        chaiAdapter = 0x73562E7B8bfB32131D6ee346f23FBA5055Ac5139;
        cdaiAdapter = 0x5FD4D707841B19Bc957cb109928BC387f1d6644f;
        cusdcAdapter = 0x7058f0fa65b4C7eD0E8cf5560823ceDF3893640b;
        daiAdapter = 0x766CD84c9ee817C61e9769CA567C4Fc8B2Fa901c;
        usdtAdapter = 0x24f0b5Ae5E1B2BbD5e07da8eDd08b0843815dD67;
        asusdAdapter = 0x349D9cE7Ee7C43763d57ae365B03121a76CB7038;
    }

    function setupAdaptersLocal () public {
        usdcAdapter = address(new KovanUsdcAdapter());
        usdtAdapter = address(new KovanUsdtAdapter());
        cdaiAdapter = address(new KovanCDaiAdapter());
        chaiAdapter = address(new KovanChaiAdapter());
        daiAdapter = address(new KovanDaiAdapter());
        cusdcAdapter = address(new KovanCUsdcAdapter());
        asusdAdapter = address(new KovanASUsdAdapter());
    }

    function includeAdapters (address _loihi, uint256 test) public {
        if (test == 0) includeAdaptersFourTokens30_30_30_10(_loihi);
        else if (test == 1) includeAdaptersThreeTokens33_33_33(_loihi);
    }

    function includeAdaptersFourTokens30_30_30_10 (address _loihi) public {
        ILoihi l = ILoihi(_loihi);

        l.includeNumeraireAndReserve(dai, cdaiAdapter);
        l.includeNumeraireAndReserve(usdc, cusdcAdapter);
        l.includeNumeraireAndReserve(usdt, usdtAdapter);
        l.includeNumeraireAndReserve(asusd, asusdAdapter);

        l.includeAdapter(usdc, usdcAdapter, cusdcAdapter, 300000000000000000);
        l.includeAdapter(cusdc, cusdcAdapter, cusdcAdapter, 300000000000000000);

        l.includeAdapter(dai, daiAdapter, cdaiAdapter, 300000000000000000);
        l.includeAdapter(chai, chaiAdapter, cdaiAdapter, 300000000000000000);
        l.includeAdapter(cdai, cdaiAdapter, cdaiAdapter, 300000000000000000);

        l.includeAdapter(usdt, usdtAdapter, usdtAdapter, 300000000000000000);

        l.includeAdapter(asusd, asusdAdapter, asusdAdapter, 100000000000000000);

    }

    function includeAdaptersThreeTokens33_33_33 (address _loihi) public {
        ILoihi l = ILoihi(_loihi);

        l.includeNumeraireAndReserve(dai, cdaiAdapter);
        l.includeNumeraireAndReserve(usdc, cusdcAdapter);
        l.includeNumeraireAndReserve(usdt, usdtAdapter);

        l.includeAdapter(usdc, usdcAdapter, cusdcAdapter, 333333333333333333);
        l.includeAdapter(cusdc, cusdcAdapter, cusdcAdapter, 333333333333333333);

        l.includeAdapter(dai, daiAdapter, cdaiAdapter, 333333333333333333);
        l.includeAdapter(chai, chaiAdapter, cdaiAdapter, 333333333333333333);
        l.includeAdapter(cdai, cdaiAdapter, cdaiAdapter, 333333333333333333);

        l.includeAdapter(usdt, usdtAdapter, usdtAdapter, 333333333333333333);


    }
}