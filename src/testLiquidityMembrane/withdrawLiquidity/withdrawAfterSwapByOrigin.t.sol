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
    uint256 shell1Liquidity;
    uint256 shell2Liquidity;

    function setUp () public {
        uint256 tokenAmount = 1000000000 * (10 ** 18);
        TEST1 = new ERC20Token("TEST ONE", "TEST1", 18, tokenAmount);
        TEST2 = new ERC20Token("TEST TWO", "TEST2", 16, tokenAmount);
        TEST3 = new ERC20Token("TEST THREE", "TEST3", 14, tokenAmount);

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

        shell1Liquidity = pool.depositLiquidity(shell1, 10000 * (10 ** 18));
        shell2Liquidity = pool.depositLiquidity(shell2, 30000 * (10 ** 18));

        pool.activateShell(shell1);
        pool.activateShell(shell2);

        pool.swapByOrigin(100 * (10 ** 18), address(TEST1), address(TEST2));
        pool.swapByOrigin(100 * (10 ** 18), address(TEST2), address(TEST1));
        pool.swapByOrigin(100 * (10 ** 18), address(TEST1), address(TEST3));
        pool.swapByOrigin(100 * (10 ** 18), address(TEST3), address(TEST2));

    }


    function testWithdrawAfterSwapByOrigin () public {

        uint256 shell1Token1 = pool.getShellBalanceOf(shell1, address(TEST1));
        uint256 shell1Token2 = pool.getShellBalanceOf(shell1, address(TEST2));
        assertEq(shell1Token1, 4999779259193854575957);
        assertEq(shell1Token2, 5000220750551876379691);

        uint256 shell2Token1 = pool.getShellBalanceOf(shell2, address(TEST1));
        uint256 shell2Token2 = pool.getShellBalanceOf(shell2, address(TEST2));
        uint256 shell2Token3 = pool.getShellBalanceOf(shell2, address(TEST3));
        assertEq(shell2Token1, 10099558518387709151914);
        assertEq(shell2Token2, 9900446943266181792303);
        assertEq(shell2Token3, 10000985770993914718635);

        uint256[] memory shell1Withdrawal = pool.withdrawLiquidity(shell1, 500 * ( 10 ** 18 ));
        assertEq(shell1Withdrawal[0], 2500110375275938189);
        assertEq(shell1Withdrawal[1], 249988962959692728798);

        uint256[] memory shell2Withdrawal = pool.withdrawLiquidity(shell2, 1500 * ( 10 ** 18 ));
        assertEq(shell2Withdrawal[0], 4950223471633090896);
        assertEq(shell2Withdrawal[1], 504977925919385457596);
        assertEq(shell2Withdrawal[2], 50004928854969573);

    }

}