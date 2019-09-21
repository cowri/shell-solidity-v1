


pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../ERC20Token.sol";
import "./SetupPool.sol";

contract TokenSetup is PoolSetup {

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
    ERC20Token TEST12;
    ERC20Token TEST13;
    ERC20Token TEST14;
    ERC20Token TEST15;
    ERC20Token TEST16;
    ERC20Token TEST17;

    function setupTokens () public {
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
        TEST12 = new ERC20Token("TEST THREE", "TEST3", 18, tokenAmount);
        TEST13 = new ERC20Token("TEST THREE", "TEST3", 18, tokenAmount);
        TEST14 = new ERC20Token("TEST THREE", "TEST3", 18, tokenAmount);
        TEST15 = new ERC20Token("TEST THREE", "TEST3", 18, tokenAmount);
        TEST16 = new ERC20Token("TEST THREE", "TEST3", 18, tokenAmount);
        TEST17 = new ERC20Token("TEST THREE", "TEST3", 18, tokenAmount);


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
        TEST12.approve(address(pool), tokenAmount);
        TEST13.approve(address(pool), tokenAmount);
        TEST14.approve(address(pool), tokenAmount);
        TEST15.approve(address(pool), tokenAmount);
        TEST16.approve(address(pool), tokenAmount);
        TEST17.approve(address(pool), tokenAmount);

    }
}