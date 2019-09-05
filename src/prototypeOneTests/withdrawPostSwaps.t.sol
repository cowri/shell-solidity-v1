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
    uint256 shell1Liquidity;
    uint256 shell2Liquidity;

    function setUp () public {
        uint256 tokenAmount = 10000000000;
        uint8 decimalAmount = 18;
        TEST1 = new TOKEN("TEST ONE", "TEST1", decimalAmount, tokenAmount);
        TEST2 = new TOKEN("TEST TWO", "TEST2", decimalAmount, tokenAmount);
        TEST3 = new TOKEN("TEST THREE", "TEST3", decimalAmount, tokenAmount);

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

        shell1Liquidity = pool.depositLiquidity(shell1, 1000);
        shell2Liquidity = pool.depositLiquidity(shell2, 3000);

        pool.swap(address(TEST1), address(TEST2), 100);
        pool.swap(address(TEST2), address(TEST1), 100);
        pool.swap(address(TEST1), address(TEST3), 100);
        pool.swap(address(TEST3), address(TEST2), 100);

    }


    function testWithdrawPostSwap () public {

        uint256 shell1Token1 = pool.getShellBalanceOf(shell1, address(TEST1));
        uint256 shell1Token2 = pool.getShellBalanceOf(shell1, address(TEST2));
        assertEq(shell1Token1, 999);
        assertEq(shell1Token2, 1000);

        uint256[] memory shell1Withdrawal = pool.withdrawLiquidity(shell1, 500);
        assertEq(shell1Withdrawal[0], 249);
        assertEq(shell1Withdrawal[1], 249);

        uint256 shell2Token1 = pool.getShellBalanceOf(shell2, address(TEST1));
        uint256 shell2Token2 = pool.getShellBalanceOf(shell2, address(TEST2));
        uint256 shell2Token3 = pool.getShellBalanceOf(shell2, address(TEST3));
        assertEq(shell2Token1, 3093);
        assertEq(shell2Token2, 2902);
        assertEq(shell2Token3, 3000);

        uint256[] memory shell2Withdrawal = pool.withdrawLiquidity(shell2, 1500);
        assertEq(shell2Withdrawal[0], 515);
        assertEq(shell2Withdrawal[1], 483);
        assertEq(shell2Withdrawal[2], 499);

    }

}