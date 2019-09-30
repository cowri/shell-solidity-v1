

pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../Prototype.sol";
import "../../ERC20Token.sol";
import "../../Shell.sol";
import "../../ShellFactory.sol";
import "../../testSetup/setupShells.sol";

contract DappTest is DSTest, ShellSetup {

    address shell;

    function setUp () public {

        setupPool();
        setupTokens();

        shell = setupShellABCDEFGHIJKLMNO();
        pool.setMinCapital(10000 * (10 ** 18));
        pool.depositLiquidity(shell, 10000 * (10 ** 18));

    }

    function testActivateShellWith15Tokens () public {
        pool.activateShell(shell);
    }

}