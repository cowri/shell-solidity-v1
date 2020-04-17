
// pragma solidity ^0.5.6;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../../loihiSetup.sol";
// import "../../../interfaces/IAdapter.sol";

// contract OriginSwapTest is LoihiSetup, DSMath, DSTest {

//     function setUp() public {

//         setupLoihi();
//         setupFlavors();
//         setupAdapters();
//         approveFlavors();
//         executeApprovals();
//         includeAdapters(0);

//     }

//     function withdraw (uint256 _type, address waddr, uint256 wamount, address xaddr, uint256 xamount, address yaddr, uint256 yamount, address zaddr, uint256 zamount) public returns (uint256) {
//         address[] memory addrs = new address[](4);
//         uint256[] memory amounts = new uint256[](4);

//         addrs[0] = waddr; amounts[0] = wamount;
//         addrs[1] = xaddr; amounts[1] = xamount;
//         addrs[2] = yaddr; amounts[2] = yamount;
//         addrs[3] = zaddr; amounts[3] = zamount;

//         if (_type == 1) return l1.selectiveWithdraw(addrs, amounts, 50000*WAD, now + 500);
//         if (_type == 2) return l2.selectiveWithdraw(addrs, amounts, 50000*WAD, now + 500);
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

//     function testBalancedOriginSwap5DaiToUsdcWithProportional300 () public {
//         l1.proportionalDeposit(300*WAD);
//         uint256 targetAmount = l1.swapByOrigin(dai, usdc, 10*WAD, 0, now+500);
//         assertEq(targetAmount, 9995000);
//     }

//     function testNoFeeUnbalancedOriginSwap10UsdcToUsdtWith80Dai100Usdc85Usdt35Susd () public {
//         deposit(1, dai, 80*WAD, usdc, 10**8, usdt, 85*(10**6), susd, 35*WAD);
//         uint256 targetAmount = l1.swapByOrigin(usdc, usdt, 10**7, 0, now+500);
//         assertEq(targetAmount, 9995000);
//     }

//     function testNoFeeBalanced10PctWeightTo30PctWeight () public {
//         l1.proportionalDeposit(300*WAD);
//         uint256 targetAmount = l1.swapByOrigin(susd, usdt, 4*WAD, 0, now + 500);
//         assertEq(targetAmount, 3998000);
//     }

//     function testPartialUpperAndLowerFeesFromUnbalancedShell10PctWeightTo30PctWeight () public {
//         deposit(1, dai, 65*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 30*WAD);
//         uint256 targetAmount = l1.swapByOrigin(susd, dai, 8*WAD, 0, now+50);
//         assertEq(targetAmount, 7920411672881948283);
//     }

//     function testNoFeeBalanced30PctWeightTo30PctWeight () public {
//         l1.proportionalDeposit(300*WAD);
//         uint256 targetAmount = l1.swapByOrigin(dai, usdc, 10*WAD, 0, now + 500);
//         assertEq(targetAmount, 9995000);
//     }

//     function testNoFeePartiallyUnbalanced30PctWeightTo10PctWeight () public {
//         deposit(1, dai, 80*WAD, usdc, 10**8, usdt, 85*(10**6), susd, 35*WAD);
//         uint256 targetAmount = l1.swapByOrigin(usdc, susd, 3*(10**6), 0, now+50);
//         assertEq(targetAmount, 2998500187500000000);
//     }

//     function testPartialUpperAndLowerFeesFromBalancedShell30PctWeight () logs_gas public {
//         l1.proportionalDeposit(300*WAD);
//         uint256 g1 = gasleft();
//         uint256 targetAmount = l1.swapByOrigin(usdc, dai, 40*(10**6), 0, now + 500);
//         uint256 g2 = gasleft();
//         emit log_named_uint("gas swap", g1-g2);
//         assertEq(targetAmount, 39330195827959985796);
//     }

