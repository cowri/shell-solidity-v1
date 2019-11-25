pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../CowriPool.sol";
import "../../ERC20Token.sol";
import "../../Shell.sol";
import "../../testSetup/setupShells.sol";

contract DappTest is DSTest, ShellSetup {

    address shell1;
    address shell2;
    address shell3;
    address shell4;
    address shell5;
    address shell6;
    address shell7;
    address shell8;
    uint256 shell1Liquidity;
    uint256 shell2Liquidity;
    uint256 shell3Liquidity;
    uint256 shell4Liquidity;
    uint256 shell5Liquidity;
    uint256 shell6Liquidity;
    uint256 shell7Liquidity;
    uint256 shell8Liquidity;

    function setUp () public {

        setupPool();
        setupTokens();
        shell1 = setupShellAB();
        shell2 = setupShellABC();
        shell3 = setupShellABD();
        shell4 = setupShellABE();
        shell5 = setupShellABF();
        shell6 = setupShellABG();
        shell7 = setupShellABCD();
        shell8 = setupShellABDE();

        uint256 amount = 10000 * ( 10 ** 18 );
        uint256 deadline = now + 50;

        shell1Liquidity = pool.depositLiquidity(shell1, amount, deadline);
        shell2Liquidity = pool.depositLiquidity(shell2, amount, deadline);
        shell3Liquidity = pool.depositLiquidity(shell3, amount, deadline);
        shell4Liquidity = pool.depositLiquidity(shell4, amount, deadline);
        shell5Liquidity = pool.depositLiquidity(shell5, amount, deadline);
        shell6Liquidity = pool.depositLiquidity(shell6, amount, deadline);
        shell7Liquidity = pool.depositLiquidity(shell7, amount, deadline);
        shell8Liquidity = pool.depositLiquidity(shell8, amount, deadline);


        pool.activateShell(shell1);
        pool.activateShell(shell2);
        pool.activateShell(shell3);
        pool.activateShell(shell4);
        pool.activateShell(shell5);
        pool.activateShell(shell6);
        pool.activateShell(shell7);
        pool.activateShell(shell8);

        emit log_named_uint("shell 3 liq", shell3Liquidity);
        emit log_named_uint("shell 3 D balance ", pool.getShellBalanceOf(shell3, address(testD)));
        emit log_addrs("shell 3 tokens", Shell(shell3).getTokens());
    }

    event log_addrs(bytes32 key, address[] value);

    function testOmnibus () public {

        address[] memory _shells = new address[](6);
        address[] memory tokens = new address[](6);
        uint256[] memory pairs = new uint256[](12);
        uint256[] memory amounts = new uint256[](6);
        uint256[] memory limits = new uint256[](6);
        bool[] memory types = new bool[](6);


        tokens[0] = address(testA);
        tokens[1] = address(testB);
        tokens[2] = address(testC);
        tokens[3] = address(testD);
        tokens[4] = address(testE);


        _shells[0] = shell1; // A & B
        pairs[0] = 0; // origin A
        pairs[1] = 1; // target B
        amounts[0] = 100 * ( 10 ** 18 ); // origin amount
        limits[0] = 50 * ( 10 ** 18 ); // min target amount
        types[0] = true; // origin trade

        _shells[1] = shell1; // A &  B
        pairs[2] = 0; // origin A
        pairs[3] = 1; // target B
        amounts[1] = 100 * ( 10 ** 18 ); // target amount
        limits[1] = 150 * ( 10 ** 18 ); // max origin amount
        types[1] = false; // target trade

        _shells[2] = shell3; // A & B & D
        pairs[4] = 1; // origin B
        pairs[5] = 3; // target D
        amounts[2] = 100 * ( 10 ** 18 );
        limits[2] = 50 * ( 10 ** 18 );
        types[2] = true;

        _shells[3] = shell3; // A & B & D
        pairs[6] = 1; // origin B
        pairs[7] = 3; // target D
        amounts[3] = 100 * ( 10 ** 18 );
        limits[3] = 150 * ( 10 ** 18 );
        types[3] = false;

        _shells[4] = shell4; // A & B & E
        pairs[8] = 1; // origin B
        pairs[9] = 4; // target E
        amounts[4] = 100 * ( 10 ** 18 );
        limits[4] = 50 * ( 10 ** 18 );
        types[4] = true;

        _shells[5] = address(0);
        pairs[10] = 1;
        pairs[11] = 2;
        amounts[5] = 100 * (10 ** 18);
        limits[5] = 150 * (10 ** 18);
        types[4] = true;

        uint256 deadline = now + 50;

        emit log_named_address("testA", address(testA));
        emit log_named_address("testB", address(testB));
        emit log_named_address("testC", address(testC));
        emit log_named_address("testD", address(testD));
        emit log_named_address("testE", address(testE));

        emit log_named_uint("shell 3 balance d",
            pool.getShellBalanceOf(
                shell3,
                address(testD)
            )
        );

        uint256[] memory results = pool.omnibus(
            _shells,
            tokens,
            pairs,
            amounts,
            limits,
            types,
            deadline
        );

        emit log_arr("results", results);

    }

    event log_arr(bytes32 key, uint256[] val);

}