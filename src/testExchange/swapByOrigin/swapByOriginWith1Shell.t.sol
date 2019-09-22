pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../Prototype.sol";
import "../../ERC20Token.sol";
import "../../testSetup/setupShells.sol";

contract DappTest is DSTest, ShellSetup {

    address shell1;
    uint256 shell1Liquidity;

    function setUp () public {

        setupPool();
        setupTokens();
        shell1 = setupShellAB();
        shell1Liquidity = pool.depositLiquidity(shell1, 10000 * ( 10 ** 18));
        pool.activateShell(shell1);

    }


    function testSwapByOriginAtoBWith1Shell () public {

        assertEq(
            pool.swapByOrigin(100 * ( 10 ** 18 ), address(testA), address(testB)),
            9803921568627450980
        );

        /* assertEq( */
        /*     pool.getShellBalanceOf(shell1, address(testA)), */
        /*     10025000000000000000000 */
        /* ); */
        /*  */
        /* assertEq( */
        /*     pool.getShellBalanceOf(shell2, address(testA)), */
        /*     30075000000000000000000 */
        /* ); */
        /*  */
        /* assertEq( */
        /*     pool.getShellBalanceOf(shell1, address(testB)), */
        /*     9975062344139650872818 */
        /* ); */
        /*  */
        /* assertEq( */
        /*     pool.getShellBalanceOf(shell2, address(testB)), */
        /*     29925187032418952618454 */
        /* ); */
        /*  */
    }

}
