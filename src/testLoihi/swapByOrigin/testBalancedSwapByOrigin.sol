pragma solidity ^0.5.6;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "ds-test/test.sol";
import "ds-math/math.sol";
import "../flavorsSetup.sol";
import "../adaptersSetup.sol";
import "../../IAdapter.sol";
import "../../Loihi.sol";

contract BalancedSwapByOriginTest is AdaptersSetup, DSMath, DSTest {
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

        emit log_named_address("me", address(this));

        l.proportionalDeposit(300 * (10 ** 18));

    }

    function testSwap10Origin () public {
        uint256 targetAmount = l.swapByOrigin(dai, 10 * WAD, usdc, 9 * WAD, now);
        assertEq(targetAmount, 9995000);
    }

    function testSwap25Origin () public {
        uint256 targetAmount = l.swapByOrigin(dai, 25 * WAD, cusdc, 9 * WAD, now);
        uint256 numeraireAmount = IAdapter(cusdcAdapter).getNumeraireAmount(targetAmount);
        numeraireAmount /= 10000000000;
        assertEq(numeraireAmount, 2498749900);
    }

    function testSwap40Origin () public {
        uint256 targetAmount = l.swapByOrigin(dai, 40 * WAD, cusdc, 9 * WAD, now);
        uint256 numeraireAmount = IAdapter(cusdcAdapter).getNumeraireAmount(targetAmount);
        numeraireAmount /= 10000000000;
        assertEq(numeraireAmount, 3953692000);
    }

    function testSwap50Origin () public {
        uint256 targetAmount = l.swapByOrigin(dai, 50 * WAD - 10000000000000, usdc, 9 * WAD, now);
        assertEq(targetAmount, 48756459);
    }

    function testFailSwap80Origin () public {
        uint256 targetAmount = l.swapByOrigin(dai, 80 * WAD, cusdc, 9 * WAD, now);
    }

}