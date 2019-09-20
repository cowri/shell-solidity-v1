

pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../Prototype.sol";
import "../../ERC20Token.sol";

contract DappTest is DSTest {
    Prototype pool;
    ERC20Token TEST1;
    ERC20Token TEST2;
    ERC20Token TEST3;
    ERC20Token TEST4;
    ERC20Token TEST5;
    ERC20Token TEST6;
    ERC20Token TEST7;
    ERC20Token TEST8;
    ERC20Token TEST9;
    ERC20Token TEST10;
    ERC20Token TEST11;
    address shell;

    event log_addr_arr(bytes32 key, address[] val);

    function setUp () public {

        uint256 tokenAmount = 1000000000 * (10 ** 18);
        TEST1 = new ERC20Token("TEST THREE", "TEST3", 18, tokenAmount);
        TEST2 = new ERC20Token("TEST THREE", "TEST3", 18, tokenAmount);
        TEST3 = new ERC20Token("TEST THREE", "TEST3", 18, tokenAmount);
        TEST4 = new ERC20Token("TEST THREE", "TEST3", 18, tokenAmount);
        TEST5 = new ERC20Token("TEST THREE", "TEST3", 18, tokenAmount);
        TEST6 = new ERC20Token("TEST THREE", "TEST3", 18, tokenAmount);
        TEST7 = new ERC20Token("TEST THREE", "TEST3", 18, tokenAmount);
        TEST8 = new ERC20Token("TEST THREE", "TEST3", 18, tokenAmount);
        TEST9 = new ERC20Token("TEST THREE", "TEST3", 18, tokenAmount);
        TEST10 = new ERC20Token("TEST THREE", "TEST3", 18, tokenAmount);
        TEST11 = new ERC20Token("TEST THREE", "TEST3", 18, tokenAmount);

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

        pool.depositLiquidity(shell, 10000 * (10 ** 18));

    }

    function testActivateShellWith11Tokens () public {
        pool.activateShell(shell);
        address[] memory allShells = pool.getActiveShellsForPair(address(TEST1), address(TEST2));
        address[] memory activeShells = pool.getActiveShellsForPair(address(TEST1), address(TEST2));
        emit log_addr_arr("all shells", allShells);
        emit log_addr_arr("active shells", activeShells);
    }

}