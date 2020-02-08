pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../../Loihi.sol";
import "../../ERC20I.sol";
import "../flavorsSetup.sol";
import "../adaptersSetup.sol";
import "../../ChaiI.sol";

contract PotMock {
    constructor () public { }
    function rho () public returns (uint256) { return now - 500; }
    function drip () public returns (uint256) { return (10 ** 18) * 2; }
    function chi () public returns (uint256) { return (10 ** 18) * 2; }
}

contract BalancedSelectiveDepositTest is AdaptersSetup, DSMath, DSTest {
    Loihi l;

    function setUp() public {
        setupFlavors();
        setupAdapters();

        address pot = address(new PotMock());
        l = new Loihi(
            chai, cdai, dai, pot,
            cusdc, usdc,
            usdt
        );

        ERC20I(chai).approve(address(l), 100000 * (10 ** 18));
        ERC20I(cdai).approve(address(l), 100000 * (10 ** 18));
        ERC20I(dai).approve(address(l), 100000 * (10 ** 18));
        ERC20I(cusdc).approve(address(l), 100000 * (10 ** 18));
        ERC20I(usdc).approve(address(l), 100000 * (10 ** 18));
        ERC20I(usdt).approve(address(l), 100000 * (10 ** 18));

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

    function testSelectiveDeposit10x0y0z () public {
        uint256[] memory amounts = new uint256[](3);
        address[] memory tokens = new address[](3);

        tokens[0] = dai; amounts[0] = WAD * 10;
        tokens[1] = usdc; amounts[1] = 0;
        tokens[2] = usdt; amounts[2] = 0;

        uint256 newShells = l.selectiveDeposit(tokens, amounts);
        assertEq(newShells, 9999999999999999990);
    }

    function testSelectiveDeposit10x15y0z () public {
        uint256[] memory amounts = new uint256[](3);
        address[] memory tokens = new address[](3);

        tokens[0] = dai; amounts[0] = WAD * 10;
        tokens[1] = usdc; amounts[1] = WAD * 15;
        tokens[2] = usdt; amounts[2] = 0;

        uint256 newShells = l.selectiveDeposit(tokens, amounts);
        assertEq(newShells, 24999999999999999975);
    }

    function testSelectiveDeposit10x25y20z () public {
        uint256[] memory amounts = new uint256[](3);
        address[] memory tokens = new address[](3);

        tokens[0] = dai; amounts[0] = WAD * 10;
        tokens[1] = usdc; amounts[1] = WAD * 15;
        tokens[2] = usdt; amounts[2] = WAD * 20;

        uint256 newShells = l.selectiveDeposit(tokens, amounts);
        assertEq(newShells, 44999999999999999955);
    }

    function testSelectiveDeposit42point857x0y0z () public {
        uint256[] memory amounts = new uint256[](3);
        address[] memory tokens = new address[](3);

        tokens[0] = dai; amounts[0] = 42857000000000000000;
        tokens[1] = usdc; amounts[1] = 0;
        tokens[2] = usdt; amounts[2] = 0;

        uint256 newShells = l.selectiveDeposit(tokens, amounts);
        assertEq(newShells, 42856999999999999957);
    }

    function testSelectiveDeposit45x0y0z () public {
        uint256[] memory amounts = new uint256[](3);
        address[] memory tokens = new address[](3);

        tokens[0] = dai; amounts[0] = 45 * WAD;
        tokens[1] = usdc; amounts[1] = 0;
        tokens[2] = usdt; amounts[2] = 0;

        uint256 newShells = l.selectiveDeposit(tokens, amounts);
        assertEq(newShells, 44998641304347826041);

    }

    function testSelectiveDeposit99point99x0y0z () public {
        uint256[] memory amounts = new uint256[](3);
        address[] memory tokens = new address[](3);

        tokens[0] = dai; amounts[0] = 99990000000000000000;
        tokens[1] = usdc; amounts[1] = 0;
        tokens[2] = usdt; amounts[2] = 0;

        uint256 newShells = l.selectiveDeposit(tokens, amounts);
        assertEq(newShells, 99156937481249531141);

    }

    function testFailSelectiveDeposit150x0y0z () public {
        uint256[] memory amounts = new uint256[](3);
        address[] memory tokens = new address[](3);

        tokens[0] = dai; amounts[0] = 150 * WAD;
        tokens[1] = usdc; amounts[1] = 0;
        tokens[2] = usdt; amounts[2] = 0;

        uint256 newShells = l.selectiveDeposit(tokens, amounts);

    }

    function testSelectiveDeposit10x0y60z () public {
        uint256[] memory amounts = new uint256[](3);
        address[] memory tokens = new address[](3);

        tokens[0] = dai; amounts[0] = 10 * WAD;
        tokens[1] = usdc; amounts[1] = 0;
        tokens[2] = usdt; amounts[2] = 60 * WAD;

        uint256 newShells = l.selectiveDeposit(tokens, amounts);
        assertEq(newShells, 69972409909909909837);

    }

    function testSelectiveDeposit100x100y25z () public {
        uint256[] memory amounts = new uint256[](3);
        address[] memory tokens = new address[](3);

        tokens[0] = dai; amounts[0] = 100 * WAD;
        tokens[1] = usdc; amounts[1] = 100 * WAD;
        tokens[2] = usdt; amounts[2] = 25 * WAD;

        uint256 newShells = l.selectiveDeposit(tokens, amounts);
        assertEq(newShells, 224999999999999999775);

    }

    function testSelectiveDeposit175x175y5z () public {
        uint256[] memory amounts = new uint256[](3);
        address[] memory tokens = new address[](3);

        tokens[0] = dai; amounts[0] = 175 * WAD;
        tokens[1] = usdc; amounts[1] = 175 * WAD;
        tokens[2] = usdt; amounts[2] = 5 * WAD;

        uint256 newShells = l.selectiveDeposit(tokens, amounts);
        assertEq(newShells, 354996024173027989465);

    }

    function testFailSelectiveDeposit10x10y200z () public {
        uint256[] memory amounts = new uint256[](3);
        address[] memory tokens = new address[](3);

        tokens[0] = dai; amounts[0] = 10 * WAD;
        tokens[1] = usdc; amounts[1] = 10 * WAD;
        tokens[2] = usdt; amounts[2] = 200 * WAD;

        uint256 newShells = l.selectiveDeposit(tokens, amounts);
        assertEq(newShells, 42856999999999999957);

    }

}