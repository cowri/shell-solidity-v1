
pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../loihiSetup.sol";
import "../../IAdapter.sol";
import "../../LoihiViews.sol";

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
        includeAdapters(address(l), 1);
        
        l.proportionalDeposit(300 * (10 ** 18));

        ChaiNM15 = IAdapter(chaiAdapter).viewRawAmount(15*WAD);
        CDaiNM15 = IAdapter(cdaiAdapter).viewRawAmount(15*WAD);
        CUsdcNM15 = IAdapter(cusdcAdapter).viewRawAmount(15*WAD);
        CDaiNM25 = IAdapter(cdaiAdapter).viewRawAmount(25*WAD);

    }

    event log_bytes4(bytes32, bytes4);

    function testBalancedSwap15TargetCUsdcUSDT () public {
        uint256 projectedAmount = l.viewTargetTrade(usdt, cusdc, CUsdcNM15);
        uint256 originAmount = l.swapByTarget(usdt, cusdc, 200 * WAD, CUsdcNM15, now);
        assertEq(projectedAmount, 15007500);
        assertEq(originAmount, 15007500);
        assertEq(originAmount, projectedAmount);
        emit log_named_uint("projected amount", projectedAmount);
        emit log_named_uint("target amount", originAmount);
    }

    function testBalancedSwap15TargetCDai () public {
        uint256 projectedAmount = l.viewTargetTrade(usdc, chai, ChaiNM15);
        uint256 originAmount = l.swapByTarget(usdc, chai, 200 * WAD, ChaiNM15, now);
        assertEq(projectedAmount, originAmount);
        assertEq(originAmount, 15007500);
    }

    function testBalancedSwap15TargetChai () public {
        uint256 projectedAmount = l.viewTargetTrade(usdc, cdai, CDaiNM15);
        uint256 originAmount = l.swapByTarget(usdc, cdai, 200 * WAD, CDaiNM15, now);
        assertEq(originAmount, 15007500);
        assertEq(projectedAmount, originAmount);
    }

    function testBalancedSwap15Target () public {
        uint256 projectedAmount = l.viewTargetTrade(dai, usdc, 15 * 1000000);
        uint256 originAmount = l.swapByTarget(dai, usdc, 200 * WAD, 15 * 1000000, now);
        assertEq(originAmount, projectedAmount);
        originAmount /= 1000000000000;
        assertEq(originAmount, 15007500);
    }

    function testBalancedSwap25TargetCusdcCdai () public {
        uint256 projectedAmount = l.viewTargetTrade(cusdc, cdai, CDaiNM25);
        uint256 originAmount = l.swapByTarget(cusdc, cdai, 300 * WAD, CDaiNM25, now);
        assertEq(projectedAmount, originAmount);
        originAmount = IAdapter(cusdcAdapter).viewNumeraireAmount(originAmount);
        assertEq(originAmount / (10**12), 25012500);
    }

    function testBalancedSwap25TargetUsdtUsdc () public {
        uint256 projectedAmount = l.viewTargetTrade(usdt, usdc, 25 * 1000000);
        uint256 originAmount = l.swapByTarget(usdt, usdc, 300 * WAD, 25 * 1000000, now);
        assertEq(projectedAmount, originAmount);
        assertEq(originAmount, 25012500);
    }

    function testBalancedSwap25Target () public {
        uint256 projectedAmount = l.viewTargetTrade(dai, usdc, 25 * 1000000);
        uint256 originAmount = l.swapByTarget(dai, usdc, 300 * WAD, 25 * 1000000, now);
        assertEq(projectedAmount, originAmount);
        originAmount /= 1000000000000;
        assertEq(originAmount, 25012500);
    }

    function testBalancedSwap30Target () public {
        uint256 projectedAmount = l.viewTargetTrade(dai, usdc, 30 * 1000000);
        uint256 originAmount = l.swapByTarget(dai, usdc, 900 * WAD, 30 * 1000000, now);
        assertEq(projectedAmount, originAmount);
        originAmount /= 1000000000000;
        assertEq(originAmount, 30065414);
    }

    function testBalancedSwap48Point25Target () public {
        uint256 projectedAmount = l.viewTargetTrade(dai, usdc, 48250000);
        uint256 originAmount = l.swapByTarget(dai, usdc, 500 * WAD, 48250000, now);
        assertEq(projectedAmount, originAmount);
        originAmount /= 100000000000000;
        assertEq(originAmount, 493821);
    }

    function testFailBalancedSwap51Target () public {
        uint256 targetAmount = l.swapByTarget(dai, usdc, 900 * WAD, 50 * 1000000, now);
    }

}