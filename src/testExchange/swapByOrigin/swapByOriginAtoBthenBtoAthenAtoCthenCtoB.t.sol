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

        shell1Liquidity = pool.depositLiquidity(shell1, amount, deadline);
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

        uint256 swap1 = pool.macroSwapByOrigin(address(testA), address(testB), amount, amount / 2, deadline);
        assertEq(swap1, 9912068989788261521);
        balanceOrigin1 = pool.getShellBalanceOf(shell1, address(testA));
        balanceOrigin2 = pool.getShellBalanceOf(shell2, address(testA));
        balanceTarget1 = pool.getShellBalanceOf(shell1, address(testB));
        balanceTarget2 = pool.getShellBalanceOf(shell2, address(testB));
        assertEq(balanceOrigin1, 5033260013666000000000);
        assertEq(balanceOrigin2, 10066520027332000000000);
        assertEq(balanceTarget1, 4966959770034039128262);
        assertEq(balanceTarget2, 9933919540068078256524);

        uint256 swap2 = pool.macroSwapByOrigin(address(testB), address(testA), amount, amount / 2, deadline);
        assertEq(swap2, 100439363116466441947);
        balanceOrigin1 = pool.getShellBalanceOf(shell1, address(testB));
        balanceOrigin2 = pool.getShellBalanceOf(shell2, address(testB));
        balanceTarget1 = pool.getShellBalanceOf(shell1, address(testA));
        balanceTarget2 = pool.getShellBalanceOf(shell2, address(testA));
        assertEq(balanceOrigin1, 5000219783700039128262);
        assertEq(balanceOrigin2, 10000439567400078256524);
        assertEq(balanceTarget1, 4999780225960511186018);
        assertEq(balanceTarget2, 9999560451921022372035);

        uint256 swap3 = pool.macroSwapByOrigin(address(testA), address(testC), amount, amount / 2, deadline);
        assertEq(swap3, 987985711224995802);
        balanceOrigin1 = pool.getShellBalanceOf(shell2, address(testA));
        balanceTarget1 = pool.getShellBalanceOf(shell2, address(testC));
        assertEq(balanceOrigin1, 10099340492919022372035);
        assertEq(balanceTarget1, 9901201428877500419776);

        uint256 swap4 = pool.macroSwapByOrigin(address(testC), address(testB), amount, amount / 2, deadline);
        assertEq(swap4, 9977463442351754430);
        balanceOrigin1 = pool.getShellBalanceOf(shell2, address(testC));
        balanceTarget1 = pool.getShellBalanceOf(shell2, address(testB));
        assertEq(balanceOrigin1, 10000981469875500419776);
        assertEq(balanceTarget1, 9900664932976560712220);

    }

}