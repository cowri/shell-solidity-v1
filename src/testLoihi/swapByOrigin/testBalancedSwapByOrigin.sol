// pragma solidity ^0.5.6;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../../adapters/kovan/KovanChaiAdapter.sol";
// import "../loihiSetup.sol";
// import "../../IAdapter.sol";
// import "../../LoihiViews.sol";

// contract BalancedSwapByOriginTest is LoihiSetup, DSMath, DSTest {
//     uint256 ChaiNM10;
//     uint256 ChaiNM25;
//     uint256 CDaiNM25;

//     function setUp() public {

//         setupFlavors();
//         setupAdapters();
//         setupLoihi();
//         approveFlavors(address(l));
//         executeLoihiApprovals(address(l));
//         includeAdapters(address(l), 1);

//         l.proportionalDeposit(300 * (10 ** 18));

//         ChaiNM10 = IAdapter(chaiAdapter).viewRawAmount(10*WAD);
//         ChaiNM25 = IAdapter(chaiAdapter).viewRawAmount(25*WAD);
//         CDaiNM25 = IAdapter(cdaiAdapter).viewRawAmount(25*WAD);

//     }

//     function testSwap10OriginDaiUsdc () public {
//         uint256 projectedAmount = l.viewOriginTrade(dai, usdc, 10 * WAD);
//         uint256 targetAmount = l.swapByOrigin(dai, usdc, 10 * WAD, 0, now);
//         assertEq(projectedAmount, 9995000);
//         assertEq(targetAmount, 9995000);
//         assertEq(projectedAmount, targetAmount);
//     }

//     function testSwap25OriginChaiCusdc () public {
//         uint256 projectedAmount = l.viewOriginTrade(chai, cusdc, ChaiNM25);
//         uint256 targetAmount = l.swapByOrigin(chai, cusdc, ChaiNM25, 9 * (10 ** 8), now);

//         assertEq(projectedAmount, targetAmount);

//         uint256 numeraireAmount = IAdapter(cusdcAdapter).getNumeraireAmount(targetAmount);
//         numeraireAmount /= 10000000000;
//         assertEq(numeraireAmount, 2498749900);
//     }

//     function testSwap25OriginCDaiCusdc () public {
//         uint256 cdaiBal1 = IERC20(cdai).balanceOf(address(this));
//         uint256 cusdcBal1 = IERC20(cusdc).balanceOf(address(this));
//         // uint256 cusdcBal = IERC20(cusdc).balanceOf(address(this));
//         // emit log_named_address("cdai", cdai);
//         // emit log_named_address("cusdc", cusdc);
//         // emit log_named_uint("cusdcBal", cusdcBal);
//         // emit log_named_address("me", address(this));
//         uint256 projectedAmount = l.viewOriginTrade(cdai, cusdc, CDaiNM25);
//         uint256 targetAmount = l.swapByOrigin(cdai, cusdc, CDaiNM25, 0, now);
//         assertEq(targetAmount, projectedAmount);
//         uint256 numeraireAmount = IAdapter(cusdcAdapter).getNumeraireAmount(targetAmount);
//         numeraireAmount /= 1000000000000000;
//         uint256 cdaiBal2 = IERC20(cdai).balanceOf(address(this));
//         uint256 cusdcBal2 = IERC20(cusdc).balanceOf(address(this));
//         emit log_named_uint("cdaiBal1", cdaiBal1);
//         emit log_named_uint("cdaiBal2", cdaiBal2);
//         emit log_named_uint("cusdcBal1", cusdcBal1);
//         emit log_named_uint("cusdcBal2", cusdcBal2);
//         assertEq(numeraireAmount, 24987);
//     }

//     function testSwap25Origin () public {
//         uint256 projectedAmount = l.viewOriginTrade(dai, cusdc, 25 * WAD);
//         uint256 targetAmount = l.swapByOrigin(dai, cusdc, 25 * WAD, 9 * (10 ** 8), now);
//         assertEq(projectedAmount, targetAmount);
//         uint256 numeraireAmount = IAdapter(cusdcAdapter).getNumeraireAmount(targetAmount);
//         numeraireAmount /= 1000000000000000;
//         assertEq(numeraireAmount, 24987);
//     }

//     function testSwap40Origin () public {
//         uint256 projectedAmount = l.viewOriginTrade(dai, cusdc, 40 * WAD);
//         uint256 targetAmount = l.swapByOrigin(dai, cusdc, 40 * WAD, 9 * (10 ** 8), now);
//         assertEq(targetAmount, projectedAmount);
//         uint256 numeraireAmount = IAdapter(cusdcAdapter).getNumeraireAmount(targetAmount);
//         numeraireAmount /= 10000000000;
//         assertEq(numeraireAmount, 3953692000);
//     }

//     function testSwap50Origin () public {
//         uint256 projectedAmount = l.viewOriginTrade(dai, usdc, 50 * WAD - 10000000000000);
//         uint256 targetAmount = l.swapByOrigin(dai, usdc, 50 * WAD - 10000000000000, 9 * (10**6), now);
//         assertEq(targetAmount, projectedAmount);
//         assertEq(targetAmount, 48756459);
//     }

//     function testFailView80Origin () public {
//         uint256 targetAmount = l.viewOriginTrade(dai, cusdc, 80 * WAD);
//         assertEq(targetAmount, 0);
//     }

//     function testFailSwap80Origin () public {
//         uint256 targetAmount = l.swapByOrigin(dai, cusdc, 80 * WAD, 9 , now);
//     }

// }