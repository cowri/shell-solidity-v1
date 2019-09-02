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

    }


    function testSwap () public {

        uint256 balanceOrigin1;
        uint256 balanceOrigin2;
        uint256 balanceTarget1;
        uint256 balanceTarget2;

        uint256 swap1 = pool.swap(address(TEST1), address(TEST2), 100);
        assertEq(swap1, 98);
        balanceOrigin1 = pool.getShellBalanceOf(shell1, address(TEST1));
        balanceOrigin2 = pool.getShellBalanceOf(shell2, address(TEST1));
        balanceTarget1 = pool.getShellBalanceOf(shell1, address(TEST2));
        balanceTarget2 = pool.getShellBalanceOf(shell2, address(TEST2));
        assertEq(balanceOrigin1, 1024);
        assertEq(balanceOrigin2, 3073);
        assertEq(balanceTarget1, 975);
        assertEq(balanceTarget2, 2926);

        uint256 swap2 = pool.swap(address(TEST2), address(TEST1), 100);
        assertEq(swap2, 102);
        balanceOrigin1 = pool.getShellBalanceOf(shell1, address(TEST2));
        balanceOrigin2 = pool.getShellBalanceOf(shell2, address(TEST2));
        balanceTarget1 = pool.getShellBalanceOf(shell1, address(TEST1));
        balanceTarget2 = pool.getShellBalanceOf(shell2, address(TEST1));
        assertEq(balanceOrigin1, 999);
        assertEq(balanceOrigin2, 2999);
        assertEq(balanceTarget1, 999);
        assertEq(balanceTarget2, 2996);

        uint256 swap3 = pool.swap(address(TEST1), address(TEST3), 100);
        assertEq(swap3, 97);
        balanceOrigin1 = pool.getShellBalanceOf(shell2, address(TEST1));
        balanceTarget1 = pool.getShellBalanceOf(shell2, address(TEST3));
        assertEq(balanceOrigin1, 3093);
        assertEq(balanceTarget1, 2903);

        uint256 swap4 = pool.swap(address(TEST3), address(TEST2), 100);
        assertEq(swap4, 100);
        balanceOrigin1 = pool.getShellBalanceOf(shell2, address(TEST3));
        balanceTarget1 = pool.getShellBalanceOf(shell2, address(TEST2));
        assertEq(balanceOrigin1, 3000);
        assertEq(balanceTarget1, 2899);

    }



}