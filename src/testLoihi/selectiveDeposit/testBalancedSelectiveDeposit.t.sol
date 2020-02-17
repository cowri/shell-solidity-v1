pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../loihiSetup.sol";

contract BalancedSelectiveDepositTest is LoihiSetup, DSMath, DSTest {

    function setUp() public {

        setupFlavors();
        setupAdapters();
        setupLoihi();
        approveFlavors(address(l));
        includeAdapters(address(l), 1);

        uint256 shells = l.proportionalDeposit(300 * (10 ** 18));

    }

    function testSelectiveDeposit10x0y0z () public {
        uint256[] memory amounts = new uint256[](1);
        address[] memory tokens = new address[](1);

        tokens[0] = dai; amounts[0] = 10 * WAD;

        uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
        newShells /= 100000000000;
        assertEq(newShells, 100000001);

    }

    function testSelectiveDeposit10x15y0z () public {
        uint256[] memory amounts = new uint256[](2);
        address[] memory tokens = new address[](2);

        tokens[0] = dai; amounts[0] = 10 * WAD;
        tokens[1] = usdc; amounts[1] = 15 * 1000000;

        uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
        newShells /= 1000000000000;
        assertEq(newShells, 25000000);
    }

    function testSelectiveDeposit10x25y20z () public {
        uint256[] memory amounts = new uint256[](3);
        address[] memory tokens = new address[](3);

        tokens[0] = dai; amounts[0] = 10 * WAD;
        tokens[1] = usdc; amounts[1] = 15 * 1000000;
        tokens[2] = usdt; amounts[2] = 20 * 1000000;

        uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
        newShells /= 1000000000000;
        assertEq(newShells, 45000000);

    }

    function testSelectiveDeposit42point857x0y0z () public {
        uint256[] memory amounts = new uint256[](1);
        address[] memory tokens = new address[](1);

        tokens[0] = dai; amounts[0] = 42857000000000000000;

        uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
        newShells /= 1000000000000;
        assertEq(newShells, 42857000);

    }

    function testSelectiveDeposit45x0y0z () public {
        uint256[] memory amounts = new uint256[](1);
        address[] memory tokens = new address[](1);

        tokens[0] = dai; amounts[0] = 45 * WAD;

        uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
        newShells /= 1000000000000;
        assertEq(newShells, 44998641);

    }

    function testSelectiveDeposit99point99x0y0z () public {
        uint256[] memory amounts = new uint256[](1);
        address[] memory tokens = new address[](1);

        tokens[0] = dai; amounts[0] = 99990000000000000000;

        uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
        newShells /= 1000000000000;
        assertEq(newShells, 99156938);

    }

    function testFailSelectiveDeposit150x0y0z () public {
        uint256[] memory amounts = new uint256[](1);
        address[] memory tokens = new address[](1);

        tokens[0] = dai; amounts[0] = 150 * WAD;

        uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);

    }

    function testSelectiveDeposit10x0y60z () public {
        uint256[] memory amounts = new uint256[](2);
        address[] memory tokens = new address[](2);

        tokens[0] = dai; amounts[0] = 10 * WAD;
        tokens[1] = usdt; amounts[1] = 60 * 1000000;

        uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
        newShells /= 1000000000000;
        assertEq(newShells, 69972410);

    }

    function testSelectiveDeposit100x100y25z () public {
        uint256[] memory amounts = new uint256[](3);
        address[] memory tokens = new address[](3);

        tokens[0] = dai; amounts[0] = 100 * WAD;
        tokens[1] = usdc; amounts[1] = 100 * 1000000;
        tokens[2] = usdt; amounts[2] = 25 * 1000000;

        uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
        newShells /= 10000000000000;
        assertEq(newShells, 22500000);

    }

    function testSelectiveDeposit175x175y5z () public {
        uint256[] memory amounts = new uint256[](3);
        address[] memory tokens = new address[](3);

        tokens[0] = dai; amounts[0] = 175 * WAD;
        tokens[1] = usdc; amounts[1] = 175 * 1000000;
        tokens[2] = usdt; amounts[2] = 5 * 1000000;

        uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
        newShells /= 10000000000000;
        assertEq(newShells, 35499602);

    }

    function testFailSelectiveDeposit10x10y200z () public {
        uint256[] memory amounts = new uint256[](3);
        address[] memory tokens = new address[](3);

        tokens[0] = dai; amounts[0] = 10 * WAD;
        tokens[1] = usdc; amounts[1] = 10 * 1000000;
        tokens[2] = usdt; amounts[2] = 200 * 1000000;

        uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
        assertEq(newShells, 42856999999999999957);

    }

}