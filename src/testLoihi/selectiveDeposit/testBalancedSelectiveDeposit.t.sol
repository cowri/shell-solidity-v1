pragma solidity ^0.5.6;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "ds-test/test.sol";
import "ds-math/math.sol";
import "../flavorsSetup.sol";
import "../adaptersSetup.sol";
import "../../Loihi.sol";


contract BalancedSelectiveDepositTest is AdaptersSetup, DSMath, DSTest {
    Loihi l;

    function setUp() public {

        // setupFlavors();
        // setupAdapters();
        // l = new Loihi(chai, cdai, dai, pot, cusdc, usdc, usdt);
        // approveFlavors(address(l));
        
        setupFlavors();
        setupAdapters();
        l = new Loihi(address(0), address(0), address(0), address(0), address(0), address(0), address(0));
        approveFlavors(address(l));

        uint256 weight = WAD / 3;

        l.includeNumeraireAndReserve(dai, cdaiAdapter);
        l.includeNumeraireAndReserve(usdc, cusdcAdapter);
        l.includeNumeraireAndReserve(usdt, usdtAdapter);

        l.includeAdapter(chai, chaiAdapter, cdaiAdapter, weight);
        l.includeAdapter(dai, daiAdapter, cdaiAdapter, weight);
        l.includeAdapter(cdai, cdaiAdapter, cdaiAdapter, weight);
        l.includeAdapter(cusdc, cusdcAdapter, cusdcAdapter, weight);
        l.includeAdapter(usdc, usdcAdapter, cusdcAdapter, weight);
        l.includeAdapter(usdt, usdtAdapter, usdtAdapter, weight);

        l.setAlpha((5 * WAD) / 10);
        l.setBeta((25 * WAD) / 100);
        l.setFeeDerivative(WAD / 10);
        l.setFeeBase(500000000000000);

        uint256 shells = l.proportionalDeposit(300 * (10 ** 18));

    }

    // function testSelectiveDeposit10x0y0z () public {
    //     uint256[] memory amounts = new uint256[](3);
    //     address[] memory tokens = new address[](3);

    //     tokens[0] = dai; amounts[0] = 10 * WAD;
    //     tokens[1] = usdc; amounts[1] = 0;
    //     tokens[2] = usdt; amounts[2] = 0;

    //     uint256 newShells = l.selectiveDeposit(tokens, amounts);
    //     newShells /= 100000000000;
    //     assertEq(newShells, 99999999);

    // }

    // function testSelectiveDeposit10x15y0z () public {
    //     uint256[] memory amounts = new uint256[](3);
    //     address[] memory tokens = new address[](3);

    //     tokens[0] = dai; amounts[0] = 10 * WAD;
    //     tokens[1] = usdc; amounts[1] = 15 * 1000000;
    //     tokens[2] = usdt; amounts[2] = 0;

    //     uint256 newShells = l.selectiveDeposit(tokens, amounts);
    //     newShells /= 1000000000000;
    //     assertEq(newShells, 24999999);
    // }

    // function testSelectiveDeposit10x25y20z () public {
    //     uint256[] memory amounts = new uint256[](3);
    //     address[] memory tokens = new address[](3);

    //     tokens[0] = dai; amounts[0] = 10 * WAD;
    //     tokens[1] = usdc; amounts[1] = 15 * 1000000;
    //     tokens[2] = usdt; amounts[2] = 20 * WAD;

    //     uint256 newShells = l.selectiveDeposit(tokens, amounts);
    //     newShells /= 1000000000000;
    //     assertEq(newShells, 44999999);
    // }

    // function testSelectiveDeposit42point857x0y0z () public {
    //     uint256[] memory amounts = new uint256[](1);
    //     address[] memory tokens = new address[](1);

    //     tokens[0] = dai; amounts[0] = 42857000000000000000;

    //     uint256 newShells = l.selectiveDeposit(tokens, amounts);
    //     newShells /= 1000000000000;
    //     assertEq(newShells, 42856999);
    // }

    // function testSelectiveDeposit45x0y0z () public {
    //     uint256[] memory amounts = new uint256[](1);
    //     address[] memory tokens = new address[](1);

    //     tokens[0] = dai; amounts[0] = 45 * WAD;

    //     uint256 newShells = l.selectiveDeposit(tokens, amounts);
    //     newShells /= 1000000000000;
    //     assertEq(newShells, 44998641);

    // }

    // function testSelectiveDeposit99point99x0y0z () public {
    //     uint256[] memory amounts = new uint256[](1);
    //     address[] memory tokens = new address[](1);

    //     tokens[0] = dai; amounts[0] = 99990000000000000000;

    //     uint256 newShells = l.selectiveDeposit(tokens, amounts);
    //     newShells /= 1000000000000;
    //     assertEq(newShells, 99156936);

    // }

    // function testFailSelectiveDeposit150x0y0z () public {
    //     uint256[] memory amounts = new uint256[](1);
    //     address[] memory tokens = new address[](1);

    //     tokens[0] = dai; amounts[0] = 150 * WAD;

    //     uint256 newShells = l.selectiveDeposit(tokens, amounts);

    // }

    // function testSelectiveDeposit10x0y60z () public {
    //     uint256[] memory amounts = new uint256[](2);
    //     address[] memory tokens = new address[](2);

    //     tokens[0] = dai; amounts[0] = 10 * WAD;
    //     tokens[1] = usdt; amounts[1] = 60 * WAD;

    //     uint256 newShells = l.selectiveDeposit(tokens, amounts);
    //     newShells /= 1000000000000;
    //     assertEq(newShells, 69972409);

    // }

    // function testSelectiveDeposit100x100y25z () public {
    //     uint256[] memory amounts = new uint256[](3);
    //     address[] memory tokens = new address[](3);

    //     tokens[0] = dai; amounts[0] = 100 * WAD;
    //     tokens[1] = usdc; amounts[1] = 100 * 1000000;
    //     tokens[2] = usdt; amounts[2] = 25 * WAD;

    //     uint256 newShells = l.selectiveDeposit(tokens, amounts);
    //     newShells /= 10000000000000;
    //     assertEq(newShells, 22499999);

    // }

    // function testSelectiveDeposit175x175y5z () public {
    //     uint256[] memory amounts = new uint256[](3);
    //     address[] memory tokens = new address[](3);

    //     tokens[0] = dai; amounts[0] = 175 * WAD;
    //     tokens[1] = usdc; amounts[1] = 175 * 1000000;
    //     tokens[2] = usdt; amounts[2] = 5 * WAD;

    //     uint256 newShells = l.selectiveDeposit(tokens, amounts);
    //     newShells /= 10000000000000;
    //     assertEq(newShells, 35499602);

    // }

    // function testFailSelectiveDeposit10x10y200z () public {
    //     uint256[] memory amounts = new uint256[](3);
    //     address[] memory tokens = new address[](3);

    //     tokens[0] = dai; amounts[0] = 10 * WAD;
    //     tokens[1] = usdc; amounts[1] = 10 * 1000000;
    //     tokens[2] = usdt; amounts[2] = 200 * WAD;

    //     uint256 newShells = l.selectiveDeposit(tokens, amounts);
    //     assertEq(newShells, 42856999999999999957);

    // }

}