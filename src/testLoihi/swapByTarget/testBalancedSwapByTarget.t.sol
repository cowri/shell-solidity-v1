
pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../flavorsSetup.sol";
import "../adaptersSetup.sol";
import "../../Loihi.sol";

contract BalancedSwapByTargetTest is AdaptersSetup, DSMath, DSTest {
    Loihi l;

    function setUp() public {

        // setupFlavors();
        // setupAdapters();
        // l = new Loihi(chai, cdai, dai, pot, cusdc, usdc, usdt);
        // approveFlavors(address(l));
        
        setupFlavors();
        setupAdapters();
        l = new Loihi(address(0), address(0), address(0), address(0), address(0), address(0), address(0));
        approveFlavors(address(l));


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

    function testBalancedSwap15Target () public {
        uint256 targetAmount = l.swapByTarget(dai, 200 * WAD, usdc, 15 * 1000000, now);
        targetAmount /= 1000000000000;
        assertEq(targetAmount, 15007500);
    }

    function testBalancedSwap25Target () public {
        uint256 targetAmount = l.swapByTarget(dai, 300 * WAD, usdc, 25 * 1000000, now);
        targetAmount /= 1000000000000;
        assertEq(targetAmount, 25012500);
    }

    function testBalancedSwap30Target () public {
        uint256 targetAmount = l.swapByTarget(dai, 900 * WAD, usdc, 30 * 1000000, now);
        targetAmount /= 1000000000000;
        assertEq(targetAmount, 30065414);
    }

    function testBalancedSwap48Point25Target () public {
        uint256 targetAmount = l.swapByTarget(dai, 500 * WAD, usdc, 48250000, now);
        targetAmount /= 100000000000000;
        assertEq(targetAmount, 493821);
    }

    function testFailBalancedSwap51Target () public {
        uint256 targetAmount = l.swapByTarget(dai, 900 * WAD, usdc, 50 * 1000000, now);
    }

}