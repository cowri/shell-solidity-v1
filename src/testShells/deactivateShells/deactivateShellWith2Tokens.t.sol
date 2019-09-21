pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../Prototype.sol";
import "../../ERC20Token.sol";
import "../../Shell.sol";
import "../../ShellFactory.sol";

contract DappTest is DSTest {
    Prototype pool;
    ShellFactory shellFactory;
    ERC20Token TEST1;
    ERC20Token TEST2;
    address shell;

    function setUp() public {
        uint256 tokenAmount = 1000000000 * (10 ** 18);
        TEST1 = new ERC20Token("TEST ONE", "TEST1", 18, tokenAmount);
        TEST2 = new ERC20Token("TEST TWO", "TEST2", 18, tokenAmount);

        shellFactory = new ShellFactory();
        pool = new Prototype(address(shellFactory));

        TEST1.approve(address(pool), tokenAmount);
        TEST2.approve(address(pool), tokenAmount);

        address[] memory shellAddrs = new address[](2);
        shellAddrs[0] = address(TEST1);
        shellAddrs[1] = address(TEST2);

        shell = pool.createShell(shellAddrs);

        pool.setMinCapital(10000 * (10 ** 18));

        uint256 amounts = 1000 * (10 ** 18);

        pool.depositLiquidity(shell, amounts);

        pool.activateShell(shell);

        pool.withdrawLiquidity(shell, amounts * 2);

    }

    function testDeactivateShellWith2Tokens () public {
        pool.deactivateShell(shell);
    }

}