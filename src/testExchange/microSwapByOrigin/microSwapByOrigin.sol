pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../testSetup/setupShells.sol";

contract DappTest is DSTest, ShellSetup {

    address shell1;
    uint256 shell1Liquidity;

    function setUp () public {

        setupPool();
        setupTokens();
        shell1 = setupShellAB();
        shell1Liquidity = pool.depositLiquidity(shell1, 10000 * ( 10 ** 18), now + 50);
        pool.activateShell(shell1);

    }


    function testMicroSwapByOrigin () public {

        assertEq(
            pool.swapByOrigin(
                address(shell1),
                address(testA),
                address(testB),
                100 * ( 10 ** 18 ),
                50 * ( 10 ** 18 ),
                now + 50
            ),
            9783738115554804744
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
