// pragma solidity ^0.5.6;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../../loihiSetup.sol";
// import "../../../interfaces/IAdapter.sol";

// contract SelectiveDepositTest is LoihiSetup, DSMath, DSTest {

//     function setUp() public {

//         setupLoihi();
//         setupFlavors();
//         setupAdapters();
//         approveFlavors();
//         executeApprovals();
//         includeAdapters(0);

//     }

//     function deposit (uint256 _type, address waddr, uint256 wamount, address xaddr, uint256 xamount, address yaddr, uint256 yamount, address zaddr, uint256 zamount) public returns (uint256) {
//         address[] memory addrs = new address[](4);
//         uint256[] memory amounts = new uint256[](4);

//         addrs[0] = waddr; amounts[0] = wamount;
//         addrs[1] = xaddr; amounts[1] = xamount;
//         addrs[2] = yaddr; amounts[2] = yamount;
//         addrs[3] = zaddr; amounts[3] = zamount;

//         if (_type == 1) return l1.selectiveDeposit(addrs, amounts, 0, now + 500);
//         if (_type == 2) return l2.selectiveDeposit(addrs, amounts, 0, now + 500);
//     }

//     function testBalancedDirectVanillaNoFees10Dai10Usdc10Usdt2Point5Susd () public {
//         uint256 startingShells = l1.proportionalDeposit(300 * (10 ** 18));
//         uint256 newShells = deposit(1, dai, 10*WAD, usdc, 10 * (10**6), usdt,  10 * (10**6), susd, 2500000000000000000);
//         assertEq(newShells, 32483751922977906373);
//         emit log_named_uint("startingShells", startingShells);
//     }

//     function testBalancedDirectVanillaNoIndirectFees5Dai1Usdc3Usdt1Susd () public {
//         uint256 startingShells = deposit(1, dai, 80*WAD, usdc, 100*(10**6), usdt, 85*(10**6), susd, 35*WAD);
//         uint256 newShells = deposit(1, dai, 5 * WAD, usdc, 1 * (10**6), usdt, 3 * (10**6), susd, WAD);
//         assertEq(newShells, 9995000591686018553);
//         emit log_named_uint("startingShells", startingShells);
//     }

//     function testFromZeroPartialUpperSlippage145Dai90Usdc90Usdt50Susd () public {
//         uint256 newShells = deposit(1, dai, 145 * WAD, usdc, 90 * (10**6), usdt, 90 * (10**6), susd, 50 * WAD);
//         assertEq(newShells, 374863205208333333331);
//         emit log_named_uint("startingShells", newShells);
//     }

//     function testFromZeroPartialLowerSlippage95Dai55Usdc95Usdt15Susd () public {
//         uint256 newShells = deposit(1, dai, 95 * WAD, usdc, 55 * (10**6), usdt, 95 * (10**6), susd, 15 * WAD);
//         assertEq(newShells, 259841433653846153849);
//         emit log_named_uint("startingShells", newShells);
//     }

//     function testBalancedPartialUpperSlippage5Dai5Usdc70Usdt28Susd () public {
//         uint256 startingShells = l1.proportionalDeposit(300*WAD);
//         uint256 newShells = deposit(1, dai, 5 * WAD, usdc, 5 * (10**6), usdt, 70 * (10**6), susd, 28 * WAD);
//         assertEq(newShells, 107785955736099867653);
//         emit log_named_uint("startingShells", startingShells);
//     }

//     function testModeratelyUnbalancedPartialLowerSli5ppageiFeeLessThanDeposit1Dai51Usdc51Usdt1Susd () public {

//         uint256 startingShells = deposit(1, dai, 80*WAD, usdc, 100*(10**6), usdt, 100*(10**6), susd, 23*WAD);
//         uint256 newShells = deposit(1, dai, WAD, usdc, 51 * (10**6), usdt, 51 * (10**6), susd, WAD);
//         assertEq(newShells, 103751906449728113092);
//         emit log_named_uint("startingShells", startingShells);

//     }

//     function testBalancedPartialLowerSlippageGreaterFeeThanDeposit0Point001Dai90Usdc90Usdt0Susd () public {

