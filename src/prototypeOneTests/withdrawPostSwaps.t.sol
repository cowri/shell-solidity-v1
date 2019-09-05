pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../PrototypeOne.sol";
import "../Shell.sol";
import "../TOKEN.sol";

contract DappTest is DSTest {

    PrototypeOne pool;
    address shell1;
    address shell2;
    TOKEN TEST1;
    TOKEN TEST2;
    TOKEN TEST3;
    uint256 shell1Liquidity;
    uint256 shell2Liquidity;

    function setUp () public {
        uint256 tokenAmount = 1000000000 * (10 ** 18);
        TEST1 = new TOKEN("TEST ONE", "TEST1", 18, tokenAmount);
        TEST2 = new TOKEN("TEST TWO", "TEST2", 16, tokenAmount);
        TEST3 = new TOKEN("TEST THREE", "TEST3", 14, tokenAmount);

        pool = new PrototypeOne();

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

        shell1Liquidity = pool.depositLiquidity(shell1, 1000 * (10 ** 18));
        shell2Liquidity = pool.depositLiquidity(shell2, 3000 * (10 ** 18));

        pool.swap(address(TEST1), address(TEST2), 100 * (10 ** 18));
        pool.swap(address(TEST2), address(TEST1), 100 * (10 ** 18));
        pool.swap(address(TEST1), address(TEST3), 100 * (10 ** 18));
        pool.swap(address(TEST3), address(TEST2), 100 * (10 ** 18));

    }


    function testWithdrawPostSwap () public {

        uint256 shell1Token1 = pool.getShellBalanceOf(shell1, address(TEST1));
        uint256 shell1Token2 = pool.getShellBalanceOf(shell1, address(TEST2));
        assertEq(shell1Token1, 999390615478366849482);
        assertEq(shell1Token2, 1000609756097560975610);

        uint256 shell2Token1 = pool.getShellBalanceOf(shell2, address(TEST1));
        uint256 shell2Token2 = pool.getShellBalanceOf(shell2, address(TEST2));
        uint256 shell2Token3 = pool.getShellBalanceOf(shell2, address(TEST3));
        assertEq(shell2Token1, 3098171846435100548446);
        assertEq(shell2Token2, 2901873868988322949148);
        assertEq(shell2Token3, 3003168702425208001416);

        uint256[] memory shell1Withdrawal = pool.withdrawLiquidity(shell1, 500 * ( 10 ** 18 ));
        assertEq(shell1Withdrawal[0], 249847653869591712370);
        assertEq(shell1Withdrawal[1], 2501524390243902439);

        uint256[] memory shell2Withdrawal = pool.withdrawLiquidity(shell2, 1500 * ( 10 ** 18 ));
        assertEq(shell2Withdrawal[0], 516361974405850091408);
        assertEq(shell2Withdrawal[1], 4836456448313871581);
        assertEq(shell2Withdrawal[2], 50052811707086800);

    }

}