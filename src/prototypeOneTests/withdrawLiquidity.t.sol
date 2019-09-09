pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";

import "../PrototypeOne.sol";
import "../Shell.sol";
import "../TOKEN.sol";

contract DappTest is DSTest, DSMath{
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
        uint256 tokenAmount = 1000000000 * (10 ** 18);
        TEST1 = new TOKEN("TEST ONE", "TEST1", 18, tokenAmount);
        TEST2 = new TOKEN("TEST TWO", "TEST2", 16, tokenAmount);
        TEST3 = new TOKEN("TEST THREE", "TEST3", 14, tokenAmount);
        TEST4 = new TOKEN("TEST FOUR", "TEST4", 12, tokenAmount);
        TEST5 = new TOKEN("TEST FIVE", "TEST5", 10, tokenAmount);
        TEST6 = new TOKEN("TEST SIX", "TEST6", 8, tokenAmount);

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

        uint256 amountToStake = 5000 * (10 ** 18);
        shell1Liquidity = pool.depositLiquidity(shell1, amountToStake);
        shell2Liquidity = pool.depositLiquidity(shell2, amountToStake);
        shell3Liquidity = pool.depositLiquidity(shell3, amountToStake);
        shell4Liquidity = pool.depositLiquidity(shell4, amountToStake);
        shell5Liquidity = pool.depositLiquidity(shell5, amountToStake);

    }

    function testWithdrawLiquidity () public {

        uint256 amount = 100 * (10 ** 18);
        uint256[] memory shell1Withdraw1 = pool.withdrawLiquidity(address(shell1), amount);

        assertEq(shell1Withdraw1[0], amount/2);
        assertEq(shell1Withdraw1[1], (amount/2) / 100);

        // uint256[] memory shell1Withdraw2 = pool.withdrawLiquidity(address(shell1), amount);

        // assertEq(shell1Withdraw2[0], amount/2);
        // assertEq(shell1Withdraw2[1], (amount/2) / 100);

        // uint256[] memory shell1Withdraw3 = pool.withdrawLiquidity(address(shell1), amount);

        // assertEq(shell1Withdraw3[0], amount/2);
        // assertEq(shell1Withdraw3[1], (amount/2) / 100);

        // uint256[] memory shell1Withdraw4 = pool.withdrawLiquidity(address(shell1), amount);

        // assertEq(shell1Withdraw4[0], amount/2);
        // assertEq(shell1Withdraw4[1], (amount/2) / 100);
        // uint256[] memory shell1Withdraw5 = pool.withdrawLiquidity(address(shell1), amount);

        // assertEq(shell1Withdraw5[0], amount/2);
        // assertEq(shell1Withdraw5[1], (amount/2) / 100);
        // uint256[] memory shell1Withdraw6 = pool.withdrawLiquidity(address(shell1), amount);

        // assertEq(shell1Withdraw6[0], amount/2);
        // assertEq(shell1Withdraw6[1], (amount/2) / 100);
        uint256[] memory shell1Withdraw2 = pool.withdrawLiquidity(address(shell1), amount);

        assertEq(shell1Withdraw2[0], amount/2);
        assertEq(shell1Withdraw2[1], (amount/2) / 100);

        uint256[] memory shell1Withdraw3 = pool.withdrawLiquidity(address(shell1), amount);

        assertEq(shell1Withdraw3[0], amount/2);
        assertEq(shell1Withdraw3[1], (amount/2) / 100);

        uint256[] memory shell1Withdraw4 = pool.withdrawLiquidity(address(shell1), amount);

        assertEq(shell1Withdraw4[0], amount/2);
        assertEq(shell1Withdraw4[1], (amount/2) / 100);

        uint256[] memory shell2Withdraw1 = pool.withdrawLiquidity(address(shell2), amount);

        assertEq(shell2Withdraw1[0], amount/3);
        assertEq(shell2Withdraw1[1], (amount/3) / 100);
        assertEq(shell2Withdraw1[2], (amount/3) / 10000);

        uint256[] memory shell2Withdraw2 = pool.withdrawLiquidity(address(shell2), amount);

        assertEq(shell2Withdraw2[0], amount/3);
        assertEq(shell2Withdraw2[1], (amount/3) / 100);
        assertEq(shell2Withdraw2[2], (amount/3) / 10000);

        uint256[] memory shell2Withdraw3 = pool.withdrawLiquidity(address(shell2), amount);

        assertEq(shell2Withdraw3[0], amount/3);
        assertEq(shell2Withdraw3[1], (amount/3) / 100);
        assertEq(shell2Withdraw3[2], (amount/3) / 10000);

        uint256[] memory shell3Withdraw1 = pool.withdrawLiquidity(address(shell3), amount);

        assertEq(shell3Withdraw1[0], amount/4);
        assertEq(shell3Withdraw1[1], (amount/4) / 100);
        assertEq(shell3Withdraw1[2], (amount/4) / 10000);
        assertEq(shell3Withdraw1[3], (amount/4) / 1000000);

        uint256[] memory shell4Withdraw1 = pool.withdrawLiquidity(address(shell4), amount);

        assertEq(shell4Withdraw1[0], amount/5);
        assertEq(shell4Withdraw1[1], (amount/5) / 100);
        assertEq(shell4Withdraw1[2], (amount/5) / 10000);
        assertEq(shell4Withdraw1[3], (amount/5) / 1000000);
        assertEq(shell4Withdraw1[4], (amount/5) / 100000000);

        uint256[] memory shell5Withdraw1 = pool.withdrawLiquidity(address(shell5), amount);

        assertEq(shell5Withdraw1[0], wdiv(amount, 6 * WAD));
        assertEq(shell5Withdraw1[1], (amount/6) / 100);
        assertEq(shell5Withdraw1[2], (amount/6) / 10000);
        assertEq(shell5Withdraw1[3], (amount/6) / 1000000);
        assertEq(shell5Withdraw1[4], (amount/6) / 100000000);
        assertEq(shell5Withdraw1[5], (amount/6) / 10000000000);

    }

}