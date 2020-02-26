pragma solidity ^0.5.15;

import "./flavorsSetup.sol";
import "../interfaces/ILoihi.sol";

import "../adapters/kovan/KovanDaiAdapter.sol";
import "../adapters/kovan/KovanCDaiAdapter.sol";
import "../adapters/kovan/KovanChaiAdapter.sol";

import "../adapters/kovan/KovanUsdcAdapter.sol";
import "../adapters/kovan/KovanCUsdcAdapter.sol";

import "../adapters/kovan/KovanSUsdAdapter.sol";
import "../adapters/kovan/KovanASUsdAdapter.sol";

import "../adapters/kovan/KovanUsdtAdapter.sol";
import "../adapters/kovan/KovanAUsdtAdapter.sol";

import "../adapters/mainnet/MainnetDaiAdapter.sol";
import "../adapters/mainnet/MainnetCDaiAdapter.sol";
import "../adapters/mainnet/MainnetChaiAdapter.sol";

import "../adapters/mainnet/MainnetUsdcAdapter.sol";
import "../adapters/mainnet/MainnetCUsdcAdapter.sol";

import "../adapters/mainnet/MainnetSUsdAdapter.sol";
import "../adapters/mainnet/MainnetASUsdAdapter.sol";

import "../adapters/mainnet/MainnetUsdtAdapter.sol";
import "../adapters/mainnet/MainnetAUsdtAdapter.sol";




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

    uint256 feeBase;
    uint256 feeDerivative;
    uint256 alpha;
    uint256 beta;

    function setupAdapters() public {
        // setupAdaptersLocal();
        // setupAdaptersKovan();
        setupAdaptersMainnet();
    }

    function setupAdaptersKovan () public {
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

    function setupAdaptersMainnet () public {
        usdcAdapter = address(new MainnetUsdcAdapter());
        cusdcAdapter = address(new MainnetCUsdcAdapter());

        daiAdapter = address(new MainnetDaiAdapter());
        cdaiAdapter = address(new MainnetCDaiAdapter());
        chaiAdapter = address(new MainnetChaiAdapter());

        usdtAdapter = address(new MainnetUsdtAdapter());
        ausdtAdapter = address(new MainnetAUsdtAdapter());

        susdAdapter = address(new MainnetSUsdAdapter());
        asusdAdapter = address(new MainnetASUsdAdapter());

    }

    function includeAdapters (address _loihi, uint256 test) public {
        if (test == 0) includeAdaptersFourTokens30_30_30_10(_loihi);
        else if (test == 1) includeAdaptersThreeTokens33_33_33(_loihi);
    }

    function includeAdaptersFourTokens30_30_30_10 (address _loihi) public {
        ILoihi l = ILoihi(_loihi);

        l.includeNumeraireAndReserve(dai, cdaiAdapter);
        l.includeNumeraireAndReserve(usdc, cusdcAdapter);
        l.includeNumeraireAndReserve(usdt, ausdtAdapter);
        l.includeNumeraireAndReserve(susd, asusdAdapter);

        l.includeAdapter(dai, daiAdapter, cdaiAdapter, 300000000000000000);
        l.includeAdapter(chai, chaiAdapter, cdaiAdapter, 300000000000000000);
        l.includeAdapter(cdai, cdaiAdapter, cdaiAdapter, 300000000000000000);

        l.includeAdapter(usdc, usdcAdapter, cusdcAdapter, 300000000000000000);
        l.includeAdapter(cusdc, cusdcAdapter, cusdcAdapter, 300000000000000000);

        l.includeAdapter(usdt, usdtAdapter, ausdtAdapter, 300000000000000000);
        l.includeAdapter(ausdt, ausdtAdapter, ausdtAdapter, 300000000000000000);

        l.includeAdapter(asusd, asusdAdapter, asusdAdapter, 100000000000000000);
        l.includeAdapter(susd, susdAdapter, asusdAdapter, 100000000000000000);

        alpha = 500000000000000000;
        beta = 250000000000000000;
        feeDerivative = 100000000000000000;
        feeBase = 500000000000000;

        l.setParams(alpha, beta, feeDerivative, feeBase);

    }

    function includeAdaptersThreeTokens33_33_33 (address _loihi) public {
        ILoihi l = ILoihi(_loihi);

        l.includeNumeraireAndReserve(dai, cdaiAdapter);
        l.includeNumeraireAndReserve(usdc, cusdcAdapter);
        l.includeNumeraireAndReserve(usdt, ausdtAdapter);

        l.includeAdapter(usdc, usdcAdapter, cusdcAdapter, 333333333333333333);
        l.includeAdapter(cusdc, cusdcAdapter, cusdcAdapter, 333333333333333333);

        l.includeAdapter(dai, daiAdapter, cdaiAdapter, 333333333333333333);
        l.includeAdapter(chai, chaiAdapter, cdaiAdapter, 333333333333333333);
        l.includeAdapter(cdai, cdaiAdapter, cdaiAdapter, 333333333333333333);

        l.includeAdapter(usdt, usdtAdapter, ausdtAdapter, 333333333333333333);
        l.includeAdapter(ausdt, ausdtAdapter, ausdtAdapter, 333333333333333333);

        alpha = 500000000000000000;
        beta = 250000000000000000;
        feeDerivative = 100000000000000000;
        feeBase = 500000000000000;

        l.setParams(alpha, beta, feeDerivative, feeBase);

    }
}