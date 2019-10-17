pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../CowriPool.sol";
import "../../ERC20Token.sol";
import "../../testSetup/setupShells.sol";

contract DappTest is DSTest, ShellSetup {

    address shell;
    uint256 shellLiquidity;

    function setUp () public {

        setupPool();
        setupTokens();
        shell = setupShellABC();

        uint256 amount = 30000 * ( 10 ** 18 );
        uint256 deadline = now + 50;

        shellLiquidity = pool.depositLiquidity(shell, amount, deadline);

        pool.activateShell(shell);

    }


    function testSwapByOriginCtoB () public {

        uint256 amount = 100 * ( 10 ** 18 );
        uint256 deadline = now + 50;

        assertEq(
            pool.macroSwapByOrigin(address(testC), address(testB), amount, amount / 2, deadline),
            9879427135339903077
        );

        assertEq(
            pool.getShellBalanceOf(shell, address(testC)),
            10099780040998000000000
        );

        assertEq(
            pool.getShellBalanceOf(shell, address(testB)),
            9901205728646600969224
        );

    }

}