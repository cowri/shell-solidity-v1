
// pragma solidity ^0.5.6;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../../loihiSetup.sol";
// import "../../../interfaces/IAdapter.sol";

// contract TargetSwapTest is LoihiSetup, DSMath, DSTest {

//     function setUp() public {

//         setupLoihi();
//         setupFlavors();
//         setupAdapters();
//         approveFlavors();
//         executeApprovals();
//         includeAdapters(0);

//     }

//     function withdraw (address waddr, uint256 wamount, address xaddr, uint256 xamount, address yaddr, uint256 yamount, address zaddr, uint256 zamount) public returns (uint256) {
//         address[] memory addrs = new address[](4);
//         uint256[] memory amounts = new uint256[](4);

//         addrs[0] = waddr; amounts[0] = wamount;
//         addrs[1] = xaddr; amounts[1] = xamount;
//         addrs[2] = yaddr; amounts[2] = yamount;
//         addrs[3] = zaddr; amounts[3] = zamount;

//         return l1.selectiveWithdraw(addrs, amounts, 50000*WAD, now + 500);
//     }

//     function deposit (address waddr, uint256 wamount, address xaddr, uint256 xamount, address yaddr, uint256 yamount, address zaddr, uint256 zamount) public returns (uint256) {
//         address[] memory addrs = new address[](4);
//         uint256[] memory amounts = new uint256[](4);

//         addrs[0] = waddr; amounts[0] = wamount;
//         addrs[1] = xaddr; amounts[1] = xamount;
//         addrs[2] = yaddr; amounts[2] = yamount;
//         addrs[3] = zaddr; amounts[3] = zamount;

//         return l1.selectiveDeposit(addrs, amounts, 0, now + 500);
//     }

//     function testBalancedTargetSwap5DaiToUsdcWithProportional300 () public {
//         l1.proportionalDeposit(300*WAD);
//         uint256 targetAmount = l1.swapByTarget(dai, usdc, 100*WAD, 10*(10**6), now+500);
//         assertEq(targetAmount, 10005000000000000000);
//     }

//     function testNoFeeUnbalancedTargetSwap10UsdcToUsdtWith80Dai100Usdc85Usdt35Susd () public {
//         deposit(dai, 80*WAD, usdc, 10**8, usdt, 85*(10**6), susd, 35*WAD);
//         uint256 targetAmount = l1.swapByTarget(usdc, susd, 500*WAD, 3*WAD, now+500);
//         assertEq(targetAmount, 3001500);
//     }

//     function testNoFeeBalanced10PctWeightTo30PctWeight () public {
//         l1.proportionalDeposit(300*WAD);
//         uint256 targetAmount = l1.swapByTarget(susd, usdt, 400*WAD, 4*(10**6), now + 500);
//         assertEq(targetAmount, 4002000000000000000);
//     }

//     function testNoSlippageBalanced30PctWeightTo30PctWeight () public {
//         l1.proportionalDeposit(300*WAD);
//         uint256 targetAmount = l1.swapByTarget(dai, usdc, 11*WAD, 10*(10**6), now + 500);
//         assertEq(targetAmount, 10005000000000000000);
//     }

//     function testPartialUpperAndLowerSlippageFromBalancedShell30PctWeight () logs_gas public {
//         l1.proportionalDeposit(300*WAD);
//         uint256 targetAmount = l1.swapByTarget(usdc, dai, 500*WAD, 40*WAD, now + 500);
//         assertEq(targetAmount, 40722721);
//     }

//     function testPartialUpperAndLowerSLippageFromBalancedShell30PctWeightTo10PctWeight () public {
//         l1.proportionalDeposit(300*WAD);
//         uint256 targetAmount = l1.swapByTarget(usdc, susd, 8*WAD, 12*WAD, now+50);
//         assertEq(targetAmount, 12073670);
//     }

//     function testPartialUpperAndLowerSlippageFromUnbalancedShell10PctWeightTo30PctWeight () public {
//         deposit(dai, 65*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 30*WAD);
//         uint256 targetAmount = l1.swapByTarget(susd, dai, 9*WAD, 8*WAD, now+50);
//         assertEq(targetAmount, 8082647704827925961);
//     }

//     function testNoSlippagePartiallyUnbalanced30PctWeightTo10PctWeight () public {
//         deposit(dai, 80*WAD, usdc, 10**8, usdt, 85*(10**6), susd, 35*WAD);
//         uint256 targetAmount = l1.swapByTarget(usdc, susd, 31*(10**6), 3*WAD, now+50);
//         assertEq(targetAmount, 3001500);
//     }


//     function testPartialUpperAndLowerSlippageFromBalancedShell30PctWeightTo10PctWeight () logs_gas public {
//         l1.proportionalDeposit(300*WAD);
//         uint256 targetAmount = l1.swapByTarget(usdc, susd, 15*(10**6), 12*WAD, now + 500);
//         assertEq(targetAmount, 12073670);
//     }

//     function testFullUpperAndLowerSlippageUnbalancedShell30PctWeight () logs_gas public {
//         deposit(dai, 135*WAD, usdc, 90*(10**6), usdt, 60*(10**6), susd, 30*WAD);
//         uint256 targetAmount = l1.swapByTarget(dai, usdt, 50*WAD, 5*(10**6), now + 500);
//         assertEq(targetAmount, 5361500900419886513);
//     }

//     function testFullUpperAndLowerSlippageUnbalancedShell30PctWeightTo10PctWeight () logs_gas public {
//         deposit(dai, 135*WAD, usdc, 90*(10**6), usdt, 65*(10**6), susd, 25*WAD);
//         uint256 targetAmount = l1.swapByTarget(dai, susd, 5*WAD, 3*WAD, now + 500);
//         assertEq(targetAmount, 3130274779406190392);
//     }