//         uint256 startingShells = l1.proportionalDeposit(300*WAD);
//         uint256 newShells = deposit(1, dai, WAD/1000, usdc, 90*(10**6), usdt, 90*(10**6), susd, 0);
//         assertEq(newShells, 179611178241247451581);
//         emit log_named_uint("startingShells", startingShells);

//     }

//     function testUnbalancedPartialUpperAntiSlippageNoDeposit0Dai46Usdc53Usdt0SusdInto145Dai90Usdc90Usdt50Susd () public {
 
//         uint256 startingShells = deposit(1, dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
//         uint256 newShells = deposit(1, dai, 0, usdc, 46*(10**6), usdt, 53*(10**6), susd, 0);
//         assertEq(newShells, 98959112727321870543);
//         emit log_named_uint("startingShells", startingShells);

//     }

//     function testUnbalancedPartialUpperAntiSlippage1Dai46Usdc53Usdt1SusdInto145Dai90Usdc90Usdt50Susd () public {

//         uint256 startingShells = deposit(1, dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
//         uint256 newShells = deposit(1, dai, WAD, usdc, 46*(10**6), usdt, 53*(10**6), susd, WAD);
//         assertEq(newShells, 100958112846963763183);
//         emit log_named_uint("startingShells", startingShells);

//     }

//     function testUnbalancedPartialLowerAntiSlippage0Dai36Usdc0Usdt18SusdInto95Dai55Usdc95Usdt15Susd () public {

//         uint256 startingShells = deposit(1, dai, 95*WAD, usdc, 55*(10**6), usdt, 95*(10**6), susd, 15*WAD);
//         uint256 newShells = deposit(1, dai, 0, usdc, 36*(10**6), usdt, 0, susd, 18*WAD);
//         assertEq(newShells, 53991711756245652893);
//         emit log_named_uint("startingShells", startingShells);

//     }

//     function testUnbalancedFullUpperSlippageFeeLessThanDeposit0Dai5Usdc0Usdt3SusdInto90Dai145Usdc90Usdt50Susd () public {
//         uint256 startingShells = deposit(1, dai, 90*WAD, usdc, 145*(10**6), usdt, 90*(10**6), susd, 50*WAD);
//         uint256 newShells = deposit(1, dai, 0, usdc, 5*(10**6), usdt, 0, susd, 3*WAD);
//         assertEq(newShells, 7935137412354349862);
//         emit log_named_uint("startingShells", startingShells);
//     }

//     function testUnbalancedFullLowerSlippageFeeLessThanDeposit12Dai12Usdc1Usdt1SusdInto95Dai95Usdc55Usdt15Susd () public {
//         uint256 startingShells = deposit(1, dai, 95*WAD, usdc, 95*(10**6), usdt, 55*(10**6), susd, 15*WAD);
//         uint256 newShells = deposit(1, dai, 12*WAD, usdc, 12*(10**6), usdt, 10**6, susd, WAD);
//         assertEq(newShells, 25895520576151595834);
//         emit log_named_uint("startingShells", startingShells);
//     }

//     function testUnbalancedFullLowerSlippageFeeGreaterThanDeposit9Dai9Usdc0Usdt0SusdInto95Dai95Usdc55Usdt15Susd () public {
//         uint256 startingShells = deposit(1, dai, 95*WAD, usdc, 95*(10**6), usdt, 55*(10**6), susd, 15*WAD);
//         uint256 newShells = deposit(1, dai, 9*WAD, usdc, 9*(10**6), usdt, 0, susd, 0);
//         assertEq(newShells, 17893188953689663008);
//         emit log_named_uint("startingShells", startingShells);
//     }

//     function testUnbalancedFullUpperAntiSlippageNoDeposit5Dai5Usdc0Usdt0SusdInto90Dai90Usdc145Usdt50Susd () public {
//         uint256 startingShells = deposit(1, dai, 90*WAD, usdc, 90*(10**6), usdt, 145*(10**6), susd, 50*WAD);
//         uint256 newShells = deposit(1, dai, 5*WAD, usdc, 5*(10**6), usdt, 0, susd, 0);
//         assertEq(newShells, 10001714411049177791);
//         emit log_named_uint("startingShells", startingShells);
//     }

