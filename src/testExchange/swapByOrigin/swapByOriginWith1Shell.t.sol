pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../Prototype.sol";
import "../../ERC20Token.sol";

contract DappTest is DSTest {

    Prototype pool;
    address shell1;
    ERC20Token TEST1;
    ERC20Token TEST2;
    uint256 shell1Liquidity;

    function setUp () public {
        uint256 tokenAmount = 10000000000 * (10 ** 18);
        uint8 decimalAmount = 18;
        TEST1 = new ERC20Token("TEST ONE", "TEST1", decimalAmount, tokenAmount);
        TEST2 = new ERC20Token("TEST TWO", "TEST2", decimalAmount, tokenAmount);

        pool = new Prototype();

        TEST1.approve(address(pool), tokenAmount);
        TEST2.approve(address(pool), tokenAmount);

        address[] memory shell1Addrs = new address[](2);
        shell1Addrs[0] = address(TEST1);
        shell1Addrs[1] = address(TEST2);
        shell1 = pool.createShell(shell1Addrs);


        shell1Liquidity = pool.depositLiquidity(shell1, 10000 * ( 10 ** 18));

        pool.activateShell(shell1);

    }


    function testSwapByOriginAtoBWith1Shell () public {

        /* assertEq( */
            pool.swapByOrigin(100 * ( 10 ** 18 ), address(TEST1), address(TEST2));
            /* 99750623441396508728 */
        /* ); */

        /* assertEq( */
        /*     pool.getShellBalanceOf(shell1, address(TEST1)), */
        /*     10025000000000000000000 */
        /* ); */
        /*  */
        /* assertEq( */
        /*     pool.getShellBalanceOf(shell2, address(TEST1)), */
        /*     30075000000000000000000 */
        /* ); */
        /*  */
        /* assertEq( */
        /*     pool.getShellBalanceOf(shell1, address(TEST2)), */
        /*     9975062344139650872818 */
        /* ); */
        /*  */
        /* assertEq( */
        /*     pool.getShellBalanceOf(shell2, address(TEST2)), */
        /*     29925187032418952618454 */
        /* ); */
        /*  */
    }

}