//     function testPartialUpperAndLowerFeesFromBalancedShell30PctWeightCusdcCdai () logs_gas public {
//         l1.proportionalDeposit(150*WAD);
//         uint256 cusdcOf20Numeraire = IAdapter(cusdcAdapter).viewRawAmount(20*WAD);
//         uint256 viewAmount = l1.viewOriginTrade(cusdc, cdai, cusdcOf20Numeraire);
//         uint256 targetAmount = l1.swapByOrigin(cusdc, cdai, cusdcOf20Numeraire, 0, now + 500);
//         uint256 numeraireOfTargetAmount = IAdapter(cdaiAdapter).viewNumeraireAmount(targetAmount);
//         uint256 viewNumeraireOfTargetAmount = IAdapter(cdaiAdapter).viewNumeraireAmount(viewAmount);
//         assertEq(numeraireOfTargetAmount, 19665097913979992898);
//         assertEq(numeraireOfTargetAmount, viewNumeraireOfTargetAmount);
//     }

//     function testPartialUpperAndLowerSlippageFromBalancedShell30PctWeightTo10PctWeight () logs_gas public {
//         l1.proportionalDeposit(300*WAD);
//         // uint256 cusdcOf15Numeraire = IAdapter(cusdcAdapter).viewRawAmount(15*WAD);
//         // uint256 chaiOf15Numeraire = IAdapter(chaiAdapter).viewRawAmount(15*WAD);
//         uint256 before = gasleft();
//         // uint256 targetAmount = l1.swapByOrigin(usdc, susd, 15*(10**6), 0, now + 500); // 939459
//         // uint256 targetAmount = l1.swapByOrigin(dai, usdc, 15*WAD, 0, now + 500); // 738567
//         // uint256 targetAmount = l1.swapByOrigin(susd, usdt, 15*WAD, 0, now + 500); // 971441
//         // uint256 targetAmount = l1.swapByOrigin(asusd, ausdt, 15*WAD, 0, now + 500); // 754748
//         // uint256 targetAmount = l1.swapByOrigin(chai, usdc, chaiOf15Numeraire, 0, now + 500); // 825593
//         // uint256 targetAmount = l1.swapByOrigin(dai, usdt, chaiOf15Numeraire, 0, now + 500); // 881113
//         uint256 viewAmount = l1.viewOriginTrade(dai, susd, 15*WAD); // 1106712
//         uint256 targetAmount = l1.swapByOrigin(dai, susd, 15*WAD, 0, now + 500); // 1106712
//         // uint256 targetAmount = l1.swapByOrigin(cusdc, asusd, cusdcOf15Numeraire, 0, now + 500); // 691498
//         uint256 _after = gasleft();
//         emit log_named_uint("swap gas", before - _after);
//         assertEq(targetAmount, 14813513177462324025);
//         assertEq(targetAmount, viewAmount);
//     }

//     function testFullUpperAndLowerSlippageUnbalancedShell30PctWeight () public {
//         deposit(1, dai, 135*WAD, usdc, 90*(10**6), usdt, 60*(10**6), susd, 30*WAD);
//         uint256 targetAmount = l1.swapByOrigin(dai, usdt, 5*WAD, 0, now + 500);
//         assertEq(targetAmount, 4666173);
//     }

//     function testFullUpperAndLowerSlippageUnbalancedShell30PctWeightTo10PctWeight () logs_gas public {
//         deposit(1, dai, 135*WAD, usdc, 90*(10**6), usdt, 65*(10**6), susd, 25*WAD);
//         uint256 viewAmount = l1.viewOriginTrade(dai, susd, 3*WAD);
//         uint256 targetAmount = l1.swapByOrigin(dai, susd, 3*WAD, 0, now + 500);
//         assertEq(targetAmount, 2876384124908864750);
//         assertEq(targetAmount, viewAmount);
//     }

