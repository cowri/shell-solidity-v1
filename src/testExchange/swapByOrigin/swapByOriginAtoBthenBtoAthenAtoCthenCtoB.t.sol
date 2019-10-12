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

        uint256 swap1 = pool.swapByOrigin(address(testA), address(testB), amount, amount / 2, deadline);
        assertEq(swap1, 9913053744571210931);
        balanceOrigin1 = pool.getShellBalanceOf(shell1, address(testA));
        balanceOrigin2 = pool.getShellBalanceOf(shell2, address(testA));
        balanceTarget1 = pool.getShellBalanceOf(shell1, address(testB));
        balanceTarget2 = pool.getShellBalanceOf(shell2, address(testB));
        assertEq(balanceOrigin1, 5033263340000000000000);
        assertEq(balanceOrigin2, 10066526680000000000000);
        assertEq(balanceTarget1, 4966956487518095963562);
        assertEq(balanceTarget2, 9933912975036191927125);

        uint256 swap2 = pool.swapByOrigin(address(testB), address(testA), amount, amount / 2, deadline);
        assertEq(swap2, 100449473561079964336);
        balanceOrigin1 = pool.getShellBalanceOf(shell1, address(testB));
        balanceOrigin2 = pool.getShellBalanceOf(shell2, address(testB));
        balanceTarget1 = pool.getShellBalanceOf(shell1, address(testA));
        balanceTarget2 = pool.getShellBalanceOf(shell2, address(testA));
        assertEq(balanceOrigin1, 5000219827518095963562);
        assertEq(balanceOrigin2, 10000439655036191927125);
        assertEq(balanceTarget1, 4999780182146306678555);
        assertEq(balanceTarget2, 9999560364292613357109);

        uint256 swap3 = pool.swapByOrigin(address(testA), address(testC), amount, amount / 2, deadline);
        assertEq(swap3, 988083551940153535);
        balanceOrigin1 = pool.getShellBalanceOf(shell2, address(testA));
        balanceTarget1 = pool.getShellBalanceOf(shell2, address(testC));
        assertEq(balanceOrigin1, 10099350384292613357109);
        assertEq(balanceTarget1, 9901191644805984646440);

        uint256 swap4 = pool.swapByOrigin(address(testC), address(testB), amount, amount / 2, deadline);
        assertEq(swap4, 9978461181432577297);
        balanceOrigin1 = pool.getShellBalanceOf(shell2, address(testC));
        balanceTarget1 = pool.getShellBalanceOf(shell2, address(testB));
        assertEq(balanceOrigin1, 10000981664805984646440);
        assertEq(balanceTarget1, 9900655043221866154149);

    }

}