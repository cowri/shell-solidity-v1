
pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../../loihiSetup.sol";
import "../../../interfaces/IAdapter.sol";

contract OriginSwapTest is LoihiSetup, DSMath, DSTest {

    function setUp() public {

        setupLoihi();
        setupFlavors();
        setupAdapters();
        approveFlavors();
        executeApprovals();
        includeAdapters(0);

    }

    function withdraw (address waddr, uint256 wamount, address xaddr, uint256 xamount, address yaddr, uint256 yamount, address zaddr, uint256 zamount) public returns (uint256) {
        address[] memory addrs = new address[](4);
        uint256[] memory amounts = new uint256[](4);

        addrs[0] = waddr; amounts[0] = wamount;
        addrs[1] = xaddr; amounts[1] = xamount;
        addrs[2] = yaddr; amounts[2] = yamount;
        addrs[3] = zaddr; amounts[3] = zamount;

        return l.selectiveWithdraw(addrs, amounts, 50000*WAD, now + 500);
    }

    function deposit (address waddr, uint256 wamount, address xaddr, uint256 xamount, address yaddr, uint256 yamount, address zaddr, uint256 zamount) public returns (uint256) {
        address[] memory addrs = new address[](4);
        uint256[] memory amounts = new uint256[](4);

        addrs[0] = waddr; amounts[0] = wamount;
        addrs[1] = xaddr; amounts[1] = xamount;
        addrs[2] = yaddr; amounts[2] = yamount;
        addrs[3] = zaddr; amounts[3] = zamount;

        return l.selectiveDeposit(addrs, amounts, 0, now + 500);
    }

    // function testBalancedOriginSwap5DaiToUsdcWithProportional300 () public {
    //     l.proportionalDeposit(300*WAD);
    //     uint256 targetAmount = l.swapByOrigin(dai, usdc, 10*WAD, 0, now+500);
    //     assertEq(targetAmount, 9995000);
    // }

    // function testNoFeeUnbalancedOriginSwap10UsdcToUsdtWith80Dai100Usdc85Usdt35Susd () public {
    //     deposit(dai, 80*WAD, usdc, 10**8, usdt, 85*(10**6), susd, 35*WAD);
    //     uint256 targetAmount = l.swapByOrigin(usdc, usdt, 10**7, 0, now+500);
    //     assertEq(targetAmount, 9995000);
    // }

    // function testPartialUpperAndLowerSlippage30UsdtToDaiWithProportional300 () public {
    //     l.proportionalDeposit(300*WAD);
    //     uint256 targetAmount = l.swapByOrigin(usdt, dai, 30*(10**6), 0, now+500);
    //     assertEq(targetAmount, 29861099310560726821);
    // }

    // function testFullUpperAndLowerSlippage3UsdtToDaiWith55Dai90Usdc125Usdt30Susd () public {
    //     deposit(dai, 55*WAD, usdc, 90*(10**6), usdt, 125*(10**6), susd, 30*WAD);
    //     uint256 targetAmount = l.swapByOrigin(usdt, dai, 3*(10**6), 0, now+50);
    //     assertEq(targetAmount, 2815130201462274925);
    // }

    

}