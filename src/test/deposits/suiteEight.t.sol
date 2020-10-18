
pragma solidity ^0.5.0;

import "ds-test/test.sol";
import "./btcDepositsTemplate.sol";

contract SelectiveDepositSuiteEight is BTCSelectiveDepositTemplate, DSTest {

    function setUp() public {

        s = getShellSuiteEight();

    }

    function test_s8_noSlippage_balanced_15mWBTC_12mRenBTC_3mSBTC() public {

        emit log_named_address("this", address(this));

        uint wbtcBal = wBTC.balanceOf(address(this));
        uint sbtcBal = sBTC.balanceOf(address(this));
        uint renBal = renBTC.balanceOf(address(this));

        uint256 newShells = super.noSlippage_balanced_15mWBTC_12mRenBTC_3mSBTC();

        uint renBalAfter = renBTC.balanceOf(address(this));

        emit log_named_uint("ren bal before", renBal);
        emit log_named_uint("ren bal after", renBalAfter);

        assertEq(wBTC.balanceOf(address(this)), wbtcBal - .015e8);
        assertEq(sBTC.balanceOf(address(this)), sbtcBal - .003e18);
        assertEq(renBTC.balanceOf(address(this)), renBal - .012e8);

        assertEq(newShells, 0);

    }

}