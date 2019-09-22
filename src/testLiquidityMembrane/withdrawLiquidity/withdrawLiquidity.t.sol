pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";

import "../../Prototype.sol";
import "../../ERC20Token.sol";
import "../../testSetup/setupShells.sol";

contract DappTest is DSTest, DSMath, ShellSetup {
    address shell1;
    address shell2;
    address shell3;
    address shell4;
    address shell5;
    uint256 shell1Liquidity;
    uint256 shell2Liquidity;
    uint256 shell3Liquidity;
    uint256 shell4Liquidity;
    uint256 shell5Liquidity;

    function setUp() public {

        setupPool();
        setupTokens();
        shell1 = setup2TokenShell();
        shell2 = setup3TokenShell();
        shell3 = setup4TokenShell();
        shell4 = setup5TokenShell();
        shell5 = setup6TokenShell();

        uint256 amountToStake = 5000 * (10 ** 18);
        shell1Liquidity = pool.depositLiquidity(shell1, amountToStake);
        shell2Liquidity = pool.depositLiquidity(shell2, amountToStake);
        shell3Liquidity = pool.depositLiquidity(shell3, amountToStake);
        shell4Liquidity = pool.depositLiquidity(shell4, amountToStake);
        shell5Liquidity = pool.depositLiquidity(shell5, amountToStake);

    }

    function testWithdrawLiquidity () public {

        uint256 amount = 100 * (10 ** 18);
        uint256[] memory shell1Withdraw1 = pool.withdrawLiquidity(address(shell1), amount);

        assertEq(shell1Withdraw1[1], amount/2);
        assertEq(shell1Withdraw1[0], (amount/2) / 100);

        // uint256[] memory shell1Withdraw2 = pool.withdrawLiquidity(address(shell1), amount);

        // assertEq(shell1Withdraw2[0], amount/2);
        // assertEq(shell1Withdraw2[1], (amount/2) / 100);

        // uint256[] memory shell1Withdraw3 = pool.withdrawLiquidity(address(shell1), amount);

        // assertEq(shell1Withdraw3[0], amount/2);
        // assertEq(shell1Withdraw3[1], (amount/2) / 100);

        // uint256[] memory shell1Withdraw4 = pool.withdrawLiquidity(address(shell1), amount);

        // assertEq(shell1Withdraw4[0], amount/2);
        // assertEq(shell1Withdraw4[1], (amount/2) / 100);
        // uint256[] memory shell1Withdraw5 = pool.withdrawLiquidity(address(shell1), amount);

        // assertEq(shell1Withdraw5[0], amount/2);
        // assertEq(shell1Withdraw5[1], (amount/2) / 100);
        // uint256[] memory shell1Withdraw6 = pool.withdrawLiquidity(address(shell1), amount);

        // assertEq(shell1Withdraw6[0], amount/2);
        // assertEq(shell1Withdraw6[1], (amount/2) / 100);
        // uint256[] memory shell1Withdraw2 = pool.withdrawLiquidity(address(shell1), amount);

        // assertEq(shell1Withdraw2[0], amount/2);
        // assertEq(shell1Withdraw2[1], (amount/2) / 100);

        // uint256[] memory shell1Withdraw3 = pool.withdrawLiquidity(address(shell1), amount);

        // assertEq(shell1Withdraw3[0], amount/2);
        // assertEq(shell1Withdraw3[1], (amount/2) / 100);

        // uint256[] memory shell1Withdraw4 = pool.withdrawLiquidity(address(shell1), amount);

        // assertEq(shell1Withdraw4[0], amount/2);
        // assertEq(shell1Withdraw4[1], (amount/2) / 100);

        uint256[] memory shell2Withdraw1 = pool.withdrawLiquidity(address(shell2), amount);

        assertEq(shell2Withdraw1[1], amount/3);
        assertEq(shell2Withdraw1[0], (amount/3) / 100);
        assertEq(shell2Withdraw1[2], (amount/3) / 10000);

        uint256[] memory shell2Withdraw2 = pool.withdrawLiquidity(address(shell2), amount);

        assertEq(shell2Withdraw2[1], amount/3);
        assertEq(shell2Withdraw2[0], (amount/3) / 100);
        assertEq(shell2Withdraw2[2], (amount/3) / 10000);

        uint256[] memory shell2Withdraw3 = pool.withdrawLiquidity(address(shell2), amount);

        assertEq(shell2Withdraw3[1], amount/3);
        assertEq(shell2Withdraw3[0], (amount/3) / 100);
        assertEq(shell2Withdraw3[2], (amount/3) / 10000);

        uint256[] memory shell3Withdraw1 = pool.withdrawLiquidity(address(shell3), amount);

        assertEq(shell3Withdraw1[2], amount/4);
        assertEq(shell3Withdraw1[1], (amount/4) / 100);
        assertEq(shell3Withdraw1[3], (amount/4) / 10000);
        assertEq(shell3Withdraw1[0], (amount/4) / 1000000);

        uint256[] memory shell4Withdraw1 = pool.withdrawLiquidity(address(shell4), amount);

        assertEq(shell4Withdraw1[3], amount/5);
        assertEq(shell4Withdraw1[2], (amount/5) / 100);
        assertEq(shell4Withdraw1[4], (amount/5) / 10000);
        assertEq(shell4Withdraw1[1], (amount/5) / 1000000);
        assertEq(shell4Withdraw1[0], (amount/5) / 100000000);

        uint256[] memory shell5Withdraw1 = pool.withdrawLiquidity(address(shell5), amount);

        assertEq(shell5Withdraw1[4], wdiv(amount, 6 * WAD));
        assertEq(shell5Withdraw1[3], (amount/6) / 100);
        assertEq(shell5Withdraw1[5], (amount/6) / 10000);
        assertEq(shell5Withdraw1[1], (amount/6) / 1000000);
        assertEq(shell5Withdraw1[0], (amount/6) / 100000000);
        assertEq(shell5Withdraw1[2], (amount/6) / 10000000000);

    }

}