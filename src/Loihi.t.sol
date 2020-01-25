pragma solidity ^0.5.12;

import "ds-test/test.sol";

import "./Loihi.sol";

contract LoihiTest is DSTest {
    Loihi loihi;

    function setUp() public {
        loihi = new Loihi();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
