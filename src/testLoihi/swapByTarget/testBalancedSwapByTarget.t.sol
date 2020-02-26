
pragma solidity ^0.5.15;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../loihiSetup.sol";
import "../../interfaces/IAdapter.sol";
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
        executeLoihiApprovals(address(l));
        includeAdapters(address(l), 1);
        
        l.proportionalDeposit(300 * (10 ** 18));

    }
    
    // function testTargetSwapDaiCDai () public {
    //     uint256 cdaiOfTenNumeraire = IAdapter(cdaiAdapter).viewRawAmount(10*WAD);
    //     uint256 originAmount = l.swapByTarget(dai, cdai, 200 * WAD, cdaiOfTenNumeraire, now + 50);
    //     assertEq(originAmount / (10**10), (10 * WAD)/(10**10));
    // }

    // function testTargetSwapDaiChai () public {
    //     uint256 chaiOfTenNumeraire = IAdapter(chaiAdapter).viewRawAmount(10*WAD);
    //     uint256 originAmount = l.swapByTarget(dai, chai, 200 * WAD, chaiOfTenNumeraire, now + 50);
    //     assertEq(originAmount, 10 * WAD);
    // }

    // function testTargetSwapChaiCDai () public {
    //     uint256 chaiOfTenNumeraire = IAdapter(chaiAdapter).viewRawAmount(10*WAD);
    //     uint256 cdaiOfTenNumeraire = IAdapter(cdaiAdapter).viewRawAmount(10*WAD);
    //     uint256 originAmount = l.swapByTarget(chai, cdai, 200 * WAD, cdaiOfTenNumeraire, now + 50);
    //     assertEq(originAmount / (10**10), chaiOfTenNumeraire / (10**10));
    // }

    // function testTargetSwapCDaiDai () public {
    //     uint256 cdaiOfTenNumeraire = IAdapter(cdaiAdapter).viewRawAmount(10*WAD);
    //     uint256 originAmount = l.swapByTarget(cdai, dai, 200 * WAD, 10 * WAD, now + 50);
    //     assertEq(originAmount, cdaiOfTenNumeraire);
    // }

    // function testTargetSwapChaiDai () public {
    //     uint256 chaiOfTenNumeraire = IAdapter(chaiAdapter).viewRawAmount(10*WAD);
    //     uint256 originAmount = l.swapByTarget(chai, dai, 200 * WAD, 10 * WAD, now + 50);
    //     assertEq(originAmount, chaiOfTenNumeraire);
    // }

    // function testTargetSwapUsdcCUsdc () public {
    //     uint256 cusdcOfTenNumeraire = IAdapter(cusdcAdapter).viewRawAmount(10*WAD);
    //     uint256 originAmount = l.swapByTarget(usdc, cusdc, 200 * WAD, cusdcOfTenNumeraire, now + 50);
    //     assertEq(originAmount, 10*(10**6));
    //     emit log_named_uint("cusdc of nume", cusdcOfTenNumeraire);
    // }

    // function testTargetSwapCusdcUsdc () public {
    //     uint256 cusdcOfTenNumeraire = IAdapter(cusdcAdapter).viewRawAmount(10*WAD);
    //     uint256 originAmount = l.swapByTarget(cusdc, usdc, 200 * WAD, 10 * (10**6), now + 50);
    //     assertEq(originAmount, cusdcOfTenNumeraire);
    // }

    // function testTargetSwapAUsdtUsdt () public {
    //     uint256 originAmount = l.swapByTarget(ausdt, usdt, 200 * WAD, 10 * (10**6), now + 50);
    //     assertEq(originAmount, 10 * (10**6));
    // }

    // function testTargetSwapUsdtAUsdt () public {
    //     uint256 originAmount = l.swapByTarget(usdt, ausdt, 200 * WAD, 10 * (10**6), now + 50);
    //     assertEq(originAmount, 10 * (10**6));
    // }

    // function testBalancedTargetSwapUsdtCUsdc15 () public {
    //     uint256 cusdcOf15Numeraire = IAdapter(cusdcAdapter).viewRawAmount(15*WAD);
    //     uint256 projectedAmount = l.viewTargetTrade(usdt, cusdc, cusdcOf15Numeraire);
    //     uint256 originAmount = l.swapByTarget(usdt, cusdc, 200 * WAD, cusdcOf15Numeraire, now);
    //     assertEq(projectedAmount, 15007500);
    //     assertEq(originAmount, 15007500);
    //     assertEq(originAmount, projectedAmount);
    // }

    // function testBalancedTargetSwapUsdtChai15 () public {
    //     uint256 chaiOf15Numeraire = IAdapter(chaiAdapter).viewRawAmount(15*WAD);
    //     uint256 projectedAmount = l.viewTargetTrade(usdt, chai, chaiOf15Numeraire);
    //     uint256 originAmount = l.swapByTarget(usdt, chai, 200 * WAD, chaiOf15Numeraire, now);
    //     assertEq(projectedAmount, 15007500);
    //     assertEq(originAmount, 15007500);
    //     assertEq(originAmount, projectedAmount);
    // }

    // function testBalancedTargetSwapUsdtDai15 () public {
    //     uint256 projectedAmount = l.viewTargetTrade(usdt, dai, 15*WAD);
    //     uint256 originAmount = l.swapByTarget(usdt, dai, 200 * WAD, 15*WAD, now);
    //     assertEq(projectedAmount, 15007500);
    //     assertEq(originAmount, 15007500);
    //     assertEq(originAmount, projectedAmount);
    // }

    // function testBalancedTargetSwapUsdtCDai15 () public {
    //     uint256 cdaiOf15Numeraire = IAdapter(cdaiAdapter).viewRawAmount(15*WAD);
    //     uint256 projectedAmount = l.viewTargetTrade(usdt, cdai, cdaiOf15Numeraire);
    //     uint256 originAmount = l.swapByTarget(usdt, cdai, 200 * WAD, cdaiOf15Numeraire, now);
    //     assertEq(projectedAmount, 15007500);
    //     assertEq(originAmount, 15007500);
    //     assertEq(originAmount, projectedAmount);
    // }

    // function testBalancedTargetSwapUsdtUsdc15 () public {
    //     uint256 projectedAmount = l.viewTargetTrade(usdt, usdc, 15*(10**6));
    //     uint256 originAmount = l.swapByTarget(usdt, usdc, 200 * WAD, 15*(10**6), now);
    //     assertEq(projectedAmount, 15007500);
    //     assertEq(originAmount, 15007500);
    //     assertEq(originAmount, projectedAmount);
    // }

    // function testBalancedTargetSwapUsdcChai15 () public {
    //     uint256 chaiOf15Numeraires = IAdapter(chaiAdapter).viewRawAmount(15*WAD);
    //     uint256 projectedAmount = l.viewTargetTrade(usdc, chai, chaiOf15Numeraires);
    //     uint256 originAmount = l.swapByTarget(usdc, chai, 200 * WAD, chaiOf15Numeraires, now);
    //     assertEq(projectedAmount, originAmount);
    //     assertEq(originAmount, 15007500);
    // }

    // function testBalancedTargetSwapUsdcCDai15 () public {
    //     uint256 cdaiOf15Numeraire = IAdapter(cdaiAdapter).viewRawAmount(15*WAD);
    //     uint256 projectedAmount = l.viewTargetTrade(usdc, cdai, cdaiOf15Numeraire);
    //     uint256 originAmount = l.swapByTarget(usdc, cdai, 200 * WAD, cdaiOf15Numeraire, now);
    //     assertEq(originAmount, 15007500);
    //     assertEq(projectedAmount, originAmount);
    // }

    // function testBalancedTargetSwapUsdcDai15 () public {
    //     uint256 projectedAmount = l.viewTargetTrade(usdc, dai, 15*WAD);
    //     uint256 originAmount = l.swapByTarget(usdc, dai, 200 * WAD, 15*WAD, now);
    //     assertEq(originAmount, 15007500);
    //     assertEq(projectedAmount, originAmount);
    // }

    // function testBalancedTargetSwapUsdcUsdt15 () public {
    //     uint256 projectedAmount = l.viewTargetTrade(usdc, usdt, 15*(10**6));
    //     uint256 originAmount = l.swapByTarget(usdc, usdt, 200 * WAD, 15*(10**6), now);
    //     assertEq(originAmount, 15007500);
    //     assertEq(projectedAmount, originAmount);
    // }

    // function testBalancedTargetSwapUsdcAUsdt15 () public {
    //     uint256 projectedAmount = l.viewTargetTrade(usdc, ausdt, 15*(10**6));
    //     uint256 originAmount = l.swapByTarget(usdc, ausdt, 200 * WAD, 15*(10**6), now);
    //     assertEq(originAmount, 15007500);
    //     assertEq(projectedAmount, originAmount);
    // }

    // function testBalancedTargetSwapCUsdcCDai15 () public {
    //     uint256 cdaiOf15Numeraire = IAdapter(cdaiAdapter).viewRawAmount(15*WAD);
    //     uint256 projectedAmount = l.viewTargetTrade(cusdc, cdai, cdaiOf15Numeraire);
    //     uint256 originAmount = l.swapByTarget(cusdc, cdai, 200 * WAD, cdaiOf15Numeraire, now + 50);
    //     uint256 projectedAmountInNumeraire = IAdapter(cusdcAdapter).viewNumeraireAmount(projectedAmount);
    //     uint256 swappedAmountInNumeraire = IAdapter(cusdcAdapter).viewNumeraireAmount(originAmount);
    //     assertEq(projectedAmount, originAmount);
    //     assertEq(projectedAmountInNumeraire / (10**12), 15007500);
    //     assertEq(swappedAmountInNumeraire / (10**12), 15007500);
    // }

    // function testBalancedTargetSwapCUsdcChai15 () public {
    //     uint256 chaiOf15Numeraire = IAdapter(chaiAdapter).viewRawAmount(15*WAD);
    //     uint256 projectedAmount = l.viewTargetTrade(cusdc, chai, chaiOf15Numeraire);
    //     uint256 originAmount = l.swapByTarget(cusdc, chai, 200*WAD, chaiOf15Numeraire, now + 50);
    //     uint256 projectedAmountInNumeraire = IAdapter(cusdcAdapter).viewNumeraireAmount(projectedAmount);
    //     uint256 swappedAmountInNumeraire = IAdapter(cusdcAdapter).viewNumeraireAmount(originAmount);
    //     assertEq(projectedAmount, originAmount);
    //     assertEq(projectedAmountInNumeraire / (10**12), 15007500);
    //     assertEq(swappedAmountInNumeraire / (10**12), 15007500);
    // }

    // function testBalancedTargetSwapCUsdDai15 () public {
    //     uint256 projectedAmount = l.viewTargetTrade(cusdc, dai, 15*WAD);
    //     uint256 originAmount = l.swapByTarget(cusdc, dai, 200*WAD, 15*WAD, now + 50);
    //     uint256 projectedAmountInNumeraire = IAdapter(cusdcAdapter).viewNumeraireAmount(projectedAmount);
    //     uint256 swappedAmountInNumeraire = IAdapter(cusdcAdapter).viewNumeraireAmount(originAmount);
    //     assertEq(projectedAmount, originAmount);
    //     assertEq(projectedAmountInNumeraire / (10**12), 15007500);
    //     assertEq(swappedAmountInNumeraire / (10**12), 15007500);
    // }
    
    // function testBalancedTargetSwapCUsdcUsdt15 () public {
    //     uint256 projectedAmount = l.viewTargetTrade(cusdc, usdt, 15*(10**6));
    //     uint256 originAmount = l.swapByTarget(cusdc, usdt, 200*WAD, 15*(10**6), now + 50);
    //     uint256 projectedAmountInNumeraire = IAdapter(cusdcAdapter).viewNumeraireAmount(projectedAmount);
    //     uint256 swappedAmountInNumeraire = IAdapter(cusdcAdapter).viewNumeraireAmount(originAmount);
    //     assertEq(projectedAmount, originAmount);
    //     assertEq(projectedAmountInNumeraire / (10**12), 15007500);
    //     assertEq(swappedAmountInNumeraire / (10**12), 15007500);
    // }
    
    // function testBalancedTargetSwapCDaiUsdc15 () public {
    //     uint256 projectedAmount = l.viewTargetTrade(cdai, usdc, 15*(10**6));
    //     uint256 originAmount = l.swapByTarget(cdai, usdc, 200 * WAD, 15*(10**6), now);
    //     uint256 projectedAmountInNumeraire = IAdapter(cdaiAdapter).viewNumeraireAmount(projectedAmount);
    //     uint256 swappedAmountInNumeraire = IAdapter(cdaiAdapter).viewNumeraireAmount(originAmount);
    //     assertEq(originAmount, projectedAmount);
    //     assertEq(projectedAmountInNumeraire / (10**12), 15007500);
    //     assertEq(swappedAmountInNumeraire / (10**12), 15007500);
    // }

    // function testBalancedTargetSwapChaiCUsdc15 () public {
    //     uint256 cusdcOf15Numeraire = IAdapter(cusdcAdapter).viewRawAmount(15*WAD);
    //     uint256 projectedAmount = l.viewTargetTrade(chai, cusdc, cusdcOf15Numeraire);
    //     uint256 originAmount = l.swapByTarget(chai, cusdc, 200 * WAD, cusdcOf15Numeraire, now);
    //     assertEq(originAmount, projectedAmount);
    //     uint256 projectedOriginInNumeraire = IAdapter(chaiAdapter).viewNumeraireAmount(projectedAmount);
    //     uint256 swappedOriginInNumeraire = IAdapter(chaiAdapter).viewNumeraireAmount(originAmount);
    //     assertEq(projectedOriginInNumeraire, 15007500000000000000);
    //     assertEq(swappedOriginInNumeraire, 15007500000000000000);
    // }

    // function testBalancedTargetSwapChaiUsdc15 () public {
    //     uint256 projectedAmount = l.viewTargetTrade(chai, usdc, 15*(10**6));
    //     uint256 originAmount = l.swapByTarget(chai, usdc, 200 * WAD, 15*(10**6), now);
    //     assertEq(originAmount, projectedAmount);
    //     uint256 projectedOriginInNumeraire = IAdapter(chaiAdapter).viewNumeraireAmount(projectedAmount);
    //     uint256 swappedOriginInNumeraire = IAdapter(chaiAdapter).viewNumeraireAmount(originAmount);
    //     assertEq(projectedOriginInNumeraire, 15007500000000000000);
    //     assertEq(swappedOriginInNumeraire, 15007500000000000000);
    // }

    // function testBalancedTargetSwapDaiUsdc15 () public {
    //     uint256 projectedAmount = l.viewTargetTrade(dai, usdc, 15 * 1000000);
    //     uint256 originAmount = l.swapByTarget(dai, usdc, 200 * WAD, 15 * 1000000, now);
    //     assertEq(originAmount, projectedAmount);
    //     originAmount /= 1000000000000;
    //     assertEq(originAmount, 15007500);
    // }

    // function testBalancedTargetSwapCUsdcCDai25 () public {
    //     uint256 cdaiOf25Numeraire = IAdapter(cdaiAdapter).viewRawAmount(25*WAD);
    //     uint256 projectedAmount = l.viewTargetTrade(cusdc, cdai, cdaiOf25Numeraire);
    //     uint256 originAmount = l.swapByTarget(cusdc, cdai, 300 * WAD, cdaiOf25Numeraire, now);
    //     assertEq(projectedAmount, originAmount);
    //     originAmount = IAdapter(cusdcAdapter).viewNumeraireAmount(originAmount);
    //     assertEq(originAmount / (10**12), 25012500);
    // }

    // function testBalancedTargetSwapUsdtUsdc25 () public {
    //     uint256 projectedAmount = l.viewTargetTrade(usdt, usdc, 25 * (10**6));
    //     uint256 originAmount = l.swapByTarget(usdt, usdc, 300 * WAD, 25 * (10**6), now);
    //     assertEq(projectedAmount, originAmount);
    //     assertEq(originAmount, 25012500);
    // }

    // function testBalancedTargetSwapDaiUsdc25 () public {
    //     uint256 projectedAmount = l.viewTargetTrade(dai, usdc, 25 * 1000000);
    //     uint256 originAmount = l.swapByTarget(dai, usdc, 300 * WAD, 25 * 1000000, now);
    //     assertEq(projectedAmount / (10**10), originAmount / (10**10));
    //     originAmount /= 1000000000000;
    //     assertEq(originAmount, 25012500);
    // }

    // function testBalancedTargetSwapDaiUsdc30 () public {
    //     uint256 projectedAmount = l.viewTargetTrade(dai, usdc, 30 * 1000000);
    //     uint256 originAmount = l.swapByTarget(dai, usdc, 900 * WAD, 30 * 1000000, now);
    //     assertEq(projectedAmount / (10**12), originAmount / (10**12));
    //     originAmount /= 1000000000000;
    //     assertEq(originAmount, 30065414);
    // }

    // function testBalancedTargetSwapDaiUsdc48point25 () public {
    //     uint256 projectedAmount = l.viewTargetTrade(dai, usdc, 48250000);
    //     uint256 originAmount = l.swapByTarget(dai, usdc, 500 * WAD, 48250000, now);
    //     assertEq(projectedAmount / (10**12), originAmount / (10**12));
    //     originAmount /= 100000000000000;
    //     assertEq(originAmount, 493821);
    // }

    // function testFailBalancedSwap51Target () public {
    //     uint256 targetAmount = l.swapByTarget(dai, usdc, 900 * WAD, 50 * 1000000, now);
    // }

}