pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../Prototype.sol";
import "../../ERC20Token.sol";

contract DappTest is DSTest {

    Prototype pool;
    address shell1;
    address shell2;
    address shell3;
    address shell4;
    address shell5;
    address shell6;
    address shell7;
    address shell8;
    address shell9;
    address shell10;
    address shell11;
    address shell12;
    address shell13;
    address shell14;
    address shell15;
    address shell16;
    address shell17;
    ERC20Token TEST1;
    ERC20Token TEST2;
    ERC20Token TEST3;
    ERC20Token TEST4;
    ERC20Token TEST5;
    ERC20Token TEST6;
    ERC20Token TEST7;
    ERC20Token TEST8;
    ERC20Token TEST9;
    ERC20Token TEST10;
    ERC20Token TEST11;
    ERC20Token TEST12;
    ERC20Token TEST13;
    ERC20Token TEST14;
    ERC20Token TEST15;
    ERC20Token TEST16;
    ERC20Token TEST17;
    ERC20Token TEST18;
    uint256 shell1Liquidity;
    uint256 shell2Liquidity;
    uint256 shell3Liquidity;
    uint256 shell4Liquidity;
    uint256 shell5Liquidity;
    uint256 shell6Liquidity;
    uint256 shell7Liquidity;
    uint256 shell8Liquidity;
    uint256 shell9Liquidity;
    uint256 shell10Liquidity;
    uint256 shell11Liquidity;
    uint256 shell12Liquidity;
    uint256 shell13Liquidity;
    uint256 shell14Liquidity;
    uint256 shell15Liquidity;
    uint256 shell16Liquidity;
    uint256 shell17Liquidity;

    function setUp () public {
        uint256 tokenAmount = 10000000000 * (10 ** 18);
        uint8 decimalAmount = 18;
        TEST1 = new ERC20Token("TEST ONE", "TEST1", decimalAmount, tokenAmount);
        TEST2 = new ERC20Token("TEST TWO", "TEST2", decimalAmount, tokenAmount);
        TEST3 = new ERC20Token("TEST THREE", "TEST3", decimalAmount, tokenAmount);
        TEST4 = new ERC20Token("TEST ONE", "TEST1", decimalAmount, tokenAmount);
        TEST5 = new ERC20Token("TEST ONE", "TEST1", decimalAmount, tokenAmount);
        TEST6 = new ERC20Token("TEST ONE", "TEST1", decimalAmount, tokenAmount);
        TEST7 = new ERC20Token("TEST TWO", "TEST2", decimalAmount, tokenAmount);
        TEST8 = new ERC20Token("TEST THREE", "TEST3", decimalAmount, tokenAmount);
        TEST9 = new ERC20Token("TEST TWO", "TEST2", decimalAmount, tokenAmount);
        TEST10 = new ERC20Token("TEST THREE", "TEST3", decimalAmount, tokenAmount);
        TEST11 = new ERC20Token("TEST TWO", "TEST2", decimalAmount, tokenAmount);
        TEST12 = new ERC20Token("TEST THREE", "TEST3", decimalAmount, tokenAmount);
        TEST13 = new ERC20Token("TEST THREE", "TEST3", decimalAmount, tokenAmount);
        TEST14 = new ERC20Token("TEST TWO", "TEST2", decimalAmount, tokenAmount);
        TEST15 = new ERC20Token("TEST THREE", "TEST3", decimalAmount, tokenAmount);
        TEST16 = new ERC20Token("TEST THREE", "TEST3", decimalAmount, tokenAmount);
        TEST17 = new ERC20Token("TEST TWO", "TEST2", decimalAmount, tokenAmount);
        TEST18 = new ERC20Token("TEST THREE", "TEST3", decimalAmount, tokenAmount);

        pool = new Prototype();

        TEST1.approve(address(pool), tokenAmount);
        TEST2.approve(address(pool), tokenAmount);
        TEST3.approve(address(pool), tokenAmount);
        TEST4.approve(address(pool), tokenAmount);
        TEST5.approve(address(pool), tokenAmount);
        TEST6.approve(address(pool), tokenAmount);
        TEST7.approve(address(pool), tokenAmount);
        TEST8.approve(address(pool), tokenAmount);
        TEST9.approve(address(pool), tokenAmount);
        TEST10.approve(address(pool), tokenAmount);
        TEST11.approve(address(pool), tokenAmount);
        TEST12.approve(address(pool), tokenAmount);
        TEST13.approve(address(pool), tokenAmount);
        TEST14.approve(address(pool), tokenAmount);
        TEST15.approve(address(pool), tokenAmount);
        TEST16.approve(address(pool), tokenAmount);
        TEST17.approve(address(pool), tokenAmount);
        TEST18.approve(address(pool), tokenAmount);

        address[] memory shell1Addrs = new address[](2);
        shell1Addrs[0] = address(TEST1);
        shell1Addrs[1] = address(TEST2);
        shell1 = pool.createShell(shell1Addrs);

        address[] memory shell2Addrs = new address[](3);
        shell2Addrs[0] = address(TEST1);
        shell2Addrs[1] = address(TEST2);
        shell2Addrs[2] = address(TEST3);
        shell2 = pool.createShell(shell2Addrs);

        address[] memory shell3Addrs = new address[](3);
        shell3Addrs[0] = address(TEST1);
        shell3Addrs[1] = address(TEST2);
        shell3Addrs[2] = address(TEST4);
        shell3 = pool.createShell(shell3Addrs);

        address[] memory shell4Addrs = new address[](3);
        shell4Addrs[0] = address(TEST1);
        shell4Addrs[1] = address(TEST2);
        shell4Addrs[2] = address(TEST5);
        shell4 = pool.createShell(shell4Addrs);

        address[] memory shell5Addrs = new address[](3);
        shell5Addrs[0] = address(TEST1);
        shell5Addrs[1] = address(TEST2);
        shell5Addrs[2] = address(TEST6);
        shell5 = pool.createShell(shell5Addrs);

        address[] memory shell6Addrs = new address[](3);
        shell6Addrs[0] = address(TEST1);
        shell6Addrs[1] = address(TEST2);
        shell6Addrs[2] = address(TEST7);
        shell6 = pool.createShell(shell6Addrs);

        address[] memory shell7Addrs = new address[](3);
        shell7Addrs[0] = address(TEST1);
        shell7Addrs[1] = address(TEST2);
        shell7Addrs[2] = address(TEST8);
        shell7 = pool.createShell(shell7Addrs);

        address[] memory shell8Addrs = new address[](3);
        shell8Addrs[0] = address(TEST1);
        shell8Addrs[1] = address(TEST2);
        shell8Addrs[2] = address(TEST9);
        shell8 = pool.createShell(shell8Addrs);

        address[] memory shell9Addrs = new address[](3);
        shell9Addrs[0] = address(TEST1);
        shell9Addrs[1] = address(TEST2);
        shell9Addrs[2] = address(TEST10);
        shell9 = pool.createShell(shell9Addrs);

        address[] memory shell10Addrs = new address[](3);
        shell10Addrs[0] = address(TEST1);
        shell10Addrs[1] = address(TEST2);
        shell10Addrs[2] = address(TEST11);
        shell10 = pool.createShell(shell10Addrs);

        address[] memory shell11Addrs = new address[](3);
        shell11Addrs[0] = address(TEST1);
        shell11Addrs[1] = address(TEST2);
        shell11Addrs[2] = address(TEST12);
        shell11 = pool.createShell(shell11Addrs);

        address[] memory shell12Addrs = new address[](3);
        shell12Addrs[0] = address(TEST1);
        shell12Addrs[1] = address(TEST2);
        shell12Addrs[2] = address(TEST13);
        shell12 = pool.createShell(shell12Addrs);

        address[] memory shell13Addrs = new address[](3);
        shell13Addrs[0] = address(TEST1);
        shell13Addrs[1] = address(TEST2);
        shell13Addrs[2] = address(TEST14);
        shell13 = pool.createShell(shell13Addrs);

        address[] memory shell14Addrs = new address[](3);
        shell14Addrs[0] = address(TEST1);
        shell14Addrs[1] = address(TEST2);
        shell14Addrs[2] = address(TEST15);
        shell14 = pool.createShell(shell14Addrs);

        address[] memory shell15Addrs = new address[](3);
        shell15Addrs[0] = address(TEST1);
        shell15Addrs[1] = address(TEST2);
        shell15Addrs[2] = address(TEST16);
        shell15 = pool.createShell(shell15Addrs);

        address[] memory shell16Addrs = new address[](3);
        shell16Addrs[0] = address(TEST1);
        shell16Addrs[1] = address(TEST2);
        shell16Addrs[2] = address(TEST17);
        shell16 = pool.createShell(shell16Addrs);

        address[] memory shell17Addrs = new address[](3);
        shell17Addrs[0] = address(TEST1);
        shell17Addrs[1] = address(TEST2);
        shell17Addrs[2] = address(TEST18);
        shell17 = pool.createShell(shell17Addrs);

        shell1Liquidity = pool.depositLiquidity(shell1, 10000 * ( 10 ** 18));
        shell2Liquidity = pool.depositLiquidity(shell2, 30000 * ( 10 ** 18));
        shell3Liquidity = pool.depositLiquidity(shell3, 30000 * ( 10 ** 18));
        shell4Liquidity = pool.depositLiquidity(shell4, 30000 * ( 10 ** 18));
        shell5Liquidity = pool.depositLiquidity(shell5, 30000 * ( 10 ** 18));
        shell6Liquidity = pool.depositLiquidity(shell6, 30000 * ( 10 ** 18));
        shell7Liquidity = pool.depositLiquidity(shell7, 30000 * ( 10 ** 18));
        shell8Liquidity = pool.depositLiquidity(shell8, 30000 * ( 10 ** 18));
        shell9Liquidity = pool.depositLiquidity(shell9, 30000 * ( 10 ** 18));
        shell10Liquidity = pool.depositLiquidity(shell10, 30000 * ( 10 ** 18));
        shell11Liquidity = pool.depositLiquidity(shell11, 30000 * ( 10 ** 18));
        shell12Liquidity = pool.depositLiquidity(shell12, 30000 * ( 10 ** 18));
        shell13Liquidity = pool.depositLiquidity(shell13, 30000 * ( 10 ** 18));
        shell14Liquidity = pool.depositLiquidity(shell14, 30000 * ( 10 ** 18));
        shell15Liquidity = pool.depositLiquidity(shell15, 30000 * ( 10 ** 18));
        shell16Liquidity = pool.depositLiquidity(shell16, 30000 * ( 10 ** 18));
        shell17Liquidity = pool.depositLiquidity(shell17, 30000 * ( 10 ** 18));

        pool.activateShell(shell1);
        pool.activateShell(shell2);
        pool.activateShell(shell3);
        pool.activateShell(shell4);
        pool.activateShell(shell5);
        pool.activateShell(shell6);
        pool.activateShell(shell7);
        pool.activateShell(shell8);
        pool.activateShell(shell9);
        pool.activateShell(shell10);
        pool.activateShell(shell11);
        pool.activateShell(shell12);
        pool.activateShell(shell13);
        pool.activateShell(shell14);
        pool.activateShell(shell15);
        pool.activateShell(shell16);
        pool.activateShell(shell17);

    }


    function testSwapByOriginAtoBWith17Shells () public {

        // assertEq(
            pool.swapByOrigin(100 * ( 10 ** 18 ), address(TEST1), address(TEST2));
            // 99750623441396508728
        // );

        // assertEq(
        //     pool.getShellBalanceOf(shell1, address(TEST1)),
        //     10025000000000000000000
        // );

        // assertEq(
        //     pool.getShellBalanceOf(shell2, address(TEST1)),
        //     30075000000000000000000
        // );

        // assertEq(
        //     pool.getShellBalanceOf(shell1, address(TEST2)),
        //     9975062344139650872818
        // );

        // assertEq(
        //     pool.getShellBalanceOf(shell2, address(TEST2)),
        //     29925187032418952618454
        // );

    }

}