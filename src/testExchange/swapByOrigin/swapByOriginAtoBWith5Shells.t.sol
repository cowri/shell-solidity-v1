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
    uint256 shell1Liquidity;
    uint256 shell2Liquidity;
    uint256 shell3Liquidity;
    uint256 shell4Liquidity;
    uint256 shell5Liquidity;

    function setUp () public {

        setupPool();
        setupTokens();
        shell1 = setupShellAB();
        shell2 = setupShellABC();
        shell3 = setupShellABD();
        shell4 = setupShellABE();
        shell5 = setupShellABF();

        uint256 amount = 10000 * (10 ** 18);
        uint256 deadline = now + 50;

        shell1Liquidity = pool.depositLiquidity(shell1, amount, deadline);
        shell2Liquidity = pool.depositLiquidity(shell2, amount, deadline);
        shell3Liquidity = pool.depositLiquidity(shell3, amount, deadline);
        shell4Liquidity = pool.depositLiquidity(shell4, amount, deadline);
        shell5Liquidity = pool.depositLiquidity(shell5, amount, deadline);

        pool.activateShell(shell1);
        pool.activateShell(shell2);
        pool.activateShell(shell3);
        pool.activateShell(shell4);
        pool.activateShell(shell5);

    }


    function testSwapByOriginAtoBWith5Shells () public {

        uint256 amount = 100 * ( 10 ** 18 );
        uint256 deadline = now + 50;
        assertEq(
            pool.swapByOrigin(address(testA), address(testB), amount, amount / 2, deadline),
            9924979423897618265
        );

        assertEq(
            pool.getShellBalanceOf(shell1, address(testA)),
            5027270000000000000000
        );

        assertEq(
            pool.getShellBalanceOf(shell2, address(testA)),
            3351513333333333333333
        );

        assertEq(
            pool.getShellBalanceOf(shell1, address(testB)),
            4972931874298461041095
        );

        assertEq(
            pool.getShellBalanceOf(shell2, address(testB)),
            3315287916198974027396
        );

    }

}