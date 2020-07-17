
pragma solidity ^0.5.0;

import "ds-test/test.sol";

import "./targetSwapTemplate.sol";

contract TargetSwapSuiteSixTest is TargetSwapTemplate, DSTest {

    function setUp() public {

        l = getLoihiSuiteSix();
        l2 = getLoihiSuiteSixClone();

    }

    function doubleDeposit (
        address w, uint256 wAmt,
        address x, uint256 xAmt,
        address y, uint256 yAmt,
        address z, uint256 zAmt
    ) public {

        l.deposit(w, wAmt, x, xAmt, y, yAmt, z, zAmt);
        l2.deposit(w, wAmt, x, xAmt, y, yAmt, z, zAmt);

    }

    function doubleDeposit (uint256 shells) public {

        l.proportionalDeposit(shells, 1e50);
        l2.proportionalDeposit(shells, 1e50);

    }

    function test_s6_targetSwap_continuity_balanced () public {

        doubleDeposit(300e18);

        uint256 originOf10 = l.targetSwap(
            address(dai),
            address(usdc),
            10e6
        );

        uint256 originOf5And5 = l2.targetSwap(
            address(dai),
            address(usdc),
            5e6
        );

        originOf5And5 += l2.targetSwap(
            address(dai),
            address(usdc),
            5e6
        );

        assertEq(
            originOf10 / 1e2,
            originOf5And5 / 1e2
        );

    }

    function test_s6_targetSwap_continuity_slippage () public {

        doubleDeposit(300e18);

        uint256 originOf40 = l.targetSwap(
            address(usdc),
            address(dai),
            40e18
        );

        uint256 originOf20And20 = l2.targetSwap(
            address(usdc),
            address(dai),
            20e18
        );

        originOf20And20 += l2.targetSwap(
            address(usdc),
            address(dai),
            20e18
        );

        assertEq(
            originOf40,
            originOf20And20
        );

    }

    function test_s6_targetSwap_continuity_antiSlippage () public {

        doubleDeposit(
            address(dai), 135e18,
            address(usdc), 60e6,
            address(usdt), 90e6,
            address(susd), 30e18
        );

        uint256 originOf30 = l.targetSwap(
            address(usdc),
            address(dai),
            30e18
        );

        uint256 originOf15And15 = l2.targetSwap(
            address(usdc),
            address(dai),
            15e18
        );

        originOf15And15 += l2.targetSwap(
            address(usdc),
            address(dai),
            15e18
        );

        assertEq(
            originOf30 / 1e2,
            originOf15And15 / 1e2
        );

    }


}