// pragma solidity ^0.5.15;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../loihiSetup.sol";
// import "../../../interfaces/IAdapter.sol";
// import "../../../LoihiViews.sol";

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

//     function testOriginSwapDaiCdai () public {
//         uint256 cdaiOfTenNumeraire = IAdapter(cdaiAdapter).viewRawAmount(10*WAD);
//         uint256 targetAmount = l.swapByOrigin(dai, cdai, 10 * WAD, 0, now + 50);
//         assertEq(targetAmount, cdaiOfTenNumeraire);
//     }

//     function testOriginSwapDaiChai () public {
//         uint256 chaiOfTenNumeraire = IAdapter(chaiAdapter).viewRawAmount(10*WAD);
//         uint256 targetAmount = l.swapByOrigin(dai, chai, 10 * WAD, 0, now + 50);
//         assertEq(targetAmount, chaiOfTenNumeraire);
//     }

//     function testOriginSwapCDaiChai () public {
//         uint256 chaiOfTenNumeraire = IAdapter(chaiAdapter).viewRawAmount(10*WAD);
//         uint256 cdaiOfTenNumeraire = IAdapter(cdaiAdapter).viewRawAmount(10*WAD);
//         uint256 targetAmount = l.swapByOrigin(cdai, chai, cdaiOfTenNumeraire, 0, now + 50);
//         assertEq(targetAmount, chaiOfTenNumeraire);
//     }

//     function testOriginSwapCDaiDai () public {
//         uint256 cdaiOfTenNumeraire = IAdapter(cdaiAdapter).viewRawAmount(10*WAD);
//         uint256 targetAmount = l.swapByOrigin(cdai, dai, cdaiOfTenNumeraire, 0, now + 50);
//         assertEq(targetAmount, 10*WAD);
//     }

//     function testOriginSwapChaiCDai () public {
//         uint256 chaiOfTenNumeraire = IAdapter(chaiAdapter).viewRawAmount(10*WAD);
//         uint256 cdaiOfTenNumeraire = IAdapter(cdaiAdapter).viewRawAmount(10*WAD);
//         uint256 targetAmount = l.swapByOrigin(chai, cdai, chaiOfTenNumeraire, 0, now + 50);
//         assertEq(targetAmount, cdaiOfTenNumeraire);
//     }

//     function testOriginSwapChaiDai () public {
//         uint256 chaiOfTenNumeraire = IAdapter(chaiAdapter).viewRawAmount(10*WAD);
//         uint256 targetAmount = l.swapByOrigin(chai, dai, chaiOfTenNumeraire, 0, now + 50);
//         assertEq(targetAmount, 10*WAD);
//     }

//     function testOriginSwapCusdCUsdc () public {
//         uint256 cusdcOfTenNumeraire = IAdapter(cusdcAdapter).viewRawAmount(10*WAD);
//         uint256 targetAmount = l.swapByOrigin(cusdc, usdc, cusdcOfTenNumeraire, 0, now + 50);
//         assertEq(targetAmount, 10*(10**6));
//     }

//     function testOriginSwapUsdcCusdc () public {
//         uint256 targetAmount = l.swapByOrigin(usdc, cusdc, 10*(10**6), 0, now + 50);
//         uint256 numeraireTargetAmount = IAdapter(cusdcAdapter).viewNumeraireAmount(targetAmount);
//         assertEq(numeraireTargetAmount, 10*WAD);
//     }

//     function testOriginSwapUsdtAUsdt () public {
//         uint256 targetAmount = l.swapByOrigin(usdt, ausdt, 10 * (10**6), 0, now + 50);
//         assertEq(targetAmount, 10*(10**6));
//     }

//     function testOriginSwapAUsdtUsdt () public {

//         uint256 ausdtBalBefore = IERC20(ausdt).balanceOf(address(this));
//         uint256 usdtBalBefore = IERC20(usdt).balanceOf(address(this));

