pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "./sandbox.sol";

contract DappTest is DSTest {
    Sandbox sandbox;

    function setUp() public {
        sandbox = new Sandbox();
    }

}
