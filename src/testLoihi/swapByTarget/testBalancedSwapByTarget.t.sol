pragma solidity ^0.5.6;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "ds-test/test.sol";
import "ds-math/math.sol";
import "../flavorsSetup.sol";
import "../adaptersSetup.sol";
import "../../Loihi.sol";

contract BalancedSwapByTargetTest is AdaptersSetup, DSMath, DSTest {
    Loihi l;

    function setUp() public {

        setupFlavors();
        setupAdapters();
        l = new Loihi(chai, cdai, dai, pot, cusdc, usdc, usdt);
        approveFlavors(address(l));
        
        // setupFlavors();
        // setupAdapters();
        // l = new Loihi(address(0), address(0), address(0), address(0), address(0), address(0), address(0));
        // approveFlavors(address(l));


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

        l.proportionalDeposit(300 * (10 ** 18));

    }

    event log_uint_arr(bytes32, uint256[]);

    function testBalancedSwap15Target () public {
        uint256 targetAmount = l.swapByTarget(dai, 200 * WAD, usdc, 15 * WAD, now);
        assertEq(targetAmount, 15007500000000000000);
    }

    function testBalancedSwap25Target () public {
        uint256 targetAmount = l.swapByTarget(dai, 300 * WAD, usdc, 25 * WAD, now);
        assertEq(targetAmount, 25012500156250000000);
    }

    function testBalancedSwap30Target () public {
        uint256 targetAmount = l.swapByTarget(dai, 900 * WAD, usdc, 30 * WAD, now);
        assertEq(targetAmount, 30065414226000156251);
    }

    function testBalancedSwap48Point25Target () public {
        uint256 targetAmount = l.swapByTarget(dai, 500 * WAD, usdc, 48250000000000000000, now);
        assertEq(targetAmount, 49382109995372719925);
    }

    function testFailBalancedSwap51Target () public {
        uint256 targetAmount = l.swapByTarget(dai, 900 * WAD, usdc, 50 * WAD, now);
    }

}