//     function testUnbalancedFullUpperAntiSlippage8Dai12Usdc10Usdt2SusdInto145Dai90Usdc90Usdt50Susd () public {
//         uint256 startingShells = deposit(1, dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
//         uint256 newShells = deposit(1, dai, 8*WAD, usdc, 12*(10**6), usdt, 10*(10**6), susd, 2*WAD);
//         assertEq(newShells, 31991964078802255779);
//         emit log_named_uint("startingShells", startingShells);
//     }

//     function testUnbalancedFullLowerAntiSlippage5Dai5Usdc5Usdt2SusdInto55Dai95Usdc95Usdt15Susd  () public {
//         uint256 startingShells = deposit(1, dai, 55*WAD, usdc, 95*(10**6), usdt, 95*(10**6), susd, 15*WAD);
//         uint256 newShells = deposit(1, dai, 5*WAD, usdc, 5*(10**6), usdt, 5*(10**6), susd, 2*WAD);
//         assertEq(newShells, 16998625195108995468);
//         emit log_named_uint("startingShells", startingShells);
//     }

//     function testDepositToFeeZone36Dai0Usdc0Usdt0SusdFromProportional300 () public {
//         uint256 startingShells = l1.proportionalDeposit(300*WAD);
//         uint256 shellsMinted = deposit(1, dai, 36*WAD, usdc, 0, usdt, 0, susd, 0);
//         assertEq(shellsMinted, 35982002130067834752);
//         emit log_named_uint("startingShells", startingShells);
//     }

//     function testDepositJustPastFeeZone36Point001Dai0Usdc0Usdt0SusdFromProportional300 () public {
//         uint256 startingShells = l1.proportionalDeposit(300*WAD);
//         uint256 shellsMinted = deposit(1, dai, 36*WAD + WAD/10000, usdc, 0, usdt, 0, susd, 0);
//         assertEq(shellsMinted, 35982102080069924643);
//         emit log_named_uint("startingShells", startingShells);
//     }

//     function testMegaDepositDirectLowerToUpper105Dai37SusdFrom55Dai95Usdc95Usdt15Susd () public {
//         uint256 startingShells = deposit(1, dai, 55*WAD, usdc, 95*(10**6), usdt, 95*(10**6), susd, 15*WAD);
//         uint256 newShells = deposit(1, dai, 105*WAD, usdc, 0, usdt, 0, susd, 37*WAD);
//         assertEq(newShells, 141932012220330711758);
//         emit log_named_uint("startingShells", startingShells);
//     }

//     function testMegaDepositIndirectUpperToLower165Dai165UsdtInto90Dai145Usdc90Usdt50Susd () public {
//         uint256 startingShells = deposit(1, dai, 90*WAD, usdc, 145*(10**6), usdt, 90*(10**6), susd, 50*WAD);
//         uint256 newShells = deposit(1, dai, 165*WAD, usdc, 0, usdt, 165*(10**6), susd, 0);
//         assertEq(newShells, 329778606762192660838);
//         emit log_named_uint("startingShells", startingShells);
//     }

//     function testMegaDepositIndirectUpperToLower165Dai0Point0001Usdc165UsdtPoint5SusdFrom90Dai145Usdc90Usdt50Susd () public {
//         uint256 startingShells = deposit(1, dai, 90*WAD, usdc, 145*(10**6), usdt, 90*(10**6), susd, 50*WAD);
//         uint256 newShells = deposit(1, dai, 165*WAD, usdc, (10**6)/10000, usdt, 165*(10**6), susd, WAD/2);
//         assertEq(newShells, 330280539057168288940);
//         emit log_named_uint("startingShells", startingShells);
//     }

//     function testProportionalDepositIntoAnUnbalancedShell () public {
//         uint256 startingShells = deposit(1, dai, 90*WAD, usdc, 90*(10**6), usdt, 140*(10**6), susd, 50*WAD);
//         uint256 newShells = l1.proportionalDeposit(90*WAD);
//         assertEq(newShells, 89945422884973251834);
//     }

// }