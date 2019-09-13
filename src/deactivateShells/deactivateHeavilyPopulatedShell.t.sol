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
    TOKEN TEST3;
    TOKEN TEST4;
    TOKEN TEST5;
    TOKEN TEST6;
    TOKEN TEST7;
    TOKEN TEST8;
    TOKEN TEST9;
    TOKEN TEST10;
    TOKEN TEST11;
    address shell;

    function setUp() public {
        uint256 tokenAmount = 1000000000 * (10 ** 18);
        TEST1 = new TOKEN("TEST ONE", "TEST1", 18, tokenAmount);
        TEST2 = new TOKEN("TEST TWO", "TEST2", 18, tokenAmount);
        TEST3 = new TOKEN("TEST THREE", "TEST3", 18, tokenAmount);
        TEST4 = new TOKEN("TEST THREE", "TEST3", 18, tokenAmount);
        TEST5 = new TOKEN("TEST THREE", "TEST3", 18, tokenAmount);
        TEST6 = new TOKEN("TEST THREE", "TEST3", 18, tokenAmount);
        TEST7 = new TOKEN("TEST THREE", "TEST3", 18, tokenAmount);
        TEST8 = new TOKEN("TEST THREE", "TEST3", 18, tokenAmount);
        TEST9 = new TOKEN("TEST THREE", "TEST3", 18, tokenAmount);
        TEST10 = new TOKEN("TEST THREE", "TEST3", 18, tokenAmount);
        TEST11 = new TOKEN("TEST THREE", "TEST3", 18, tokenAmount);

        pool = new Prototype();

        TEST1.approve(address(pool), tokenAmount);
        TEST2.approve(address(pool), tokenAmount);
        TEST3.approve(address(pool), tokenAmount);
        TEST4.approve(address(pool), tokenAmount);
        TEST5.approve(address(pool), tokenAmount);
        TEST6.approve(address(pool), tokenAmount);
        TEST7.approve(address(pool), tokenAmount);
        TEST8.approve(address(pool), tokenAmount);
        TEST9.approve(address(pool), tokenAmount);
        TEST10.approve(address(pool), tokenAmount);
        TEST11.approve(address(pool), tokenAmount);

        address[] memory shellAddrs = new address[](11);
        shellAddrs[0] = address(TEST1);
        shellAddrs[1] = address(TEST2);
        shellAddrs[2] = address(TEST3);
        shellAddrs[3] = address(TEST4);
        shellAddrs[4] = address(TEST5);
        shellAddrs[5] = address(TEST6);
        shellAddrs[6] = address(TEST7);
        shellAddrs[7] = address(TEST8);
        shellAddrs[8] = address(TEST9);
        shellAddrs[9] = address(TEST10);
        shellAddrs[10] = address(TEST11);

        shell = pool.createShell(shellAddrs);

        pool.setMinCapital(10000 * (10 ** 18));

        uint256 amounts = 10000 * (10 ** 18);

        pool.depositLiquidity(shell, amounts);

        pool.activateShell(shell);

        pool.withdrawLiquidity(shell, amounts * 11);

    }

    function testDeactivateHeavilyPopulatedShell () public {
        pool.deactivateShell(shell);
    }

}