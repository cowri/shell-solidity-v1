
pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";

import "../../CowriPool.sol";
import "../../ERC20Token.sol";
import "../../testSetup/setupShells.sol";

contract DappTest is DSTest, DSMath, ShellSetup {
    address shell;

    function setUp() public {
        setupPool();
        setupTokens();
        shell = setupShellABC();
        // pool.depositLiquidity(shell, 1, now + 500);
        pool.depositLiquidity(shell, 300 * WAD, now + 500);
    }

    function testDepositLiquidity () public {

        uint256[] memory amounts = new uint256[](3);
        amounts[0] = 11 * WAD;
        amounts[1] = 0 * WAD;
        amounts[2] = 0 * WAD;

        uint256 amount = pool.depositSelectiveLiquidity(shell, amounts);

    }

}