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
        shell1 = setup2TokenShell();
        shell2 = setup3TokenShell();

        shell1Liquidity = pool.depositLiquidity(shell1, 10000 * ( 10 ** 18));
        shell2Liquidity = pool.depositLiquidity(shell2, 30000 * ( 10 ** 18));

        pool.activateShell(shell1);
        pool.activateShell(shell2);

    }


    function testGetTargetPrice () public {

        uint256 price1 = pool.getTargetPrice(100 * ( 10 ** 18 ), address(TEST1), address(TEST2));
        assertEq(price1, 100250626566416040100);
        pool.swapByTarget(100 * ( 10 ** 18 ), address(TEST1), address(TEST2));

        uint256 price2 = pool.getTargetPrice(100 * ( 10 ** 18 ), address(TEST2), address(TEST1));
        assertEq(price2, 99749375003916015564);
        pool.swapByTarget(100 * ( 10 ** 18 ), address(TEST2), address(TEST1));

        uint256 price3 = pool.getTargetPrice(100 * ( 10 ** 18 ), address(TEST1), address(TEST3));
        assertEq(price3, 100335076822491010134);
        pool.swapByTarget(100 * ( 10 ** 18 ), address(TEST1), address(TEST3));

        uint256 price4 = pool.getTargetPrice(100 * ( 10 ** 18), address(TEST3), address(TEST2));
        assertEq(price4, 100000628661969066939);

    }

}