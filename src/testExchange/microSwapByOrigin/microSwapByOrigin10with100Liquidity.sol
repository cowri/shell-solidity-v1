pragma solidity ^0.5.6;

import "ds-test/test.sol";

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
        shell1Liquidity = pool.depositLiquidity(shell1, 200 * ( 10 ** 18), now + 50);
        pool.activateShell(shell1);

    }


    function testMicroSwapByOrigin () public {

        assertEq(
            pool.swapByOrigin(
                address(shell1),
                address(testA),
                address(testB),
                10 * ( 10 ** 18 ),
                5 * ( 10 ** 18 ),
                now + 50
            ),
            907355205860115006
        );

        assertEq(
            pool.getRevenue(address(testA)),
            1000000000000000
        );

        assertEq(
            pool.getShellBalanceOf(shell1, address(testA)),
            109999000000000000000
        );

        assertEq(
            pool.getShellBalanceOf(shell1, address(testB)),
            90926447941398849937
        );

    }

}
