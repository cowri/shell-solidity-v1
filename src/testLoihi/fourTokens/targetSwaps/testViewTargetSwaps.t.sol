pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../../loihiSetup.sol";
import "../../../interfaces/IAdapter.sol";

contract ViewTargetSwapTest is LoihiSetup, DSMath, DSTest {

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

        return l1.selectiveWithdraw(addrs, amounts, 50000*WAD, now + 500);
    }

    function deposit (address waddr, uint256 wamount, address xaddr, uint256 xamount, address yaddr, uint256 yamount, address zaddr, uint256 zamount) public returns (uint256) {
        address[] memory addrs = new address[](4);
        uint256[] memory amounts = new uint256[](4);

        addrs[0] = waddr; amounts[0] = wamount;
        addrs[1] = xaddr; amounts[1] = xamount;
        addrs[2] = yaddr; amounts[2] = yamount;
        addrs[3] = zaddr; amounts[3] = zamount;

        return l1.selectiveDeposit(addrs, amounts, 0, now + 500);
    }

    // function testBalancedTargetSwapDaiTo10UsdcWithProportional300 () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 targetAmount = l1.viewTargetTrade(dai, usdc, 10*(10**6));
    //     assertEq(targetAmount, 10005000625000000000);
    // }

    // function testNoFeeUnbalancedTargetSwap10UsdcToUsdtWith80Dai100Usdc85Usdt35Susd () public {
    //     deposit(dai, 80*WAD, usdc, 10**8, usdt, 85*(10**6), susd, 35*WAD);
    //     uint256 targetAmount = l1.viewTargetTrade(usdc, susd, 3*WAD);
    //     assertEq(targetAmount, 3001500);
    // }

    // function testNoFeeBalanced10PctWeightTo30PctWeight () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 targetAmount = l1.viewTargetTrade(susd, usdt, 4*(10**6));
    //     assertEq(targetAmount, 4002000250000000000);
    // }

    // function testPartialUpperAndLowerSlippageFromBalancedShell30PctWeight () logs_gas public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 targetAmount = l1.viewTargetTrade(usdc, dai, 40*WAD);
    //     assertEq(targetAmount, 40722871);
    // }

    // function testPartialUpperAndLowerSLippageFromBalancedShell30PctWeightTo10PctWeight () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 targetAmount = l1.viewTargetTrade(usdc, susd, 12*WAD);
    //     assertEq(targetAmount, 12073660);
    // }

    // function testPartialUpperAndLowerSlippageFromUnbalancedShell10PctWeightTo30PctWeight () public {
    //     deposit(dai, 65*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 30*WAD);
    //     uint256 targetAmount = l1.viewTargetTrade(susd, dai, 8*WAD);
    //     assertEq(targetAmount, 8082681715960427072);
    // }

    // function testNoSlippagePartiallyUnbalanced30PctWeightTo10PctWeight () public {
    //     deposit(dai, 80*WAD, usdc, 10**8, usdt, 85*(10**6), susd, 35*WAD);
    //     uint256 targetAmount = l1.viewTargetTrade(usdc, susd, 3*WAD);
    //     assertEq(targetAmount, 3001500);
    // }

    // function testFullUpperAndLowerSlippageUnbalancedShell30PctWeight () logs_gas public {
    //     deposit(dai, 135*WAD, usdc, 90*(10**6), usdt, 60*(10**6), susd, 30*WAD);
    //     uint256 targetAmount = l1.viewTargetTrade(dai, usdt, 5*(10**6));
    //     assertEq(targetAmount, 5361455914007417759);
    // }

    // function testFullUpperAndLowerSlippageUnbalancedShell30PctWeightTo10PctWeight () logs_gas public {
    //     deposit(dai, 135*WAD, usdc, 90*(10**6), usdt, 65*(10**6), susd, 25*WAD);
    //     uint256 targetAmount = l1.viewTargetTrade(dai, susd, 3*WAD);
    //     assertEq(targetAmount, 3130264791663764854);
    // }

    // function testFullUpperAndLowerSlippageUnbalancedShell10PctWeightTo30PctWeight () public {
    //     deposit(dai, 90*WAD, usdc, 55*(10**6), usdt, 90*(10**6), susd, 35*WAD);
    //     uint256 targetAmount = l1.viewTargetTrade(susd, usdc, 2800000);
    //     assertEq(targetAmount, 2909155536050677534);
    // }

    // function testPartialUpperAndLowerAntiSlippageUnbalanced30PctWeight () public {
    //     deposit(dai, 135*WAD, usdc, 60*(10**6), usdt, 90*(10**6), susd, 30*WAD);
    //     uint256 targetAmount = l1.viewTargetTrade(usdc, dai, 30*WAD);
    //     assertEq(targetAmount, 29929682);
    // }

    // function testPartialUpperAndLowerAntiSlippageUnbalanced10PctWeightTo30PctWeight () public {
    //     deposit(dai, 135*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 25*WAD);
    //     uint256 targetAmount = l1.viewTargetTrade(susd, dai, 10*WAD);
    //     assertEq(targetAmount, 9993821361386267461);
    // }

    // function testPartialUpperAndLowerAntiSlippageUnbalanced30PctWeightTo10PctWeight () public {
    //     deposit(dai, 90*WAD, usdc, 90*(10**6), usdt, 58*(10**6), susd, 40*WAD);
    //     uint256 targetAmount = l1.viewTargetTrade(usdt, susd, 10*WAD);
    //     assertEq(targetAmount, 9980200);
    // }

    // function testFullUpperAndLowerAntiSlippageUnbalanced30PctWeight () public {
    //     deposit(dai, 90*WAD, usdc, 135*(10**6), usdt, 60*(10**6), susd, 30*WAD);
    //     uint256 targetAmount = l1.viewTargetTrade(usdt, usdc, 5*(10**6));
    //     assertEq(targetAmount, 4954524);
    // }

    // function testFullUpperAndLowerAntiSlippage10PctOrigin30PctTarget () public {
    //     deposit(dai, 90*WAD, usdc, 90 *(10**6), usdt, 135*(10**6), susd, 25*WAD);
    //     uint256 targetAmount = l1.viewTargetTrade(susd, usdt, 3653700);
    //     assertEq(targetAmount, 3647272548665275214);
    // }

    // function testFullUpperAndLowerAntiSlippage30pctOriginTo10Pct () public {
    //     deposit(dai, 58*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 40*WAD);
    //     uint256 targetAmount = l1.viewTargetTrade(dai, susd, 2349000000000000000);
    //     assertEq(targetAmount, 2332712403174737113);
    // }

    // function testMegaLowerToUpperUpperToLower30PctWeight () public {
    //     deposit(dai, 55*WAD, usdc, 90*(10**6), usdt, 125*(10**6), susd, 30*WAD);
    //     uint256 targetAmount = l1.viewTargetTrade(dai, usdt, 70*(10**6));
    //     assertEq(targetAmount, 70035406577130885767);
    // }

    // function testMegaLowerToUpper10PctWeightTo30PctWeight () public {
    //     deposit(dai, 90*WAD, usdc, 90*(10**6), usdt, 100*(10**6), susd, 20*WAD);
    //     uint256 targetAmount = l1.viewTargetTrade(susd, usdt, 20*(10**6));
    //     assertEq(targetAmount, 20010074968656541264);
    // }

    // function testMegaUpperToLower30PctWeightTo10PctWeight () public {
    //     deposit(dai, 80*WAD, usdc, 100*(10**6), usdt, 80*(10**6), susd, 40*WAD);
    //     uint256 targetAmount = l1.viewTargetTrade(dai, susd, 20*WAD);
    //     assertEq(targetAmount, 20010007164941759473);
    // }

    // function testUpperHaltCheck30PctWeight () public {
    //     deposit(dai, 90*WAD, usdc, 135*(10**6), usdt, 90*(10**6), susd, 30*WAD);
    //     (bool success, bytes memory result) = address(l1).call(abi.encodeWithSignature(
    //         "viewTargetTrade(address,address,uint256)", usdc, usdt, 30*(10**6)));
    //     assertTrue(!success);
    // }

    // function testLowerHaltCheck30PctWeight () public {
    //     deposit(dai, 60*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 30*WAD);
    //     (bool success, bytes memory result) = address(l1).call(abi.encodeWithSignature(
    //         "viewTargetTrade(address,address,uint256)", usdc, dai, 30*WAD));
    //     assertTrue(!success);
    // }

    // function testUpperHaltCheck10PctWeight () public {
    //     l1.proportionalDeposit(300*WAD);
    //     (bool success, bytes memory result) = address(l1).call(abi.encodeWithSignature(
    //         "viewTargetTrade(address,address,uint256)", susd, usdt, 20*WAD));
    //     assertTrue(!success);
    // }

    // function testLowerhaltCheck10PctWeight () public {
    //     l1.proportionalDeposit(300*WAD);
    //     (bool success, bytes memory result) = address(l1).call(abi.encodeWithSignature(
    //         "viewTargetTrade(address,address,uint256)", dai, susd, 20*WAD));
    //     assertTrue(!success);
    // }

    // function testThing () public {
    //     deposit(dai, 13787004200000000000, usdc, 39926669, usdt, 32476855, susd, 7503542900000000000);
    //     uint256 targetAmount = l1.viewOriginTrade(usdt, dai, 12080000);
    // }

    // function testNoFeesPartiallyUnbalanced10PctTarget () public {
    //     deposit(dai, 80*WAD, usdc, 100*(10**6), usdt, 85*(10**6), susd, 35*WAD);
    //     uint256 originAmount = l1.viewTargetTrade(dai, susd, 3*WAD);
    //     assertEq(originAmount, 3001500187500000000);
    // }

    // function testFailTargetGreaterThanBalance30Pct () public {
    //     deposit(dai, 46*WAD, usdc, 134*(10**6), usdt, 75*(10**6), susd, 45*WAD);
    //     uint256 originAmount = l1.viewTargetTrade(usdt, dai, 50*WAD);
    // }

    // function testFailTargetGreaterThanBalance10Pct () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 originAmount = l1.viewTargetTrade(usdc, susd, 31*WAD);
    // }

}