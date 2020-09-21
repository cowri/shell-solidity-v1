pragma solidity ^0.5.0;

import "ds-test/test.sol";

import "./depositsTemplate.sol";

contract SelectiveDepositSuiteSix is SelectiveDepositTemplate, DSTest {

    function setUp() public {

        s = getShellSuiteSix();
        s2 = getShellSuiteSixClone();

    }

    function doubleDeposit (
        address w, uint256 wAmt,
        address x, uint256 xAmt,
        address y, uint256 yAmt,
        address z, uint256 zAmt
    ) public {

        s.deposit(w, wAmt, x, xAmt, y, yAmt, z, zAmt);
        s2.deposit(w, wAmt, x, xAmt, y, yAmt, z, zAmt);

    }

    function test_s6_selectiveDeposit_continuity_noSlippage_noAntiSlippage () public {

        uint256 shellsOfTenTenTenAndTwoPFive = s.deposit(
            address(dai), 10e18,
            address(usdc), 10e6,
            address(usdt), 10e6,
            address(susd), 2.5e18
        );

        uint256 shellsOfFiveFiveFiveAndOnePTwoFiveTwice = s.deposit(
            address(dai), 5e18,
            address(usdc), 5e6,
            address(usdt), 5e6,
            address(susd), 1.25e18
        );

        shellsOfFiveFiveFiveAndOnePTwoFiveTwice += s.deposit(
            address(dai), 5e18,
            address(usdc), 5e6,
            address(usdt), 5e6,
            address(susd), 1.25e18
        );

        assertEq(
            shellsOfTenTenTenAndTwoPFive / 1e12,
            shellsOfFiveFiveFiveAndOnePTwoFiveTwice / 1e12 + 1
        );

    }

    function test_s6_selectiveDeposit_continuity_slippage () public {

        doubleDeposit(
            address(dai), 145e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );

        uint256 shellsOfTen = s.deposit(address(dai), 10e18);

        uint256 shellsOfFiveAndFive = s2.deposit(address(dai), 5e18);

        shellsOfFiveAndFive += s2.deposit(address(dai), 5e18);

        assertEq(
            shellsOfTen / 1e12,
            shellsOfFiveAndFive / 1e12
        );

    }

    function test_s6_selectiveDeposit_continuity_antiSlippage () public {

        doubleDeposit(
            address(dai), 45e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 30e18
        );

        uint256 shellsOfTen = s.deposit(address(dai), 10e18);

        uint256 shellsOfFiveAndFive = s2.deposit(address(dai), 5e18);
        shellsOfFiveAndFive += s2.deposit(address(dai), 5e18);

        assertEq(
            shellsOfTen / 1e12,
            shellsOfFiveAndFive / 1e12
        );

    }

}