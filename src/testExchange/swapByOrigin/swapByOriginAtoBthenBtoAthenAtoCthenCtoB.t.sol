pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../CowriPool.sol";
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
        uint256 deadline = now + 50;

        shell1Liquidity = pool.depositLiquidity(shell1, amount * 2, deadline);
        shell2Liquidity = pool.depositLiquidity(shell2, amount * 3, deadline);

        pool.activateShell(shell1);
        pool.activateShell(shell2);

    }

    function testSwapByOriginAtoBthenBtoAthenAtoCthenCtoB () public {

        uint256 balanceOrigin1;
        uint256 balanceOrigin2;
        uint256 balanceTarget1;
        uint256 balanceTarget2;

        uint256 amount = 100 * (10 ** 18);
        uint256 deadline = now + 50;
        balanceOrigin1 = pool.getShellBalanceOf(shell1, address(testA));
        balanceOrigin2 = pool.getShellBalanceOf(shell2, address(testA));
        balanceTarget1 = pool.getShellBalanceOf(shell1, address(testB));
        balanceTarget2 = pool.getShellBalanceOf(shell2, address(testB));
        emit log_named_uint("balanceOrigin1", balanceOrigin1);
        emit log_named_uint("balanceOrigin2", balanceOrigin2);
        emit log_named_uint("balanceTarget1", balanceTarget1);
        emit log_named_uint("balanceTarget2", balanceTarget2);

        uint256 swap1 = pool.macroSwapByOrigin(address(testA), address(testB), amount, amount / 2, deadline);
        assertEq(swap1, 9929458954616482108);
        balanceOrigin1 = pool.getShellBalanceOf(shell1, address(testA));
        balanceOrigin2 = pool.getShellBalanceOf(shell2, address(testA));
        balanceTarget1 = pool.getShellBalanceOf(shell1, address(testB));
        balanceTarget2 = pool.getShellBalanceOf(shell2, address(testB));
        emit log_named_uint("balanceOrigin1", balanceOrigin1);
        emit log_named_uint("balanceOrigin2", balanceOrigin2);
        emit log_named_uint("balanceTarget1", balanceTarget1);
        emit log_named_uint("balanceTarget2", balanceTarget2);
        
        assertEq(balanceOrigin1, 10049995000000000000000);
        assertEq(balanceOrigin2, 10049995000000000000000);
        assertEq(balanceTarget1, 9950352705226917589460);
        assertEq(balanceTarget2, 9950352705226917589460);

        // uint256 swap2 = pool.macroSwapByOrigin(address(testB), address(testA), amount, amount / 2, deadline);
        // assertEq(swap2, 100450803903137445793);
        // balanceOrigin1 = pool.getShellBalanceOf(shell1, address(testB));
        // balanceOrigin2 = pool.getShellBalanceOf(shell2, address(testB));
        // balanceTarget1 = pool.getShellBalanceOf(shell1, address(testA));
        // balanceTarget2 = pool.getShellBalanceOf(shell2, address(testA));
        // assertEq(balanceOrigin1, 5000286487518095963562);
        // assertEq(balanceOrigin2, 10000572975036191927125);
        // assertEq(balanceTarget1, 4999846398698954184736);
        // assertEq(balanceTarget2, 9999692797397908369471);

        // uint256 swap3 = pool.macroSwapByOrigin(address(testA), address(testC), amount, amount / 2, deadline);
        // assertEq(swap3, 988070595338767082);
        // balanceOrigin1 = pool.getShellBalanceOf(shell2, address(testA));
        // balanceTarget1 = pool.getShellBalanceOf(shell2, address(testC));
        // assertEq(balanceOrigin1, 10099682797397908369471);
        // assertEq(balanceTarget1, 9901192940466123291782);

        // uint256 swap4 = pool.macroSwapByOrigin(address(testC), address(testB), amount, amount / 2, deadline);
        // assertEq(swap4, 9978592915668846888);
        // balanceOrigin1 = pool.getShellBalanceOf(shell2, address(testC));
        // balanceTarget1 = pool.getShellBalanceOf(shell2, address(testB));
        // assertEq(balanceOrigin1, 10001182940466123291782);
        // assertEq(balanceTarget1, 9900787045879503458239);

    }

}