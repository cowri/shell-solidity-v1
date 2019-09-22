pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../Prototype.sol";
import "../../ERC20Token.sol";

contract DappTest is DSTest {

    Prototype pool;
    address shell1;
    address shell2;
    ERC20Token TEST1;
    ERC20Token TEST2;
    ERC20Token TEST3;
    uint256 shell1Liquidity;
    uint256 shell2Liquidity;

    function setUp () public {
        uint256 tokenAmount = 10000000000 * (10 ** 18);
        uint8 decimalAmount = 18;
        TEST1 = new ERC20Token("TEST ONE", "TEST1", decimalAmount, tokenAmount);
        TEST2 = new ERC20Token("TEST TWO", "TEST2", decimalAmount, tokenAmount);
        TEST3 = new ERC20Token("TEST THREE", "TEST3", decimalAmount, tokenAmount);

        pool = new Prototype();

        TEST1.approve(address(pool), tokenAmount);
        TEST2.approve(address(pool), tokenAmount);
        TEST3.approve(address(pool), tokenAmount);

        address[] memory shell1Addrs = new address[](2);
        shell1Addrs[0] = address(TEST1);
        shell1Addrs[1] = address(TEST2);
        shell1 = pool.createShell(shell1Addrs);

        address[] memory shell2Addrs = new address[](3);
        shell2Addrs[0] = address(TEST1);
        shell2Addrs[1] = address(TEST2);
        shell2Addrs[2] = address(TEST3);
        shell2 = pool.createShell(shell2Addrs);

        shell1Liquidity = pool.depositLiquidity(shell1, 10000 * ( 10 ** 18));
        shell2Liquidity = pool.depositLiquidity(shell2, 30000 * ( 10 ** 18));

        pool.activateShell(shell1);
        pool.activateShell(shell2);

    }


    function testSwapByTargetAtoB () public {

        uint256 swapAmount = 100 * ( 10 ** 18 );

        assertEq(
            pool.swapByTarget(swapAmount, address(TEST1), address(TEST2)),
            100671140939597315436
        );

    }

}