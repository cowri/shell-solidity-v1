
pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";

import "../../CowriPool.sol";
import "../../ERC20Token.sol";
import "../../testSetup/setupShells.sol";

contract DappTest is DSTest, DSMath, ShellSetup {
    address shell1;
    address shell2;

    function setUp() public {

        setupPool();
        setupTokens();
        shell1 = setupShellAB();
        shell2 = setupShellABC();

    }

    function testDepositLiquidity () public {

        uint256 test1Withdrawn;
        uint256 test2Withdrawn;
        uint256 test3Withdrawn;

        uint256 amount;
        uint256 balance;
        uint256 amountToStake = 500 * WAD;
        uint256 deadline = now + 50;
        uint256 tokenAmount = 1000000000 * WAD;

        amount = pool.depositLiquidity(shell1, amountToStake, deadline);
        balance = CowriShell(shell1).balanceOf(address(this));

        test1Withdrawn = amountToStake / 2;
        test2Withdrawn = amountToStake / 2 / 10;

        assertEq(testA.balanceOf(address(this)), tokenAmount - test1Withdrawn);
        assertEq(testB.balanceOf(address(this)), tokenAmount - test2Withdrawn);

        assertEq(amount,  amountToStake);
        assertEq(balance, amountToStake);

        amount = pool.depositLiquidity(shell2, amountToStake, deadline);
        balance = CowriShell(shell2).balanceOf(address(this));

        test1Withdrawn = test1Withdrawn + wdiv(amountToStake, 3 * WAD);
        test2Withdrawn = test2Withdrawn + wdiv(amountToStake, 30 * WAD) - 1;
        test3Withdrawn = wdiv(amountToStake, 300 * WAD) - 1;

        assertEq(testA.balanceOf(address(this)), tokenAmount - test1Withdrawn);
        assertEq(testB.balanceOf(address(this)), tokenAmount - test2Withdrawn);
        assertEq(testC.balanceOf(address(this)), tokenAmount - test3Withdrawn);

        assertEq(balance, amountToStake);
        assertEq(amount, amountToStake);

    }

}