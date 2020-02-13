
pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../loihiSetup.sol";

contract BalancedSwapByTargetTest is LoihiSetup, DSMath, DSTest {

    function setUp() public {

        setupFlavors();
        setupAdapters();
        setupLoihi();
        approveFlavors(address(l));
        l.proportionalDeposit(300 * (10 ** 18));

    }

    function testBalancedSwap15Target () public {
        uint256 targetAmount = l.swapByTarget(dai, usdc, 200 * WAD, 15 * 1000000, now);
        targetAmount /= 1000000000000;
        assertEq(targetAmount, 15007500);
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