//     function testFullUpperAndLowerSlippageUnbalancedShell10PctWeightTo30PctWeightAsusdCusdc () public {
//         deposit(1, dai, 90*WAD, usdc, 55*(10**6), usdt, 90*(10**6), susd, 35*WAD);
//         uint256 asusdOf2Point8Numeraire = IAdapter(asusdAdapter).viewRawAmount(28*(10**17));
//         uint256 targetAmount = l1.swapByOrigin(asusd, cusdc, asusdOf2Point8Numeraire, 0, now+50);
//         uint256 cusdcNumeraireTargetAmount = IAdapter(cusdcAdapter).viewNumeraireAmount(targetAmount);
//         assertEq(cusdcNumeraireTargetAmount, 2696349000000000000);
//     }

//     function testFullUpperAndLowerSlippageUnbalancedShell10PctWeightTo30PctWeight () public {
//         deposit(1, dai, 90*WAD, usdc, 55*(10**6), usdt, 90*(10**6), susd, 35*WAD);
//         uint256 viewAmount = l1.viewOriginTrade(susd, usdc, 28*(10**17));
//         uint256 targetAmount = l1.swapByOrigin(susd, usdc, 28*(10**17), 0, now+50);
//         assertEq(targetAmount, 2696349);
//         assertEq(targetAmount, viewAmount);
//     }

//     function testPartialUpperAndLowerAntiSlippageUnbalanced30PctWeight () public {
//         deposit(1, dai, 135*WAD, usdc, 60*(10**6), usdt, 90*(10**6), susd, 30*WAD);
//         uint256 targetAmount = l1.swapByOrigin(usdc, dai, 30*(10**6), 0, now+50);
//         assertEq(targetAmount, 30070278169642344458);
//     }

//     function testPartialUpperAndLowerAntiSlippageUnbalanced10PctWeightTo30PctWeight () public {
//         deposit(1, dai, 135*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 25*WAD);
//         uint256 viewAmount = l1.viewOriginTrade(susd, dai, 10*WAD);
//         uint256 targetAmount = l1.swapByOrigin(susd, dai, 10*WAD, 0, now+50);
//         assertEq(targetAmount, 10006174300378984359);
//         assertEq(targetAmount, viewAmount);
//     }

//     function testPartialUpperAndLowerAntiSlippageUnbalanced30PctWeightTo10PctWeight () public {
//         deposit(1, dai, 90*WAD, usdc, 90*(10**6), usdt, 58*(10**6), susd, 40*WAD);
//         uint256 targetAmount = l1.swapByOrigin(usdt, susd, 10**7, 0, now +50);
//         assertEq(targetAmount, 10019788191004510065);
//     }

//     function testFullUpperAndLowerAntiSlippageUnbalanced30PctWeight () public {
//         deposit(1, dai, 90*WAD, usdc, 135*(10**6), usdt, 60*(10**6), susd, 30*WAD);
//         uint256 targetAmount = l1.swapByOrigin(usdt, usdc, 5*(10**6), 0, now + 50);
//         assertEq(targetAmount, 5045804);
//     }

//     function testFullUpperAndLowerAntiSlippage10PctOrigin30Pct () public {
//         deposit(1, dai, 90*WAD, usdc, 90 *(10**6), usdt, 135*(10**6), susd, 25*WAD);
//         uint256 viewAmount = l1.viewOriginTrade(susd, usdt, 3653700000000000000);
//         uint256 targetAmount = l1.swapByOrigin(susd, usdt, 3653700000000000000, 0, now + 50);
//         assertEq(targetAmount, 3660153);
//         assertEq(targetAmount, viewAmount);
//     }

//     function testFullUpperAndLowerAntiSlippage30pctOriginTo10Pct () public {
//         deposit(1, dai, 58*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 40*WAD);
//         uint256 viewAmount = l1.viewOriginTrade(dai, susd, 2349000000000000000);
//         uint256 targetAmount = l1.swapByOrigin(dai, susd, 2349000000000000000, 0, now+50);
//         assertEq(targetAmount, 2365464484251272960);
//     }

//     function testFullUpperAndLowerAntiSlippage30pctOriginTo10PctChai () public {
//         deposit(1, dai, 58*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 40*WAD);
//         uint256 rawChaiAmt = IAdapter(chaiAdapter).viewRawAmount(2349000000000000000);
//         uint256 targetAmount = l1.swapByOrigin(chai, susd, rawChaiAmt, 0, now+50);
//         assertEq(targetAmount, 2365464484251272960);
//     }

