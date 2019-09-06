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
        uint256 tokenAmount = 10000000000 * (10 ** 18);
        uint8 decimalAmount = 18;
        TEST1 = new TOKEN("TEST ONE", "TEST1", decimalAmount, tokenAmount);
        TEST2 = new TOKEN("TEST TWO", "TEST2", decimalAmount, tokenAmount);
        TEST3 = new TOKEN("TEST THREE", "TEST3", decimalAmount, tokenAmount);

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

        shell1Liquidity = pool.depositLiquidity(shell1, 1000 * ( 10 ** 18));
        shell2Liquidity = pool.depositLiquidity(shell2, 3000 * ( 10 ** 18));

    }


    function testSwapByOrigin () public {

        uint256 balanceOrigin1;
        uint256 balanceOrigin2;
        uint256 balanceTarget1;
        uint256 balanceTarget2;

        uint256 swap1 = pool.swapByOrigin(100 * ( 10 ** 18 ), address(TEST1), address(TEST2));
        assertEq(swap1, 97560975609756097561);
        balanceOrigin1 = pool.getShellBalanceOf(shell1, address(TEST1));
        balanceOrigin2 = pool.getShellBalanceOf(shell2, address(TEST1));
        balanceTarget1 = pool.getShellBalanceOf(shell1, address(TEST2));
        balanceTarget2 = pool.getShellBalanceOf(shell2, address(TEST2));
        assertEq(balanceOrigin1, 1025000000000000000000);
        assertEq(balanceOrigin2, 3075000000000000000000);
        assertEq(balanceTarget1, 975609756097560975610);
        assertEq(balanceTarget2, 2926829268292682926829);

        uint256 swap2 = pool.swapByOrigin(100 * ( 10 ** 18 ), address(TEST2), address(TEST1));
        assertEq(swap2, 102437538086532602072);
        balanceOrigin1 = pool.getShellBalanceOf(shell1, address(TEST2));
        balanceOrigin2 = pool.getShellBalanceOf(shell2, address(TEST2));
        balanceTarget1 = pool.getShellBalanceOf(shell1, address(TEST1));
        balanceTarget2 = pool.getShellBalanceOf(shell2, address(TEST1));
        assertEq(balanceOrigin1, 1000609756097560975610);
        assertEq(balanceOrigin2, 3001829268292682926829);
        assertEq(balanceTarget1, 999390615478366849482);
        assertEq(balanceTarget2, 2998171846435100548446);

        uint256 swap3 = pool.swapByOrigin(100 * ( 10 ** 18 ), address(TEST1), address(TEST3));
        assertEq(swap3, 96831297574791998584);
        balanceOrigin1 = pool.getShellBalanceOf(shell2, address(TEST1));
        balanceTarget1 = pool.getShellBalanceOf(shell2, address(TEST3));
        assertEq(balanceOrigin1, 3098171846435100548446);
        assertEq(balanceTarget1, 2903168702425208001416);

        uint256 swap4 = pool.swapByOrigin(100 * ( 10 ** 18 ), address(TEST3), address(TEST2));
        assertEq(swap4, 99955399304359977681);
        balanceOrigin1 = pool.getShellBalanceOf(shell2, address(TEST3));
        balanceTarget1 = pool.getShellBalanceOf(shell2, address(TEST2));
        assertEq(balanceOrigin1, 3003168702425208001416);
        assertEq(balanceTarget1, 2901873868988322949148);

    }

}