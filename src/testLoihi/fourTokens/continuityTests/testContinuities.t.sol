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

    // function testWithdrawContinuityTen () public {
    //     deposit(dai, 55*WAD, usdc, 95*(10**6), usdt, 95*(10**6), susd, 15*WAD);
    //     uint256 shellsBurned = withdraw(dai, 10*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsBurned, 5);
    // }

    // function testWithdrawContinuityFiveAndFive () public {
    //     deposit(dai, 55*WAD, usdc, 95*(10**6), usdt, 95*(10**6), susd, 15*WAD);
    //     uint256 shellsBurned = withdraw(dai, 5*WAD, usdc, 0, usdt, 0, susd, 0);
    //     shellsBurned += withdraw(dai, 5*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsBurned, 5);
    // }

    // function testContinuityTenWithdrawTenDeposit () public {
    //     deposit(dai, 55*WAD, usdc, 95*(10**6), usdt, 95*(10**6), susd, 15*WAD);
    //     uint256 shellsBurned = withdraw(dai, 10*WAD, usdc, 0, usdt, 0, susd, 0);
    //     uint256 shellsMinted = deposit(dai, 10*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsBurned, 5);
    //     assertEq(shellsMinted, 5);
    // }

    // function testFeeCrossContinuity50DaiFromProportional300 () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(dai, 50*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted, 49927083339792853692);
    // }

    // function testFeeCrossContinuity36DaiThen14DaiFromProportional300 () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(dai, 36*WAD, usdc, 0, usdt, 0, susd, 0);
    //     shellsMinted += deposit(dai, 14*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted, 49927083339792333938);
    // }

    // function testFeeCrossContinuity36Point0001DaiThen13Point9999DaiFromProportional300 () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(dai, 36*WAD + WAD/10000, usdc, 0, usdt, 0, susd, 0);
    //     shellsMinted += deposit(dai, 14*WAD - WAD/10000, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted, 49927083339791772622);
    // }

    // function testContinuity50Deposit50WithdrawFrom300Proportional () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(dai, 50*WAD, usdc, 0, usdt, 0, susd, 0);
    //     uint256 shellsBurned = withdraw(dai, 50*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted, shellsBurned);
    // }

    // function testContinuityDeposit36Dai14UsdcWithdraw36Dai14UsdcFrom300Proportional () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(dai, 36*WAD, usdc, 14*(10**6), usdt, 0, susd, 0);
    //     uint256 shellsBurned = withdraw(dai, 36*WAD, usdc, 14*(10**6), usdt, 0, susd, 0);
    //     assertEq(shellsMinted, shellsBurned);
    // }

    // function testContinuityDeposit36Then14DaiWithdraw36Then14DaiFrom300Proportional () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(dai, 36*WAD, usdc, 0, usdt, 0, susd, 0);
    //     shellsMinted += deposit(dai, 14*WAD, usdc, 0, usdt, 0, susd, 0);
    //     uint256 shellsBurned = withdraw(dai, 36*WAD, usdc, 0, usdt, 0, susd, 0);
    //     shellsBurned += withdraw(dai, 14*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted, shellsBurned);
    // }

    // function testContinuityDeposit14Then36DaiWithdraw14Then36DaiFrom300Proportional () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(dai, 14*WAD, usdc, 0, usdt, 0, susd, 0);
    //     shellsMinted += deposit(dai, 36*WAD, usdc, 0, usdt, 0, susd, 0);
    //     uint256 shellsBurned = withdraw(dai, 14*WAD, usdc, 0, usdt, 0, susd, 0);
    //     shellsBurned += withdraw(dai, 36*WAD, usdc, 0, usdt, 0, susd, 0);
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
    //     uint256 shellsMinted = deposit(dai, 40*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted, 5);
    // }
    // function testUnbalancedContinuitySwap () public {
    //     deposit(dai, 55*WAD, usdc, 95*(10**6), usdt, 95*(10**6), susd, 15*WAD);
    //     uint256 targetAmount = l1.swapByOrigin(usdt, dai, 15*(10**6), 0, now+50);
    // }

    // function testMe () public {
    //     string memory hi = "hi";
    //     string memory hello = "hello";
    //     assertEq(hi, hello);
    // }

    // function testUnbalancedContinuityDeposit40Withdraw39659722214604436634 () public {
    //     deposit(dai, 55*WAD, usdc, 95*(10**6), usdt, 95*(10**6), susd, 15*WAD);
    //     uint256 shellsBefore = l.totalSupply();
    //     uint256 deposited = deposit(dai, 0, usdt, 15*(10**6), usdc, 0, susd, 0);
    //     uint256 withdrawn = withdraw(dai, 14405299910046315737, usdt, 0, usdc, 0, susd, 0);
    //     uint256 shellsAfter = l.totalSupply();
    //     emit log_named_uint("shellsBefore", shellsBefore);
    //     emit log_named_uint("shellsAfter", shellsAfter);
    //     emit log_named_uint("deposited", deposited);
    //     emit log_named_uint("withdrawn", withdrawn);
    // }

    // function testUnbalancedContinuityDeposit40Withdraw39659722214604436634 () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsBefore = l.totalSupply();
    //     uint256 deposited = deposit(dai, 0, usdt, 40*(10**6), usdc, 0, susd, 0);
    //     uint256 withdrawn = withdraw(dai, 39349593617240527427, usdt, 0, usdc, 0, susd, 0);
    //     uint256 shellsAfter = l.totalSupply();
    //     emit log_named_uint("shellsBefore", shellsBefore);
    //     emit log_named_uint("shellsAfter", shellsAfter);
    //     emit log_named_uint("deposited", deposited);
    //     emit log_named_uint("withdrawn", withdrawn);
    // }

    // function testContinuityDepositTen () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(dai, 10*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted, 5);
    // }

    // function testContinuityDepositFiveAndFive () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(dai, 5*WAD, usdc, 0, usdt, 0, susd, 0);
    //     shellsMinted += deposit(dai, 5*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted, 5);
    // }

    // function testContinuityDepositFifty () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(dai, 40*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted, 5);
    // }

    // function testContinuityDepositTwentyFiveAndTwentyFive () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(dai, 25*WAD, usdc, 0, usdt, 0, susd, 0);
    //     shellsMinted += deposit(dai, 25*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted, 5);
    // }

    // function testContinuity106Dai106Usdc () public {
    //     l1.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(dai, 106*WAD, usdc, 106*(10**6), usdt, 0, susd, 0);
    //     assertEq(shellsMinted, 5);
    // }

    // function testDepositFullUpperSlippageContinuityTen () public {
    //     deposit(dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 newShells = deposit(dai, 10*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(newShells, 32007966147128995554);
    // }

    // function testDepositFullUppSlippageContinuityFiveAndFive () public {
    //     deposit(dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 newShells = deposit(dai, 5*WAD, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(dai, 5*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(newShells, 32007966147128995554);
    // }

    // function testDepositFullUppSlippageContinuityTwoPointFiveTwoPointFiveTwoPointFiveTwoPointFive () public {
    //     deposit(dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 newShells = deposit(dai, (5*WAD)/2, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(dai, (5*WAD)/2, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(dai, (5*WAD)/2, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(dai, (5*WAD)/2, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(newShells, 32007966147128995554);
    // }

    // function testDepositFullUppSlippageContinuityFiveAndTwoAndThree () public {
    //     deposit(dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 newShells = deposit(dai, 5*WAD, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(dai, 2*WAD, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(dai, 3*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(newShells, 32007966147128995554);
    // }

    // function testDepositLowerAntiSlippageContinuityTen () public {
    //     deposit(dai, 45*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 30*WAD);
    //     uint256 newShells = deposit(dai, 10*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(newShells, 4998750000000000000);
    // }

    // function testDepositLowerAntiSlippageContinuityFiveAndFive () public {
    //     deposit(dai, 45*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 30*WAD);
    //     uint256 newShells = deposit(dai, 5*WAD, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(dai, 5*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(newShells, 4998750000000000000);
    // }

    // function testDepositLowerAntiSlippageContinuitySixAndFour () public {
    //     deposit(dai, 45*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 30*WAD);
    //     uint256 newShells = deposit(dai, 6*WAD, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(dai, 4*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(newShells, 4998750000000000000);
    // }

    // function testDepositLowerAntiSlippageContinuityTwoAndTwoAndSix () public {
    //     deposit(dai, 45*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 30*WAD);
    //     uint256 newShells = deposit(dai, 2*WAD, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(dai, 2*WAD, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(dai, 6*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(newShells, 4998750000000000000);
    // }

    // function testDepositLowerAntiSlippageContinuityThreeAndThreeAndThreeAndOne () public {
    //     deposit(dai, 45*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 30*WAD);
    //     uint256 newShells = deposit(dai, 3*WAD, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(dai, 3*WAD, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(dai, 3*WAD, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(dai, WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(newShells, 4998750000000000000);
    // }

    // function testDepositLowerAntiSlippageContinuityTwoPointFiveTwoPointFiveTwoPointFiveTwoPointFive () public {
    //     deposit(dai, 45*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 30*WAD);
    //     uint256 newShells = deposit(dai, (5*WAD)/2, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(dai, (5*WAD)/2, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(dai, (5*WAD)/2, usdc, 0, usdt, 0, susd, 0);
    //     newShells += deposit(dai, (5*WAD)/2, usdc, 0, usdt, 0, susd, 0);
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
    //     deposit(dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 targetAmount = l1.swapByOrigin(dai, usdt, 10*WAD, 0, now + 500);
    //     assertEq(targetAmount, 5);
    // }

    // function testFullFeeContinuityOriginSwapFiveAndFiveDaiToUsdt () public {
    //     deposit(dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 targetAmount = l1.swapByOrigin(dai, usdt, 5*WAD, 0, now + 500);
    //     targetAmount += l1.swapByOrigin(dai, usdt, 5*WAD, 0, now + 500);
    //     assertEq(targetAmount, 5);
    // }

    // function testFullFeeContinuityTargetSwapTenUsdtFromDai () public {
    //     deposit(dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 targetAmount = l1.swapByTarget(dai, usdt, 50*WAD, 10*(10**6), now + 500);
    //     assertEq(targetAmount, 5);
    // }

    // function testFullFeeContinuityOriginSwapFiveAndFiveUsdtFromDai () public {
    //     deposit(dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 targetAmount = l1.swapByTarget(dai, usdt, 10*WAD, 5*(10**6), now + 500);
    //     targetAmount += l1.swapByTarget(dai, usdt, 10*WAD, 5*(10**6), now + 500);
    //     assertEq(targetAmount, 5);
    // }

}