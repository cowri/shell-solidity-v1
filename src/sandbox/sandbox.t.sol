pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "./sandbox.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract SandboxTest is DSMath, DSTest {
    Sandbox sandbox;

    function setUp() public { sandbox = new Sandbox(); }

    function testERC () public {
        IERC20 i;

        bytes4 sig = i.totalSupply.selector
            ^ i.balanceOf.selector
            ^ i.transfer.selector
            ^ i.allowance.selector
            ^ i.approve.selector
            ^ i.transferFrom.selector;

        emit log_named_bytes32("sig", sig);

    }

}