//     function testFullUpperAndLowerSlippageUnbalancedShell10PctWeightTo30PctWeight () public {
//         deposit(dai, 90*WAD, usdc, 55*(10**6), usdt, 90*(10**6), susd, 35*WAD);
//         uint256 targetAmount = l1.swapByTarget(susd, usdc, 100*WAD, 2800000, now+50);
//         assertEq(targetAmount, 2909159856113401975);
//     }

//     function testPartialUpperAndLowerAntiSlippageUnbalanced30PctWeight () public {
//         deposit(dai, 135*WAD, usdc, 60*(10**6), usdt, 90*(10**6), susd, 30*WAD);
//         uint256 targetAmount = l1.swapByTarget(usdc, dai, 30*WAD, 30*WAD, now+50);
//         assertEq(targetAmount, 29929659);
//     }

//     function testPartialUpperAndLowerAntiSlippageUnbalanced10PctWeightTo30PctWeight () public {
//         deposit(dai, 135*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 25*WAD);
//         uint256 targetAmount = l1.swapByTarget(susd, dai, 11*WAD, 10*WAD, now+50);
//         assertEq(targetAmount, 9993817942268893372);
//     }

//     function testPartialUpperAndLowerAntiSlippageUnbalanced30PctWeightTo10PctWeight () public {
//         deposit(dai, 90*WAD, usdc, 90*(10**6), usdt, 58*(10**6), susd, 40*WAD);
//         uint256 targetAmount = l1.swapByTarget(usdt, susd, 10*WAD, 10*WAD, now +50);
//         assertEq(targetAmount, 9980193);
//     }

//     function testFullUpperAndLowerAntiSlippageUnbalanced30PctWeight () public {
//         deposit(dai, 90*WAD, usdc, 135*(10**6), usdt, 60*(10**6), susd, 30*WAD);
//         uint256 targetAmount = l1.swapByTarget(usdt, usdc, 10*(10**6), 5*(10**6), now + 50);
//         assertEq(targetAmount, 4955265);
//     }

//     function testFullUpperAndLowerAntiSlippage10PctOrigin30PctTarget () public {
//         deposit(dai, 90*WAD, usdc, 90 *(10**6), usdt, 135*(10**6), susd, 25*WAD);
//         uint256 targetAmount = l1.swapByTarget(susd, usdt, 50*WAD, 3653700, now + 50);
//         assertEq(targetAmount, 3647270782578611503);
//     }

//     function testFullUpperAndLowerAntiSlippage30pctOriginTo10Pct () public {
//         deposit(dai, 58*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 40*WAD);
//         uint256 targetAmount = l1.swapByTarget(dai, susd, 10*WAD, 2349000000000000000, now+50);
//         assertEq(targetAmount, 2332708705097930419);
//     }

//     function testMegaLowerToUpperUpperToLower30PctWeight () public {
//         deposit(dai, 55*WAD, usdc, 90*(10**6), usdt, 125*(10**6), susd, 30*WAD);
//         uint256 targetAmount = l1.swapByTarget(dai, usdt, 75*WAD, 70*(10**6), now+50);
//         assertEq(targetAmount, 70034999999999802070);
//     }

//     function testMegaLowerToUpper10PctWeightTo30PctWeight () public {
//         deposit(dai, 90*WAD, usdc, 90*(10**6), usdt, 100*(10**6), susd, 20*WAD);
//         uint256 targetAmount = l1.swapByTarget(susd, usdt, 21*WAD, 20*(10**6), now+50);
//         assertEq(targetAmount, 20009999999323363488);
//     }

//     function testMegaUpperToLower30PctWeightTo10PctWeight () public {
//         deposit(dai, 80*WAD, usdc, 100*(10**6), usdt, 80*(10**6), susd, 40*WAD);
//         uint256 targetAmount = l1.swapByTarget(dai, susd, 22*WAD, 20*WAD, now+50);
//         assertEq(targetAmount, 20010000003334730968);
//     }

//     function testUpperHaltCheck30PctWeight () public {
//         deposit(dai, 90*WAD, usdc, 135*(10**6), usdt, 90*(10**6), susd, 30*WAD);
//         (bool success, bytes memory result) = address(l1).call(abi.encodeWithSignature(
//             "swapByTarget(address,address,uint256,uint256,uint256)", usdc, usdt, 31*(10**6), 30*(10**6), now+50));
//         assertTrue(!success);
//     }

//     function testLowerHaltCheck30PctWeight () public {
//         deposit(dai, 60*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 30*WAD);
//         (bool success, bytes memory result) = address(l1).call(abi.encodeWithSignature(
//             "swapByTarget(address,address,uint256,uint256,uint256)", usdc, dai, 31*(10**6), 30*WAD, now+50));
//         assertTrue(!success);
//     }

//     function testUpperHaltCheck10PctWeight () public {
//         l1.proportionalDeposit(300*WAD);
//         (bool success, bytes memory result) = address(l1).call(abi.encodeWithSignature(
//             "swapByTarget(address,address,uint256,uint256,uint256)", susd, usdt, 21*WAD, 20*WAD, now+50));
//         assertTrue(!success);
//     }

//     function testLowerhaltCheck10PctWeight () public {
//         l1.proportionalDeposit(300*WAD);
//         (bool success, bytes memory result) = address(l1).call(abi.encodeWithSignature(
//             "swapByTarget(address,address,uint256,uint256,uint256)", dai, susd, 21*WAD, 20*WAD, now+50));
//         assertTrue(!success);
//     }

// }