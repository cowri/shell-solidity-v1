pragma solidity ^0.5.0;

import "ds-test/test.sol";

import "./withdrawTemplate.sol";

contract SelectiveWithdrawSuiteSix is SelectiveWithdrawTemplate, DSTest {

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

    function doubleDeposit (uint256 shells) public {

        s.proportionalDeposit(shells, 1e50);
        s2.proportionalDeposit(shells, 1e50);

    }

    function test_s6_selectiveWithdraw_continuity_noSlippage_noAntiSlippage () public {

        doubleDeposit(300e18);

        uint256 burntShellsOf10 = s.withdraw(
            address(dai), 10e18,
            address(usdc), 10e6,
            address(usdt), 10e6,
            address(susd), 2.5e18
        );

        uint256 burntShellsOf5And5 = s2.withdraw(
            address(dai), 5e18,
            address(usdc), 5e6,
            address(usdt), 5e6,
            address(susd), 1.25e18
        );

        burntShellsOf5And5 += s2.withdraw(
            address(dai), 5e18,
            address(usdc), 5e6,
            address(usdt), 5e6,
            address(susd), 1.25e18
        );

        assertEq(
            burntShellsOf10 / 1e12,
            burntShellsOf5And5 / 1e12
        );

    }

    function test_s6_selectiveWithdraw_continuity_slippage () public {

        doubleDeposit(300e18);


        uint256 shellsBurnedFiveFiveFortysevenSixteen = s.withdraw(
            address(dai), 5e18,
            address(usdc), 5e6,
            address(usdt), 47e6,
            address(susd), 16e18
        );

        uint256 shellsBurnedTwoPFiveTwoPFiveTwentythreePFiveEightTwice = s2.withdraw(
            address(dai), 2.5e18,
            address(usdc), 2.5e6,
            address(usdt), 23.5e6,
            address(susd), 8e18
        );

        shellsBurnedTwoPFiveTwoPFiveTwentythreePFiveEightTwice += s2.withdraw(
            address(dai), 2.5e18,
            address(usdc), 2.5e6,
            address(usdt), 23.5e6,
            address(susd), 8e18
        );

        assertEq(
            shellsBurnedFiveFiveFortysevenSixteen / 1e12,
            shellsBurnedTwoPFiveTwoPFiveTwentythreePFiveEightTwice / 1e12
        );



    }

    function test_s6_selectiveWithdraw_continuity_antiSlippage () public {

        doubleDeposit(
            address(dai), 90e18,
            address(usdc), 145e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );

        uint256 shellsBurntOf50And18 = s.withdraw(
            address(usdc), 50e6,
            address(susd), 18e18
        );

        uint256 shellsBurntOf25And9Twice = s2.withdraw(
            address(usdc), 25e6,
            address(susd), 9e18
        );

        shellsBurntOf25And9Twice += s2.withdraw(
            address(usdc), 25e6,
            address(susd), 9e18
        );

        assertEq(
            shellsBurntOf50And18 / 1e12,
            shellsBurntOf25And9Twice / 1e12
        );

    }

}