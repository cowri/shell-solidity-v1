pragma solidity ^0.5.6;

import "ds-test/test.sol";

<<<<<<< HEAD:src/testExchange/getOriginPrice/getOriginPrice.t.sol
import "../../Prototype.sol";
import "../../ERC20Token.sol";
=======
import "../Prototype.sol";
import "../Shell.sol";
import "../TOKEN.sol";
>>>>>>> master:src/prototypeOneTests/getOriginPrice.t.sol

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


    function testGetSwapRate () public {

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