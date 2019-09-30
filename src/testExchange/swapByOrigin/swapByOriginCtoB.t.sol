pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../Prototype.sol";
import "../../ERC20Token.sol";
import "../../testSetup/setupShells.sol";

contract DappTest is DSTest, ShellSetup {

    address shell;
    uint256 shellLiquidity;

    function setUp () public {

        setupPool();
        setupTokens();
        shell = setupShellABC();

        shellLiquidity = pool.depositLiquidity(shell, 30000 * ( 10 ** 18));

        pool.activateShell(shell);

    }


    function testSwapByOriginCtoB () public {

        assertEq(
            pool.swapByOrigin(100 * ( 10 ** 18 ), address(testC), address(testB)),
            9900990099009900990
        );

        assertEq(
            pool.getShellBalanceOf(shell, address(testC)),
            10100000000000000000000
        );

        assertEq(
            pool.getShellBalanceOf(shell, address(testB)),
            9900990099009900990099
        );

    }

}