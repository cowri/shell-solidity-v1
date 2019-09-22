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


    function testSwapByTargetAtoBthenBtoAthenAtoCthenCtoB () public {

        uint256 swapAmount = 100 * ( 10 ** 18 );

        assertEq(
            pool.swapByTarget(swapAmount, address(TEST1), address(TEST2)),
            100250626566416040100
        );

        assertEq(
            pool.swapByTarget(swapAmount, address(TEST2), address(TEST1)),
            99749375003916015564
        );

        assertEq(
            pool.swapByTarget(swapAmount, address(TEST1), address(TEST3)),
            100335076822491010134
        );

        assertEq(
            pool.swapByTarget(swapAmount, address(TEST3), address(TEST2)),
            100000628661969066939
        );

    }

}