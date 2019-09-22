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


    function testSwapByTargetAtoBthenBtoAthenAtoCthenCtoB () public {

        uint256 swapAmount = 100 * ( 10 ** 18 );

        assertEq(
            pool.swapByTarget(swapAmount, address(testA), address(testB)),
            100671140939597315436
        );

        assertEq(
            pool.swapByTarget(swapAmount, address(testB), address(testA)),
            9932888908773656659
        );

        assertEq(
            pool.swapByTarget(swapAmount, address(testA), address(testC)),
            101014620477707726030
        );

        assertEq(
            pool.swapByTarget(swapAmount, address(testC), address(testB)),
            1000045194696492755
        );

    }

}