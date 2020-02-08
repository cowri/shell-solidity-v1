
pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../../Loihi.sol";
import "../../ERC20I.sol";
import "../flavorsSetup.sol";
import "../adaptersSetup.sol";
import "../../ChaiI.sol";

contract PotMock {
    constructor () public { }
    function rho () public returns (uint256) { return now - 500; }
    function drip () public returns (uint256) { return (10 ** 18) * 2; }
    function chi () public returns (uint256) { return (10 ** 18) * 2; }
}

contract BalancedSwapByOriginTest is AdaptersSetup, DSMath, DSTest {
    Loihi l;

    function setUp() public {
        setupFlavors();
        setupAdapters();

        address pot = address(new PotMock());
        l = new Loihi(
            chai, cdai, dai, pot,
            cusdc, usdc,
            usdt
        );

        ERC20I(chai).approve(address(l), 100000 * (10 ** 18));
        ERC20I(cdai).approve(address(l), 100000 * (10 ** 18));
        ERC20I(dai).approve(address(l), 100000 * (10 ** 18));
        ERC20I(cusdc).approve(address(l), 100000 * (10 ** 18));
        ERC20I(usdc).approve(address(l), 100000 * (10 ** 18));
        ERC20I(usdt).approve(address(l), 100000 * (10 ** 18));

        uint256 weight = WAD / 3;

        l.includeNumeraireAndReserve(dai, cdaiAdapter);
        l.includeNumeraireAndReserve(usdc, cusdcAdapter);
        l.includeNumeraireAndReserve(usdt, usdtAdapter);

        l.includeAdapter(chai, chaiAdapter, cdaiAdapter, weight);
        l.includeAdapter(dai, daiAdapter, cdaiAdapter, weight);
        l.includeAdapter(cdai, cdaiAdapter, cdaiAdapter, weight);
        l.includeAdapter(cusdc, cusdcAdapter, cusdcAdapter, weight);
        l.includeAdapter(usdc, usdcAdapter, cusdcAdapter, weight);
        l.includeAdapter(usdt, usdtAdapter, usdtAdapter, weight);

        l.setAlpha((5 * WAD) / 10);
        l.setBeta((25 * WAD) / 100);
        l.setFeeDerivative(WAD / 10);
        l.setFeeBase(500000000000000);

        l.proportionalDeposit(300 * (10 ** 18));

    }

    function testSwap10Origin () public {
        uint256 targetAmount = l.swapByOrigin(dai, 10 * WAD, usdc, 9 * WAD, now);
        assertEq(targetAmount, 9995000000000000000);
    }

    function testSwap25Origin () public {
        uint256 targetAmount = l.swapByOrigin(dai, 25 * WAD, cusdc, 9 * WAD, now);
        assertEq(targetAmount, 24987500000000000000);
    }

    function testSwap40Origin () public {
        uint256 targetAmount = l.swapByOrigin(dai, 40 * WAD, cusdc, 9 * WAD, now);
        assertEq(targetAmount, 39536921025312499999);
    }

    function testSwap50Origin () public {
        uint256 targetAmount = l.swapByOrigin(dai, 50 * WAD - 200, usdc, 9 * WAD, now);
        assertEq(targetAmount, 48756468945312499807);
    }

    function testFailSwap80Origin () public {
        uint256 targetAmount = l.swapByOrigin(dai, 80 * WAD, cusdc, 9 * WAD, now);
    }

}