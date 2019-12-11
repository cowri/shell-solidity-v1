pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../CowriPool.sol";
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

        uint256 amount = 10000 * (10 ** 18);
        uint256 deadline = now + 50;

        shell1Liquidity = pool.depositLiquidity(shell1, amount, deadline);
        shell2Liquidity = pool.depositLiquidity(shell2, amount * 3, deadline);

        pool.activateShell(shell1);
        pool.activateShell(shell2);

    }

    event log(bytes32);

    function testGetOriginPrice () public {

        uint256 amount = 100 * ( 10 ** 18 );
        uint256 deadline = now + 50;

        emit log("ying");

        uint256 price1 = pool.getOriginPrice(address(testA), address(testB), amount);
        assertEq(price1, 99130537445712109313);
        pool.macroSwapByOrigin(address(testA), address(testB), amount, amount / 2, deadline);

        emit log("yang");
        emit log("yang");
        emit log("yang");
        uint256 price2 = pool.getOriginPrice(address(testB), address(testA), amount);
        emit log("yang");
        assertEq(price2, 100450803903137445793);
        emit log("yang");
        pool.macroSwapByOrigin(address(testB), address(testA), amount, amount / 2, deadline);

        emit log("yang");
        emit log("zing");

        uint256 price3 = pool.getOriginPrice(address(testA), address(testC), amount);
        assertEq(price3, 98807059533876708218);
        pool.macroSwapByOrigin(address(testA), address(testC), amount, amount / 2, deadline);

        emit log("zang");

        uint256 price4 = pool.getOriginPrice(address(testC), address(testB), amount);
        assertEq(price4, 99785929156688468886);

        emit log("zlang");

    }

}