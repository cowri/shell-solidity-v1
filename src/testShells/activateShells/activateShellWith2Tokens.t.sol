

pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../Prototype.sol";
import "../../ERC20Token.sol";

contract DappTest is DSTest {
    Prototype pool;
    ERC20Token TEST1;
    ERC20Token TEST2;
    address shell;

    function setUp () public {

        uint256 tokenAmount = 1000000000 * (10 ** 18);
        TEST1 = new ERC20Token("TEST THREE", "TEST3", 18, tokenAmount);
        TEST2 = new ERC20Token("TEST THREE", "TEST3", 18, tokenAmount);

        pool = new Prototype();

        TEST1.approve(address(pool), tokenAmount);
        TEST2.approve(address(pool), tokenAmount);

        address[] memory shellAddrs = new address[](2);
        shellAddrs[0] = address(TEST1);
        shellAddrs[1] = address(TEST2);

        shell = pool.createShell(shellAddrs);

        pool.setMinCapital(10000 * (10 ** 18));

        pool.depositLiquidity(shell, 10000 * (10 ** 18));

    }

    function testActivateShellWith2Tokens () public {
        pool.activateShell(shell);
    }

}