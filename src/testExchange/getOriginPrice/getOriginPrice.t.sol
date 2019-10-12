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

        uint256 amount = 10000 * (10 ** 18);
        uint256 deadline = 0;

        shell1Liquidity = pool.depositLiquidity(shell1, amount, amount, deadline);
        shell2Liquidity = pool.depositLiquidity(shell2, amount * 3, amount * 3, deadline);

        pool.activateShell(shell1);
        pool.activateShell(shell2);

    }


    function testGetOriginPrice () public {

        uint256 amount = 100 * ( 10 ** 18 );
        uint256 deadline = 0;

        uint256 price1 = pool.getOriginPrice(address(testA), address(testB), amount);
        assertEq(price1, 99337748344370860927);
        pool.swapByOrigin(address(testA), address(testB), amount, amount / 2, deadline);

        uint256 price2 = pool.getOriginPrice(address(testB), address(testA), amount);
        assertEq(price2, 100662222418436272129);
        pool.swapByOrigin(address(testB), address(testA), amount, amount / 2, deadline);

        uint256 price3 = pool.getOriginPrice(address(testA), address(testC), amount);
        assertEq(price3, 99014229006085281365);
        pool.swapByOrigin(address(testA), address(testC), amount, amount / 2, deadline);

        uint256 price4 = pool.getOriginPrice(address(testC), address(testB), amount);
        assertEq(price4, 99994557837570967079);

    }

}