pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../../loihiSetup.sol";
import "../../../interfaces/IAdapter.sol";

contract SelectiveDepositTest is LoihiSetup, DSMath, DSTest {

    function setUp() public {

        setupLoihi();
        setupFlavors();
        setupAdapters();
        approveFlavors();
        executeApprovals();
        includeAdapters(0);

    }

    function setReserveState (address waddr, uint256 wamount, address xaddr, uint256 xamount, address yaddr, uint256 yamount, address zaddr, uint256 zamount) public returns (uint256) {
        address[] memory addrs = new address[](4);
        uint256[] memory amounts = new uint256[](4);

        addrs[0] = waddr; amounts[0] = wamount;
        addrs[1] = xaddr; amounts[1] = xamount;
        addrs[2] = yaddr; amounts[2] = yamount;
        addrs[3] = zaddr; amounts[3] = zamount;

        return l.selectiveDeposit(addrs, amounts, 0, now + 500);
    }

    // function testBalancedDirectVanillaNoFees10Dai10Usdc10Usdt2Point5Susd () public {
    //     uint256 initialShells = l.proportionalDeposit(300 * (10 ** 18));
    //     uint256 newShells = setReserveState(dai, 10*WAD, usdc, 10 * (10**6), usdt,  10 * (10**6), susd, 2500000000000000000);
    //     emit log_named_uint("NEWSHELLS", newShells);
    //     assertEq(newShells, 32500000000000000000);
    // }

    // function testBalancedDirectVanillaNoIndirectFees5Dai1Usdc3Usdt1Susd () public {
    //     setReserveState(dai, 80*WAD, usdc, 100*(10**6), usdt, 85*(10**6), susd, 35*WAD);
    //     uint256 newShells = setReserveState(dai, 5 * WAD, usdc, 1 * (10**6), usdt, 3 * (10**6), susd, WAD);
    //     assertEq(newShells, 10000000000000000000);
    // }

    // function testFromZeroPartialUpperSlippage145Dai90Usdc90Usdt50Susd () public {
    //     uint256 newShells = setReserveState(dai, 145 * WAD, usdc, 90 * (10**6), usdt, 90 * (10**6), susd, 50 * WAD);
    //     assertEq(newShells, 374956944444444444442);
    // }

    // function testFromZeroPartialLowerSlippage95Dai55Usdc95Usdt15Susd () public {
    //     uint256 newShells = setReserveState(dai, 95 * WAD, usdc, 55 * (10**6), usdt, 95 * (10**6), susd, 15 * WAD);
    //     assertEq(newShells, 259906410256410256413);
    // }

    // function testBalancedPartialUpperSlippage5Dai5Usdc70Usdt28Susd () public {

    //     uint256 startingShells = l.proportionalDeposit(300*WAD);
    //     uint256 newShells = setReserveState(dai, 5 * WAD, usdc, 5 * (10**6), usdt, 70 * (10**6), susd, 28 * WAD);
    //     assertEq(newShells, 107839869290016073510);

    // }

    // function testModeratelyUnbalancedPartialLowerSlippage1Dai51Usdc51Usdt1Susd () public {

    //     setReserveState(dai, 80*WAD, usdc, 100*(10**6), usdt, 100*(10**6), susd, 23*WAD);
    //     uint256 newShells = setReserveState(dai, WAD, usdc, 51 * (10**6), usdt, 51 * (10**6), susd, WAD);
    //     assertEq(newShells, 103803802205481130757);

    // }

    // function testBalancedPartialLowerSlippageGreaterFeeThanDeposit0Point001Dai90Usdc90Usdt0Susd () public {

    //     l.proportionalDeposit(300*WAD);
    //     uint256 newShells = setReserveState(dai, WAD/1000, usdc, 90*(10**6), usdt, 90*(10**6), susd, 0);
    //     assertEq(newShells, 179701018117657431282);

    // }

    // function testUnbalancedPartialUpperAntiSlippageNoDeposit0Dai46Usdc53Usdt0SusdInto145Dai90Usdc90Usdt50Susd () public {

    //     setReserveState(dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 newShells = setReserveState(dai, 0, usdc, 46*(10**6), usdt, 53*(10**6), susd, 0);
    //     assertEq(newShells, 99008611110088104087);

    // }

    // function testUnbalancedPartialUpperAntiSlippage1Dai46Usdc53Usdt1SusdInto145Dai90Usdc90Usdt50Susd () public {

    //     setReserveState(dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 newShells = setReserveState(dai, WAD, usdc, 46*(10**6), usdt, 53*(10**6), susd, WAD);
    //     assertEq(newShells, 101008611110088104087);

    // }

    // function testUnbalancedPartialLowerAntiSlippage0Dai36Usdc0Usdt18SusdInto95Dai55Usdc95Usdt15Susd () public {

    //     setReserveState(dai, 95*WAD, usdc, 55*(10**6), usdt, 95*(10**6), susd, 15*WAD);
    //     uint256 newShells = setReserveState(dai, 0, usdc, 36*(10**6), usdt, 0, susd, 18*WAD);
    //     assertEq(newShells, 54018717947774199076);

    // }

    // function testUnbalancedFullUpperSlippageFeeLessThanDeposit0Dai5Usdc0Usdt3SusdInto90Dai145Usdc90Usdt50Susd () public {
    //     setReserveState(dai, 90*WAD, usdc, 145*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 newShells = setReserveState(dai, 0, usdc, 5*(10**6), usdt, 0, susd, 3*WAD);
    //     assertEq(newShells, 7939106469393501544);
    // }

    // function testUnbalancedFullLowerSlippageFeeLessThanDeposit12Dai12Usdc1Usdt1SusdInto95Dai95Usdc55Usdt15Susd () public {
    //     setReserveState(dai, 95*WAD, usdc, 95*(10**6), usdt, 55*(10**6), susd, 15*WAD);
    //     uint256 newShells = setReserveState(dai, 12*WAD, usdc, 12*(10**6), usdt, 1*(10**6), susd, WAD);
    //     assertEq(newShells, 25908473193473091522);
    // }

    // function testUnbalancedFullLowerSlippageFeeGreaterThanDeposit9Dai9Usdc0Usdt0SusdInto95Dai95Usdc55Usdt15Susd () public {
    //     setReserveState(dai, 95*WAD, usdc, 95*(10**6), usdt, 55*(10**6), susd, 15*WAD);
    //     uint256 newShells = setReserveState(dai, 9*WAD, usdc, 9*(10**6), usdt, 0, susd, 0);
    //     assertEq(newShells, 17902138904261106553);
    // }

    // function testUnbalancedFullUpperAntiSlippageNoDeposit5Dai5Usdc0Usdt0SusdInto90Dai90Usdc145Usdt50Susd () public {
    //     setReserveState(dai, 90*WAD, usdc, 90*(10**6), usdt, 145*(10**6), susd, 50*WAD);
    //     uint256 newShells = setReserveState(dai, 5*WAD, usdc, 5*(10**6), usdt, 0, susd, 0);
    //     assertEq(newShells, 10006717171023848741);
    // }

    // function testUnbalancedFullUpperAntiSlippage8Dai12Usdc10Usdt2SusdInto145Dai90Usdc90Usdt50Susd () public {
    //     setReserveState(dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 newShells = setReserveState(dai, 8*WAD, usdc, 12*(10**6), usdt, 10*(10**6), susd, 2*WAD);
    //     assertEq(newShells, 32007966147128995554);
    // }

    // function testUnbalancedFullLowerAntiSlippage5Dai5Usdc5Usdt2SusdInto55Dai95Usdc95Usdt15Susd  () public {
    //     setReserveState(dai, 55*WAD, usdc, 95*(10**6), usdt, 95*(10**6), susd, 15*WAD);
    //     uint256 newShells = setReserveState(dai, 5*WAD, usdc, 5*(10**6), usdt, 5*(10**6), susd, 2*WAD);
    //     assertEq(newShells, 17007127696010375216);
    // }

    // function testDepositToFeeZone36Dai0Usdc0Usdt0SusdFromProportional300 () public {
    //     l.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = setReserveState(dai, 36*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted, 36000000000000000000);
    // }

    // function testDepositJustPastFeeZone36Point001Dai0Usdc0Usdt0SusdFromProportional300 () public {
    //     l.proportionalDeposit(300*WAD);
    //     uint256 shellsMinted = setReserveState(dai, 36*WAD + WAD/10000, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(shellsMinted, 36000099999996171122);
    // }
    // function testLowerAntiSlippageContinuityTen () public {
    //     setReserveState(dai, 45*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 30*WAD);
    //     uint256 newShells = setReserveState(dai, 10*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(newShells, 4998750000000000000);
    // }

    // function testLowerAntiSlippageContinuityFiveAndFive () public {
    //     setReserveState(dai, 45*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 30*WAD);
    //     uint256 newShells = setReserveState(dai, 5*WAD, usdc, 0, usdt, 0, susd, 0);
    //     newShells += setReserveState(dai, 5*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(newShells, 4998750000000000000);
    // }

    // function testLowerAntiSlippageContinuitySixAndFour () public {
    //     setReserveState(dai, 45*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 30*WAD);
    //     uint256 newShells = setReserveState(dai, 6*WAD, usdc, 0, usdt, 0, susd, 0);
    //     newShells += setReserveState(dai, 4*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(newShells, 4998750000000000000);
    // }

    // function testLowerAntiSlippageContinuityTwoAndTwoAndSix () public {
    //     setReserveState(dai, 45*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 30*WAD);
    //     uint256 newShells = setReserveState(dai, 2*WAD, usdc, 0, usdt, 0, susd, 0);
    //     newShells += setReserveState(dai, 2*WAD, usdc, 0, usdt, 0, susd, 0);
    //     newShells += setReserveState(dai, 6*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(newShells, 4998750000000000000);
    // }

    // function testLowerAntiSlippageContinuityThreeAndThreeAndThreeAndOne () public {
    //     setReserveState(dai, 45*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 30*WAD);
    //     uint256 newShells = setReserveState(dai, 3*WAD, usdc, 0, usdt, 0, susd, 0);
    //     newShells += setReserveState(dai, 3*WAD, usdc, 0, usdt, 0, susd, 0);
    //     newShells += setReserveState(dai, 3*WAD, usdc, 0, usdt, 0, susd, 0);
    //     newShells += setReserveState(dai, WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(newShells, 4998750000000000000);
    // }

    // function testFullUpperSlippageContinuityTen () public {
    //     setReserveState(dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 newShells = setReserveState(dai, 10*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(newShells, 32007966147128995554);
    // }

    // function testFullUppSlippageContinuityFiveAndFive () public {
    //     setReserveState(dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 newShells = setReserveState(dai, 5*WAD, usdc, 0, usdt, 0, susd, 0);
    //     newShells += setReserveState(dai, 5*WAD, usdc, 0, usdt, 0, susd, 0);
    //     assertEq(newShells, 32007966147128995554);
    // }

    // function testMegaDepositDirectLowerToUpper105Dai37SusdFrom55Dai95Usdc95Usdt15Susd () public {
    //     setReserveState(dai, 55*WAD, usdc, 95*(10**6), usdt, 95*(10**6), susd, 15*WAD);
    //     uint256 newShells = setReserveState(dai, 105*WAD, usdc, 0, usdt, 0, susd, 37*WAD);
    //     assertEq(newShells, 141958811072841197850);
    // }

    // function testMegaDepositIndirectUpperToLower165Dai165UsdtFrom90Dai145Usdc90Usdt50Susd () public {
    //     setReserveState(dai, 90*WAD, usdc, 145*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 newShells = setReserveState(dai, 165*WAD, usdc, 0, usdt, 165*(10**6), susd, 0);
    //     assertEq(newShells, 329932104018912940624);
    // }

    // function testMegaDepositIndirectUpperToLower165Dai0Point0001Usdc165UsdtPoint5SusdFrom90Dai145Usdc90Usdt50Susd () public {
    //     setReserveState(dai, 90*WAD, usdc, 145*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 newShells = setReserveState(dai, 165*WAD, usdc, (10**6)/10000, usdt, 165*(10**6), susd, WAD/2);
    //     assertEq(newShells, 330431507733603831873);
    // }

    // function testProportionalDepositIntoAnUnbalancedShell () public {
    //     setReserveState(dai, 90*WAD, usdc, 90*(10**6), usdt, 140*(10**6), susd, 50*WAD);
    //     uint256 newShells = l.proportionalDeposit(90*WAD);
    //     assertEq(newShells, 90*WAD);
    // }


} 