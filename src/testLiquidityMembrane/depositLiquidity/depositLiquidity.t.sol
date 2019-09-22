
pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../Prototype.sol";
import "../../ERC20Token.sol";

contract DappTest is DSTest {
    Prototype pool;
    address shell1;
    address shell2;
    ERC20Token TEST1;
    ERC20Token TEST2;
    ERC20Token TEST3;

    function setUp() public {
        uint256 tokenAmount = 1000000000 * (10 ** 18);
        TEST1 = new ERC20Token("TEST ONE", "TEST1", 18, tokenAmount);
        TEST2 = new ERC20Token("TEST TWO", "TEST2", 16, tokenAmount);
        TEST3 = new ERC20Token("TEST THREE", "TEST3", 14, tokenAmount);

        address[] memory addrs = new address[](3);
        addrs[0] = address(TEST1);
        addrs[1] = address(TEST2);
        addrs[2] = address(TEST2);

        pool = new Prototype();

        TEST1.approve(address(pool), tokenAmount);
        TEST2.approve(address(pool), tokenAmount);
        TEST3.approve(address(pool), tokenAmount);

        address[] memory shell1Addrs = new address[](2);
        shell1Addrs[0] = address(TEST1);
        shell1Addrs[1] = address(TEST2);
        shell1 = pool.createShell(shell1Addrs);

        address[] memory shell2Addrs = new address[](3);
        shell2Addrs[0] = address(TEST1);
        shell2Addrs[1] = address(TEST2);
        shell2Addrs[2] = address(TEST3);
        shell2 = pool.createShell(shell2Addrs);

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