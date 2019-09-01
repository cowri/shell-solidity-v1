
pragma solidity ^0.5.6;

import "ds-test/test.sol";

contract DappTest is DSTest {
    event logMsgSender(bytes32,  address);

    function setUp() public {
        emit logMsgSender("msg.sender", msg.sender);
    }

    function testMsgSender() public {
        bool equals0 = msg.sender == address(0);
        assertTrue(!equals0);
    }

}