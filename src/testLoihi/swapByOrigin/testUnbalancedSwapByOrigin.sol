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

        // IERC20(cdai).transfer(address(l), 35 * WAD);
        // IERC20(cusdc).transfer(address(l), 50 * WAD);
        // SafeERC20.safeTransfer(IERC20(usdt), address(l), 130 * WAD);

        l.fakeMint(300 * WAD);

    }

    // function testUnbalancedOriginSwapZtoY () public {
    //     uint256 targetAmount = l.swapByOrigin(usdt, 10 * WAD, usdc, 5 * WAD, now);
    //     assertEq(targetAmount, 9845075000000000000);
    // }

    // function testUnbalancedOriginSwapYtoX () public {
    //     uint256 targetAmount = l.swapByOrigin(usdc, 10 * (WAD / 10 ** 12), dai, 5 * WAD, now);
    //     assertEq(targetAmount, 9845075000000000000);
    // }

    // function testUnbalancedOriginSwapZtoX () public {
    //     uint256 targetAmount = l.swapByOrigin(usdt, 10 * WAD, dai, 5 * WAD, now);
    //     assertEq(targetAmount, 9698875636250000000);
    // }

    // function testUnbalancedOriginSwapXtoZ () public {
    //     uint256 targetAmount = l.swapByOrigin(dai, 10 * WAD, usdt, 5 * WAD, now);
    //     assertEq(targetAmount, 9995000000000000000);
    // }

    // function testFailUnbalancedOriginSwap () public {
    //     uint256 targetAmount = l.swapByOrigin(dai, 80 * WAD, cusdc, 9 * WAD, now);
    // }

}