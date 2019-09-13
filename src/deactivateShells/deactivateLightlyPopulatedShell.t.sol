pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../Prototype.sol";
import "../Shell.sol";
import "../TOKEN.sol";
import "../CowriState.sol";

contract DappTest is DSTest {
    Prototype pool;
    TOKEN TEST1;
    TOKEN TEST2;
    address shell;

    function setUp() public {
        uint256 tokenAmount = 1000000000 * (10 ** 18);
        TEST1 = new TOKEN("TEST ONE", "TEST1", 18, tokenAmount);
        TEST2 = new TOKEN("TEST TWO", "TEST2", 18, tokenAmount);

        pool = new Prototype();

        TEST1.approve(address(pool), tokenAmount);
        TEST2.approve(address(pool), tokenAmount);

        address[] memory shellAddrs = new address[](2);
        shellAddrs[0] = address(TEST1);
        shellAddrs[1] = address(TEST2);

        shell = pool.createShell(shellAddrs);

        pool.setMinCapital(10000 * (10 ** 18));

        uint256 amounts = 10000 * (10 ** 18);

        pool.depositLiquidity(shell, amounts);

        pool.activateShell(shell);

        pool.withdrawLiquidity(shell, amounts * 2);

    }

    function testDeactivateLightlyPopulatedShell () public {
        pool.deactivateShell(shell);
    }

}