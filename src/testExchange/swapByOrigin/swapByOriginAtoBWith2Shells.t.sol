pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../CowriPool.sol";
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

        uint256 amount = 10000 * ( 10 ** 18 );
        uint256 deadline = now + 50;

        shell1Liquidity = pool.depositLiquidity(shell1, amount, deadline);
        shell2Liquidity = pool.depositLiquidity(shell2, amount * 3, deadline);

        pool.activateShell(shell1);
        pool.activateShell(shell2);

    }


    function testSwapByOriginAtoBWith2Shells () public {


        uint256 amount = 100 * ( 10 ** 18 );
        uint256 deadline = now + 50;

        assertEq(
            pool.swapByOrigin(address(testA), address(testB), amount, amount / 2, deadline),
            9913053744571210931
        );

        assertEq(
            pool.getShellBalanceOf(shell1, address(testA)),
            5033330000000000000000
        );

        assertEq(
            pool.getShellBalanceOf(shell2, address(testA)),
            10066660000000000000000
        );

        assertEq(
            pool.getShellBalanceOf(shell1, address(testB)),
            4966956487518095963562
        );

        assertEq(
            pool.getShellBalanceOf(shell2, address(testB)),
            9933912975036191927125
        );

    }

}