//         uint256 targetAmount = l.swapByOrigin(ausdt, usdt, 10 * (10**6), 0, now + 50);

//         assertEq(targetAmount, 10*(10**6));

//         uint256 ausdtBalAfter = IERC20(ausdt).balanceOf(address(this));
//         uint256 usdtBalAfter = IERC20(usdt).balanceOf(address(this));

//         assertEq(ausdtBalBefore - 10*(10**6), ausdtBalAfter);
//         assertEq(usdtBalAfter - 10*(10**6), usdtBalBefore);
//     }

//     function testSwapOrigin10DaiUsdt () public {

//         uint256 daiBalBefore = IERC20(dai).balanceOf(address(this));
//         uint256 usdtBalBefore = IERC20(usdt).balanceOf(address(this));

//         uint256 projectedAmount = l.viewOriginTrade(dai, usdt, 10 * WAD);
//         uint256 targetAmount = l.swapByOrigin(dai, usdt, 10 * WAD, 0, now);

//         uint256 daiBalAfter = IERC20(dai).balanceOf(address(this));
//         uint256 usdtBalAfter = IERC20(usdt).balanceOf(address(this));

//         assertEq(projectedAmount, 9995000);
//         assertEq(targetAmount, 9995000);
//         assertEq(projectedAmount, targetAmount);
        
//         assertEq(daiBalBefore - 10*WAD, daiBalAfter);
//         assertEq(usdtBalBefore + targetAmount, usdtBalAfter);
//     }

//     function testSwapOrigin10DaiAUsdt () public {

//         uint256 daiBalBefore = IERC20(dai).balanceOf(address(this));
//         uint256 ausdtBalBefore = IERC20(ausdt).balanceOf(address(this));

//         uint256 projectedAmount = l.viewOriginTrade(dai, ausdt, 10*WAD);
//         uint256 targetAmount = l.swapByOrigin(dai, ausdt, 10*WAD, 0, now);

//         assertEq(projectedAmount, 9995000);
//         assertEq(targetAmount, 9995000);
//         assertEq(projectedAmount, targetAmount);

//         uint256 daiBalAfter = IERC20(dai).balanceOf(address(this));
//         uint256 ausdtBalAfter = IERC20(ausdt).balanceOf(address(this));

//         assertEq(daiBalBefore - 10*WAD, daiBalAfter);
//         assertEq(ausdtBalBefore + targetAmount, ausdtBalAfter);
//     }

//     function testSwapOrigin10DaiCUsdc () public {

//         uint256 daiBalBefore = IERC20(dai).balanceOf(address(this));
//         uint256 cusdcBalBefore = IERC20(cusdc).balanceOf(address(this));

//         uint256 projectedAmount = l.viewOriginTrade(dai, cusdc, 10*WAD);
//         uint256 targetAmount = l.swapByOrigin(dai, cusdc, 10*WAD, 0, now);

//         uint256 projectedAmountInNumeraire = IAdapter(cusdcAdapter).viewNumeraireAmount(projectedAmount);
//         uint256 targetAmountInNumeraire = IAdapter(cusdcAdapter).viewNumeraireAmount(targetAmount);

//         assertEq(projectedAmount, targetAmount);
//         assertEq(projectedAmountInNumeraire, 9995000000000000000);
//         assertEq(targetAmountInNumeraire, 9995000000000000000);

//         uint256 daiBalAfter = IERC20(dai).balanceOf(address(this));
//         uint256 cusdcBalAfter = IERC20(cusdc).balanceOf(address(this));

//         assertEq(daiBalBefore - 10*WAD, daiBalAfter);
//         assertEq(cusdcBalBefore + targetAmount, cusdcBalAfter);
//     }

//     function testSwapOrigin10DaiUsdc () public {
//         uint256 daiBalBefore = IERC20(dai).balanceOf(address(this));
//         uint256 usdcBalBefore = IERC20(usdc).balanceOf(address(this));

