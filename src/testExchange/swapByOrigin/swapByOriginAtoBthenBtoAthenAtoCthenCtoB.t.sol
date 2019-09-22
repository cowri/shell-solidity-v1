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
        shell1 = setup2TokenShell();
        shell2 = setup3TokenShell();

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
        assertEq(swap1, 99750623441396508728);
        balanceOrigin1 = pool.getShellBalanceOf(shell1, address(TEST1));
        balanceOrigin2 = pool.getShellBalanceOf(shell2, address(TEST1));
        balanceTarget1 = pool.getShellBalanceOf(shell1, address(TEST2));
        balanceTarget2 = pool.getShellBalanceOf(shell2, address(TEST2));
        assertEq(balanceOrigin1, 10025000000000000000000);
        assertEq(balanceOrigin2, 30075000000000000000000);
        assertEq(balanceTarget1, 9975062344139650872818);
        assertEq(balanceTarget2, 29925187032418952618454);

        uint256 swap2 = pool.swapByOrigin(100 * ( 10 ** 18 ), address(TEST2), address(TEST1));
        assertEq(swap2, 100249375003896484436);
        balanceOrigin1 = pool.getShellBalanceOf(shell1, address(TEST2));
        balanceOrigin2 = pool.getShellBalanceOf(shell2, address(TEST2));
        balanceTarget1 = pool.getShellBalanceOf(shell1, address(TEST1));
        balanceTarget2 = pool.getShellBalanceOf(shell2, address(TEST1));
        assertEq(balanceOrigin1, 10000062344139650872818);
        assertEq(balanceOrigin2, 30000187032418952618454);
        assertEq(balanceTarget1, 9999937656249025878891);
        assertEq(balanceTarget2, 29999812968747077636673);

        uint256 swap3 = pool.swapByOrigin(100 * ( 10 ** 18 ), address(TEST1), address(TEST3));
        assertEq(swap3, 99668393392175843776);
        balanceOrigin1 = pool.getShellBalanceOf(shell2, address(TEST1));
        balanceTarget1 = pool.getShellBalanceOf(shell2, address(TEST3));
        assertEq(balanceOrigin1, 30099812968747077636673);
        assertEq(balanceTarget1, 29900331606607824156224);

        uint256 swap4 = pool.swapByOrigin(100 * ( 10 ** 18 ), address(TEST3), address(TEST2));
        assertEq(swap4, 99999518091363897811);
        balanceOrigin1 = pool.getShellBalanceOf(shell2, address(TEST3));
        balanceTarget1 = pool.getShellBalanceOf(shell2, address(TEST2));
        assertEq(balanceOrigin1, 30000331606607824156224);
        assertEq(balanceTarget1, 29900187514327588720643);

    }

}