

pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../CowriPool.sol";
import "../../ERC20Token.sol";
import "../../CowriShell.sol";
import "../../testSetup/setupShells.sol";

contract DappTest is DSTest, ShellSetup {
    address shell;

    event log_addr_arr(bytes32 key, address[] val);

    function setUp () public {
        setupPool();
        setupTokens();
    }

    function testCreateShellWith2Tokens () public {

        shell = setupShellAB();
        address[] memory tokens = CowriShell(shell).getTokens();
        assertEq(address(testA), tokens[0]);
        assertEq(address(testB), tokens[1]);

    }

}