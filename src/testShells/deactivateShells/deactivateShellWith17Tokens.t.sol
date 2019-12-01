pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../CowriPool.sol";
import "../../ERC20Token.sol";
import "../../testSetup/setupShells.sol";

contract DappTest is DSTest, ShellSetup {
    address shell;

    function setUp() public {

        setupPool();
        setupTokens();
        shell = setupShellABCDEFGHIJKLMNOPQ();

        uint256 amount = 10000 * (10 ** 18);
        uint256 deadline = now + 50;

        pool.setShellActivationThreshold(amount);
        pool.depositLiquidity(shell, amount, deadline);

        pool.activateShell(shell);

        pool.withdrawLiquidity(shell, amount, getLimits(17, amount / 17), deadline);

    }

    function testDeactivateShellWith17Tokens () public {
        pool.deactivateShell(shell);
    }

}