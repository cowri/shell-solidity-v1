pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "./testGas.sol";

contract DappTest is DSTest {
    TestGas gasTest;

    function setup () public {
        gasTest = new TestGas();
    }

    function testMappingAddressStorage () public {
        address shell = gasTest.testMappingAddress();
    }

    function testMappingShellStorage () public {
        Shell shell = gasTest.testMappingShell();
    }

}
