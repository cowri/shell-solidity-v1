pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../Prototype.sol";
import "../../ERC20Token.sol";
import "../../testSetup/setupShells.sol";

contract DappTest is DSTest, ShellSetup {

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


        setupPool();
        setupTokens();
        shell1 = setupShellAB();
        shell2 = setupShellABC();
        shell3 = setupShellABD();
        shell4 = setupShellABE();
        shell5 = setupShellABF();
        shell6 = setupShellABG();
        shell7 = setupShellABCD();
        shell8 = setupShellABDE();
        shell9 = setupShellABEF();
        shell10 = setupShellABCDE();
        shell11 = setupShellABDEF();
        shell12 = setupShellABEFG();
        shell13 = setupShellABCDEF();
        shell14 = setupShellABCDEFG();
        shell15 = setupShellABCDEFGH();
        shell16 = setupShellABDEFGHI();
        shell17 = setupShellABCDEFGHI();

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

    }


    function testSwapByOriginAtoBWith17Shells () public {

        // assertEq(
            pool.swapByOrigin(100 * ( 10 ** 18 ), address(testA), address(testB));
            // 99750623441396508728
        // );

        // assertEq(
        //     pool.getShellBalanceOf(shell1, address(testA)),
        //     10025000000000000000000
        // );

        // assertEq(
        //     pool.getShellBalanceOf(shell2, address(testA)),
        //     30075000000000000000000
        // );

        // assertEq(
        //     pool.getShellBalanceOf(shell1, address(testB)),
        //     9975062344139650872818
        // );

        // assertEq(
        //     pool.getShellBalanceOf(shell2, address(testB)),
        //     29925187032418952618454
        // );

    }

}