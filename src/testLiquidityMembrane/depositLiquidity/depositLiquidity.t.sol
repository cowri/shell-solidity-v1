
pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../Prototype.sol";
import "../../ERC20Token.sol";
import "../../testSetup/setupShells.sol";

contract DappTest is DSTest, ShellSetup {
    address shell1;
    address shell2;

    function setUp() public {

        setupPool();
        setupTokens();
        shell1 = setup2TokenShell();
        shell2 = setup3TokenShell();

    }

    function testDepositLiquidity () public {

        uint256 tokenAmount = 1000000000 * (10 ** 18);

        uint256 token1Balance;
        uint256 token2Balance;
        uint256 token3Balance;

        uint256 amountToStake = 500 * (10 ** 18);
        uint256 amount1 = pool.depositLiquidity(shell1, amountToStake);
        uint256 balance1 = Shell(shell1).balanceOf(address(this));


        token1Balance = TEST1.balanceOf(address(this));
        token2Balance = TEST2.balanceOf(address(this));

        assertEq(token1Balance, tokenAmount - amountToStake);
        assertEq(token2Balance, tokenAmount - ( amountToStake / 100 ));

        assertEq(balance1, amountToStake * 2);
        assertEq(amount1, amountToStake * 2);

        uint256 amount2 = pool.depositLiquidity(shell2, amountToStake);
        uint256 balance2 = Shell(shell2).balanceOf(address(this));

        token1Balance = TEST1.balanceOf(address(this));
        token2Balance = TEST2.balanceOf(address(this));
        token3Balance = TEST3.balanceOf(address(this));

        assertEq(token1Balance, tokenAmount - ( amountToStake * 2));
        assertEq(token2Balance, tokenAmount - ( amountToStake * 2 / 100 ));
        assertEq(token3Balance, tokenAmount - ( amountToStake / 10000 ));

        assertEq(balance2, amountToStake * 3);
        assertEq(amount2, amountToStake * 3);

    }

}