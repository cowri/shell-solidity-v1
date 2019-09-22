pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../Prototype.sol";
import "../../ERC20Token.sol";
import "../../ShellFactory.sol";
import "../../Shell.sol";
import "../../testSetup/setupShells.sol";

contract DappTest is DSTest, ShellSetup {
    address shell;

    function setUp() public {

        setupPool();
        setupTokens();
        shell = setup11TokenShell();
        pool.setMinCapital(10000 * (10 ** 18));
        uint256 amounts = 10000 * (10 ** 18);
        pool.depositLiquidity(shell, amounts);
        pool.activateShell(shell);
        pool.withdrawLiquidity(shell, amounts * 11);

    }

    function testDeactivateShellWtih11Tokens () public {
        pool.deactivateShell(shell);
    }

}