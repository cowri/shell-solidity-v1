
pragma solidity ^0.5.0;

import "ds-test/test.sol";

import "../setup/setup.sol";

contract MiscSuiteOneTest is Setup, DSTest {

    function setUp() public {

        l = getLoihiSuiteOne();

    }

    function testLiquidity () public {

        l.proportionalDeposit(300e18, 1e50);

        ( uint liquidity, uint[] memory liquidities ) = l.liquidity();

    }

}