//         uint256 projectedAmount = l.viewOriginTrade(dai, usdc, 10 * WAD);
//         uint256 targetAmount = l.swapByOrigin(dai, usdc, 10 * WAD, 0, now);

//         assertEq(projectedAmount, 9995000);
//         assertEq(targetAmount, 9995000);
//         assertEq(projectedAmount, targetAmount);

//         uint256 daiBalAfter = IERC20(dai).balanceOf(address(this));
//         uint256 usdcBalAfter = IERC20(usdc).balanceOf(address(this));

//         assertEq(daiBalBefore - 10*WAD, daiBalAfter);
//         assertEq(usdcBalBefore + targetAmount, usdcBalAfter);
//     }

//     function testSwapOrigin10ChaiUsdt () public {

//         uint256 chaiBalBefore = IERC20(chai).balanceOf(address(this));
//         uint256 usdtBalBefore = IERC20(usdt).balanceOf(address(this));

//         uint256 chaiOfTenNumeraire = IAdapter(chaiAdapter).viewRawAmount(10*WAD);

//         uint256 projectedAmount = l.viewOriginTrade(chai, usdt, chaiOfTenNumeraire);
//         uint256 targetAmount = l.swapByOrigin(chai, usdt, chaiOfTenNumeraire, 0, now);

//         assertEq(projectedAmount, 9995000);
//         assertEq(targetAmount, 9995000);
//         assertEq(projectedAmount, targetAmount);

//         uint256 chaiBalAfter = IERC20(chai).balanceOf(address(this));
//         uint256 usdtBalAfter = IERC20(usdt).balanceOf(address(this));

//         assertEq(chaiBalBefore - chaiOfTenNumeraire, chaiBalAfter);
//         assertEq(usdtBalBefore + targetAmount, usdtBalAfter);
//     }

//     function testSwapOrigin10ChaiAUsdt () public {

//         uint256 chaiBalBefore = IERC20(chai).balanceOf(address(this));
//         uint256 ausdtBalBefore = IERC20(ausdt).balanceOf(address(this));

//         uint256 chaiOfTenNumeraire = IAdapter(chaiAdapter).viewRawAmount(10*WAD);
//         uint256 projectedAmount = l.viewOriginTrade(chai, ausdt, chaiOfTenNumeraire);
//         uint256 targetAmount = l.swapByOrigin(chai, ausdt, chaiOfTenNumeraire, 0, now);

//         assertEq(projectedAmount, 9995000);
//         assertEq(targetAmount, 9995000);
//         assertEq(projectedAmount, targetAmount);

//         uint256 chaiBalAfter = IERC20(chai).balanceOf(address(this));
//         uint256 ausdtBalAfter = IERC20(ausdt).balanceOf(address(this));

//         assertEq(chaiBalBefore - chaiOfTenNumeraire, chaiBalAfter);
//         assertEq(ausdtBalBefore + targetAmount, ausdtBalAfter);
//     }

//     function testSwapOrigin10ChaiUsdc () public {

//         uint256 chaiBalBefore = IERC20(chai).balanceOf(address(this));
//         uint256 usdcBalBefore = IERC20(usdc).balanceOf(address(this));

//         uint256 chaiOfTenNumeraire = IAdapter(chaiAdapter).viewRawAmount(10*WAD);
//         uint256 projectedAmount = l.viewOriginTrade(chai, usdc, chaiOfTenNumeraire);
//         uint256 targetAmount = l.swapByOrigin(chai, usdc, chaiOfTenNumeraire, 0, now);

//         assertEq(projectedAmount, 9995000);
//         assertEq(targetAmount, 9995000);
//         assertEq(projectedAmount, targetAmount);

//         uint256 chaiBalAfter = IERC20(chai).balanceOf(address(this));
//         uint256 usdcBalAfter = IERC20(usdc).balanceOf(address(this));

//         assertEq(chaiBalBefore - chaiOfTenNumeraire, chaiBalAfter);
//         assertEq(usdcBalBefore + targetAmount, usdcBalAfter);
//     }

