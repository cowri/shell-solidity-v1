pragma solidity ^0.5.6;

import "openzeppelin-contracts/contracts/token/ERC20/SafeERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "ds-test/test.sol";
import "ds-math/math.sol";
import "../flavorsSetup.sol";
import "../adaptersSetup.sol";
import "../../Loihi.sol";

contract UnbalancedSwapByOriginTest is AdaptersSetup, DSMath, DSTest {
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

        l.proportionalDeposit(300 * (10 ** 18));

        address[] memory addr = new address[](1);
        uint256[] memory amt = new uint256[](1);
        addr[0] = dai;
        amt[0] = 30 * WAD;
        uint256 burned = l.selectiveWithdraw(addr, amt, 500 * WAD, now + 500);

        addr[0] = usdt;
        amt[0] = 30 * 1000000;
        uint256 deposited = l.selectiveDeposit(addr, amt, 0, now + 500);

    }

    function testUnbalancedOriginSwapZtoY () public {
        uint256 targetAmount = l.swapByOrigin(usdt, usdc, 10 * 1000000, 5 * (10 ** 6), now);
        assertEq(targetAmount, 9845074);
    }

    function testUnbalancedOriginSwapYtoX () public {
        uint256 targetAmount = l.swapByOrigin(usdc, dai, 10 * (10 ** 6), 5 * WAD, now);
        targetAmount /= 10000000000;
        assertEq(targetAmount, 984507500);
    }

    function testUnbalancedOriginSwapZtoX () public {
        uint256 targetAmount = l.swapByOrigin(usdt, dai, 10 * 1000000, 5 * WAD, now);
        targetAmount /= 10000000000;
        assertEq(targetAmount, 969887563);
    }

    function testUnbalancedOriginSwapXtoZ () public {
        uint256 targetAmount = l.swapByOrigin(dai, usdt, 10 * WAD, 5 * 1000000, now);
        assertEq(targetAmount, 9995000);
    }

    function testFailUnbalancedOriginSwap () public {
        uint256 targetAmount = l.swapByOrigin(dai, cusdc, 80 * WAD, 9 * WAD, now);
    }

}