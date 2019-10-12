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

        uint256 amount = 10000 * ( 10 ** 18 );
        uint256 deadline = now + 50;

        shell1Liquidity = pool.depositLiquidity(shell1, amount, deadline);
        shell2Liquidity = pool.depositLiquidity(shell2, amount * 3, deadline);

        pool.activateShell(shell1);
        pool.activateShell(shell2);

    }


    function testSwapByTargetAtoBthenBtoAthenAtoCthenCtoB () public {

        uint256 amount = 100 * ( 10 ** 18 );
        uint256 deadline = now + 50;

        assertEq(
            pool.swapByTarget(address(testA), address(testB), amount, amount * 2, deadline),
            100469798657718120805
        );

        assertEq(
            pool.swapByTarget(address(testB), address(testA), amount, amount * 2, deadline),
            9913156187501957433
        );

        assertEq(
            pool.swapByTarget(address(testA), address(testC), amount, amount * 2, deadline),
            100811238108150859828
        );

        assertEq(
            pool.swapByTarget(address(testC), address(testB), amount, amount * 2, deadline),
            998058367133803010
        );

    }

}