//     function testSwapOrigin10ChaiCUsdc () public {

//         uint256 chaiBalBefore = IERC20(chai).balanceOf(address(this));
//         uint256 cusdcBalBefore = IERC20(cusdc).balanceOf(address(this));

//         uint256 chaiOfTenNumeraire = IAdapter(chaiAdapter).viewRawAmount(10*WAD);
//         uint256 projectedAmount = l.viewOriginTrade(chai, cusdc, chaiOfTenNumeraire);
//         uint256 targetAmount = l.swapByOrigin(chai, cusdc, chaiOfTenNumeraire, 0, now);

//         uint256 projectedAmountInNumeraire = IAdapter(cusdcAdapter).viewNumeraireAmount(projectedAmount);
//         uint256 swappedAmountInNumeraire = IAdapter(cusdcAdapter).viewNumeraireAmount(targetAmount);

//         assertEq(projectedAmount, targetAmount);
//         assertEq(projectedAmountInNumeraire, 9995000000000000000);
//         assertEq(swappedAmountInNumeraire, 9995000000000000000);

//         uint256 chaiBalAfter = IERC20(chai).balanceOf(address(this));
//         uint256 cusdcBalAfter = IERC20(cusdc).balanceOf(address(this));

//         assertEq(chaiBalBefore - chaiOfTenNumeraire, chaiBalAfter);
//         assertEq(cusdcBalBefore + targetAmount, cusdcBalAfter);
//     }

//     function testSwap25OriginChaiCusdc () public {

//         uint256 chaiBalBefore = IERC20(chai).balanceOf(address(this));
//         uint256 cusdcBalBefore = IERC20(cusdc).balanceOf(address(this));
        
//         uint256 chaiOf25Numeraire = IAdapter(chaiAdapter).viewRawAmount(25*WAD);

//         uint256 projectedAmount = l.viewOriginTrade(chai, cusdc, chaiOf25Numeraire);
//         uint256 targetAmount = l.swapByOrigin(chai, cusdc, chaiOf25Numeraire, 9 * (10 ** 8), now);

//         uint256 numeraireAmount = IAdapter(cusdcAdapter).getNumeraireAmount(targetAmount);
//         numeraireAmount /= 10000000000;

//         assertEq(projectedAmount, targetAmount);
//         assertEq(numeraireAmount, 2498749900);

//         uint256 chaiBalAfter = IERC20(chai).balanceOf(address(this));
//         uint256 cusdcBalAfter = IERC20(cusdc).balanceOf(address(this));

//         assertEq(chaiBalBefore - chaiOf25Numeraire, chaiBalAfter);
//         assertEq(cusdcBalBefore + targetAmount, cusdcBalAfter);
//     }

//     function testSwap25OriginCDaiCusdc () public {

//         uint256 cdaiBalBefore = IERC20(cdai).balanceOf(address(this));
//         uint256 cusdcBalBefore = IERC20(cusdc).balanceOf(address(this));

//         uint256 cdaiOf25Numeraire = IAdapter(cdaiAdapter).viewRawAmount(25*WAD);
//         uint256 projectedAmount = l.viewOriginTrade(cdai, cusdc, cdaiOf25Numeraire);

//         uint256 targetAmount = l.swapByOrigin(cdai, cusdc, cdaiOf25Numeraire, 0, now);
//         uint256 numeraireAmount = IAdapter(cusdcAdapter).getNumeraireAmount(targetAmount);

//         numeraireAmount /= 1000000000000000;
//         assertEq(targetAmount, projectedAmount);
//         assertEq(numeraireAmount, 24987);

//         uint256 cdaiBalAfter = IERC20(cdai).balanceOf(address(this));
//         uint256 cusdcBalAfter = IERC20(cusdc).balanceOf(address(this));

//         assertEq(cdaiBalBefore - cdaiOf25Numeraire, cdaiBalAfter);
//         assertEq(cusdcBalBefore + targetAmount, cusdcBalAfter);
//     }