//     function testUpperHaltCheck30PctWeight () public {
//         deposit(1, dai, 90*WAD, usdc, 135*(10**6), usdt, 90*(10**6), susd, 30*WAD);
//         (bool success, bytes memory result) = address(l1).call(abi.encodeWithSignature(
//             "swapByOrigin(address,address,uint256,uint256,uint256)", usdc, usdt, 30*(10**6), 0, now+50));
//         assertTrue(!success);
//     }

//     function testLowerHaltCheck30PctWeight () public {
//         deposit(1, dai, 60*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 30*WAD);
//         (bool success, bytes memory result) = address(l1).call(abi.encodeWithSignature(
//             "swapByOrigin(address,address,uint256,uint256,uint256)", usdc, dai, 30*(10**6), 0, now+50));
//         assertTrue(!success);
//     }

//     function testUpperHaltCheck10PctWeight () public {
//         l1.proportionalDeposit(300*WAD);
//         (bool success, bytes memory result) = address(l1).call(abi.encodeWithSignature(
//             "swapByOrigin(address,address,uint256,uint256,uint256)", susd, usdt, 20*WAD, 0, now+50));
//         assertTrue(!success);
//     }

//     function testLowerhaltCheck10PctWeight () public {
//         l1.proportionalDeposit(300*WAD);
//         (bool success, bytes memory result) = address(l1).call(abi.encodeWithSignature(
//             "swapByOrigin(address,address,uint256,uint256,uint256)", dai, susd, 20*WAD, 0, now+50));
//         assertTrue(!success);
//     }

//     function testMegaLowerToUpperUpperToLower30PctWeight () public {
//         deposit(1, dai, 55*WAD, usdc, 90*(10**6), usdt, 125*(10**6), susd, 30*WAD);
//         uint256 targetAmount = l1.swapByOrigin(dai, usdt, 70*WAD, 0, now+50);
//         assertEq(targetAmount, 69965119);
//     }

//     function testMegaLowerToUpperUpperToLower30PctWeightCDai () public {
//         deposit(1, dai, (55*WAD)/4, usdc, (90*(10**6))/4, usdt, (125*(10**6))/4, susd, (30*WAD)/4);
//         uint256 cdaiOf70Numeraire = IAdapter(cdaiAdapter).viewRawAmount((70*WAD)/4);
//         uint256 targetAmount = l1.swapByOrigin(cdai, usdt, cdaiOf70Numeraire, 0, now+50);
//         assertEq(targetAmount, 17491279);
//     }

//     function testMegaLowerToUpper10PctWeightTo30PctWeight () public {
//         deposit(1, dai, 90*WAD, usdc, 90*(10**6), usdt, 100*(10**6), susd, 20*WAD);
//         uint256 targetAmount = l1.swapByOrigin(susd, usdt, 20*WAD, 0, now+50);
//         assertEq(targetAmount, 19990003);
//     }

//     function testMegaUpperToLower30PctWeightTo10PctWeight () public {
//         deposit(1, dai, 80*WAD, usdc, 100*(10**6), usdt, 80*(10**6), susd, 40*WAD);
//         uint256 targetAmount = l1.swapByOrigin(dai, susd, 20*WAD, 0, now+50);
//         assertEq(targetAmount, 19990016481618381864);
//     }

//     function testFailOriginGreaterThanBalance30Pct () public {
//         deposit(1, dai, 46*WAD, usdc, 134*(10**6), usdt, 75*(10**6), susd, 45*WAD);
//         uint256 originAmount = l1.swapByOrigin(usdt, dai, 50*(10**6), 0, now+50);
//     }

//     function testFailOriginGreaterThanBalance10Pct () public {
//         l1.proportionalDeposit(300*WAD);
//         uint256 originAmount = l1.swapByOrigin(usdc, susd, 31*(10**6), 0, now+50);
//     }

// }