
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

contract BalancedSwapByTargetTest is AdaptersSetup, DSMath, DSTest {
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

        l.includeNumeraireAndReserve(dai, chaiAdapter);
        l.includeNumeraireAndReserve(usdc, cusdcAdapter);
        l.includeNumeraireAndReserve(usdt, usdtAdapter);

        l.includeAdapter(chai, chaiAdapter, chaiAdapter, weight);
        l.includeAdapter(dai, daiAdapter, chaiAdapter, weight);
        l.includeAdapter(cdai, cdaiAdapter, chaiAdapter, weight);
        l.includeAdapter(cusdc, cusdcAdapter, cusdcAdapter, weight);
        l.includeAdapter(usdc, usdcAdapter, cusdcAdapter, weight);
        l.includeAdapter(usdt, usdtAdapter, usdtAdapter, weight);

        l.setAlpha((5 * WAD) / 10);
        l.setBeta((25 * WAD) / 100);
        l.setFeeDerivative(WAD / 10);
        l.setFeeBase(500000000000000);

        l.balancedDeposit(300 * (10 ** 18));

    }

    event log_uint_arr(bytes32, uint256[]);

    function testBalancedSwap15AndATinyBitTarget () public {
        uint256 targetAmount = l.swapByTarget(dai, 20 * WAD, usdc, 15 * WAD, now);
        assertEq(targetAmount, 15007500000000000000);
    }

    function testBalancedSwap25AndATinyBitTarget () public {
        uint256 targetAmount = l.swapByTarget(dai, 30 * WAD, usdc, 25 * WAD, now);
        assertEq(targetAmount, 25012500156250000000);
    }

    function testBalancedSwap30TinyBitTarget () public {
        uint256 targetAmount = l.swapByTarget(dai, 9 * WAD, usdc, 30 * WAD, now);
        assertEq(targetAmount, 30065414226000156251);
    }

    function testBalancedSwap48Point25Target () public {
        uint256 targetAmount = l.swapByTarget(dai, 9 * WAD, usdc, 48250000000000000000, now);
        assertEq(targetAmount, 49382109995372719925);
    }

    function testFailBalancedSwap51Target () public {
        uint256 targetAmount = l.swapByTarget(dai, 9 * WAD, usdc, 50 * WAD, now);
    }


}