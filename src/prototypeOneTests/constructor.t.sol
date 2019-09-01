pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../PrototypeOne.sol";
import "../Shell.sol";
import "../TOKEN.sol";

contract DappTest is DSTest {
    PrototypeOne pool;
    TOKEN TEST1;
    TOKEN TEST2;
    TOKEN TEST3;

    function setUp() public {
        TEST1 = new TOKEN("TEST ONE", "TEST1", 18, 500);
        TEST2 = new TOKEN("TEST TWO", "TEST2", 18, 500);
        TEST3 = new TOKEN("TEST THREE", "TEST3", 18, 500);

        address[] memory addrs = new address[](3);
        addrs[0] = address(TEST1);
        addrs[1] = address(TEST2);
        addrs[2] = address(TEST3);

        pool = new PrototypeOne();
        pool.__init__(addrs);

    }

    function testConstructor() public {
        address[] memory addrs = pool.getTokens();
        assertTrue(addrs.length == 3);

        TOKEN test1 = TOKEN(addrs[0]);
        TOKEN test2 = TOKEN(addrs[1]);
        TOKEN test3 = TOKEN(addrs[2]);

        assertTrue(keccak256(bytes(test1.symbol())) == keccak256('TEST1'));
        assertTrue(keccak256(bytes(test2.symbol())) == keccak256('TEST2'));
        assertTrue(keccak256(bytes(test3.symbol())) == keccak256('TEST3'));
        assertTrue(keccak256('TEST3') == keccak256('TEST3'));
    }

}