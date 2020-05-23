
// pragma solidity ^0.5.0;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../../loihiSetup.sol";
// import "../../../interfaces/IAdapter.sol";

// contract ViewOriginSwapTest is LoihiSetup, DSMath, DSTest {

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
//         uint256 targetAmount = l1.viewOriginTrade(dai, usdc, 10*WAD);
//         assertEq(targetAmount, 9995000);
//     }

//     function testNoFeeUnbalancedOriginSwap10UsdcToUsdtWith80Dai100Usdc85Usdt35Susd () public {
//         deposit(1, dai, 80*WAD, usdc, 10**8, usdt, 85*(10**6), susd, 35*WAD);
//         uint256 targetAmount = l1.viewOriginTrade(usdc, usdt, 10**7);
//         assertEq(targetAmount, 9995000);
//     }

//     function testNoFeeBalanced10PctWeightTo30PctWeight () public {
//         l1.proportionalDeposit(300*WAD);
//         uint256 targetAmount = l1.viewOriginTrade(susd, usdt, 4*WAD);
//         assertEq(targetAmount, 3998000);
//     }

//     function testPartialUpperAndLowerFeesFromUnbalancedShell10PctWeightTo30PctWeight () public {
//         deposit(1, dai, 65*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 30*WAD);
//         uint256 targetAmount = l1.viewOriginTrade(susd, dai, 8*WAD);
//         assertEq(targetAmount, 7920411672881948283);
//     }

//     function testNoFeeBalanced30PctWeightTo30PctWeight () public {
//         l1.proportionalDeposit(300*WAD);
//         uint256 targetAmount = l1.viewOriginTrade(dai, usdc, 10*WAD);
//         assertEq(targetAmount, 9995000);
//     }

//     function testNoFeePartiallyUnbalanced30PctWeightTo10PctWeight () public {
//         deposit(1, dai, 80*WAD, usdc, 10**8, usdt, 85*(10**6), susd, 35*WAD);
//         uint256 targetAmount = l1.viewOriginTrade(usdc, susd, 3*(10**6));
//         assertEq(targetAmount, 2998500187500000000);
//     }

//     function testPartialUpperAndLowerFeesFromBalancedShell30PctWeight () logs_gas public {
//         l1.proportionalDeposit(300*WAD);
//         uint256 targetAmount = l1.viewOriginTrade(usdc, dai, 40*(10**6));
//         assertEq(targetAmount, 39330195827959985796);
//     }

//     function testPartialUpperAndLowerSlippageFromBalancedShell30PctWeightTo10PctWeight () logs_gas public {
//         l1.proportionalDeposit(300*WAD);
//         uint256 targetAmount = l1.viewOriginTrade(usdc, susd, 15*(10**6));
//         assertEq(targetAmount, 14813513177462324025);
//     }

//     function testFullUpperAndLowerSlippageUnbalancedShell30PctWeight () public {
//         deposit(1, dai, 135*WAD, usdc, 90*(10**6), usdt, 60*(10**6), susd, 30*WAD);
//         uint256 targetAmount = l1.viewOriginTrade(dai, usdt, 5*WAD);
//         assertEq(targetAmount, 4666173);
//     }

//     function testFullUpperAndLowerSlippageUnbalancedShell30PctWeightTo10PctWeight () logs_gas public {
//         deposit(1, dai, 135*WAD, usdc, 90*(10**6), usdt, 65*(10**6), susd, 25*WAD);
//         uint256 targetAmount = l1.viewOriginTrade(dai, susd, 3*WAD);
//         assertEq(targetAmount, 2876384124908864750);
//     }

//     function testFullUpperAndLowerSlippageUnbalancedShell10PctWeightTo30PctWeight () public {
//         deposit(1, dai, 90*WAD, usdc, 55*(10**6), usdt, 90*(10**6), susd, 35*WAD);
//         uint256 targetAmount = l1.viewOriginTrade(susd, usdc, 28*(10**17));
//         assertEq(targetAmount, 2696349);
//     }

//     function testPartialUpperAndLowerAntiSlippageUnbalanced30PctWeight () public {
//         deposit(1, dai, 135*WAD, usdc, 60*(10**6), usdt, 90*(10**6), susd, 30*WAD);
//         uint256 targetAmount = l1.viewOriginTrade(usdc, dai, 30*(10**6));
//         assertEq(targetAmount, 30070278169642344458);
//     }

//     function testPartialUpperAndLowerAntiSlippageUnbalanced10PctWeightTo30PctWeight () public {
//         deposit(1, dai, 135*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 25*WAD);
//         uint256 targetAmount = l1.viewOriginTrade(susd, dai, 10*WAD);
//         assertEq(targetAmount, 10006174300378984359);
//     }

