pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../CowriPool.sol";
import "../testSetup/setupShells.sol";

contract DappTest is DSTest, DSMath, ShellSetup {

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
        uint256 deadline = now + 50;

        shell1Liquidity = pool.depositLiquidity(shell1, amount, deadline);
        shell2Liquidity = pool.depositLiquidity(shell2, amount * 3, deadline);

        pool.activateShell(shell1);
        pool.activateShell(shell2);

    }

    function testGeometricMean () public { 

        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 10 * WAD;
        amounts[1] = 10 * WAD;

        (uint256 prev, uint256 next) = pool.calculateDifferenceInGeometricMeans(shell1, amounts);

        // emit log_named_uint("prev", prev);
        // emit log_named_uint("next", next);

    }



}