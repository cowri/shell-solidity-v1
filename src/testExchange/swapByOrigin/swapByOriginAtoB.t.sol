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
        shell1 = setup2TokenShell();
        shell2 = setup3TokenShell();

        shell1Liquidity = pool.depositLiquidity(shell1, 10000 * ( 10 ** 18));
        shell2Liquidity = pool.depositLiquidity(shell2, 30000 * ( 10 ** 18));

        pool.activateShell(shell1);
        pool.activateShell(shell2);

    }


    function testSwapByOriginAtoB () public {

        assertEq(
            pool.swapByOrigin(100 * ( 10 ** 18 ), address(TEST1), address(TEST2)),
            99750623441396508728
        );

        assertEq(
            pool.getShellBalanceOf(shell1, address(TEST1)),
            10025000000000000000000
        );

        assertEq(
            pool.getShellBalanceOf(shell2, address(TEST1)),
            30075000000000000000000
        );

        assertEq(
            pool.getShellBalanceOf(shell1, address(TEST2)),
            9975062344139650872818
        );

        assertEq(
            pool.getShellBalanceOf(shell2, address(TEST2)),
            29925187032418952618454
        );

    }

}