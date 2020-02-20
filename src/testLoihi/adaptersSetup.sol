pragma solidity ^0.5.6;

import "./flavorsSetup.sol";
import "../ILoihi.sol";

import "../adapters/kovan/KovanUsdcAdapter.sol";
import "../adapters/kovan/KovanCUsdcAdapter.sol";

import "../adapters/kovan/KovanDaiAdapter.sol";
import "../adapters/kovan/KovanCDaiAdapter.sol";
import "../adapters/kovan/KovanChaiAdapter.sol";

import "../adapters/kovan/KovanSUsdAdapter.sol";
import "../adapters/kovan/KovanASUsdAdapter.sol";

import "../adapters/kovan/KovanUsdtAdapter.sol";
import "../adapters/kovan/KovanAUsdtAdapter.sol";

contract AdaptersSetup is FlavorsSetup {
    address daiAdapter;
    address chaiAdapter;
    address cdaiAdapter;

    address usdcAdapter;
    address cusdcAdapter;

    address usdtAdapter;
    address ausdtAdapter;

    address susdAdapter;
    address asusdAdapter;

    function setupAdapters() public {
        setupAdaptersLocal();
        // setupAdaptersKovan();
    }

    function setupAdaptersKovan () public {
        usdcAdapter = 0xa23F24d8d18BE37f617148CD494a1a7e83F06dAC;
        cusdcAdapter = 0x23bF0abe17Ee2Fb81CF5Ae4A21473526cAD95f97;

        daiAdapter = 0xa557bF50Eeb88978318B3eDEE60e1781C939Acfa;
        chaiAdapter = 0xe8E99291163839F28A2Cd195C50AE7B259272BFC;
        cdaiAdapter = 0x71AB605c2C7EF07dAF4f3052DcD7953D5423Dafd;

        usdtAdapter = 0x5b8066A3413990BC4979E2C5DFBA2B5F6FDCcA48;
        ausdtAdapter = 0x8BF8F69832EC206B0Ea63890cE0A2ca7637A4378;

        susdAdapter = 0x2b9C3E35Ccf89E69aC79472D17E355D88d95F26D;
        asusdAdapter = 0x86EF85573Bb728434778c26f3F87B6103F0BD27b;
    }

    function setupAdaptersLocal () public {
        usdcAdapter = address(new KovanUsdcAdapter());
        cusdcAdapter = address(new KovanCUsdcAdapter());

        daiAdapter = address(new KovanDaiAdapter());
        cdaiAdapter = address(new KovanCDaiAdapter());
        chaiAdapter = address(new KovanChaiAdapter());

        usdtAdapter = address(new KovanUsdtAdapter());
        ausdtAdapter = address(new KovanAUsdtAdapter());

        susdAdapter = address(new KovanSUsdAdapter());
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