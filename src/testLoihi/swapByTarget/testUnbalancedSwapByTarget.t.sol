pragma solidity ^0.5.6;

import "openzeppelin-contracts/contracts/token/ERC20/SafeERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "ds-test/test.sol";
import "ds-math/math.sol";
import "../flavorsSetup.sol";
import "../adaptersSetup.sol";
import "../../Loihi.sol";


contract UnbalancedSwapByTargetTest is AdaptersSetup, DSMath, DSTest {
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

        // l.proportionalDeposit(210 * (10 ** 18));

        IERC20(cdai).transfer(address(l), 35 * WAD);
        IERC20(cusdc).transfer(address(l), 50 * WAD);
        SafeERC20.safeTransfer(IERC20(usdt), address(l), 130 * WAD);

        l.fakeMint(300 * WAD);

    }

    event log_uint_arr(bytes32, uint256[]);

    function testBalancedTargetSwap10yToZ () public {
        uint256 originAmount = l.swapByTarget(usdt, 20 * WAD, usdc, 10 * WAD, now);
        assertEq(originAmount, 10155125025000000000);
    }

    function testBalancedTargetSwap10zToY () public {
        uint256 targetAmount = l.swapByTarget(usdc, 30 * WAD, usdt, 10 * WAD, now);
        assertEq(targetAmount, 10005000000000000000);
    }

    function testBalancedTargetSwap10xToZ () public {
        uint256 targetAmount = l.swapByTarget(usdt, 20 * WAD, dai, 10 * WAD, now);
        assertEq(targetAmount, 10308975923255625000);
    }

    function testBalancedTargetSwap10zToX () public {
        uint256 targetAmount = l.swapByTarget(dai, 20 * WAD, usdt, 10 * WAD, now);
        assertEq(targetAmount, 10005000000000000000);
    }

    function testFailBalancedSwap51Target () public {
        uint256 targetAmount = l.swapByTarget(dai, 9 * WAD, usdc, 51 * WAD, now);
    }

}