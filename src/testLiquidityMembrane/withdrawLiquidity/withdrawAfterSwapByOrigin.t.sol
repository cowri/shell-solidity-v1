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

        shell1Liquidity = pool.depositLiquidity(shell1, 10000 * (10 ** 18));
        shell2Liquidity = pool.depositLiquidity(shell2, 30000 * (10 ** 18));

        pool.activateShell(shell1);
        pool.activateShell(shell2);

        pool.swapByOrigin(100 * (10 ** 18), address(TEST1), address(TEST2));
        pool.swapByOrigin(100 * (10 ** 18), address(TEST2), address(TEST1));
        pool.swapByOrigin(100 * (10 ** 18), address(TEST1), address(TEST3));
        pool.swapByOrigin(100 * (10 ** 18), address(TEST3), address(TEST2));

    }


    function testWithdrawAfterSwapByOrigin () public {

        uint256 shell1Token1 = pool.getShellBalanceOf(shell1, address(TEST1));
        uint256 shell1Token2 = pool.getShellBalanceOf(shell1, address(TEST2));
        assertEq(shell1Token1, 9999937656249025878891);
        assertEq(shell1Token2, 10000062344139650872818);

        uint256 shell2Token1 = pool.getShellBalanceOf(shell2, address(TEST1));
        uint256 shell2Token2 = pool.getShellBalanceOf(shell2, address(TEST2));
        uint256 shell2Token3 = pool.getShellBalanceOf(shell2, address(TEST3));
        assertEq(shell2Token1, 30099812968747077636673);
        assertEq(shell2Token2, 29900187514327588720643);
        assertEq(shell2Token3, 30000331606607824156224);

        uint256[] memory shell1Withdrawal = pool.withdrawLiquidity(shell1, 500 * ( 10 ** 18 ));
        assertEq(shell1Withdrawal[0], 2500015586034912718);
        assertEq(shell1Withdrawal[1], 249998441406225646972);

        uint256[] memory shell2Withdrawal = pool.withdrawLiquidity(shell2, 1500 * ( 10 ** 18 ));
        assertEq(shell2Withdrawal[0], 4983364585721264786);
        assertEq(shell2Withdrawal[1], 501663549479117960611);
        assertEq(shell2Withdrawal[2], 50000552677679706);

    }

}