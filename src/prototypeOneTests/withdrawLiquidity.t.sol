pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../PrototypeOne.sol";
import "../Shell.sol";
import "../TOKEN.sol";

contract DappTest is DSTest {
    PrototypeOne pool;
    address shell1;
    address shell2;
    address shell3; 
    address shell4; 
    address shell5;
    address shell6;
    uint256 shell1Liquidity;
    uint256 shell2Liquidity;
    uint256 shell3Liquidity; 
    uint256 shell4Liquidity; 
    uint256 shell5Liquidity; 
    uint256 shell6Liquidity; 
    TOKEN TEST1;
    TOKEN TEST2;
    TOKEN TEST3;
    TOKEN TEST4;
    TOKEN TEST5;
    TOKEN TEST6;

    function setUp() public {
        uint256 tokenAmount = 100000;
        uint8 decimalAmount = 18;
        TEST1 = new TOKEN("TEST ONE", "TEST1", decimalAmount, tokenAmount);
        TEST2 = new TOKEN("TEST TWO", "TEST2", decimalAmount, tokenAmount);
        TEST3 = new TOKEN("TEST THREE", "TEST3", decimalAmount, tokenAmount);

        TEST4 = new TOKEN("TEST ONE", "TEST1", decimalAmount, tokenAmount);
        TEST5 = new TOKEN("TEST TWO", "TEST2", decimalAmount, tokenAmount);
        TEST6 = new TOKEN("TEST THREE", "TEST3", decimalAmount, tokenAmount);

        pool = new PrototypeOne();

        TEST1.approve(address(pool), tokenAmount);
        TEST2.approve(address(pool), tokenAmount);
        TEST3.approve(address(pool), tokenAmount);
        TEST4.approve(address(pool), tokenAmount);
        TEST5.approve(address(pool), tokenAmount);
        TEST6.approve(address(pool), tokenAmount);

        address[] memory shell1Addrs = new address[](2);
        shell1Addrs[0] = address(TEST1);
        shell1Addrs[1] = address(TEST2);
        shell1 = pool.createShell(shell1Addrs);

        address[] memory shell2Addrs = new address[](3);
        shell2Addrs[0] = address(TEST1);
        shell2Addrs[1] = address(TEST2);
        shell2Addrs[2] = address(TEST3);
        shell2 = pool.createShell(shell2Addrs);

        address[] memory shell3Addrs = new address[](4);
        shell3Addrs[0] = address(TEST1);
        shell3Addrs[1] = address(TEST2);
        shell3Addrs[2] = address(TEST3);
        shell3Addrs[3] = address(TEST4);
        shell3 = pool.createShell(shell3Addrs);

        address[] memory shell4Addrs = new address[](5);
        shell4Addrs[0] = address(TEST1);
        shell4Addrs[1] = address(TEST2);
        shell4Addrs[2] = address(TEST3);
        shell4Addrs[3] = address(TEST4);
        shell4Addrs[4] = address(TEST5);
        shell4 = pool.createShell(shell4Addrs);

        address[] memory shell5Addrs = new address[](6);
        shell5Addrs[0] = address(TEST1);
        shell5Addrs[1] = address(TEST2);
        shell5Addrs[2] = address(TEST3);
        shell5Addrs[3] = address(TEST4);
        shell5Addrs[4] = address(TEST5);
        shell5Addrs[5] = address(TEST6);
        shell5 = pool.createShell(shell5Addrs);

        shell1Liquidity = pool.depositLiquidity(shell1, 500);
        shell2Liquidity = pool.depositLiquidity(shell2, 500);
        shell3Liquidity = pool.depositLiquidity(shell3, 500);
        shell4Liquidity = pool.depositLiquidity(shell4, 500);
        shell5Liquidity = pool.depositLiquidity(shell5, 500);

    }

    function testWithdrawLiquidity () public {

        uint256[] memory shell1Withdraw1 = pool.withdrawLiquidity(address(shell1), 500);

        assertEq(shell1Withdraw1[0], 250);
        assertEq(shell1Withdraw1[1], 250);

        uint256[] memory shell1Withdraw2 = pool.withdrawLiquidity(address(shell1), 100);

        assertEq(shell1Withdraw2[0], 50);
        assertEq(shell1Withdraw2[1], 50);

        uint256[] memory shell2Withdraw1 = pool.withdrawLiquidity(address(shell2), 500);

        assertEq(shell2Withdraw1[0], 166);
        assertEq(shell2Withdraw1[1], 166);
        assertEq(shell2Withdraw1[2], 166);

        uint256[] memory shell2Withdraw2 = pool.withdrawLiquidity(address(shell2), 333);

        assertEq(shell2Withdraw2[0], 111);
        assertEq(shell2Withdraw2[1], 111);
        assertEq(shell2Withdraw2[2], 111);

        uint256[] memory shell3Withdraw1 = pool.withdrawLiquidity(address(shell3), 500);

        assertEq(shell3Withdraw1[0], 125);
        assertEq(shell3Withdraw1[1], 125);
        assertEq(shell3Withdraw1[2], 125);
        assertEq(shell3Withdraw1[3], 125);

        uint256[] memory shell4Withdraw1 = pool.withdrawLiquidity(address(shell4), 500);

        assertEq(shell4Withdraw1[0], 100);
        assertEq(shell4Withdraw1[1], 100);
        assertEq(shell4Withdraw1[2], 100);
        assertEq(shell4Withdraw1[3], 100);
        assertEq(shell4Withdraw1[4], 100);

        uint256[] memory shell5Withdraw1 = pool.withdrawLiquidity(address(shell5), 500);

        assertEq(shell5Withdraw1[0], 83);
        assertEq(shell5Withdraw1[1], 83);
        assertEq(shell5Withdraw1[2], 83);
        assertEq(shell5Withdraw1[3], 83);
        assertEq(shell5Withdraw1[4], 83);
        assertEq(shell5Withdraw1[5], 83);

    }

}