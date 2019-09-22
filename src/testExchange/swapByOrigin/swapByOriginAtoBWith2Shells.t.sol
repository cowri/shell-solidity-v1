pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../Prototype.sol";
import "../../ERC20Token.sol";
import "../../testSetup/setupShells.sol";

contract DappTest is DSTest, ShellSetup {
    address shell1;
    address shell2;
    uint256 shell1Liquidity;
    uint256 shell2Liquidity;

    function setUp () public {

        setupPool();
        setupTokens();
        shell1 = setupShellAB();
        shell2 = setupShellABC();

        shell1Liquidity = pool.depositLiquidity(shell1, 10000 * ( 10 ** 18));
        shell2Liquidity = pool.depositLiquidity(shell2, 30000 * ( 10 ** 18));

        pool.activateShell(shell1);
        pool.activateShell(shell2);

    }


    function testSwapByOriginAtoBWith2Shells () public {

        assertEq(
            pool.swapByOrigin(100 * ( 10 ** 18 ), address(testA), address(testB)),
            9933774834437086092
        );

        assertEq(
            pool.getShellBalanceOf(shell1, address(testA)),
            5033333333333333333333
        );

        assertEq(
            pool.getShellBalanceOf(shell2, address(testA)),
            10066666666666666666667
        );

        assertEq(
            pool.getShellBalanceOf(shell1, address(testB)),
            4966887417218543046358
        );

        assertEq(
            pool.getShellBalanceOf(shell2, address(testB)),
            9933774834437086092715
        );

    }

}