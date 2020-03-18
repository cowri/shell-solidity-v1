pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../../loihiSetup.sol";
import "../../../interfaces/IAdapter.sol";

contract ContinuityTests is LoihiSetup, DSMath, DSTest {

    function setUp() public {

        setupLoihi();
        setupFlavors();
        setupAdapters();
        approveFlavors();
        executeApprovals();
        includeAdapters(2);

    }

    function withdraw (uint256 _type, address waddr, uint256 wamount, address xaddr, uint256 xamount, address yaddr, uint256 yamount, address zaddr, uint256 zamount) public returns (uint256) {
        address[] memory addrs = new address[](4);
        uint256[] memory amounts = new uint256[](4);

        addrs[0] = waddr; amounts[0] = wamount;
        addrs[1] = xaddr; amounts[1] = xamount;
        addrs[2] = yaddr; amounts[2] = yamount;
        addrs[3] = zaddr; amounts[3] = zamount;

        if (_type == 1) return l1.selectiveWithdraw(addrs, amounts, 50000*WAD, now + 500);
        if (_type == 2) return l2.selectiveWithdraw(addrs, amounts, 50000*WAD, now + 500);
    }

    function deposit (uint256 _type, address waddr, uint256 wamount, address xaddr, uint256 xamount, address yaddr, uint256 yamount, address zaddr, uint256 zamount) public returns (uint256) {
        address[] memory addrs = new address[](4);
        uint256[] memory amounts = new uint256[](4);

        addrs[0] = waddr; amounts[0] = wamount;
        addrs[1] = xaddr; amounts[1] = xamount;
        addrs[2] = yaddr; amounts[2] = yamount;
        addrs[3] = zaddr; amounts[3] = zamount;

        if (_type == 1) return l1.selectiveDeposit(addrs, amounts, 0, now + 500);
        if (_type == 2) return l2.selectiveDeposit(addrs, amounts, 0, now + 500);
    }

    // function testWithdrawContinuityTen () public {
    //     deposit(1, dai, 55*WAD, usdc, 95*(10**6), usdt, 95*(10**6), susd, 15*WAD);
    //     uint256 shellsBurned = withdraw(1, dai, 10*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsBurned, 5);
    // }

    // function testWithdrawContinuityFiveAndFive () public {
    //     deposit(1, dai, 55*WAD, usdc, 95*(10**6), usdt, 95*(10**6), susd, 15*WAD);
    //     uint256 shellsBurned = withdraw(1, dai, 5*WAD, usdc, 0, usdt, 0, susd, 0);
    //     shellsBurned += withdraw(1, dai, 5*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsBurned, 5);
    // }

    // function testContinuityTenWithdrawTenDeposit () public {
    //     deposit(1, dai, 55*WAD, usdc, 95*(10**6), usdt, 95*(10**6), susd, 15*WAD);
    //     // l1.proportionalDeposit(300*WAD);
    //     uint256 shellsBefore = l1.totalSupply();
    //     uint256 shellsBurned = withdraw(1, dai, 10*WAD, usdc, 0, usdt, 0, susd, 0);
    //     uint256 shellsMinted = deposit(1, dai, 10*WAD, usdc, 0, usdt, 0, susd, 0);
    //     uint256 shellsAfter = l1.totalSupply();
    //     assertEq(shellsBurned, 5);
    //     assertEq(shellsMinted, 5);
    //     assertEq(shellsBefore, shellsAfter);
    // }

    // function testFeeCrossContinuity50DaiFromProportional300 () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(1, dai, 50*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted, 49927083339792853692);
    // }

    // function testFeeCrossContinuity36DaiThen14DaiFromProportional300 () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(1, dai, 36*WAD, usdc, 0, usdt, 0, susd, 0);
    //     shellsMinted += deposit(1, dai, 14*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted, 49927083339792333938);
    // }

    // function testFeeCrossContinuity36Point0001DaiThen13Point9999DaiFromProportional300 () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(1, dai, 36*WAD + WAD/10000, usdc, 0, usdt, 0, susd, 0);
    //     shellsMinted += deposit(1, dai, 14*WAD - WAD/10000, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted, 49927083339791772622);
    // }

    // function testContinuity50Deposit50WithdrawFrom300Proportional () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(1, dai, 50*WAD, usdc, 0, usdt, 0, susd, 0);
    //     uint256 shellsBurned = withdraw(1, dai, 50*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted, shellsBurned);
    // }

    // function testContinuityDeposit36Dai14UsdcWithdraw36Dai14UsdcFrom300Proportional () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(1, dai, 36*WAD, usdc, 14*(10**6), usdt, 0, susd, 0);
    //     uint256 shellsBurned = withdraw(1, dai, 36*WAD, usdc, 14*(10**6), usdt, 0, susd, 0);
    //     assertEq(shellsMinted, shellsBurned);
    // }

    // function testContinuityDeposit36Then14DaiWithdraw36Then14DaiFrom300Proportional () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(1, dai, 36*WAD, usdc, 0, usdt, 0, susd, 0);
    //     shellsMinted += deposit(1, dai, 14*WAD, usdc, 0, usdt, 0, susd, 0);
    //     uint256 shellsBurned = withdraw(1, dai, 36*WAD, usdc, 0, usdt, 0, susd, 0);
    //     shellsBurned += withdraw(1, dai, 14*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted, shellsBurned);
    // }

    // function testContinuityDeposit14Then36DaiWithdraw14Then36DaiFrom300Proportional () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(1, dai, 14*WAD, usdc, 0, usdt, 0, susd, 0);
    //     shellsMinted += deposit(1, dai, 36*WAD, usdc, 0, usdt, 0, susd, 0);
    //     uint256 shellsBurned = withdraw(1, dai, 14*WAD, usdc, 0, usdt, 0, susd, 0);
    //     shellsBurned += withdraw(1, dai, 36*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted, shellsBurned);
    // }

    // function testBalancedContinuitySwap () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 gas1 = gasleft();
    //     uint256 targetAmount = l1.swapByOrigin(usdt, dai, 40*(10**6), 0, now+50);
    //     uint256 gas2 = gasleft();
    //     assertEq(gas1-gas2, 5);
    //     emit log_named_uint("gas1", gas1);
    //     emit log_named_uint("gas2", gas2);
    //     // assertEq(targetAmount, 3*WAD);
    // }

    // function testContinuityDepositFifty () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(1, dai, 40*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted, 5);
    // }

    // function testUnbalancedContinuitySwap () public {
    //     deposit(1, dai, 55*WAD, usdc, 95*(10**6), usdt, 95*(10**6), susd, 15*WAD);
    //     uint256 targetAmount = l1.swapByOrigin(usdt, dai, 15*(10**6), 0, now+50);
    //     assertEq(targetAmount, 5);
    // }

    // function testUnbalancedContinuityDeposit40Withdraw39659722214604436634 () public {
    //     deposit(1, dai, 55*WAD, usdc, 95*(10**6), usdt, 95*(10**6), susd, 15*WAD);
    //     uint256 shellsBefore = l1.totalSupply();
    //     uint256 deposited = deposit(1, dai, 0, usdt, 15*(10**6), usdc, 0, susd, 0);
    //     uint256 withdrawn = withdraw(1, dai, 14405299903077506874, usdt, 0, usdc, 0, susd, 0);
    //     uint256 shellsAfter = l1.totalSupply();
    //     assertEq(shellsBefore, shellsAfter);
    //     assertEq(deposited, 5);
    //     assertEq(withdrawn, 55);
    //     emit log_named_uint("shellsBefore", shellsBefore);
    //     emit log_named_uint("shellsAfter", shellsAfter);
    //     emit log_named_uint("deposited", deposited);
    //     emit log_named_uint("withdrawn", withdrawn);
    // }

    // function testUnbalancedContinuityDeposit40Withdraw39659722214604436634 () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsBefore = l.totalSupply();
    //     uint256 deposited = deposit(1, dai, 0, usdt, 40*(10**6), usdc, 0, susd, 0);
    //     uint256 withdrawn = withdraw(1, dai, 39349593617240527427, usdt, 0, usdc, 0, susd, 0);
    //     uint256 shellsAfter = l.totalSupply();
    //     emit log_named_uint("shellsBefore", shellsBefore);
    //     emit log_named_uint("shellsAfter", shellsAfter);
    //     emit log_named_uint("deposited", deposited);
    //     emit log_named_uint("withdrawn", withdrawn);
    // }

    // function testContinuityDepositTen () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(1, dai, 10*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted, 5);
    // }

    // function testContinuityDepositFiveAndFive () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(1, dai, 5*WAD, usdc, 0, usdt, 0, susd, 0);
    //     shellsMinted += deposit(1, dai, 5*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted, 5);
    // }

    // function testContinuityDepositFifty () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(1, dai, 40*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted, 5);
    // }

    // function testContinuityDepositTwentyFiveAndTwentyFive () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(1, dai, 25*WAD, usdc, 0, usdt, 0, susd, 0);
    //     shellsMinted += deposit(1, dai, 25*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted, 5);
    // }

    // function testContinuity106Dai106Usdc () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(1, dai, 106*WAD, usdc, 106*(10**6), usdt, 0, susd, 0);
    //     assertEq(shellsMinted, 5);
    // }

    // function testDepositFullUpperSlippageContinuityTen () public {
    //     deposit(1, dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 newShells = deposit(1, dai, 10*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(newShells, 32007966147128995554);
    // }

    // function testDepositFullUpperSlippageContinuityFiveAndFive () public {
    //     deposit(1, dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 newShells = deposit(1, dai, 5*WAD, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(1, dai, 5*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(newShells, 32007966147128995554);
    // }

    // function testDepositFullUppSlippageContinuityTwoPointFiveTwoPointFiveTwoPointFiveTwoPointFive () public {
    //     deposit(1, dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 newShells = deposit(1, dai, (5*WAD)/2, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(1, dai, (5*WAD)/2, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(1, dai, (5*WAD)/2, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(1, dai, (5*WAD)/2, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(newShells, 32007966147128995554);
    // }

    // function testDepositFullUppSlippageContinuityFiveAndTwoAndThree () public {
    //     deposit(1, dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 newShells = deposit(1, dai, 5*WAD, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(1, dai, 2*WAD, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(1, dai, 3*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(newShells, 32007966147128995554);
    // }

    // function testDepositLowerAntiSlippageContinuityTen () public {
    //     deposit(1, dai, 45*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 30*WAD);
    //     uint256 newShells = deposit(1, dai, 10*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(newShells, 4998750000000000000);
    // }

    // function testDepositLowerAntiSlippageContinuityFiveAndFive () public {
    //     deposit(1, dai, 45*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 30*WAD);
    //     uint256 newShells = deposit(1, dai, 5*WAD, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(1, dai, 5*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(newShells, 4998750000000000000);
    // }

    // function testDepositLowerAntiSlippageContinuitySixAndFour () public {
    //     deposit(1, dai, 45*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 30*WAD);
    //     uint256 newShells = deposit(1, dai, 6*WAD, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(1, dai, 4*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(newShells, 4998750000000000000);
    // }

    // function testDepositLowerAntiSlippageContinuityTwoAndTwoAndSix () public {
    //     deposit(1, dai, 45*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 30*WAD);
    //     uint256 newShells = deposit(1, dai, 2*WAD, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(1, dai, 2*WAD, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(1, dai, 6*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(newShells, 4998750000000000000);
    // }

    // function testDepositLowerAntiSlippageContinuityThreeAndThreeAndThreeAndOne () public {
    //     deposit(1, dai, 45*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 30*WAD);
    //     uint256 newShells = deposit(1, dai, 3*WAD, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(1, dai, 3*WAD, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(1, dai, 3*WAD, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(1, dai, WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(newShells, 4998750000000000000);
    // }

    // function testDepositLowerAntiSlippageContinuityTwoPointFiveTwoPointFiveTwoPointFiveTwoPointFive () public {
    //     deposit(1, dai, 45*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 30*WAD);
    //     uint256 newShells = deposit(1, dai, (5*WAD)/2, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(1, dai, (5*WAD)/2, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(1, dai, (5*WAD)/2, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(1, dai, (5*WAD)/2, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(newShells, 4998750000000000000);
    // }

    // function testTargetSwapContinuity () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 originAmount = l1.swapByTarget(usdt, dai, 500*WAD, 39349593748892135593, now + 500);
    //     // assertEq(originAmount, 5);
    // }

    // function testBalancedContinuitySwap () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 gas1 = gasleft();
    //     uint256 targetAmount = l1.swapByOrigin(usdt, dai, 40*(10**6), 0, now+50);
    //     uint256 gas2 = gasleft();
    //     assertEq(targetAmount, 3*WAD);
    // }

    // function testFullFeeContinuityOriginSwapTenDaiToUsdt () public {
    //     deposit(1, dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 targetAmount = l1.swapByOrigin(dai, usdt, 10*WAD, 0, now + 500);
    //     assertEq(targetAmount, 5);
    // }

    // function testFullFeeContinuityOriginSwapFiveAndFiveDaiToUsdt () public {
    //     deposit(1, dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 targetAmount = l1.swapByOrigin(dai, usdt, 5*WAD, 0, now + 500);
    //     targetAmount += l1.swapByOrigin(dai, usdt, 5*WAD, 0, now + 500);
    //     assertEq(targetAmount, 5);
    // }

    // function testOriginSwapContinuityPartialUpperAndLowerFeesFromBalancedShell30PctWeight () logs_gas public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 targetAmount1 = l1.swapByOrigin(usdc, dai, 40*(10**6), 0, now + 500);
    //     l2.proportionalDeposit(300*WAD);
    //     uint256 targetAmount2 = l2.swapByOrigin(usdc, dai, 20*(10**6), 0, now + 500);
    //     targetAmount2 += l2.swapByOrigin(usdc, dai, 20*(10**6), 0, now + 500);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testOriginSwapContinuityFullUpperAndLowerFeesUnbalancedShell30PctWeightTo10PctWeight () logs_gas public {
    //     deposit(1, dai, 135*WAD, usdc, 90*(10**6), usdt, 65*(10**6), susd, 25*WAD);
    //     uint256 targetAmount1 = l1.swapByOrigin(dai, susd, 3*WAD, 0, now + 500);
    //     deposit(2, dai, 135*WAD, usdc, 90*(10**6), usdt, 65*(10**6), susd, 25*WAD);
    //     uint256 targetAmount2 = l2.swapByOrigin(dai, susd, (3*WAD)/2, 0, now + 500);
    //     targetAmount2 += l2.swapByOrigin(dai, susd, (3*WAD)/2, 0, now + 500);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testOriginSwapContinuityFullUpperAndLowerSlippageUnbalancedShell10PctWeightTo30PctWeight () public {
    //     deposit(1, dai, 90*WAD, usdc, 55*(10**6), usdt, 90*(10**6), susd, 35*WAD);
    //     uint256 targetAmount1 = l1.swapByOrigin(susd, usdc, 28*(10**17), 0, now+50);
    //     deposit(2, dai, 90*WAD, usdc, 55*(10**6), usdt, 90*(10**6), susd, 35*WAD);
    //     uint256 targetAmount2 = l2.swapByOrigin(susd, usdc, 14*(10**17), 0, now+50);
    //     targetAmount2 += l2.swapByOrigin(susd, usdc, 14*(10**17), 0, now+50);
    //     assertEq(targetAmount1, targetAmount2);
    // }


    // function testOriginSwapContinuityPartialUpperAndLowerAntiSlippageUnbalanced30PctWeight () public {
    //     deposit(1, dai, 135*WAD, usdc, 60*(10**6), usdt, 90*(10**6), susd, 30*WAD);
    //     uint256 targetAmount1 = l1.swapByOrigin(usdc, dai, 30*(10**6), 0, now+50);
    //     deposit(2, dai, 135*WAD, usdc, 60*(10**6), usdt, 90*(10**6), susd, 30*WAD);
    //     uint256 targetAmount2 = l2.swapByOrigin(usdc, dai, 15*(10**6), 0, now+50);
    //     targetAmount2 += l2.swapByOrigin(usdc, dai, 15*(10**6), 0, now+50);
    //     assertEq(targetAmount1, targetAmount2);
    // }


    // function testOriginSwapContinuityPartialUpperAndLowerAntiSlippageUnbalanced10PctWeightTo30PctWeight () public {
    //     deposit(1, dai, 135*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 25*WAD);
    //     uint256 targetAmount1 = l1.swapByOrigin(susd, dai, 10*WAD, 0, now+50);
    //     deposit(2, dai, 135*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 25*WAD);
    //     uint256 targetAmount2 = l2.swapByOrigin(susd, dai, 5*WAD, 0, now+50);
    //     targetAmount2 += l2.swapByOrigin(susd, dai, 5*WAD, 0, now+50);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testOriginSwapContinuityPartialUpperAndLowerAntiSlippageUnbalanced30PctWeightTo10PctWeight () public {
    //     deposit(1, dai, 90*WAD, usdc, 90*(10**6), usdt, 58*(10**6), susd, 40*WAD);
    //     uint256 targetAmount1 = l1.swapByOrigin(usdt, susd, 10**7, 0, now +50);
    //     deposit(2, dai, 90*WAD, usdc, 90*(10**6), usdt, 58*(10**6), susd, 40*WAD);
    //     uint256 targetAmount2 = l2.swapByOrigin(usdt, susd, (10**7)/2, 0, now +50);
    //     targetAmount2 += l2.swapByOrigin(usdt, susd, (10**7)/2, 0, now +50);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testOriginSwapContinuityFullUpperAndLowerAntiSlippageUnbalanced30PctWeight () public {
    //     deposit(1, dai, 90*WAD, usdc, 135*(10**6), usdt, 60*(10**6), susd, 30*WAD);
    //     uint256 targetAmount1 = l1.swapByOrigin(usdt, usdc, 5*(10**6), 0, now + 50);
    //     deposit(2, dai, 90*WAD, usdc, 135*(10**6), usdt, 60*(10**6), susd, 30*WAD);
    //     uint256 targetAmount2 = l2.swapByOrigin(usdt, usdc, (5*(10**6))/2, 0, now + 50);
    //     targetAmount2 += l2.swapByOrigin(usdt, usdc, (5*(10**6))/2, 0, now + 50);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testOriginSwapContinuityFullUpperAndLowerAntiSlippage30pctOriginTo10Pct () public {
    //     deposit(1, dai, 58*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 40*WAD);
    //     uint256 targetAmount1 = l1.swapByOrigin(dai, susd, 2349000000000000000, 0, now+50);
    //     deposit(2, dai, 58*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 40*WAD);
    //     uint256 targetAmount2 = l2.swapByOrigin(dai, susd, (2349000000000000000)/2, 0, now+50);
    //     targetAmount2 += l2.swapByOrigin(dai, susd, (2349000000000000000)/2, 0, now+50);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testOriginSwapContinuityPartialUpperAndLowerFeesFromBalancedShell10PctWeight () logs_gas public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 targetAmount1 = l1.swapByOrigin(usdc, susd, 15*(10**6), 0, now + 500);
    //     l2.proportionalDeposit(300*WAD);
    //     uint256 targetAmount2 = l2.swapByOrigin(usdc, susd, (15*(10**6))/2, 0, now + 500);
    //     targetAmount2 += l2.swapByOrigin(usdc, susd, (15*(10**6))/2, 0, now + 500);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testOriginSwapContinuityBalancedOriginSwap5DaiToUsdcWithProportional300 () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 targetAmount1 = l1.swapByOrigin(dai, usdc, 10*WAD, 0, now+500);
    //     l2.proportionalDeposit(300*WAD);
    //     uint256 targetAmount2 = l2.swapByOrigin(dai, usdc, 5*WAD, 0, now+500);
    //     targetAmount2 += l2.swapByOrigin(dai, usdc, 5*WAD, 0, now+500);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testOriginSwapContinuityNoFeeUnbalancedOriginSwap10UsdcToUsdtWith80Dai100Usdc85Usdt35Susd () public {
    //     deposit(1, dai, 80*WAD, usdc, 10**8, usdt, 85*(10**6), susd, 35*WAD);
    //     uint256 targetAmount1 = l1.swapByOrigin(usdc, usdt, 10**7, 0, now+500);
    //     deposit(2, dai, 80*WAD, usdc, 10**8, usdt, 85*(10**6), susd, 35*WAD);
    //     uint256 targetAmount2 = l2.swapByOrigin(usdc, usdt, (10**7)/2, 0, now+500);
    //     targetAmount2 += l2.swapByOrigin(usdc, usdt, (10**7)/2, 0, now+500);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testOriginSwapContinuityNoFeeBalanced10PctWeightTo30PctWeight () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 targetAmount1 = l1.swapByOrigin(susd, usdt, 4*WAD, 0, now + 500);
    //     l2.proportionalDeposit(300*WAD);
    //     uint256 targetAmount2 = l2.swapByOrigin(susd, usdt, 2*WAD, 0, now + 500);
    //     targetAmount2 += l2.swapByOrigin(susd, usdt, 2*WAD, 0, now + 500);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testOriginSwapContinuityPartialUpperAndLowerFeesFromUnbalancedShell10PctWeightTo30PctWeight () public {
    //     deposit(1, dai, 65*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 30*WAD);
    //     uint256 targetAmount1 = l1.swapByOrigin(susd, dai, 8*WAD, 0, now+50);
    //     deposit(2, dai, 65*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 30*WAD);
    //     uint256 targetAmount2 = l2.swapByOrigin(susd, dai, 4*WAD, 0, now+50);
    //     targetAmount2 += l2.swapByOrigin(susd, dai, 4*WAD, 0, now+50);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testOriginSwapContinuityNoFeeBalanced30PctWeightTo30PctWeight () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 targetAmount1 = l1.swapByOrigin(dai, usdc, 10*WAD, 0, now + 500);
    //     l2.proportionalDeposit(300*WAD);
    //     uint256 targetAmount2 = l2.swapByOrigin(dai, usdc, 5*WAD, 0, now + 500);
    //     targetAmount2 += l2.swapByOrigin(dai, usdc, 5*WAD, 0, now + 500);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testOriginSwapContinuityNoFeePartiallyUnbalanced30PctWeightTo10PctWeight () public {
    //     deposit(1, dai, 80*WAD, usdc, 10**8, usdt, 85*(10**6), susd, 35*WAD);
    //     uint256 targetAmount1 = l1.swapByOrigin(usdc, susd, 3*(10**6), 0, now+50);
    //     deposit(2, dai, 80*WAD, usdc, 10**8, usdt, 85*(10**6), susd, 35*WAD);
    //     uint256 targetAmount2 = l2.swapByOrigin(usdc, susd, (3*(10**6))/2, 0, now+50);
    //     targetAmount2 += l2.swapByOrigin(usdc, susd, (3*(10**6))/2, 0, now+50);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testTargetSwapContinuityBalancedDaiToUsdcWithProportional300 () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 targetAmount1 = l1.swapByTarget(dai, usdc, 100*WAD, 10*(10**6), now+500);
    //     l2.proportionalDeposit(300*WAD);
    //     uint256 targetAmount2 = l2.swapByTarget(dai, usdc, 50*WAD, 5*(10**6), now+500);
    //     targetAmount2 += l2.swapByTarget(dai, usdc, 50*WAD, 5*(10**6), now+500);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testTargetSwapContinuityNoFeeUnbalanced10UsdcToUsdtWith80Dai100Usdc85Usdt35Susd () public {
    //     deposit(1, dai, 80*WAD, usdc, 10**8, usdt, 85*(10**6), susd, 35*WAD);
    //     uint256 targetAmount1 = l1.swapByTarget(usdc, susd, 500*WAD, 3*WAD, now+500);
    //     deposit(2, dai, 80*WAD, usdc, 10**8, usdt, 85*(10**6), susd, 35*WAD);
    //     uint256 targetAmount2 = l2.swapByTarget(usdc, susd, 250*WAD, (3*WAD)/2, now+500);
    //     targetAmount2 += l2.swapByTarget(usdc, susd, 250*WAD, (3*WAD)/2, now+500);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testTargetSwapContinuityNoFeeBalanced10PctWeightTo30PctWeight () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 targetAmount1 = l1.swapByTarget(susd, usdt, 400*WAD, 4*(10**6), now + 500);
    //     l2.proportionalDeposit(300*WAD);
    //     uint256 targetAmount2 = l2.swapByTarget(susd, usdt, 400*WAD, 2*(10**6), now + 500);
    //     targetAmount2 += l2.swapByTarget(susd, usdt, 400*WAD, 2*(10**6), now + 500);
    //     assertEq(targetAmount1, targetAmount2);
    // }


    // function testTargetSwapContinuityNoSlippageBalanced30PctWeightTo30PctWeight () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 targetAmount1 = l1.swapByTarget(dai, usdc, 11*WAD, 10*(10**6), now + 500);
    //     l2.proportionalDeposit(300*WAD);
    //     uint256 targetAmount2 = l2.swapByTarget(dai, usdc, 11*WAD, 5*(10**6), now + 500);
    //     targetAmount2 += l2.swapByTarget(dai, usdc, 11*WAD, 5*(10**6), now + 500);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testTargetSwapContinuityPartialUpperAndLowerSlippageFromBalancedShell30PctWeight () logs_gas public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 targetAmount1 = l1.swapByTarget(usdc, dai, 500*WAD, 40*WAD, now + 500);
    //     l2.proportionalDeposit(300*WAD);
    //     uint256 targetAmount2 = l2.swapByTarget(usdc, dai, 500*WAD, 20*WAD, now + 500);
    //     targetAmount2 += l2.swapByTarget(usdc, dai, 500*WAD, 20*WAD, now + 500);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testTargetSwapContinuityPartialUpperAndLowerSLippageFromBalancedShell30PctWeightTo10PctWeight () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 targetAmount1 = l1.swapByTarget(usdc, susd, 8*WAD, 12*WAD, now+50);
    //     l2.proportionalDeposit(300*WAD);
    //     uint256 targetAmount2 = l2.swapByTarget(usdc, susd, 8*WAD, 6*WAD, now+50);
    //     targetAmount2 += l2.swapByTarget(usdc, susd, 8*WAD, 6*WAD, now+50);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testTargetSwapContinuityPartialUpperAndLowerSlippageFromUnbalancedShell10PctWeightTo30PctWeight () public {
    //     deposit(1, dai, 65*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 30*WAD);
    //     uint256 targetAmount1 = l1.swapByTarget(susd, dai, 9*WAD, 8*WAD, now+50);
    //     deposit(2, dai, 65*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 30*WAD);
    //     uint256 targetAmount2 = l2.swapByTarget(susd, dai, 9*WAD, 4*WAD, now+50);
    //     targetAmount2 += l2.swapByTarget(susd, dai, 9*WAD, 4*WAD, now+50);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testTargetSwapContinuityNoSlippagePartiallyUnbalanced30PctWeightTo10PctWeight () public {
    //     deposit(1, dai, 80*WAD, usdc, 10**8, usdt, 85*(10**6), susd, 35*WAD);
    //     uint256 targetAmount1 = l1.swapByTarget(usdc, susd, 31*(10**6), 3*WAD, now+50);
    //     deposit(2, dai, 80*WAD, usdc, 10**8, usdt, 85*(10**6), susd, 35*WAD);
    //     uint256 targetAmount2 = l2.swapByTarget(usdc, susd, 31*(10**6), (3*WAD)/2, now+50);
    //     targetAmount2 += l2.swapByTarget(usdc, susd, 31*(10**6), (3*WAD)/2, now+50);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testTargetSwapContinuityPartialUpperAndLowerSlippageFromBalancedShell30PctWeightTo10PctWeight () logs_gas public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 targetAmount1 = l1.swapByTarget(usdc, susd, 15*(10**6), 12*WAD, now + 500);
    //     l2.proportionalDeposit(300*WAD);
    //     uint256 targetAmount2 = l2.swapByTarget(usdc, susd, 15*(10**6), 6*WAD, now + 500);
    //     targetAmount2 += l2.swapByTarget(usdc, susd, 15*(10**6), 6*WAD, now + 500);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testTargetSwapContinuityFullUpperAndLowerSlippageUnbalancedShell30PctWeight () logs_gas public {
    //     deposit(1, dai, 135*WAD, usdc, 90*(10**6), usdt, 60*(10**6), susd, 30*WAD);
    //     uint256 targetAmount1 = l1.swapByTarget(dai, usdt, 50*WAD, 5*(10**6), now + 500);
    //     deposit(2, dai, 135*WAD, usdc, 90*(10**6), usdt, 60*(10**6), susd, 30*WAD);
    //     uint256 targetAmount2 = l2.swapByTarget(dai, usdt, 50*WAD, (5*(10**6))/2, now + 500);
    //     targetAmount2 += l2.swapByTarget(dai, usdt, 50*WAD, (5*(10**6))/2, now + 500);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testTargetSwapContinuityFullUpperAndLowerSlippageUnbalancedShell30PctWeightTo10PctWeight () logs_gas public {
    //     deposit(1, dai, 135*WAD, usdc, 90*(10**6), usdt, 65*(10**6), susd, 25*WAD);
    //     uint256 targetAmount1 = l1.swapByTarget(dai, susd, 5*WAD, 3*WAD, now + 500);
    //     deposit(2, dai, 135*WAD, usdc, 90*(10**6), usdt, 65*(10**6), susd, 25*WAD);
    //     uint256 targetAmount2 = l2.swapByTarget(dai, susd, 5*WAD, (3*WAD)/2, now + 500);
    //     targetAmount2 += l2.swapByTarget(dai, susd, 5*WAD, (3*WAD)/2, now + 500);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testTargetSwapContinuityFullUpperAndLowerSlippageUnbalancedShell10PctWeightTo30PctWeight () public {
    //     deposit(1, dai, 90*WAD, usdc, 55*(10**6), usdt, 90*(10**6), susd, 35*WAD);
    //     uint256 targetAmount1 = l1.swapByTarget(susd, usdc, 100*WAD, 2800000, now+50);
    //     deposit(2, dai, 90*WAD, usdc, 55*(10**6), usdt, 90*(10**6), susd, 35*WAD);
    //     uint256 targetAmount2 = l2.swapByTarget(susd, usdc, 100*WAD, 1400000, now+50);
    //     targetAmount2 += l2.swapByTarget(susd, usdc, 100*WAD, 1400000, now+50);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testTargetSwapContinuityPartialUpperAndLowerAntiSlippageUnbalanced30PctWeight () public {
    //     deposit(1, dai, 135*WAD, usdc, 60*(10**6), usdt, 90*(10**6), susd, 30*WAD);
    //     uint256 targetAmount1 = l1.swapByTarget(usdc, dai, 30*WAD, 30*WAD, now+50);
    //     deposit(2, dai, 135*WAD, usdc, 60*(10**6), usdt, 90*(10**6), susd, 30*WAD);
    //     uint256 targetAmount2 = l2.swapByTarget(usdc, dai, 30*WAD, 15*WAD, now+50);
    //     targetAmount2 += l2.swapByTarget(usdc, dai, 30*WAD, 15*WAD, now+50);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testTargetSwapContinuityPartialUpperAndLowerAntiSlippageUnbalanced10PctWeightTo30PctWeight () public {
    //     deposit(1, dai, 135*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 25*WAD);
    //     uint256 targetAmount1 = l1.swapByTarget(susd, dai, 11*WAD, 10*WAD, now+50);
    //     deposit(2, dai, 135*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 25*WAD);
    //     uint256 targetAmount2 = l2.swapByTarget(susd, dai, 11*WAD, 5*WAD, now+50);
    //     targetAmount2 += l2.swapByTarget(susd, dai, 11*WAD, 5*WAD, now+50);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testTargetSwapContinuityPartialUpperAndLowerAntiSlippageUnbalanced30PctWeightTo10PctWeight () public {
    //     deposit(1, dai, 90*WAD, usdc, 90*(10**6), usdt, 58*(10**6), susd, 40*WAD);
    //     uint256 targetAmount1 = l1.swapByTarget(usdt, susd, 10*WAD, 10*WAD, now +50);
    //     deposit(2, dai, 90*WAD, usdc, 90*(10**6), usdt, 58*(10**6), susd, 40*WAD);
    //     uint256 targetAmount2 = l2.swapByTarget(usdt, susd, 10*WAD, 5*WAD, now +50);
    //     targetAmount2 += l2.swapByTarget(usdt, susd, 10*WAD, 5*WAD, now +50);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testTargetSwapContinuityFullUpperAndLowerAntiSlippageUnbalanced30PctWeight () public {
    //     deposit(1, dai, 90*WAD, usdc, 135*(10**6), usdt, 60*(10**6), susd, 30*WAD);
    //     uint256 targetAmount1 = l1.swapByTarget(usdt, usdc, 10*(10**6), 5*(10**6), now + 50);
    //     deposit(2, dai, 90*WAD, usdc, 135*(10**6), usdt, 60*(10**6), susd, 30*WAD);
    //     uint256 targetAmount2 = l2.swapByTarget(usdt, usdc, 10*(10**6), (5*(10**6))/2, now + 50);
    //     targetAmount2 += l2.swapByTarget(usdt, usdc, 10*(10**6), (5*(10**6))/2, now + 50);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testTargetSwapContinuityFullUpperAndLowerAntiSlippage10PctOrigin30PctTarget () public {
    //     deposit(1, dai, 90*WAD, usdc, 90 *(10**6), usdt, 135*(10**6), susd, 25*WAD);
    //     uint256 targetAmount1 = l1.swapByTarget(susd, usdt, 50*WAD, 3653700, now + 50);
    //     deposit(2, dai, 90*WAD, usdc, 90 *(10**6), usdt, 135*(10**6), susd, 25*WAD);
    //     uint256 targetAmount2 = l2.swapByTarget(susd, usdt, 50*WAD, (3653700)/2, now + 50);
    //     targetAmount2 += l2.swapByTarget(susd, usdt, 50*WAD, (3653700)/2, now + 50);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testTargetSwapContinuityFullUpperAndLowerAntiSlippage30pctOriginTo10Pct () public {
    //     deposit(1, dai, 58*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 40*WAD);
    //     uint256 targetAmount1 = l1.swapByTarget(dai, susd, 10*WAD, 2349000000000000000, now+50);
    //     deposit(2, dai, 58*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 40*WAD);
    //     uint256 targetAmount2 = l2.swapByTarget(dai, susd, 10*WAD, (2349000000000000000)/2, now+50);
    //     targetAmount2 += l2.swapByTarget(dai, susd, 10*WAD, (2349000000000000000)/2, now+50);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testTargetSwapContinuityMegaLowerToUpperUpperToLower30PctWeight () public {
    //     deposit(1, dai, 55*WAD, usdc, 90*(10**6), usdt, 125*(10**6), susd, 30*WAD);
    //     uint256 targetAmount1 = l1.swapByTarget(dai, usdt, 75*WAD, 70*(10**6), now+50);
    //     deposit(2, dai, 55*WAD, usdc, 90*(10**6), usdt, 125*(10**6), susd, 30*WAD);
    //     uint256 targetAmount2 = l2.swapByTarget(dai, usdt, 75*WAD, 35*(10**6), now+50);
    //     targetAmount2 += l2.swapByTarget(dai, usdt, 75*WAD, 35*(10**6), now+50);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testTargetSwapContinuityMegaLowerToUpper10PctWeightTo30PctWeight () public {
    //     deposit(1, dai, 90*WAD, usdc, 90*(10**6), usdt, 100*(10**6), susd, 20*WAD);
    //     uint256 targetAmount1 = l1.swapByTarget(susd, usdt, 21*WAD, 20*(10**6), now+50);
    //     deposit(2, dai, 90*WAD, usdc, 90*(10**6), usdt, 100*(10**6), susd, 20*WAD);
    //     uint256 targetAmount2 = l2.swapByTarget(susd, usdt, 21*WAD, 10*(10**6), now+50);
    //     targetAmount2 += l2.swapByTarget(susd, usdt, 21*WAD, 10*(10**6), now+50);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testTargetSwapContinuityMegaUpperToLower30PctWeightTo10PctWeight () public {
    //     deposit(1, dai, 80*WAD, usdc, 100*(10**6), usdt, 80*(10**6), susd, 40*WAD);
    //     uint256 targetAmount1 = l1.swapByTarget(dai, susd, 22*WAD, 20*WAD, now+50);
    //     deposit(2, dai, 80*WAD, usdc, 100*(10**6), usdt, 80*(10**6), susd, 40*WAD);
    //     uint256 targetAmount2 = l2.swapByTarget(dai, susd, 22*WAD, 10*WAD, now+50);
    //     targetAmount2 += l2.swapByTarget(dai, susd, 22*WAD, 10*WAD, now+50);
    //     assertEq(targetAmount1, targetAmount2);
    // }

    // function testDepositContinuityBalancedDirectVanillaNoFees10Dai10Usdc10Usdt2Point5Susd () public {
    //     uint256 newShells1 = deposit(1, dai, 10*WAD, usdc, 10 * (10**6), usdt,  10 * (10**6), susd, 2500000000000000000);
    //     uint256 newShells2 = deposit(2, dai, 5*WAD, usdc, 5 * (10**6), usdt,  5 * (10**6), susd, (2500000000000000000)/2);
    //     newShells2 += deposit(2, dai, 5*WAD, usdc, 5*(10**6), usdt, 5*(10**6), susd, (2500000000000000000)/2);
    //     assertEq(newShells1, newShells2);
    // }

    // function testDepositContinuityBalancedDirectVanillaNoIndirectFees5Dai1Usdc3Usdt1Susd () public {
    //     deposit(1, dai, 80*WAD, usdc, 100*(10**6), usdt, 85*(10**6), susd, 35*WAD);
    //     uint256 newShells1 = deposit(1, dai, 5 * WAD, usdc, 1 * (10**6), usdt, 3 * (10**6), susd, WAD);
    //     deposit(2, dai, 80*WAD, usdc, 100*(10**6), usdt, 85*(10**6), susd, 35*WAD);
    //     uint256 newShells2 = deposit(1, dai, (5 * WAD)/2, usdc, (1 * (10**6))/2, usdt, (3 * (10**6))/2, susd, WAD/2);
    //     newShells2 += deposit(1, dai, (5 * WAD)/2, usdc, (1 * (10**6))/2, usdt, (3 * (10**6))/2, susd, WAD/2);
    //     assertEq(newShells1, newShells2);
    // }

    // function testDepositContinuityFromZeroPartialUpperSlippage145Dai90Usdc90Usdt50Susd () public {
    //     uint256 newShells1 = deposit(1, dai, 145 * WAD, usdc, 90 * (10**6), usdt, 90 * (10**6), susd, 50 * WAD);
    //     uint256 newShells2 = deposit(2, dai, (145 * WAD)/2, usdc, (90 * (10**6))/2, usdt, (90 * (10**6))/2, susd, (50 * WAD)/2);
    //     newShells2 += deposit(2, dai, (145 * WAD)/2, usdc, (90 * (10**6))/2, usdt, (90 * (10**6))/2, susd, (50 * WAD)/2);
    //     assertEq(newShells1, newShells2);
    // }

    // function testDepositContinuityFromZeroPartialLowerSlippage95Dai55Usdc95Usdt15Susd () public {
    //     uint256 newShells1 = deposit(1, dai, 95 * WAD, usdc, 55 * (10**6), usdt, 95 * (10**6), susd, 15 * WAD);
    //     uint256 newShells2 = deposit(2, dai, (95 * WAD)/2, usdc, (55 * (10**6))/2, usdt, (95 * (10**6))/2, susd, (15 * WAD)/2);
    //     newShells2 += deposit(2, dai, (95 * WAD)/2, usdc, (55 * (10**6))/2, usdt, (95 * (10**6))/2, susd, (15 * WAD)/2);
    //     assertEq(newShells1, newShells2);
    // }

    // function testDepositContinuityBalancedPartialUpperSlippage5Dai5Usdc70Usdt28Susd () public {
    //     uint256 newShells1 = deposit(1, dai, 5 * WAD, usdc, 5 * (10**6), usdt, 70 * (10**6), susd, 28 * WAD);
    //     uint256 newShells2 = deposit(2, dai, (5 * WAD)/2, usdc, (5 * (10**6))/2, usdt, (70 * (10**6))/2, susd, (28 * WAD)/2);
    //     newShells2 += deposit(2, dai, (5 * WAD)/2, usdc, (5 * (10**6))/2, usdt, (70 * (10**6))/2, susd, (28 * WAD)/2);
    //     assertEq(newShells1, newShells2);
    // }

    // function testDepositContinuityModeratelyUnbalancedPartialLowerSlippage1Dai51Usdc51Usdt1Susd () public {
    //     deposit(1, dai, 80*WAD, usdc, 100*(10**6), usdt, 100*(10**6), susd, 23*WAD);
    //     uint256 newShells1 = deposit(1, dai, WAD, usdc, 51 * (10**6), usdt, 51 * (10**6), susd, WAD);
    //     deposit(2, dai, 80*WAD, usdc, 100*(10**6), usdt, 100*(10**6), susd, 23*WAD);
    //     uint256 newShells2 = deposit(2, dai, WAD/2, usdc, (51 * (10**6))/2, usdt, (51 * (10**6))/2, susd, WAD/2);
    //     newShells2 += deposit(2, dai, WAD/2, usdc, (51 * (10**6))/2, usdt, (51 * (10**6))/2, susd, WAD/2);
    //     assertEq(newShells1, newShells2);
    // }

    // function testDepositContinuityBalancedPartialLowerSlippageGreaterFeeThanDeposit0Point001Dai90Usdc90Usdt0Susd () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 newShells1 = deposit(1, dai, WAD/1000, usdc, 90*(10**6), usdt, 90*(10**6), susd, 0);
    //     l2.proportionalDeposit(300*WAD);
    //     uint256 newShells2 = deposit(2, dai, (WAD/1000)/2, usdc, (90*(10**6))/2, usdt, (90*(10**6))/2, susd, 0);
    //     newShells2 += deposit(2, dai, (WAD/1000)/2, usdc, (90*(10**6))/2, usdt, (90*(10**6))/2, susd, 0);
    //     assertEq(newShells1, newShells2);
    // }

    // function testDepositContinuityUnbalancedPartialUpperAntiSlippageNoDeposit0Dai46Usdc53Usdt0SusdInto145Dai90Usdc90Usdt50Susd () public {
    //     deposit(1, dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 newShells1 = deposit(1, dai, 0, usdc, 46*(10**6), usdt, 53*(10**6), susd, 0);
    //     deposit(2, dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 newShells2 = deposit(2, dai, 0, usdc, (46*(10**6))/2, usdt, (53*(10**6))/2, susd, 0);
    //     newShells2 += deposit(2, dai, 0, usdc, (46*(10**6))/2, usdt, (53*(10**6))/2, susd, 0);
    //     assertEq(newShells1, newShells2);
    // }

    // function testDepositContinuityUnbalancedPartialUpperAntiSlippage1Dai46Usdc53Usdt1SusdInto145Dai90Usdc90Usdt50Susd () public {
    //     deposit(1, dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 newShells1 = deposit(1, dai, WAD, usdc, 46*(10**6), usdt, 53*(10**6), susd, WAD);
    //     deposit(2, dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 newShells2 = deposit(2, dai, WAD/2, usdc, (46*(10**6))/2, usdt, (53*(10**6))/2, susd, WAD/2);
    //     newShells2 += deposit(2, dai, WAD/2, usdc, (46*(10**6))/2, usdt, (53*(10**6))/2, susd, WAD/2);
    //     assertEq(newShells1, newShells2);
    // }

    // function testDepositContinuityUnbalancedPartialLowerAntiSlippage0Dai36Usdc0Usdt18SusdInto95Dai55Usdc95Usdt15Susd () public {
    //     deposit(1, dai, 95*WAD, usdc, 55*(10**6), usdt, 95*(10**6), susd, 15*WAD);
    //     uint256 newShells1 = deposit(1, dai, 0, usdc, 36*(10**6), usdt, 0, susd, 18*WAD);
    //     deposit(2, dai, 95*WAD, usdc, 55*(10**6), usdt, 95*(10**6), susd, 15*WAD);
    //     uint256 newShells2 = deposit(2, dai, 0, usdc, (36*(10**6))/2, usdt, 0, susd, (18*WAD)/2);
    //     newShells2 += deposit(2, dai, 0, usdc, (36*(10**6))/2, usdt, 0, susd, (18*WAD)/2);
    //     assertEq(newShells1, newShells2);
    // }

    // function testDepositContinuityUnbalancedFullUpperSlippageFeeLessThanDeposit0Dai5Usdc0Usdt3SusdInto90Dai145Usdc90Usdt50Susd () public {
    //     deposit(1, dai, 90*WAD, usdc, 145*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 newShells1 = deposit(1, dai, 0, usdc, 5*(10**6), usdt, 0, susd, 3*WAD);
    //     deposit(2, dai, 90*WAD, usdc, 145*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 newShells2 = deposit(2, dai, 0, usdc, (5*(10**6))/2, usdt, 0, susd, (3*WAD)/2);
    //     newShells2 += deposit(2, dai, 0, usdc, (5*(10**6))/2, usdt, 0, susd, (3*WAD)/2);
    //     assertEq(newShells1, newShells2);
    // }

    // function testDepositContinuityUnbalancedFullLowerSlippageFeeLessThanDeposit12Dai12Usdc1Usdt1SusdInto95Dai95Usdc55Usdt15Susd () public {
    //     deposit(1, dai, 95*WAD, usdc, 95*(10**6), usdt, 55*(10**6), susd, 15*WAD);
    //     uint256 newShells1 = deposit(1, dai, 12*WAD, usdc, 12*(10**6), usdt, 10**6, susd, WAD);
    //     deposit(2, dai, 95*WAD, usdc, 95*(10**6), usdt, 55*(10**6), susd, 15*WAD);
    //     uint256 newShells2 = deposit(2, dai, (12*WAD)/2, usdc, (12*(10**6))/2, usdt, (10**6)/2, susd, WAD/2);
    //     newShells2 += deposit(2, dai, (12*WAD)/2, usdc, (12*(10**6))/2, usdt, (10**6)/2, susd, WAD/2);
    //     assertEq(newShells1, newShells2);
    // }

    // function testDepositContinuityUnbalancedFullLowerSlippageFeeGreaterThanDeposit9Dai9Usdc0Usdt0SusdInto95Dai95Usdc55Usdt15Susd () public {
    //     deposit(1, dai, 95*WAD, usdc, 95*(10**6), usdt, 55*(10**6), susd, 15*WAD);
    //     uint256 newShells1 = deposit(1, dai, 9*WAD, usdc, 9*(10**6), usdt, 0, susd, 0);
    //     deposit(2, dai, 95*WAD, usdc, 95*(10**6), usdt, 55*(10**6), susd, 15*WAD);
    //     uint256 newShells2 = deposit(2, dai, (9*WAD)/2, usdc, (9*(10**6))/2, usdt, 0, susd, 0);
    //     newShells2 += deposit(2, dai, (9*WAD)/2, usdc, (9*(10**6))/2, usdt, 0, susd, 0);
    //     assertEq(newShells1, newShells2);
    // }

    // function testDepositContinuityUnbalancedFullUpperAntiSlippageNoDeposit5Dai5Usdc0Usdt0SusdInto90Dai90Usdc145Usdt50Susd () public {
    //     deposit(1, dai, 90*WAD, usdc, 90*(10**6), usdt, 145*(10**6), susd, 50*WAD);
    //     uint256 newShells1 = deposit(1, dai, 5*WAD, usdc, 5*(10**6), usdt, 0, susd, 0);
    //     deposit(2, dai, 90*WAD, usdc, 90*(10**6), usdt, 145*(10**6), susd, 50*WAD);
    //     uint256 newShells2 = deposit(2, dai, (5*WAD)/2, usdc, (5*(10**6))/2, usdt, 0, susd, 0);
    //     newShells2 += deposit(2, dai, (5*WAD)/2, usdc, (5*(10**6))/2, usdt, 0, susd, 0);
    //     assertEq(newShells1, newShells2);
    // }

    // function testDepositContinuityUnbalancedFullUpperAntiSlippage8Dai12Usdc10Usdt2SusdInto145Dai90Usdc90Usdt50Susd () public {
    //     deposit(1, dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 newShells1 = deposit(1, dai, 8*WAD, usdc, 12*(10**6), usdt, 10*(10**6), susd, 2*WAD);
    //     deposit(2, dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 newShells2 = deposit(2, dai, 4*WAD, usdc, 6*(10**6), usdt, 5*(10**6), susd, WAD);
    //     newShells2 += deposit(2, dai, 4*WAD, usdc, 6*(10**6), usdt, 5*(10**6), susd, WAD);
    //     assertEq(newShells1, newShells2);
    // }

    // function testDepositContinuityUnbalancedFullLowerAntiSlippage5Dai5Usdc5Usdt2SusdInto55Dai95Usdc95Usdt15Susd  () public {
    //     deposit(1, dai, 55*WAD, usdc, 95*(10**6), usdt, 95*(10**6), susd, 15*WAD);
    //     uint256 newShells1 = deposit(1, dai, 5*WAD, usdc, 5*(10**6), usdt, 5*(10**6), susd, 2*WAD);
    //     deposit(2, dai, 55*WAD, usdc, 95*(10**6), usdt, 95*(10**6), susd, 15*WAD);
    //     uint256 newShells2 = deposit(2, dai, (5*WAD)/2, usdc, (5*(10**6))/2, usdt, (5*(10**6))/2, susd, WAD);
    //     newShells2 += deposit(2, dai, (5*WAD)/2, usdc, (5*(10**6))/2, usdt, (5*(10**6))/2, susd, WAD);
    //     assertEq(newShells1, newShells2);
    // }

    // function testDepositContinuityToFeeZone36Dai0Usdc0Usdt0SusdFromProportional300 () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted1 = deposit(1, dai, 36*WAD, usdc, 0, usdt, 0, susd, 0);
    //     l2.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted2 = deposit(2, dai, 18*WAD, usdc, 0, usdt, 0, susd, 0);
    //     shellsMinted2 += deposit(2, dai, 18*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted1, shellsMinted2);
    // }

    // function testDepositContinuityJustPastFeeZone36Point001Dai0Usdc0Usdt0SusdFromProportional300 () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted1 = deposit(1, dai, 36*WAD + WAD/10000, usdc, 0, usdt, 0, susd, 0);
    //     l2.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted2 = deposit(2, dai, (36*WAD + WAD/10000)/2, usdc, 0, usdt, 0, susd, 0);
    //     shellsMinted2 += deposit(2, dai, (36*WAD + WAD/10000)/2, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted1, shellsMinted2);
    // }

    // function testDepositContinuityMegaDepositDirectLowerToUpper105Dai37SusdFrom55Dai95Usdc95Usdt15Susd () public {
    //     deposit(1, dai, 55*WAD, usdc, 95*(10**6), usdt, 95*(10**6), susd, 15*WAD);
    //     uint256 newShells1 = deposit(1, dai, 105*WAD, usdc, 0, usdt, 0, susd, 37*WAD);
    //     deposit(2, dai, 55*WAD, usdc, 95*(10**6), usdt, 95*(10**6), susd, 15*WAD);
    //     uint256 newShells2 = deposit(2, dai, (105*WAD)/2, usdc, 0, usdt, 0, susd, (37*WAD)/2);
    //     newShells2 += deposit(2, dai, (105*WAD)/2, usdc, 0, usdt, 0, susd, (37*WAD)/2);
    //     assertEq(newShells1, newShells2);
    // }

    // function testDepositContinuityMegaDepositIndirectUpperToLower165Dai165UsdtInto90Dai145Usdc90Usdt50Susd () public {
    //     deposit(1, dai, 90*WAD, usdc, 145*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 newShells1 = deposit(1, dai, 165*WAD, usdc, 0, usdt, 165*(10**6), susd, 0);
    //     deposit(2, dai, 90*WAD, usdc, 145*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 newShells2 = deposit(2, dai, (165*WAD)/2, usdc, 0, usdt, (165*(10**6))/2, susd, 0);
    //     newShells2 += deposit(2, dai, (165*WAD)/2, usdc, 0, usdt, (165*(10**6))/2, susd, 0);
    //     assertEq(newShells1, newShells2);
    // }

    // function testDepositContinuityMegaDepositIndirectUpperToLower165Dai0Point0001Usdc165UsdtPoint5SusdFrom90Dai145Usdc90Usdt50Susd () public {
    //     deposit(1, dai, 90*WAD, usdc, 145*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 newShells1 = deposit(1, dai, 165*WAD, usdc, (10**6)/10000, usdt, 165*(10**6), susd, WAD/2);
    //     deposit(2, dai, 90*WAD, usdc, 145*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 newShells2 = deposit(2, dai, (165*WAD)/2, usdc, ((10**6)/10000)/2, usdt, (165*(10**6))/2, susd, WAD/4);
    //     newShells2 += deposit(2, dai, (165*WAD)/2, usdc, ((10**6)/10000)/2, usdt, (165*(10**6))/2, susd, WAD/4);
    //     assertEq(newShells1, newShells2);
    // }

    // function testDepositContinuityProportionalDepositIntoAnUnbalancedShell () public {
    //     deposit(1, dai, 90*WAD, usdc, 90*(10**6), usdt, 140*(10**6), susd, 50*WAD);
    //     uint256 newShells1 = l1.proportionalDeposit(90*WAD);
    //     deposit(2, dai, 90*WAD, usdc, 90*(10**6), usdt, 140*(10**6), susd, 50*WAD);
    //     uint256 newShells2 = l2.proportionalDeposit(45*WAD);
    //     newShells2 += l2.proportionalDeposit(45*WAD);
    //     assertEq(newShells1, newShells2);
    // }

    // function testWithdrawContinuityBalancedWithdraw10Dai10Usdc10Usdt2Point5SusdFrom300Proportional () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsBurned1 = withdraw(1, dai, 10*WAD, usdc, 10*(10**6), usdt, 10*(10**6), susd, 2500000000000000000);
    //     l2.proportionalDeposit(300*WAD);
    //     uint256 shellsBurned2 = withdraw(2, dai, 5*WAD, usdc, 5*(10**6), usdt, 5*(10**6), susd, (2500000000000000000)/2);
    //     shellsBurned2 += withdraw(2, dai, 5*WAD, usdc, 5*(10**6), usdt, 5*(10**6), susd, (2500000000000000000)/2);
    //     assertEq(shellsBurned1, shellsBurned2);
    // }

    // function testWithdrawContinuityModeratelyUnbalancedWithdraw5Dai1Usdc3Usdt1SusdFrom80Dai100Usdc85Usdt35Susd () public {
    //     deposit(1, dai, 80*WAD, usdc, 100*(10**6), usdt, 85*(10**6), susd, 35*WAD);
    //     uint256 shellsBurned1 = withdraw(1, dai, 5*WAD, usdc, 10**6, usdt, 3*(10**6), susd, WAD);
    //     deposit(2, dai, 80*WAD, usdc, 100*(10**6), usdt, 85*(10**6), susd, 35*WAD);
    //     uint256 shellsBurned2 = withdraw(2, dai, (5*WAD)/2, usdc, (10**6)/2, usdt, (3*(10**6))/2, susd, WAD/2);
    //     shellsBurned2 += withdraw(2, dai, (5*WAD)/2, usdc, (10**6)/2, usdt, (3*(10**6))/2, susd, WAD/2);
    //     assertEq(shellsBurned1, shellsBurned2);
    // }

    // function testWithdrawContinuityPartialLowerSlippage5Dai5Usdc47Usdt16SusdFromProportional300 () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsBurned1 = withdraw(1, dai, 5*WAD, usdc, 5*(10**6), usdt, 47*(10**6), susd, 16*WAD);
    //     l2.proportionalDeposit(300*WAD);
    //     uint256 shellsBurned2 = withdraw(2, dai, (5*WAD)/2, usdc, (5*(10**6))/2, usdt, (47*(10**6))/2, susd, 8*WAD);
    //     shellsBurned2 += withdraw(2, dai, (5*WAD)/2, usdc, (5*(10**6))/2, usdt, (47*(10**6))/2, susd, 8*WAD);
    //     assertEq(shellsBurned1, shellsBurned2);
    // }

    // function testWithdrawContinuityPartialLowerSlippage3Dai60Usdc30Usdt1SusdFrom80Dai100Usdc100Usdt23Susd () public {
    //     deposit(1, dai, 80*WAD, usdc, 100*(10**6), usdt, 100*(10**6), susd, 23*WAD);
    //     uint256 shellsBurned1 = withdraw(1, dai, 3*WAD, usdc, 60*(10**6), usdt, 30*(10**6), susd, 1*WAD);
    //     deposit(2, dai, 80*WAD, usdc, 100*(10**6), usdt, 100*(10**6), susd, 23*WAD);
    //     uint256 shellsBurned2 = withdraw(2, dai, (3*WAD)/2, usdc, 30*(10**6), usdt, 15*(10**6), susd, WAD/2);
    //     shellsBurned2 += withdraw(2, dai, (3*WAD)/2, usdc, 30*(10**6), usdt, 15*(10**6), susd, WAD/2);
    //     assertEq(shellsBurned1, shellsBurned2);
    // }

    // function testWithdrawContinuityPartialUpperSlippage0Point001Dai40Usdc40Usdt10SusdFromProportional300 () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsBurned1 = withdraw(1, dai, WAD/1000, usdc, 40*(10**6), usdt, 40*(10**6), susd, 10*WAD);
    //     l2.proportionalDeposit(300*WAD);
    //     uint256 shellsBurned2 = withdraw(2, dai, (WAD/1000)/2, usdc, 20*(10**6), usdt, 20*(10**6), susd, 5*WAD);
    //     shellsBurned2 += withdraw(2, dai, (WAD/1000)/2, usdc, 20*(10**6), usdt, 20*(10**6), susd, 5*WAD);
    //     assertEq(shellsBurned1, shellsBurned2);
    // }

    // function testWithdrawContinuityPartialLowerAntiSlippageNoWithdraw40Dai0Usdc40Usdt0SusdFrom95Dai55Usdc95Usdt15Susd () public {
    //     deposit(1, dai, 95*WAD, usdc, 55*(10**6), usdt, 95*(10**6), susd, 15*WAD);
    //     uint256 shellsBurned1 = withdraw(1, dai, 40*WAD, usdc, 0, usdt, 40*(10**6), susd, 0);
    //     deposit(2, dai, 95*WAD, usdc, 55*(10**6), usdt, 95*(10**6), susd, 15*WAD);
    //     uint256 shellsBurned2 = withdraw(2, dai, 20*WAD, usdc, 0, usdt, 20*(10**6), susd, 0);
    //     shellsBurned2 += withdraw(2, dai, 20*WAD, usdc, 0, usdt, 20*(10**6), susd, 0);
    //     assertEq(shellsBurned1, shellsBurned2);
    // }

    // function testWithdrawContinuityPartialLowerAntiSlippageWithWithdraw0Point0001Dai41Usdc41Usdt1SusdFrom55Dai95Usdc95Usdt15Susd () public {
    //     deposit(1, dai, 55*WAD, usdc, 95*(10**6), usdt, 95*(10**6), susd, 15*WAD);
    //     uint256 shellsBurned1 = withdraw(1, dai, WAD/10000, usdc, 41*(10**6), usdt, 41*(10**6), susd, WAD);
    //     deposit(2, dai, 55*WAD, usdc, 95*(10**6), usdt, 95*(10**6), susd, 15*WAD);
    //     uint256 shellsBurned2 = withdraw(2, dai, (WAD/10000)/2, usdc, (41*(10**6))/2, usdt, (41*(10**6))/2, susd, WAD/2);
    //     shellsBurned2 += withdraw(2, dai, (WAD/10000)/2, usdc, (41*(10**6))/2, usdt, (41*(10**6))/2, susd, WAD/2);
    //     assertEq(shellsBurned1, shellsBurned2);
    // }

    // function testWithdrawContinuityPartialUpperAntiSlippage0Dai50Usdc0Usdt18SusdFrom90Dai145Usdc90Usdt50Susd () public {
    //     deposit(1, dai, 90*WAD, usdc, 145*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 shellsBurned1 = withdraw(1, dai, 0, usdc, 50*(10**6), usdt, 0, susd, 18*WAD);
    //     deposit(2, dai, 90*WAD, usdc, 145*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 shellsBurned2 = withdraw(2, dai, 0, usdc, 25*(10**6), usdt, 0, susd, 9*WAD);
    //     shellsBurned2 += withdraw(2, dai, 0, usdc, 25*(10**6), usdt, 0, susd, 9*WAD);
    //     assertEq(shellsBurned1, shellsBurned2);
    // }

    // function testWithdrawContinuityFullUpperSlippageNoWithdraw5Dai0Usdc5Usdt0SusdFrom90Dai145Usdc90Usdt50Susd () public {
    //     deposit(1, dai, 90*WAD, usdc, 145*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 shellsBurned1 = withdraw(1, dai, 5*WAD, usdc, 0, usdt, 5*(10**6), susd, 0);
    //     deposit(2, dai, 90*WAD, usdc, 145*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 shellsBurned2 = withdraw(2, dai, (5*WAD)/2, usdc, 0, usdt, (5*(10**6))/2, susd, 0);
    //     shellsBurned2 += withdraw(2, dai, (5*WAD)/2, usdc, 0, usdt, (5*(10**6))/2, susd, 0);
    //     assertEq(shellsBurned1, shellsBurned2);
    // }

    // function testWithdrawContinuityFullUpperSlippage8Dai2Usdc8Usdt2SusdFrom90Dai145Usdc90Usdt50Susd () public {
    //     deposit(1, dai, 90*WAD, usdc, 145*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 shellsBurned1 = withdraw(1, dai, 8*WAD, usdc, 2*(10**6), usdt, 8*(10**6), susd, 2*WAD);
    //     deposit(2, dai, 90*WAD, usdc, 145*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 shellsBurned2 = withdraw(2, dai, 4*WAD, usdc, 10**6, usdt, 4*(10**6), susd, WAD);
    //     shellsBurned2 += withdraw(2, dai, 4*WAD, usdc, 10**6, usdt, 4*(10**6), susd, WAD);
    //     assertEq(shellsBurned1, shellsBurned2);
    // }

    // function testWithdrawContinuityFullLowerSlippage0Dai1Usdc7Usdt2SusdFrom95Dai95Usdc55Usdt15Susd () public {
    //     deposit(1, dai, 95*WAD, usdc, 95*(10**6), usdt, 55*(10**6), susd, 15*WAD);
    //     uint256 shellsBurned1 = withdraw(1, dai, 0, usdc, 10**6, usdt, 7*(10**6), susd, 2*WAD);
    //     deposit(2, dai, 95*WAD, usdc, 95*(10**6), usdt, 55*(10**6), susd, 15*WAD);
    //     uint256 shellsBurned2 = withdraw(2, dai, 0, usdc, (10**6)/2, usdt, (7*(10**6))/2, susd, WAD);
    //     shellsBurned2 += withdraw(2, dai, 0, usdc, (10**6)/2, usdt, (7*(10**6))/2, susd, WAD);
    //     assertEq(shellsBurned1, shellsBurned2);
    // }

    // function testWithdrawContinuityFullLowerAntiSlippageNoWithdraw5Dai5Usdc0Usdt0SusdFrom95Dai95Usdc55Usdt15Susd () public {
    //     deposit(1, dai, 95*WAD, usdc, 95*(10**6), usdt, 55*(10**6), susd, 15*WAD);
    //     uint256 shellsBurned1 = withdraw(1, dai, 5*WAD, usdc, 5*(10**6), usdt, 0, susd, 0);
    //     deposit(2, dai, 95*WAD, usdc, 95*(10**6), usdt, 55*(10**6), susd, 15*WAD);
    //     uint256 shellsBurned2 = withdraw(2, dai, (5*WAD)/2, usdc, (5*(10**6))/2, usdt, 0, susd, 0);
    //     shellsBurned2 += withdraw(2, dai, (5*WAD)/2, usdc, (5*(10**6))/2, usdt, 0, susd, 0);
    //     assertEq(shellsBurned1, shellsBurned2);
    // }

    // function testWithdrawContinuityFullLowerAntiSlippageWithdraw5Dai5Usdc0Point5Usdt0Point2SusdFrom95Dai95Usdc55Usdt15Susd () public {
    //     deposit(1, dai, 95*WAD, usdc, 95*(10**6), usdt, 55*(10**6), susd, 15*WAD);
    //     uint256 shellsBurned1 = withdraw(1, dai, 5*WAD, usdc, 5*(10**6), usdt, (10**6)/2, susd, WAD/5);
    //     deposit(2, dai, 95*WAD, usdc, 95*(10**6), usdt, 55*(10**6), susd, 15*WAD);
    //     uint256 shellsBurned2 = withdraw(2, dai, (5*WAD)/2, usdc, (5*(10**6))/2, usdt, (10**6)/4, susd, WAD/10);
    //     shellsBurned2 += withdraw(2, dai, (5*WAD)/2, usdc, (5*(10**6))/2, usdt, (10**6)/4, susd, WAD/10);
    //     assertEq(shellsBurned1, shellsBurned2);
    // }

    // function testWithdrawContinuityFullUpperAntiSlippage5Dai2SusdFrom145Dai90Usdc90Usdt50Susd () public {
    //     deposit(1, dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 shellsBurned1 = withdraw(1, dai, 5*WAD, usdc, 0, usdt, 0, susd, 2*WAD);
    //     deposit(2, dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 shellsBurned2 = withdraw(2, dai, (5*WAD)/2, usdc, 0, usdt, 0, susd, WAD);
    //     shellsBurned2 += withdraw(2, dai, (5*WAD)/2, usdc, 0, usdt, 0, susd, WAD);
    //     assertEq(shellsBurned1, shellsBurned2);
    // }

    // function testWithdrawContinuityMegaWithdrawDirectUpperToLower95Usdt35SusdFrom90Dai90Usdc145Usdt50Susd () public {
    //     deposit(1, dai, 90*WAD, usdc, 90*(10**6), usdt, 145*(10**6), susd, 50*WAD);
    //     uint256 shellsBurned1 = withdraw(1, dai, 0, usdc, 0, usdt, 95*(10**6), susd, 35*WAD);
    //     deposit(2, dai, 90*WAD, usdc, 90*(10**6), usdt, 145*(10**6), susd, 50*WAD);
    //     uint256 shellsBurned2 = withdraw(2, dai, 0, usdc, 0, usdt, (95*(10**6))/2, susd, (35*WAD)/2);
    //     shellsBurned2 += withdraw(2, dai, 0, usdc, 0, usdt, (95*(10**6))/2, susd, (35*WAD)/2);
    //     assertEq(shellsBurned1, shellsBurned2);
    // }

    // function testWithdrawContinuityMegaWithdrawIndirectLowerToUpperNoWithdraw11Dai74Usdc74UsdtFrom55Dai95Usdc95Usdt15Susd () public {
    //     deposit(1, dai, 55*WAD, usdc, 95*(10**6), usdt, 95*(10**6), susd, 15*WAD);
    //     uint256 shellsMinted1 = withdraw(1, dai, 11*WAD, usdc, 74*(10**6), usdt, 74*(10**6), susd, 0);
    //     deposit(2, dai, 55*WAD, usdc, 95*(10**6), usdt, 95*(10**6), susd, 15*WAD);
    //     uint256 shellsMinted2 = withdraw(2, dai, (11*WAD)/2, usdc, (74*(10**6))/2, usdt, (74*(10**6))/2, susd, 0);
    //     shellsMinted2 += withdraw(2, dai, (11*WAD)/2, usdc, (74*(10**6))/2, usdt, (74*(10**6))/2, susd, 0);
    //     assertEq(shellsMinted1, shellsMinted2);
    // }

    // function testWithdrawContinuityMegaWithdrawIndirectLowerToUpper11Dai74Usdc74Usdt0Point0001From55Dai95Usdc95Usdt15Susd () public {
    //     deposit(1, dai, 55*WAD, usdc, 95*(10**6), usdt, 95*(10**6), susd, 15*WAD);
    //     uint256 shellsMinted1 = withdraw(1, dai, 11*WAD, usdc, 74*(10**6), usdt, 74*(10**6), susd, WAD/10000);
    //     deposit(2, dai, 55*WAD, usdc, 95*(10**6), usdt, 95*(10**6), susd, 15*WAD);
    //     uint256 shellsMinted2 = withdraw(2, dai, (11*WAD)/2, usdc, 37*(10**6), usdt, 37*(10**6), susd, (WAD/10000)/2);
    //     shellsMinted2 += withdraw(2, dai, (11*WAD)/2, usdc, 37*(10**6), usdt, 37*(10**6), susd, (WAD/10000)/2);
    //     assertEq(shellsMinted1, shellsMinted2);
    // }

}