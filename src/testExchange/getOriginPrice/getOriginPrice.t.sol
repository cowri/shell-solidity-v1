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


    function testGetOriginPrice () public {

        uint256 price1 = pool.getOriginPrice(100 * ( 10 ** 18 ), address(TEST1), address(TEST2));
        assertEq(price1, 99750623441396508728);
        pool.swapByOrigin(100 * ( 10 ** 18 ), address(TEST1), address(TEST2));

        uint256 price2 = pool.getOriginPrice(100 * ( 10 ** 18 ), address(TEST2), address(TEST1));
        assertEq(price2, 100249375003896484436);
        pool.swapByOrigin(100 * ( 10 ** 18 ), address(TEST2), address(TEST1));

        uint256 price3 = pool.getOriginPrice(100 * ( 10 ** 18 ), address(TEST1), address(TEST3));
        assertEq(price3, 99668393392175843776);
        pool.swapByOrigin(100 * ( 10 ** 18 ), address(TEST1), address(TEST3));

        uint256 price4 = pool.getOriginPrice(100 * ( 10 ** 18), address(TEST3), address(TEST2));
        assertEq(price4, 99999518091363897811);

    }

}