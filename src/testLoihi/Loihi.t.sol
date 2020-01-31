pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../Loihi.sol";

contract LoihiTest is DSMath, DSTest {
    Loihi l;

    function setUp() public {
        l = new Loihi();
    }

    function testDelegate () public {
        sandbox.testDelegate();
    }

}