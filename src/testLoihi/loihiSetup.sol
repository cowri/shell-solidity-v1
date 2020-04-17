pragma solidity ^0.5.15;

import "../Loihi.sol";

import "../LoihiExchange.sol";
import "../LoihiLiquidity.sol";
import "../LoihiViews.sol";
import "../LoihiERC20.sol";

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IBadERC20.sol";

import "./mocks/chai.sol";
import "./mocks/cdai.sol";
import "./mocks/cusdc.sol";
import "./mocks/atoken.sol";
import "./mocks/baderc20.sol";
import "./mocks/erc20.sol";
import "./mocks/pot.sol";

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

import "../adapters/local/LocalDaiAdapter.sol";
import "../adapters/local/LocalCDaiAdapter.sol";
import "../adapters/local/LocalChaiAdapter.sol";
import "../adapters/local/LocalUsdcAdapter.sol";
import "../adapters/local/LocalCUsdcAdapter.sol";
import "../adapters/local/LocalUsdtAdapter.sol";
import "../adapters/local/LocalAusdtAdapter.sol";
import "../adapters/local/LocalSUsdAdapter.sol";
import "../adapters/local/LocalASUsdAdapter.sol";

contract LoihiSetup {
    Loihi l1;
    Loihi l2;

    address dai;
    address chai;
    address cdai;

    address usdc;
    address cusdc;

    address usdt;
    address ausdt;

    address susd;
    address asusd;

    address pot;

    address aaveLpCore;
    address daiAdapter;
    address chaiAdapter;
    address cdaiAdapter;

    address usdcAdapter;
    address cusdcAdapter;

    address usdtAdapter;
    address ausdtAdapter;

    address susdAdapter;
    address asusdAdapter;

    uint256 epsilon;
    uint256 delta;
    uint256 lambda;
    uint256 alpha;
    uint256 beta;

    event log_addr(bytes32, address);

    function setupLoihi () public {

        l1 = new Loihi(
            address(new LoihiExchange()),
            address(new LoihiLiquidity()),
            address(new LoihiViews()),
            address(new LoihiERC20())
        );

        l2 = new Loihi(
            address(new LoihiExchange()),
            address(new LoihiLiquidity()),
            address(new LoihiViews()),
            address(new LoihiERC20())
        );

    }

    function setupFlavors () public {
        // setupFlavorsMainnet();
        // setupFlavorsKovan();
        setupFlavorsLocal();
    }

    function setupFlavorsMainnet () public {

        dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
        chai = 0x06AF07097C9Eeb7fD685c692751D5C66dB49c215;
        cdai = 0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643;

        usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
        cusdc = 0x39AA39c021dfbaE8faC545936693aC917d5E7563;

        usdt = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
        ausdt = 0x71fc860F7D3A592A4a98740e39dB31d25db65ae8;

        susd = 0x57Ab1ec28D129707052df4dF418D58a2D46d5f51;
        asusd = 0x625aE63000f46200499120B906716420bd059240;

        aaveLpCore = 0x3dfd23A6c5E8BbcFc9581d2E864a68feb6a076d3;

    }

    function setupFlavorsKovan() public {

        chai = 0xB641957b6c29310926110848dB2d464C8C3c3f38;
        cdai = 0xe7bc397DBd069fC7d0109C0636d06888bb50668c;
        dai = 0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa;

        cusdc = 0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35;
        usdc = 0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF;

        usdt = 0x13512979ADE267AB5100878E2e0f485B568328a4;
        ausdt = 0xA01bA9fB493b851F4Ac5093A324CB081A909C34B;

        susd = 0xD868790F57B39C9B2B51b12de046975f986675f9;
        asusd = 0xb9c1434aB6d5811D1D0E92E8266A37Ae8328e901;

        aaveLpCore = 0x95D1189Ed88B380E319dF73fF00E479fcc4CFa45;

    }

    function setupFlavorsLocal () public {
        dai = address(new ERC20Mock("dai", "dai", 18, uint256(-1)/2));
        chai = address(new ChaiMock(dai, "chai", "chai", 18, 0));
        cdai = address(new CDaiMock(dai, "cdai", "cdai", 8, 0));

        usdc = address(new ERC20Mock("usdc", "usdc", 6, uint256(-1)/2));
        cusdc = address(new CUsdcMock(usdc, "cusdc", "cusdc", 8, 0));
        usdt = address(new BadERC20Mock("usdt", "usdt", 6, uint256(-1)/2));
        ausdt = address(new ATokenMock(usdt, "ausdt", "ausdt", 6, 0));
        susd = address(new ERC20Mock("susd", "susd", 18, uint256(-1)/2));
        asusd = address(new ATokenMock(susd, "asusd", "asusd", 18, 0));
        pot = address(new PotMock());
        aaveLpCore = 0x95D1189Ed88B380E319dF73fF00E479fcc4CFa45; // just for tests bootstrap

        IERC20(dai).approve(chai, uint256(-1));
        IChai(chai).join(address(this), 1e30);

        IERC20(dai).approve(cdai, uint256(-1));
        ICToken(cdai).mint(1e30);

        IERC20(usdc).approve(cusdc, uint256(-1));
        ICToken(cusdc).mint(1e30);

        IBadERC20(usdt).approve(ausdt, uint256(-1));
        IAToken(ausdt).deposit(1e30);

        IERC20(susd).approve(asusd, uint256(-1));
        IAToken(asusd).deposit(1e30);
    }

    event log_named_address(bytes32, address);
    event log_named_uint(bytes32, uint256);

    function approve (address token, address l) public {
        uint256 approved = IERC20(token).allowance(address(this), l);
        if (approved > 0) IERC20(token).approve(l, 0);
        IERC20(token).approve(l, uint256(-1));
    }

    function approveBad (address token, address l) public {
        uint256 approved = IBadERC20(token).allowance(address(this), l);
        if (approved > 0) IBadERC20(token).approve(l, 0);
        IBadERC20(token).approve(l, uint256(-1));
    }

    function approveFlavors () public {

        approve(dai, address(l1));
        approve(chai, address(l1));
        approve(cdai, address(l1));
        approve(dai, address(l2));
        approve(chai, address(l2));
        approve(cdai, address(l2));

        approve(usdc, address(l1));
        approve(cusdc, address(l1));
        approve(usdc, address(l2));
        approve(cusdc, address(l2));

        approveBad(usdt, address(l1));
        approve(ausdt, address(l1));
        approveBad(usdt, address(l2));
        approve(ausdt, address(l2));

        approve(susd, address(l1));
        approve(asusd, address(l1));
        approve(susd, address(l2));
        approve(asusd, address(l2));

    }

    function executeApprovals () public {
        // executeApprovalsRPC();
        executeApprovalsLocal();
    }

    function executeApprovalsLocal () public {

        address[] memory targets = new address[](5);
        address[] memory spenders = new address[](5);
        targets[0] = dai; spenders[0] = chai;
        targets[1] = dai; spenders[1] = cdai;
        targets[2] = susd; spenders[2] = asusd;
        targets[3] = usdc; spenders[3] = cusdc;
        targets[4] = usdt; spenders[4] = ausdt;

        for (uint i = 0; i < targets.length; i++) {
            l1.safeApprove(targets[i], spenders[i], uint256(0));
            l1.safeApprove(targets[i], spenders[i], uint256(-1));
            l2.safeApprove(targets[i], spenders[i], uint256(0));
            l2.safeApprove(targets[i], spenders[i], uint256(-1));
        }

    }

    function executeApprovalsRPC () public {

        address[] memory targets = new address[](5);
        address[] memory spenders = new address[](5);
        targets[0] = dai; spenders[0] = chai;
        targets[1] = dai; spenders[1] = cdai;
        targets[2] = susd; spenders[2] = aaveLpCore;
        targets[3] = usdc; spenders[3] = cusdc;
        targets[4] = usdt; spenders[4] = aaveLpCore;
        
        for (uint i = 0; i < targets.length; i++) {
            l1.safeApprove(targets[i], spenders[i], uint256(0));
            l1.safeApprove(targets[i], spenders[i], uint256(-1));
            l2.safeApprove(targets[i], spenders[i], uint256(0));
            l2.safeApprove(targets[i], spenders[i], uint256(-1));
        }

    }

    function setupAdapters() public {
        // setupAdaptersMainnet();
        // setupDeployedAdaptersMainnet();
        // setupAdaptersKovan();
        setupAdaptersLocal();
    }

    event log_address(bytes32, address);

    function setupAdaptersLocal () public {

        daiAdapter = address(new LocalDaiAdapter(cdai));
        cdaiAdapter = address(new LocalCDaiAdapter(cdai));
        chaiAdapter = address(new LocalChaiAdapter(cdai, pot));

        usdcAdapter = address(new LocalUsdcAdapter(cusdc));
        cusdcAdapter = address(new LocalCUsdcAdapter(cusdc));

        usdtAdapter = address(new LocalUsdtAdapter(ausdt));
        ausdtAdapter = address(new LocalAUsdtAdapter(ausdt));

        susdAdapter = address(new LocalSUsdAdapter(asusd));
        asusdAdapter = address(new LocalASUsdAdapter(asusd));

        l1.includeTestAdapterState(dai, cdai, chai, pot, usdc, cusdc, usdt, ausdt, susd, asusd);
        l2.includeTestAdapterState(dai, cdai, chai, pot, usdc, cusdc, usdt, ausdt, susd, asusd);

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

    function setupDeployedAdaptersMainnet () public {
        usdcAdapter = 0x54B7b567bc634E19632A8E85EEaE4EAE955ae9f9;
        cusdcAdapter = 0xf5AB3FFD9F92893cAf1CBCcEC01b1c6EaA140C3f;

        daiAdapter = 0x9E77104724A8390b6f2e80E222B5E8fe7eb7383f;
        cdaiAdapter = 0xaEb74F5a22935FB6c812395c3e2fE2F5258c8d6E;
        chaiAdapter = 0x21C09C793cc94c964D76cEC0A80D2cC61f155375;

        usdtAdapter = 0xCd0dA368E6e32912DD6633767850751969346d15;
        ausdtAdapter = 0xA4906F20a7806ca28626d3D607F9a594f1B9ed3B;

        susdAdapter = 0x4CB5174C962a40177876799836f353e8E9c4eF75;
        asusdAdapter = 0x68747564d7B4e7b654BE26D09f60f7756Cf54BF8;

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

    function includeAdapters (uint256 test) public {
        if (test == 0) includeAdaptersFourTokens30_30_30_10();
        else if (test == 1) includeAdaptersThreeTokens33_33_33();
        else if (test == 2) includeAdaptersFourTokens30_30_30_10Feez();
        else if (test == 3) includeParamsDeployed();
    }

    function includeParamsDeployed () public {

        alpha = 500000000000000000;
        beta = 250000000000000000;
        delta = 100000000000000000;
        epsilon = 250000000000000;
        lambda = 200000000000000000;

        l1.setParams(alpha, beta, delta, epsilon, lambda, 0);
        l2.setParams(alpha, beta, delta, epsilon, lambda, 0);

    }

    function includeAdaptersFourTokens30_30_30_10Feez () public {

        l1.includeNumeraireReserveAndWeight(dai, cdaiAdapter, 300000000000000000);
        l1.includeNumeraireReserveAndWeight(usdc, cusdcAdapter, 300000000000000000);
        l1.includeNumeraireReserveAndWeight(usdt, ausdtAdapter, 300000000000000000);
        l1.includeNumeraireReserveAndWeight(susd, asusdAdapter, 100000000000000000);
        l2.includeNumeraireReserveAndWeight(dai, cdaiAdapter, 300000000000000000);
        l2.includeNumeraireReserveAndWeight(usdc, cusdcAdapter, 300000000000000000);
        l2.includeNumeraireReserveAndWeight(usdt, ausdtAdapter, 300000000000000000);
        l2.includeNumeraireReserveAndWeight(susd, asusdAdapter, 100000000000000000);

        l1.includeAdapter(dai, daiAdapter, cdaiAdapter);
        l1.includeAdapter(chai, chaiAdapter, cdaiAdapter);
        l1.includeAdapter(cdai, cdaiAdapter, cdaiAdapter);
        l2.includeAdapter(dai, daiAdapter, cdaiAdapter);
        l2.includeAdapter(chai, chaiAdapter, cdaiAdapter);
        l2.includeAdapter(cdai, cdaiAdapter, cdaiAdapter);

        l1.includeAdapter(usdc, usdcAdapter, cusdcAdapter);
        l1.includeAdapter(cusdc, cusdcAdapter, cusdcAdapter);
        l2.includeAdapter(usdc, usdcAdapter, cusdcAdapter);
        l2.includeAdapter(cusdc, cusdcAdapter, cusdcAdapter);

        l1.includeAdapter(usdt, usdtAdapter, ausdtAdapter);
        l1.includeAdapter(ausdt, ausdtAdapter, ausdtAdapter);
        l2.includeAdapter(usdt, usdtAdapter, ausdtAdapter);
        l2.includeAdapter(ausdt, ausdtAdapter, ausdtAdapter);

        l1.includeAdapter(asusd, asusdAdapter, asusdAdapter);
        l1.includeAdapter(susd, susdAdapter, asusdAdapter);
        l2.includeAdapter(asusd, asusdAdapter, asusdAdapter);
        l2.includeAdapter(susd, susdAdapter, asusdAdapter);

        alpha = 500000000000000000;
        beta = 250000000000000000;
        delta = 100000000000000000;
        epsilon = 0;
        lambda = 1000000000000000000;

        l1.setParams(alpha, beta, delta, epsilon, lambda, 0);
        l2.setParams(alpha, beta, delta, epsilon, lambda, 0);

    }

    function includeAdaptersFourTokens30_30_30_10 () public {

        l1.includeNumeraireReserveAndWeight(dai, cdaiAdapter, 300000000000000000);
        l1.includeNumeraireReserveAndWeight(usdc, cusdcAdapter, 300000000000000000);
        l1.includeNumeraireReserveAndWeight(usdt, ausdtAdapter, 300000000000000000);
        l1.includeNumeraireReserveAndWeight(susd, asusdAdapter, 100000000000000000);
        l2.includeNumeraireReserveAndWeight(dai, cdaiAdapter, 300000000000000000);
        l2.includeNumeraireReserveAndWeight(usdc, cusdcAdapter, 300000000000000000);
        l2.includeNumeraireReserveAndWeight(usdt, ausdtAdapter, 300000000000000000);
        l2.includeNumeraireReserveAndWeight(susd, asusdAdapter, 100000000000000000);

        l1.includeAdapter(dai, daiAdapter, cdaiAdapter);
        l1.includeAdapter(chai, chaiAdapter, cdaiAdapter);
        l1.includeAdapter(cdai, cdaiAdapter, cdaiAdapter);
        l2.includeAdapter(dai, daiAdapter, cdaiAdapter);
        l2.includeAdapter(chai, chaiAdapter, cdaiAdapter);
        l2.includeAdapter(cdai, cdaiAdapter, cdaiAdapter);

        l1.includeAdapter(usdc, usdcAdapter, cusdcAdapter);
        l1.includeAdapter(cusdc, cusdcAdapter, cusdcAdapter);
        l2.includeAdapter(usdc, usdcAdapter, cusdcAdapter);
        l2.includeAdapter(cusdc, cusdcAdapter, cusdcAdapter);

        l1.includeAdapter(usdt, usdtAdapter, ausdtAdapter);
        l1.includeAdapter(ausdt, ausdtAdapter, ausdtAdapter);
        l2.includeAdapter(usdt, usdtAdapter, ausdtAdapter);
        l2.includeAdapter(ausdt, ausdtAdapter, ausdtAdapter);

        l1.includeAdapter(asusd, asusdAdapter, asusdAdapter);
        l1.includeAdapter(susd, susdAdapter, asusdAdapter);
        l2.includeAdapter(asusd, asusdAdapter, asusdAdapter);
        l2.includeAdapter(susd, susdAdapter, asusdAdapter);

        alpha = 500000000000000000;
        beta = 250000000000000000;
        delta = 100000000000000000;
        epsilon = 250000000000000;
        lambda = 200000000000000000;

        // alpha = 900000000000000000; // .9
        // beta = 400000000000000000; // .4
        // delta = 150000000000000000; // .15
        // epsilon = 175000000000000; // 1.75 bps * 2 = 3.5 bps
        // lambda = 500000000000000000; // .5

        l1.setParams(alpha, beta, delta, epsilon, lambda, 0);
        l2.setParams(alpha, beta, delta, epsilon, lambda, 0);

    }

    function includeAdaptersThreeTokens33_33_33 () public {

        l1.includeNumeraireReserveAndWeight(dai, cdaiAdapter, 333333333333333333);
        l1.includeNumeraireReserveAndWeight(usdc, cusdcAdapter, 333333333333333333);
        l1.includeNumeraireReserveAndWeight(usdt, ausdtAdapter, 333333333333333333);
        l2.includeNumeraireReserveAndWeight(dai, cdaiAdapter, 333333333333333333);
        l2.includeNumeraireReserveAndWeight(usdc, cusdcAdapter, 333333333333333333);
        l2.includeNumeraireReserveAndWeight(usdt, ausdtAdapter, 333333333333333333);

        l1.includeAdapter(usdc, usdcAdapter, cusdcAdapter);
        l1.includeAdapter(cusdc, cusdcAdapter, cusdcAdapter);
        l2.includeAdapter(usdc, usdcAdapter, cusdcAdapter);
        l2.includeAdapter(cusdc, cusdcAdapter, cusdcAdapter);

        l1.includeAdapter(dai, daiAdapter, cdaiAdapter);
        l1.includeAdapter(chai, chaiAdapter, cdaiAdapter);
        l1.includeAdapter(cdai, cdaiAdapter, cdaiAdapter);
        l2.includeAdapter(dai, daiAdapter, cdaiAdapter);
        l2.includeAdapter(chai, chaiAdapter, cdaiAdapter);
        l2.includeAdapter(cdai, cdaiAdapter, cdaiAdapter);

        l1.includeAdapter(usdt, usdtAdapter, ausdtAdapter);
        l1.includeAdapter(ausdt, ausdtAdapter, ausdtAdapter);
        l2.includeAdapter(usdt, usdtAdapter, ausdtAdapter);
        l2.includeAdapter(ausdt, ausdtAdapter, ausdtAdapter);

        alpha = 500000000000000000;
        beta = 250000000000000000;
        delta = 100000000000000000;
        epsilon = 250000000000000;
        lambda = 200000000000000000;

        l1.setParams(alpha, beta, delta, epsilon, lambda, 0);
        l2.setParams(alpha, beta, delta, epsilon, lambda, 0);

    }

}