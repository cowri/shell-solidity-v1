pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../loihiSetup.sol";

contract LoihiERC165Test is LoihiSetup, DSMath, DSTest {

    function setUp() public {
        setupFlavors();
        setupAdapters();
        setupLoihi();
    }

    function testSupportsERC165 () public {
        assert(l.supportsInterface(bytes4(0x36372b07)));
    }

    function testSupportsERC20 () public {
        assert(l.supportsInterface(bytes4(0x01ffc9a7)));
    }

}