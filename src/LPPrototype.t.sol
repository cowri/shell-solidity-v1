pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "./Dapp.sol";

contract DappTest is DSTest {
    Dapp dapp;

    function setUp() public {
        dapp = new Dapp();
    }

    function testSet() public {
        dapp.setNum(10);
        assertTrue(dapp.getNum() == 10);
    }

    function testConstructor() public {
        assertTrue(dapp.getNum() == 5);
    }
}
