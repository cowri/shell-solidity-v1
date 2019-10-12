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
        uint256 deadline = 0;

        shellLiquidity = pool.depositLiquidity(shell, amount, amount, deadline);

        pool.activateShell(shell);

    }


    function testSwapByOriginCtoB () public {

        uint256 amount = 100 * ( 10 ** 18 );
        uint256 deadline = 0;

        assertEq(
<<<<<<< HEAD
            pool.swapByOrigin(100 * ( 10 ** 18 ), address(testC), address(testB)),
            9880405414606827637
=======
            pool.swapByOrigin(address(testC), address(testB), amount, amount / 2, deadline),
            9900990099009900990
        );

        assertEq(
            pool.getShellBalanceOf(shell, address(testC)),
            10100000000000000000000
        );

        assertEq(
            pool.getShellBalanceOf(shell, address(testB)),
            9900990099009900990099
>>>>>>> master
        );

    }

}