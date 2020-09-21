
pragma solidity ^0.5.0;

import "ds-test/test.sol";

import "./partitionedTemplate.sol";

contract PartitionedWithdrawSuiteOne is PartitionedLiquidityTemplate, DSTest {

    function setUp() public {

        s = getShellSuiteOne();

    }

    event log_bool(bytes32, bool);
    event log_uints(bytes32, uint[]);

    function test_s1_partitioned_from_proportional_state () public {

        uint[] memory _withdraws = super.from_proportional_state();

        assertEq(_withdraws[0], 29999999999999999998);

        uint[] memory _claims = s.viewPartitionClaims(address(this));

        assertEq(_claims[0], 200e18);
        assertEq(_claims[1], 300e18);
        assertEq(_claims[2], 300e18);
        assertEq(_claims[3], 300e18);

        uint daiBalance = dai.balanceOf(address(s));

        assertEq(daiBalance, 60000000000000000002);

    }

    function testFail_s1_partitioned_from_proportional_state_underflow () public {

        bool success = super.from_proprotional_state_underflow();

        assertTrue(success);

    }

    function test_s1_partitioned_from_slighty_unbalanced_state () public {

        uint[] memory _withdraws = super.from_slightly_unbalanced_state();

        assertEq(_withdraws[0], 3333333333333333330);

        assertEq(_withdraws[1], 266666);

        assertEq(_withdraws[2], 1499999);

        uint[] memory _claims = s.viewPartitionClaims(address(this));

        assertEq(_claims[0], 290000000000000000000);

        assertEq(_claims[1], 299000000000000000000);

        assertEq(_claims[2], 295000000000000000000);

        assertEq(_claims[3], 300000000000000000000);

    }

}
