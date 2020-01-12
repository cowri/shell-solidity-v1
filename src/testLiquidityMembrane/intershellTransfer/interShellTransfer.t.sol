
pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";

import "../../CowriPool.sol";
import "../../ERC20Token.sol";
import "../../testSetup/setupShells.sol";

contract DappTest is DSTest, DSMath, ShellSetup {
    address shell1;
    address shell2;

    function setUp() public {

        setupPool();
        setupTokens();
        shell1 = setupShellABC();
        shell2 = setupShellABCD();

        uint256 amountToStake = 100 * WAD;
        uint256 deadline = now + 50;

        uint256 amount = pool.depositLiquidity(shell1, amountToStake * 3, deadline);
        emit log_named_uint("amount", amount);
        amount = pool.depositLiquidity(shell2, amountToStake * 4, deadline);
        emit log_named_uint("amount", amount);

    }

    function testInterShellTransfer () public {
        pool.interShellTransfer(shell1, shell2, 10 * WAD);

        // assertEq(pool.getShellBalanceOf(shell1, address(testA)), 5443310539593824530);
        // assertEq(pool.getShellBalanceOf(shell1, address(testB)), 5443310539593824530);
        // assertEq(pool.getShellBalanceOf(shell1, address(testC)), 10 * WAD);

        // assertEq(pool.getShellBalanceOf(shell2, address(testA)), 14556689460406175470);
        // assertEq(pool.getShellBalanceOf(shell2, address(testB)), 14556689460406175470);
        // assertEq(pool.getShellBalanceOf(shell2, address(testD)), 10 * WAD);

    }

}