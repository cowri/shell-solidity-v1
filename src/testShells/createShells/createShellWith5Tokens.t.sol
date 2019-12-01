

pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../CowriPool.sol";
import "../../ERC20Token.sol";
import "../../CowriShell.sol";
import "../../testSetup/setupShells.sol";

contract DappTest is DSTest, ShellSetup {
    address shell;

    function setUp () public {
        setupPool();
        setupTokens();
    }

    function testCreateShellWith5Tokens () public {

        shell = setupShellABCDE();
        address[] memory tokens = CowriShell(shell).getTokens();

        assertEq(address(testA), tokens[0]);
        assertEq(address(testB), tokens[1]);
        assertEq(address(testC), tokens[2]);
        assertEq(address(testD), tokens[3]);
        assertEq(address(testE), tokens[4]);

    }

}