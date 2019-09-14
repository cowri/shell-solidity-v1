pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "./sandbox.sol";

contract DappTest is DSMath, DSTest {
    Sandbox sandbox;

    function setUp() public {
        sandbox = new Sandbox();
    }

    // function testMe () public {
    // }

}