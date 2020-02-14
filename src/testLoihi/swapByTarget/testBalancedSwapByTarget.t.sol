
pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../loihiSetup.sol";
import "../../IAdapter.sol";

contract BalancedSwapByTargetTest is LoihiSetup, DSMath, DSTest {
    uint ChaiNM15;
    uint CDaiNM15;
    uint CUsdcNM15;
    uint CDaiNM25;

    function setUp() public {

        setupFlavors();
        setupAdapters();
        setupLoihi();
        approveFlavors(address(l));
        l.proportionalDeposit(300 * (10 ** 18));

        ChaiNM15 = IAdapter(chaiAdapter).viewRawAmount(15*WAD);
        CDaiNM15 = IAdapter(cdaiAdapter).viewRawAmount(15*WAD);
        CUsdcNM15 = IAdapter(cusdcAdapter).viewRawAmount(15*WAD);
        CDaiNM25 = IAdapter(cdaiAdapter).viewRawAmount(25*WAD);

    }

    function testBalancedSwap15TargetCUsdcUSDT () public {
        uint256 targetAmount = l.swapByTarget(usdt, cusdc, 200 * WAD, CUsdcNM15, now);
        assertEq(targetAmount, 15007500);
    }

    function testBalancedSwap15TargetCDai () public {
        uint256 targetAmount = l.swapByTarget(usdc, chai, 200 * WAD, ChaiNM15, now);
        assertEq(targetAmount, 15007500);
    }

    function testBalancedSwap15TargetChai () public {
        uint256 targetAmount = l.swapByTarget(usdc, cdai, 200 * WAD, CDaiNM15, now);
        assertEq(targetAmount, 15007500);
    }

    function testBalancedSwap15Target () public {
        uint256 targetAmount = l.swapByTarget(dai, usdc, 200 * WAD, 15 * 1000000, now);
        targetAmount /= 1000000000000;
        assertEq(targetAmount, 15007500);
    }

    function testBalancedSwap25Target () public {
        uint256 targetAmount = l.swapByTarget(cusdc, cdai, 300 * WAD, CDaiNM25, now);
        targetAmount = IAdapter(cusdcAdapter).viewNumeraireAmount(targetAmount);
        assertEq(targetAmount / (10**12), 25012500);
    }

    function testBalancedSwap25TargetUsdtUsdc () public {
        uint256 targetAmount = l.swapByTarget(usdt, usdc, 300 * WAD, 25 * 1000000, now);
        assertEq(targetAmount, 25012500);
    }

    function testBalancedSwap25Target () public {
        uint256 targetAmount = l.swapByTarget(dai, usdc, 300 * WAD, 25 * 1000000, now);
        targetAmount /= 1000000000000;
        assertEq(targetAmount, 25012500);
    }

    function testBalancedSwap30Target () public {
        uint256 targetAmount = l.swapByTarget(dai, usdc, 900 * WAD, 30 * 1000000, now);
        targetAmount /= 1000000000000;
        assertEq(targetAmount, 30065414);
    }

    function testBalancedSwap48Point25Target () public {
        uint256 targetAmount = l.swapByTarget(dai, usdc, 500 * WAD, 48250000, now);
        targetAmount /= 100000000000000;
        assertEq(targetAmount, 493821);
    }

    function testFailBalancedSwap51Target () public {
        uint256 targetAmount = l.swapByTarget(dai, usdc, 900 * WAD, 50 * 1000000, now);
    }

}