//     function testSwapOrigin25DaiCusdc () public {

//         uint256 daiBalBefore = IERC20(dai).balanceOf(address(this));
//         uint256 cusdcBalBefore = IERC20(cusdc).balanceOf(address(this));

//         uint256 projectedAmount = l.viewOriginTrade(dai, cusdc, 25 * WAD);
//         uint256 targetAmount = l.swapByOrigin(dai, cusdc, 25 * WAD, 9 * (10 ** 8), now);

//         uint256 numeraireAmount = IAdapter(cusdcAdapter).getNumeraireAmount(targetAmount);
//         numeraireAmount /= 1000000000000000;

//         assertEq(projectedAmount, targetAmount);
//         assertEq(numeraireAmount, 24987);

//         uint256 daiBalAfter = IERC20(dai).balanceOf(address(this));
//         uint256 cusdcBalAfter = IERC20(cusdc).balanceOf(address(this));

//         assertEq(daiBalBefore - 25*WAD, daiBalAfter);
//         assertEq(cusdcBalBefore + targetAmount, cusdcBalAfter);
//     }

//     function testSwapOrigin40DaiCusdc () public {

//         uint256 daiBalBefore = IERC20(dai).balanceOf(address(this));
//         uint256 cusdcBalBefore = IERC20(cusdc).balanceOf(address(this));

//         uint256 projectedAmount = l.viewOriginTrade(dai, cusdc, 40 * WAD);
//         uint256 targetAmount = l.swapByOrigin(dai, cusdc, 40 * WAD, 0, now);

//         uint256 numeraireAmount = IAdapter(cusdcAdapter).getNumeraireAmount(targetAmount);
//         numeraireAmount /= 10000000000;

//         assertEq(targetAmount, projectedAmount);
//         assertEq(numeraireAmount, 3953692000);

//         uint256 daiBalAfter = IERC20(dai).balanceOf(address(this));
//         uint256 cusdcBalAfter = IERC20(cusdc).balanceOf(address(this));

//         emit log_named_uint("daiBalAfter", daiBalAfter);
//         emit log_named_uint("daiBalBefore", daiBalBefore);

//         emit log_named_uint("cusdcBalBefore", cusdcBalBefore);
//         emit log_named_uint("cusdcBalAfter", cusdcBalAfter);

//         emit log_named_uint("target amount", targetAmount);
//         emit log_named_uint("projected amount", projectedAmount);

//         assertEq(daiBalBefore - 40*WAD, daiBalAfter);
//         assertEq(cusdcBalBefore + targetAmount, cusdcBalAfter);
//     }

//     function testSwapOrigin50DaiUsdc () public {

//         uint256 daiBalBefore = IERC20(dai).balanceOf(address(this));
//         uint256 usdcBalBefore = IERC20(usdc).balanceOf(address(this));

//         uint256 projectedAmount = l.viewOriginTrade(dai, usdc, 50 * WAD - 10000000000000);
//         uint256 targetAmount = l.swapByOrigin(dai, usdc, 50 * WAD - 10000000000000, 9 * (10**6), now);

//         assertEq(targetAmount, projectedAmount);
//         assertEq(targetAmount, 48756459);

//         uint256 daiBalAfter = IERC20(dai).balanceOf(address(this));
//         uint256 usdcBalAfter = IERC20(usdc).balanceOf(address(this));

//         assertEq(daiBalBefore - 50*WAD - 10000000000000, daiBalAfter);
//         assertEq(usdcBalBefore + targetAmount, usdcBalAfter);
//     }

//     function testFailView80Origin () public {
//         uint256 targetAmount = l.viewOriginTrade(dai, cusdc, 80 * WAD);
//         assertEq(targetAmount, 0);
//     }

//     function testFailSwap80Origin () public {
//         uint256 targetAmount = l.swapByOrigin(dai, cusdc, 80 * WAD, 9 , now);
//     }

// }