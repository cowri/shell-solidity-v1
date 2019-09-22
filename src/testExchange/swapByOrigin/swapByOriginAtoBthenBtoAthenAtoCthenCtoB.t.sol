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
        uint256 tokenAmount = 10000000000 * (10 ** 18);
        uint8 decimalAmount = 18;
        TEST1 = new ERC20Token("TEST ONE", "TEST1", decimalAmount, tokenAmount);
        TEST2 = new ERC20Token("TEST TWO", "TEST2", decimalAmount, tokenAmount);
        TEST3 = new ERC20Token("TEST THREE", "TEST3", decimalAmount, tokenAmount);

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

        shell1Liquidity = pool.depositLiquidity(shell1, 10000 * ( 10 ** 18));
        shell2Liquidity = pool.depositLiquidity(shell2, 30000 * ( 10 ** 18));

        pool.activateShell(shell1);
        pool.activateShell(shell2);

    }


    function testSwapByOriginAtoBthenBtoAthenAtoCthenCtoB () public {

        uint256 balanceOrigin1;
        uint256 balanceOrigin2;
        uint256 balanceTarget1;
        uint256 balanceTarget2;

        uint256 swap1 = pool.swapByOrigin(100 * ( 10 ** 18 ), address(TEST1), address(TEST2));
        assertEq(swap1, 99337748344370860927);
        balanceOrigin1 = pool.getShellBalanceOf(shell1, address(TEST1));
        balanceOrigin2 = pool.getShellBalanceOf(shell2, address(TEST1));
        balanceTarget1 = pool.getShellBalanceOf(shell1, address(TEST2));
        balanceTarget2 = pool.getShellBalanceOf(shell2, address(TEST2));
        assertEq(balanceOrigin1, 5033333333333333333333);
        assertEq(balanceOrigin2, 10066666666666666666667);
        assertEq(balanceTarget1, 4966887417218543046358);
        assertEq(balanceTarget2, 9933774834437086092715);

        uint256 swap2 = pool.swapByOrigin(100 * ( 10 ** 18 ), address(TEST2), address(TEST1));
        assertEq(swap2, 100662222418436272129);
        balanceOrigin1 = pool.getShellBalanceOf(shell1, address(TEST2));
        balanceOrigin2 = pool.getShellBalanceOf(shell2, address(TEST2));
        balanceTarget1 = pool.getShellBalanceOf(shell1, address(TEST1));
        balanceTarget2 = pool.getShellBalanceOf(shell2, address(TEST1));
        assertEq(balanceOrigin1, 5000220750551876379691);
        assertEq(balanceOrigin2, 10000441501103752759382);
        assertEq(balanceTarget1, 4999779259193854575957);
        assertEq(balanceTarget2, 9999558518387709151914);

        uint256 swap3 = pool.swapByOrigin(100 * ( 10 ** 18 ), address(TEST1), address(TEST3));
        assertEq(swap3, 99014229006085281365);
        balanceOrigin1 = pool.getShellBalanceOf(shell2, address(TEST1));
        balanceTarget1 = pool.getShellBalanceOf(shell2, address(TEST3));
        assertEq(balanceOrigin1, 10099558518387709151914);
        assertEq(balanceTarget1, 9900985770993914718635);

        uint256 swap4 = pool.swapByOrigin(100 * ( 10 ** 18 ), address(TEST3), address(TEST2));
        assertEq(swap4, 99994557837570967079);
        balanceOrigin1 = pool.getShellBalanceOf(shell2, address(TEST3));
        balanceTarget1 = pool.getShellBalanceOf(shell2, address(TEST2));
        assertEq(balanceOrigin1, 10000985770993914718635);
        assertEq(balanceTarget1, 9900446943266181792303);

    }

}