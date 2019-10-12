pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../Prototype.sol";
import "../../ERC20Token.sol";
import "../../testSetup/setupShells.sol";

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

        uint256 amount = 10000 * (10 ** 18);
        uint256 deadline = 0;

        shell1Liquidity = pool.depositLiquidity(shell1, amount, amount, deadline);
        shell2Liquidity = pool.depositLiquidity(shell2, amount * 3, amount * 3, deadline);

        pool.activateShell(shell1);
        pool.activateShell(shell2);

    }

    function testSwapByOriginAtoBthenBtoAthenAtoCthenCtoB () public {

        uint256 balanceOrigin1;
        uint256 balanceOrigin2;
        uint256 balanceTarget1;
        uint256 balanceTarget2;

        uint256 amount = 100 * (10 ** 18);
        uint256 deadline = 0;

        uint256 swap1 = pool.swapByOrigin(address(testA), address(testB), amount, amount / 2, deadline);
        assertEq(swap1, 9933774834437086092);
        balanceOrigin1 = pool.getShellBalanceOf(shell1, address(testA));
        balanceOrigin2 = pool.getShellBalanceOf(shell2, address(testA));
        balanceTarget1 = pool.getShellBalanceOf(shell1, address(testB));
        balanceTarget2 = pool.getShellBalanceOf(shell2, address(testB));
        assertEq(balanceOrigin1, 5033333333333333333333);
        assertEq(balanceOrigin2, 10066666666666666666667);
        assertEq(balanceTarget1, 4966887417218543046358);
        assertEq(balanceTarget2, 9933774834437086092715);

        uint256 swap2 = pool.swapByOrigin(address(testB), address(testA), amount, amount / 2, deadline);
        assertEq(swap2, 100662222418436272129);
        balanceOrigin1 = pool.getShellBalanceOf(shell1, address(testB));
        balanceOrigin2 = pool.getShellBalanceOf(shell2, address(testB));
        balanceTarget1 = pool.getShellBalanceOf(shell1, address(testA));
        balanceTarget2 = pool.getShellBalanceOf(shell2, address(testA));
        assertEq(balanceOrigin1, 5000220750551876379691);
        assertEq(balanceOrigin2, 10000441501103752759382);
        assertEq(balanceTarget1, 4999779259193854575957);
        assertEq(balanceTarget2, 9999558518387709151914);

        uint256 swap3 = pool.swapByOrigin(address(testA), address(testC), amount, amount / 2, deadline);
        assertEq(swap3, 990142290060852813);
        balanceOrigin1 = pool.getShellBalanceOf(shell2, address(testA));
        balanceTarget1 = pool.getShellBalanceOf(shell2, address(testC));
        assertEq(balanceOrigin1, 10099558518387709151914);
        assertEq(balanceTarget1, 9900985770993914718635);

        uint256 swap4 = pool.swapByOrigin(address(testC), address(testB), amount, amount / 2, deadline);
        assertEq(swap4, 9999455783757096707);
        balanceOrigin1 = pool.getShellBalanceOf(shell2, address(testC));
        balanceTarget1 = pool.getShellBalanceOf(shell2, address(testB));
        assertEq(balanceOrigin1, 10000985770993914718635);
        assertEq(balanceTarget1, 9900446943266181792303);

    }

}