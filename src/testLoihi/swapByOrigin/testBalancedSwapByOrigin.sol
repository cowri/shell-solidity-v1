pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../../adapters/kovan/KovanChaiAdapter.sol";
import "../loihiSetup.sol";
import "../../IAdapter.sol";
import "../../LoihiViews.sol";

contract BalancedSwapByOriginTest is LoihiSetup, DSMath, DSTest {
    uint256 ChaiNM10; 
    uint256 ChaiNM25; 
    uint256 CDaiNM25;

    function setUp() public {

        setupFlavors();
        setupAdapters();
        setupLoihi();
        approveFlavors(address(l));

        l.proportionalDeposit(300 * (10 ** 18));

        ChaiNM10 = IAdapter(chaiAdapter).viewRawAmount(10*WAD);
        ChaiNM25 = IAdapter(chaiAdapter).viewRawAmount(25*WAD);
        CDaiNM25 = IAdapter(cdaiAdapter).viewRawAmount(25*WAD);

    }

    event log_bytes4(bytes32, bytes4);

    function testSwap10OriginChaiUsdc () public {
        uint256 projectedAmount = l.viewOriginTrade(chai, usdc, ChaiNM10);
        // uint256 targetAmount = l.swapByOrigin(chai, usdc, ChaiNM10, 0, now);
        assertEq(projectedAmount, 9995000);
        assertEq(targetAmount, 9995000);
        assertEq(projectedAmount, targetAmount);
    }

    // function testSwap10OriginDaiUsdc () public {
    //     uint256 targetAmount = l.swapByOrigin(dai, usdc, 10 * WAD, 0, now);
    //     assertEq(targetAmount, 9995000);
    // }

    // function testSwap25OriginChaiCusdc () public {
    //     uint256 targetAmount = l.swapByOrigin(chai, cusdc, ChaiNM25, 9 * (10 ** 8), now);
    //     uint256 numeraireAmount = IAdapter(cusdcAdapter).getNumeraireAmount(targetAmount);
    //     numeraireAmount /= 10000000000;
    //     assertEq(numeraireAmount, 2498749900);
    // }

    // function testSwap25OriginCDaiCusdc () public {
    //     uint256 targetAmount = l.swapByOrigin(cdai, cusdc, CDaiNM25, 0, now);
    //     uint256 numeraireAmount = IAdapter(cusdcAdapter).getNumeraireAmount(targetAmount);
    //     numeraireAmount /= 10000000000;
    //     assertEq(numeraireAmount, 2498750000);
    // }

    // function testSwap25Origin () public {
    //     uint256 targetAmount = l.swapByOrigin(dai, cusdc, 25 * WAD, 9 * (10 ** 8), now);
    //     uint256 numeraireAmount = IAdapter(cusdcAdapter).getNumeraireAmount(targetAmount);
    //     numeraireAmount /= 10000000000;
    //     assertEq(numeraireAmount, 2498749900);
    // }
    // function testSwap40Origin () public {
    //     uint256 targetAmount = l.swapByOrigin(dai, cusdc, 40 * WAD, 9 * (10 ** 8), now);
    //     uint256 numeraireAmount = IAdapter(cusdcAdapter).getNumeraireAmount(targetAmount);
    //     numeraireAmount /= 10000000000;
    //     assertEq(numeraireAmount, 3953692000);
    // }

    // function testSwap50Origin () public {
    //     uint256 targetAmount = l.swapByOrigin(dai, usdc, 50 * WAD - 10000000000000, 9 * (10**6), now);
    //     assertEq(targetAmount, 48756459);
    // }

    // function testFailSwap80Origin () public {
    //     uint256 targetAmount = l.swapByOrigin(dai, cusdc, 80 * WAD, 9 , now);
    // }

}