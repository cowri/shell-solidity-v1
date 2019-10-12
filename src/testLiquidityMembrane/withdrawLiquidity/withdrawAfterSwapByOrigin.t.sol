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
        uint256 deadline = 0;

        shell1Liquidity = pool.depositLiquidity(shell1, amount, amount, deadline);
        shell2Liquidity = pool.depositLiquidity(shell2, amount, amount, deadline);

        pool.activateShell(shell1);
        pool.activateShell(shell2);

        pool.swapByOrigin(100 * (10 ** 18), address(testA), address(testB));
        pool.swapByOrigin(100 * (10 ** 18), address(testB), address(testA));
        pool.swapByOrigin(100 * (10 ** 18), address(testA), address(testC));
        pool.swapByOrigin(100 * (10 ** 18), address(testC), address(testB));

    }


    function testWithdrawAfterSwapByOrigin () public {

        uint256 shell1Token1 = pool.getShellBalanceOf(shell1, address(testA));
        uint256 shell1Token2 = pool.getShellBalanceOf(shell1, address(testB));
        assertEq(shell1Token1, 4999780182146306678555);
        assertEq(shell1Token2, 5000219827518095963562);

        uint256 shell2Token1 = pool.getShellBalanceOf(shell2, address(testA));
        uint256 shell2Token2 = pool.getShellBalanceOf(shell2, address(testB));
        uint256 shell2Token3 = pool.getShellBalanceOf(shell2, address(testC));
        assertEq(shell2Token1, 10099350384292613357109);
        assertEq(shell2Token2, 9900655043221866154149);
        assertEq(shell2Token3, 10000981664805984646440);

        uint256 amount = 500 * ( 10 ** 18 );
        uint256 deadline = 0;

        uint256[] memory shell1Withdrawal = pool.withdrawLiquidity(shell1, amount, amount, deadline);
        assertEq(shell1Withdrawal[0], 249988962959692728798);
        assertEq(shell1Withdrawal[1], 25001103752759381898);

        uint256[] memory shell2Withdrawal = pool.withdrawLiquidity(shell2, amount, amount, deadline);
        assertEq(shell2Withdrawal[0], 504977925919385457596);
        assertEq(shell2Withdrawal[1], 49502234716330908961);
        assertEq(shell2Withdrawal[2], 5000492885496957359);

    }

}