pragma solidity ^0.5.6;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "ds-test/test.sol";
import "ds-math/math.sol";
import "../loihiSetup.sol";

contract TestProportionalWithdraw is LoihiSetup, DSMath, DSTest {

    event log_uints(bytes32, uint256[]);

    function setUp() public {
        
        setupFlavors();
        setupAdapters();
        setupLoihi();
        approveFlavors(address(l));

        l.proportionalDeposit(300 * (10 ** 18));

    }

    function testproportionalWithdraw300 () public {

        uint256[] memory withdrawals = l.proportionalWithdraw(300 * WAD);
        assertEq(l.totalSupply(), 0);
        assertEq(withdrawals[0] / 10000000000, 9994999999);
        assertEq(withdrawals[1], 99949998);
        assertEq(withdrawals[2], 99949999);

    }

    function testProportionalWithdraw150 () public {

        uint256[] memory withdrawals = l.proportionalWithdraw(150 * WAD);
        assertEq(l.totalSupply(), 150000000000000000000);
        assertEq(withdrawals[0] / 10000000000, 4997499999);
        assertEq(withdrawals[1], 49974999);
        assertEq(withdrawals[2], 49974999);

    }

}