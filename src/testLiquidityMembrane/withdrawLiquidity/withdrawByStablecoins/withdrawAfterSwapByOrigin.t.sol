pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../../CowriPool.sol";
import "../../../ERC20Token.sol";
import "../../../testSetup/setupShells.sol";

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
        shell2Liquidity = pool.depositLiquidity(shell2, amount, deadline);

        pool.activateShell(shell1);
        pool.activateShell(shell2);

        uint256 swapAmount = 100 * (10 ** 18);
        pool.swapByOrigin(address(testA), address(testB), swapAmount, swapAmount / 2, deadline);
        pool.swapByOrigin(address(testB), address(testA), swapAmount, swapAmount / 2, deadline);
        pool.swapByOrigin(address(testA), address(testC), swapAmount, swapAmount / 2, deadline);
        pool.swapByOrigin(address(testC), address(testB), swapAmount, swapAmount / 2, deadline);

    }


    function testWithdrawAfterSwapByOrigin () public {

        uint256 shell1Token1 = pool.getShellBalanceOf(shell1, address(testA));
        uint256 shell1Token2 = pool.getShellBalanceOf(shell1, address(testB));
        assertEq(shell1Token1, 4999410156379361248965);
        assertEq(shell1Token2, 5000828483370531795763);

        uint256 shell2Token1 = pool.getShellBalanceOf(shell2, address(testA));
        uint256 shell2Token2 = pool.getShellBalanceOf(shell2, address(testB));
        uint256 shell2Token3 = pool.getShellBalanceOf(shell2, address(testC));
        assertEq(shell2Token1, 3432930104252907499309);
        assertEq(shell2Token2, 3234165542511280374569);
        assertEq(shell2Token3, 3336422794124066579176);

        uint256 amount = 500 * ( 10 ** 18 );
        uint256 limitAmount = 450 * ( 10 ** 18 );
        uint256 deadline = now + 50;

        uint256[] memory shell1Withdrawal = pool.withdrawLiquidity(shell1, amount, getLimits(2, limitAmount / 2), deadline);
        assertEq(shell1Withdrawal[0], 249970507818968062448);
        assertEq(shell1Withdrawal[1], 25004142416852658978);

        uint256[] memory shell2Withdrawal = pool.withdrawLiquidity(shell2, amount, getLimits(3, limitAmount / 3), deadline);
        assertEq(shell2Withdrawal[0], 171646505212645374966);
        assertEq(shell2Withdrawal[1], 16170827712556401872);
        assertEq(shell2Withdrawal[2], 1668211397062033289);

    }

}