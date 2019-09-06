pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../PrototypeOne.sol";
import "../Shell.sol";
import "../TOKEN.sol";

contract DappTest is DSTest {

    PrototypeOne pool;
    address shell1;
    address shell2;
    TOKEN TEST1;
    TOKEN TEST2;
    TOKEN TEST3;
    uint256 shell1Liquidity;
    uint256 shell2Liquidity;

    function setUp () public {
        uint256 tokenAmount = 10000000000 * (10 ** 18);
        uint8 decimalAmount = 18;
        TEST1 = new TOKEN("TEST ONE", "TEST1", decimalAmount, tokenAmount);
        TEST2 = new TOKEN("TEST TWO", "TEST2", decimalAmount, tokenAmount);
        TEST3 = new TOKEN("TEST THREE", "TEST3", decimalAmount, tokenAmount);

        pool = new PrototypeOne();

        TEST1.approve(address(pool), tokenAmount);
        TEST2.approve(address(pool), tokenAmount);
        TEST3.approve(address(pool), tokenAmount);

        address[] memory shell1Addrs = new address[](2);
        shell1Addrs[0] = address(TEST1);
        shell1Addrs[1] = address(TEST2);
        shell1 = pool.createShell(shell1Addrs);

        address[] memory shell2Addrs = new address[](3);
        shell2Addrs[0] = address(TEST1);
        shell2Addrs[1] = address(TEST2);
        shell2Addrs[2] = address(TEST3);
        shell2 = pool.createShell(shell2Addrs);

        shell1Liquidity = pool.depositLiquidity(shell1, 1000 * ( 10 ** 18));
        shell2Liquidity = pool.depositLiquidity(shell2, 3000 * ( 10 ** 18));

    }


    function testGetSwapRate () public {

        // uint256 price1 = pool.getOriginPrice(100 * ( 10 ** 18 ), address(TEST1), address(TEST2));
        // assertEq(price1, 97560975609756097561);
        // pool.swap(address(TEST1), address(TEST2), 100 * ( 10 ** 18 ));

        // uint256 price2 = pool.getOriginPrice(100 * ( 10 ** 18 ), address(TEST2), address(TEST1));
        // assertEq(price2, 102437538086532602072);
        // pool.swap(address(TEST2), address(TEST1), 100 * ( 10 ** 18 ));

        // uint256 price3 = pool.getOriginPrice(100 * ( 10 ** 18 ), address(TEST1), address(TEST3));
        // assertEq(price3, 96831297574791998584);
        // pool.swap(address(TEST1), address(TEST3), 100 * ( 10 ** 18 ));

        // uint256 price4 = pool.getOriginPrice(100 * ( 10 ** 18), address(TEST3), address(TEST2));
        // assertEq(price4, 99955399304359977681);

    }

}