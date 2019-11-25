pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../CowriPool.sol";
import "../../ERC20Token.sol";
import "../../testSetup/setupShells.sol";

contract DappTest is DSTest, ShellSetup {

    address shell1;
    uint256 shell1Liquidity;

    function setUp () public {

        setupPool();
        setupTokens();
        shell1 = setupShellAB();

        uint256 amount = 10000 * ( 10 ** 18 );
        uint256 deadline = now + 50;

        shell1Liquidity = pool.depositLiquidity(shell1, amount, deadline);
        pool.activateShell(shell1);

    }


    function testSwapByOriginAtoBWith1Shell () public {

        uint256 amount = 100 * ( 10 ** 18 );
        uint256 deadline = now;

        assertEq(
            pool.macroSwapByOrigin(address(testA), address(testB), amount, amount / 2, deadline),
            9783738115554804744
        );

    }

}
