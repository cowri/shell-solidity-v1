
pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";

import "../../Prototype.sol";
import "../../ERC20Token.sol";

contract DappTest is DSMath, DSTest {
    Prototype pool;
    address shell1;
    address shell2;
    uint256 amountToStake = 500 * WAD;
    uint256 tokenAmount = 1000000000 * WAD;
    ERC20Token TEST1;
    ERC20Token TEST2;
    ERC20Token TEST3;

    function setUp() public {
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

        uint256 test1Withdrawn;
        uint256 test2Withdrawn;
        uint256 test3Withdrawn;

        uint256 amount;
        uint256 balance;

        // uint256 amount = pool.depositLiquidity(shell1, amountToStake);
        // uint256 balance = Shell(shell1).balanceOf(address(this));

        // token1Balance = TEST1.balanceOf(address(this));
        // token2Balance = TEST2.balanceOf(address(this));

        // test1Withdrawn = amountToStake / 2;
        // test2Withdrawn = amountToStake / 2 / 100;

        // assertEq(token1Balance, tokenAmount - test1Withdrawn);
        // assertEq(token2Balance, tokenAmount - test2Withdrawn);

        // assertEq(amount,  amountToStake);
        // assertEq(balance, amountToStake);

        amount = pool.depositLiquidity(shell2, amountToStake);
        balance = Shell(shell2).balanceOf(address(this));

        // token1Balance = TEST1.balanceOf(address(this));
        // token2Balance = TEST2.balanceOf(address(this));
        // token3Balance = TEST3.balanceOf(address(this));

        // test1Withdrawn = test1Withdrawn + wdiv(amountToStake, 3 * WAD);
        // test2Withdrawn = test2Withdrawn + wdiv(amountToStake, 300 * WAD);
        // test3Withdrawn = wdiv(amountToStake, 3000 * WAD);

        // assertEq(token1Balance, tokenAmount - test1Withdrawn);
        // assertEq(token2Balance, tokenAmount - test2Withdrawn);
        // assertEq(token3Balance, tokenAmount - test3Withdrawn);

        assertEq(balance, amountToStake);
        assertEq(amount, amountToStake);

    }

}