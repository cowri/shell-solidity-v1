pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../testSetup/setupShells.sol";

contract DappTest is DSTest, ShellSetup {

    address shell1;
    address shell2;
    address shell3;
    uint256 shell1Liquidity;
    uint256 shell2Liquidity;
    uint256 shell3Liquidity;

    function setUp () public {

        setupPool();
        setupTokens();
        shell1 = setupShellAB();
        shell2 = setupShellABC();
        shell3 = setupShellABCD();
        shell1Liquidity = pool.depositLiquidity(shell1, 200 * ( 10 ** 18), now + 50);
        shell2Liquidity = pool.depositLiquidity(shell2, 300 * ( 10 ** 18), now + 50);
        shell3Liquidity = pool.depositLiquidity(shell3, 400 * ( 10 ** 18), now + 50);
        pool.activateShell(shell1);
        pool.activateShell(shell2);
        pool.activateShell(shell3);

    }


    function testMicroSwapByOrigin () public {

        assertEq(
            pool.swapByOrigin(
                address(testA),
                address(testB),
                10 * ( 10 ** 18 ),
                5 * ( 10 ** 18 ),
                now + 50
            ),
            965775288224200425
        );

        assertEq(
            pool.getRevenue(address(testA)),
            1000000000000000
        );

        assertEq(
            pool.getShellBalanceOf(shell1, address(testA)),
            103333000000000000000
        );

        assertEq(
            pool.getShellBalanceOf(shell2, address(testA)),
            103333000000000000000
        );

        assertEq(
            pool.getShellBalanceOf(shell3, address(testA)),
            103333000000000000000
        );

        assertEq(
            pool.getShellBalanceOf(shell1, address(testB)),
            96780749039252665250
        );

        assertEq(
            pool.getShellBalanceOf(shell2, address(testB)),
            96780749039252665250
        );

        assertEq(
            pool.getShellBalanceOf(shell3, address(testB)),
            96780749039252665250
        );

        assertEq(
            testA.balanceOf(address(pool)),
            310000000000000000000
        );

        assertEq(
            testB.balanceOf(address(pool)),
            29034224711775799575
        );

    }
}
