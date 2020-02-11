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
        uint256 burned = l.selectiveWithdraw(addr, amt, 50 * WAD, now + 500);

        addr[0] = usdt;
        amt[0] = 30 * (10**6);
        uint256 deposited = l.selectiveDeposit(addr, amt, 0, now + 500);

    }

    function testUnbalancedTargetSwap10yToZ () public {
        uint256 originAmount = l.swapByTarget(usdt, usdc, 20 * (10 ** 6), 10 * 1000000, now);
        assertEq(originAmount, 10155125);
    }

    function testUnbalancedTargetSwap10zToY () public {
        uint256 targetAmount = l.swapByTarget(usdc, usdt, 30 * (10**6), 10 * (10**6), now);
        assertEq(targetAmount, 10005000);
    }

    function testUnbalancedTargetSwap10xToZ () public {
        uint256 targetAmount = l.swapByTarget(usdt, dai, 20 * (10**6), 10 * WAD, now);
        assertEq(targetAmount, 10308975);
    }

    function testUnbalancedTargetSwap10zToX () public {
        uint256 targetAmount = l.swapByTarget(dai, usdt, 20 * WAD, 10 * (10**6), now);
        assertEq(targetAmount, 10005000000000000000);
    }

    function testFailUnbalancedSwap51Target () public {
        uint256 targetAmount = l.swapByTarget(dai, usdc, 9 * WAD, 51 * 1000000, now);
    }

}