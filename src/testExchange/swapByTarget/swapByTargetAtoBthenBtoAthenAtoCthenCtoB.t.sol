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
            pool.macroSwapByTarget(address(testA), address(testB), amount, amount * 2, deadline),
            100882570469798657716
        );

        assertEq(
            pool.macroSwapByTarget(address(testB), address(testA), amount, amount * 2, deadline),
            9953616362448716629
        );

        assertEq(
            pool.macroSwapByTarget(address(testA), address(testC), amount, amount * 2, deadline),
            101228130071452782862
        );

        assertEq(
            pool.macroSwapByTarget(address(testC), address(testB), amount, amount * 2, deadline),
            1002132173009880412
        );

    }

}