//     function testPartialUpperAndLowerAntiSlippageUnbalanced30PctWeightTo10PctWeight () public {
//         deposit(1, dai, 90*WAD, usdc, 90*(10**6), usdt, 58*(10**6), susd, 40*WAD);
//         uint256 targetAmount = l1.viewOriginTrade(usdt, susd, 10**7);
//         assertEq(targetAmount, 10019788191004510065);
//     }

//     function testFullUpperAndLowerAntiSlippageUnbalanced30PctWeight () public {
//         deposit(1, dai, 90*WAD, usdc, 135*(10**6), usdt, 60*(10**6), susd, 30*WAD);
//         uint256 targetAmount = l1.viewOriginTrade(usdt, usdc, 5*(10**6));
//         assertEq(targetAmount, 5046505);
//     }

//     function testFullUpperAndLowerAntiSlippage10PctOrigin30Pct () public {
//         deposit(1, dai, 90*WAD, usdc, 90 *(10**6), usdt, 135*(10**6), susd, 25*WAD);
//         uint256 targetAmount = l1.viewOriginTrade(susd, usdt, 3653700000000000000);
//         assertEq(targetAmount, 3660184);
//     }

//     function testFullUpperAndLowerAntiSlippage30pctOriginTo10Pct () public {
//         deposit(1, dai, 58*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 40*WAD);
//         uint256 targetAmount = l1.viewOriginTrade(dai, susd, 2349000000000000000);
//         assertEq(targetAmount, 2365738201029778619);
//     }

//     function testUpperHaltCheck30PctWeight () public {
//         deposit(1, dai, 90*WAD, usdc, 135*(10**6), usdt, 90*(10**6), susd, 30*WAD);
//         (bool success, bytes memory result) = address(l1).call(abi.encodeWithSignature(
//             "viewOriginTrade(address,address,uint256,uint256,uint256)", usdc, usdt, 30*(10**6)));
//         assertTrue(!success);
//     }

//     function testLowerHaltCheck30PctWeight () public {
//         deposit(1, dai, 60*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 30*WAD);
//         (bool success, bytes memory result) = address(l1).call(abi.encodeWithSignature(
//             "viewOriginTrade(address,address,uint256,uint256,uint256)", usdc, dai, 30*(10**6)));
//         assertTrue(!success);
//     }

//     function testUpperHaltCheck10PctWeight () public {
//         l1.proportionalDeposit(300*WAD);
//         (bool success, bytes memory result) = address(l1).call(abi.encodeWithSignature(
//             "viewOriginTrade(address,address,uint256,uint256,uint256)", susd, usdt, 20*WAD));
//         assertTrue(!success);
//     }

//     function testLowerhaltCheck10PctWeight () public {
//         l1.proportionalDeposit(300*WAD);
//         (bool success, bytes memory result) = address(l1).call(abi.encodeWithSignature(
//             "viewOriginTrade(address,address,uint256,uint256,uint256)", dai, susd, 20*WAD));
//         assertTrue(!success);
//     }

//     function testMegaLowerToUpperUpperToLower30PctWeight () public {
//         deposit(1, dai, 55*WAD, usdc, 90*(10**6), usdt, 125*(10**6), susd, 30*WAD);
//         uint256 targetAmount = l1.viewOriginTrade(dai, usdt, 70*WAD);
//         assertEq(targetAmount, 69965116);
//     }

//     function testMegaLowerToUpper10PctWeightTo30PctWeight () public {
//         deposit(1, dai, 90*WAD, usdc, 90*(10**6), usdt, 100*(10**6), susd, 20*WAD);
//         uint256 targetAmount = l1.viewOriginTrade(susd, usdt, 20*WAD);
//         assertEq(targetAmount, 19990003);
//     }

//     function testMegaUpperToLower30PctWeightTo10PctWeight () public {
//         deposit(1, dai, 80*WAD, usdc, 100*(10**6), usdt, 80*(10**6), susd, 40*WAD);
//         uint256 targetAmount = l1.viewOriginTrade(dai, susd, 20*WAD);
//         assertEq(targetAmount, 19990016481618381864);
//     }

//     function testFailOriginGreaterThanBalance30Pct () public {
//         deposit(1, dai, 46*WAD, usdc, 134*(10**6), usdt, 75*(10**6), susd, 45*WAD);
//         uint256 originAmount = l1.viewOriginTrade(usdt, dai, 50*(10**6));
//     }

//     function testFailOriginGreaterThanBalance10Pct () public {
//         l1.proportionalDeposit(300*WAD);
//         uint256 originAmount = l1.viewOriginTrade(usdc, susd, 31*(10**6));
//     }

// }