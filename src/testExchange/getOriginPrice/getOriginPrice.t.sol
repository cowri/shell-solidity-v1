pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../Prototype.sol";
import "../../ERC20Token.sol";
import "../../testSetup/setupShells.sol";

contract DappTest is DSTest, ShellSetup {

    address shell1;
    address shell2;
    uint256 shell1Liquidity;
    uint256 shell2Liquidity;

    function setUp () public {

        setupPool();
        setupTokens();
        shell1 = setupShellAB();
        shell2 = setupShellABC();

        shell1Liquidity = pool.depositLiquidity(shell1, 10000 * ( 10 ** 18));
        shell2Liquidity = pool.depositLiquidity(shell2, 30000 * ( 10 ** 18));

        pool.activateShell(shell1);
        pool.activateShell(shell2);

    }


    function testGetOriginPrice () public {

        uint256 price1 = pool.getOriginPrice(100 * ( 10 ** 18 ), address(testA), address(testB));
        assertEq(price1, 99337748344370860927);
        pool.swapByOrigin(100 * ( 10 ** 18 ), address(testA), address(testB));

        uint256 price2 = pool.getOriginPrice(100 * ( 10 ** 18 ), address(testB), address(testA));
        assertEq(price2, 100662222418436272129);
        pool.swapByOrigin(100 * ( 10 ** 18 ), address(testB), address(testA));

        uint256 price3 = pool.getOriginPrice(100 * ( 10 ** 18 ), address(testA), address(testC));
        assertEq(price3, 99014229006085281365);
        pool.swapByOrigin(100 * ( 10 ** 18 ), address(testA), address(testC));

        uint256 price4 = pool.getOriginPrice(100 * ( 10 ** 18), address(testC), address(testB));
        assertEq(price4, 99994557837570967079);

    }

}