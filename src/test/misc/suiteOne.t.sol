
pragma solidity ^0.5.0;

import "ds-test/test.sol";

import "../../Shell.sol";

import "../setup/setup.sol";

contract MiscSuiteOneTest is Setup, DSTest {

    Shell s;

    function setUp() public {

        s = getShellSuiteOne();

    }

    function testLiquidity () public {

        s.proportionalDeposit(300e18, 1e50);

        ( uint liquidity, uint[] memory liquidities ) = s.liquidity();

    }

}