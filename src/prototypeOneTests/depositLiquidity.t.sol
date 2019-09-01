
pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../PrototypeOne.sol";
import "../Shell.sol";
import "../TOKEN.sol";

contract DappTest is DSTest {
    PrototypeOne pool;
    address shell1;
    address shell2;
    TOKEN TEST1;
    TOKEN TEST2;
    TOKEN TEST3;

    function setUp() public {
        uint256 tokenAmount = 1000;
        uint8 decimalAmount = 18;
        TEST1 = new TOKEN("TEST ONE", "TEST1", decimalAmount, tokenAmount);
        TEST2 = new TOKEN("TEST TWO", "TEST2", decimalAmount, tokenAmount);
        TEST3 = new TOKEN("TEST THREE", "TEST3", decimalAmount, tokenAmount);

        address[] memory addrs = new address[](3);
        addrs[0] = address(TEST1);
        addrs[1] = address(TEST2);
        addrs[2] = address(TEST2);

        pool = new PrototypeOne();

        TEST1.approve(address(pool), tokenAmount);
        TEST2.approve(address(pool), tokenAmount);
        TEST3.approve(address(pool), tokenAmount);

        address[] memory shell1Addrs = new address[](2);
        shell1Addrs[0] = address(TEST1);
        shell1Addrs[1] = address(TEST2);
        shell1 = pool.createShell(shell1Addrs);

        address[] memory shell2Addrs = new address[](3);
        shell2Addrs[0] = address(TEST1);
        shell2Addrs[1] = address(TEST2);
        shell2Addrs[2] = address(TEST3);
        shell2 = pool.createShell(shell2Addrs);

    }

    function testAddLiquidity () public {

        uint256 amount1 = pool.depositLiquidity(shell1, 500);
        uint256 balance1 = Shell(shell1).balanceOf(address(this));
        assertEq(balance1, 1000);
        assertEq(amount1, 1000);

        uint256 amount2 = pool.depositLiquidity(shell2, 500);
        uint256 balance2 = Shell(shell2).balanceOf(address(this));
        assertEq(balance2, 1500);
        assertEq(amount2, 1500);

    }

}