pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../loihiSetup.sol";
import "../../IAdapter.sol";

contract BalancedSwapByOriginTest is LoihiSetup, DSMath, DSTest {

    function setUp() public {

        setupFlavors();
        setupAdapters();
        setupLoihi();
        approveFlavors(address(l));

        l.proportionalDeposit(300 * (10 ** 18));

    }

    function testSwap10Origin () public {
        uint256 targetAmount = l.swapByOrigin(dai, usdc, 10 * WAD, 9 * (6 ** WAD), now);
        assertEq(targetAmount, 9995000);
    }

    function testSwap25Origin () public {
        uint256 targetAmount = l.swapByOrigin(dai, cusdc, 25 * WAD, 9 * (10 ** 8), now);
        uint256 numeraireAmount = IAdapter(cusdcAdapter).getNumeraireAmount(targetAmount);
        numeraireAmount /= 10000000000;
        assertEq(numeraireAmount, 2498749900);
    }

    function testSwap40Origin () public {
        uint256 targetAmount = l.swapByOrigin(dai, cusdc, 40 * WAD, 9 * (10 ** 8), now);
        uint256 numeraireAmount = IAdapter(cusdcAdapter).getNumeraireAmount(targetAmount);
        numeraireAmount /= 10000000000;
        assertEq(numeraireAmount, 3953692000);
    }

    function testSwap50Origin () public {
        uint256 targetAmount = l.swapByOrigin(dai, usdc, 50 * WAD - 10000000000000, 9 * (10**6), now);
        assertEq(targetAmount, 48756459);
    }

    function testFailSwap80Origin () public {
        uint256 targetAmount = l.swapByOrigin(dai, cusdc, 80 * WAD, 9 , now);
    }

}