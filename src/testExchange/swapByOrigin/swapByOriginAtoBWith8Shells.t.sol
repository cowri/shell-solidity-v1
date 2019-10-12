pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../CowriPool.sol";
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
    uint256 shell1Liquidity;
    uint256 shell2Liquidity;
    uint256 shell3Liquidity;
    uint256 shell4Liquidity;
    uint256 shell5Liquidity;
    uint256 shell6Liquidity;
    uint256 shell7Liquidity;
    uint256 shell8Liquidity;

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

        uint256 amount = 10000 * ( 10 ** 18 );
        uint256 deadline = now + 50;

        shell1Liquidity = pool.depositLiquidity(shell1, amount, deadline);
        shell2Liquidity = pool.depositLiquidity(shell2, amount, deadline);
        shell3Liquidity = pool.depositLiquidity(shell3, amount, deadline);
        shell4Liquidity = pool.depositLiquidity(shell4, amount, deadline);
        shell5Liquidity = pool.depositLiquidity(shell5, amount, deadline);
        shell6Liquidity = pool.depositLiquidity(shell6, amount, deadline);
        shell7Liquidity = pool.depositLiquidity(shell7, amount, deadline);
        shell8Liquidity = pool.depositLiquidity(shell8, amount, deadline);

        pool.activateShell(shell1);
        pool.activateShell(shell2);
        pool.activateShell(shell3);
        pool.activateShell(shell4);
        pool.activateShell(shell5);
        pool.activateShell(shell6);
        pool.activateShell(shell7);
        pool.activateShell(shell8);

    }


    function testSwapByOriginAtoBWith8Shells () public {

        uint256 amount = 100 * ( 10 ** 18 );
        uint256 deadline = now + 50;
        // assertEq(
            pool.swapByOrigin(address(testA), address(testB), amount, amount / 2, deadline);
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