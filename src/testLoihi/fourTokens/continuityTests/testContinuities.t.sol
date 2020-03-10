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
    //     l.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(dai, 50*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted, 49927083339792853692);
    // }

    // function testFeeCrossContinuity36DaiThen14DaiFromProportional300 () public {
    //     l.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(dai, 36*WAD, usdc, 0, usdt, 0, susd, 0);
    //     shellsMinted += deposit(dai, 14*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted, 49927083339792333938);
    // }

    // function testFeeCrossContinuity36Point0001DaiThen13Point9999DaiFromProportional300 () public {
    //     l.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(dai, 36*WAD + WAD/10000, usdc, 0, usdt, 0, susd, 0);
    //     shellsMinted += deposit(dai, 14*WAD - WAD/10000, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted, 49927083339791772622);
    // }

    // function testContinuity50Deposit50WithdrawFrom300Proportional () public {
    //     l.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(dai, 50*WAD, usdc, 0, usdt, 0, susd, 0);
    //     uint256 shellsBurned = withdraw(dai, 50*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted, shellsBurned);
    // }

    // function testContinuityDeposit36Dai14UsdcWithdraw36Dai14UsdcFrom300Proportional () public {
    //     l.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(dai, 36*WAD, usdc, 14*(10**6), usdt, 0, susd, 0);
    //     uint256 shellsBurned = withdraw(dai, 36*WAD, usdc, 14*(10**6), usdt, 0, susd, 0);
    //     assertEq(shellsMinted, shellsBurned);
    // }

    // function testContinuityDeposit36Then14DaiWithdraw36Then14DaiFrom300Proportional () public {
    //     l.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(dai, 36*WAD, usdc, 0, usdt, 0, susd, 0);
    //     shellsMinted += deposit(dai, 14*WAD, usdc, 0, usdt, 0, susd, 0);
    //     uint256 shellsBurned = withdraw(dai, 36*WAD, usdc, 0, usdt, 0, susd, 0);
    //     shellsBurned += withdraw(dai, 14*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted, shellsBurned);
    // }

    // function testContinuityDeposit14Then36DaiWithdraw14Then36DaiFrom300Proportional () public {
    //     l.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = deposit(dai, 14*WAD, usdc, 0, usdt, 0, susd, 0);
    //     shellsMinted += deposit(dai, 36*WAD, usdc, 0, usdt, 0, susd, 0);
    //     uint256 shellsBurned = withdraw(dai, 14*WAD, usdc, 0, usdt, 0, susd, 0);
    //     shellsBurned += withdraw(dai, 36*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted, shellsBurned);
    // }

    // function testContinuitySwap () public {
    //     // deposit(dai, 55*WAD, usdc, 90*(10**6), usdt, 125*(10**6), susd, 30*WAD);
    //     l.proportionalDeposit(300*WAD);
    //     uint256 targetAmount = l.swapByOrigin(usdt, dai, 40*(10**6), 0, now+50);
    //     assertEq(targetAmount, 3*WAD);
    // }

    function testContinuityDepWith () public {
        l.proportionalDeposit(300*WAD);
        uint256 before = l.totalSupply();
        uint256 minted = deposit(dai, 0, usdc, 40*(10**6), usdt, 0, susd, 0);
        uint256 during = l.totalSupply();
        uint256 burned = withdraw(dai, 39653833013453246277, usdc, 0, usdt, 0, susd, 0);
        uint256 shellsAfter = l.totalSupply();
        assertEq(before, shellsAfter);
        emit log_named_uint("before", before);
        emit log_named_uint("during", during);
        emit log_named_uint("after", shellsAfter);
        emit log_named_uint("minted", minted);
        emit log_named_uint("burned", burned);
    }

    // function testContinuityDepositWithdraw () public {
    //     deposit(dai, 55*WAD, usdc, 90*(10**6), usdt, 125*(10**6), susd, 30*WAD);
    //     uint256 shellsBefore = l.totalSupply();
    //     uint256 minted = deposit(dai,3*WAD,usdc,0,usdt,0,susd,0);
    //     uint256 burned = withdraw(dai, 0, usdc, 0, usdt, 2816538470697623737, susd, 0);
    //     uint256 shellsAfter = l.totalSupply();
    //     assertEq(shellsBefore, shellsAfter);
    //     emit log_named_uint("before", shellsBefore);
    //     emit log_named_uint("after", shellsAfter);
    //     emit log_named_uint("burnt", burned);
    //     emit log_named_uint("minted", minted);
    // }
}