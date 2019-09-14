pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../Prototype.sol";
import "../Shell.sol";
import "../TOKEN.sol";

contract DappTest is DSTest {

    Prototype pool;
    address shell1;
    address shell2;
    TOKEN TEST1;
    TOKEN TEST2;
    TOKEN TEST3;
    uint256 shell1Liquidity;
    uint256 shell2Liquidity;

    function setUp () public {
        uint256 tokenAmount = 10000000000 * (10 ** 18);
        uint8 decimalAmount = 18;
        TEST1 = new TOKEN("TEST ONE", "TEST1", decimalAmount, tokenAmount);
        TEST2 = new TOKEN("TEST TWO", "TEST2", decimalAmount, tokenAmount);
        TEST3 = new TOKEN("TEST THREE", "TEST3", decimalAmount, tokenAmount);

        pool = new Prototype();

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

        shell1Liquidity = pool.depositLiquidity(shell1, 10000 * ( 10 ** 18));
        shell2Liquidity = pool.depositLiquidity(shell2, 30000 * ( 10 ** 18));

        pool.activateShell(shell1);
        pool.activateShell(shell2);

    }


    function testSwapByTarget () public {

        uint256 swapAmount = 100 * ( 10 ** 18 );

        uint256 swap1 = pool.swapByTarget(swapAmount, address(TEST1), address(TEST2));
        assertEq(swap1, 100250626566416040100);

        uint256 swap2 = pool.swapByTarget(swapAmount, address(TEST2), address(TEST1));
        assertEq(swap2, 99749375003916015564);

        uint256 swap3 = pool.swapByTarget(swapAmount, address(TEST1), address(TEST3));
        assertEq(swap3, 100335076822491010134);

        uint256 swap4 = pool.swapByTarget(swapAmount, address(TEST3), address(TEST2));
        assertEq(swap4, 100000628661969066939);

    }

}