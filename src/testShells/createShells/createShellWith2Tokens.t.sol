

pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../Prototype.sol";
import "../../ERC20Token.sol";
import "../../ShellFactory.sol";
import "../../Shell.sol";
import "../../testSetup/setupShells.sol";

contract DappTest is DSTest, ShellSetup {
    address shell;

    event log_addr_arr(bytes32 key, address[] val);

    function setUp () public {
        setupPool();
        setupTokens();
    }

    function testCreateShellWith2Tokens () public {

        shell = setup2TokenShell();
        address[] memory tokens = Shell(shell).getTokens();
        assertEq(address(TEST1), tokens[0]);
        assertEq(address(TEST2), tokens[1]);

    }

}