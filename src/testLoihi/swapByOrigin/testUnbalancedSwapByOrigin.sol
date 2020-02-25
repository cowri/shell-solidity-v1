// pragma solidity ^0.5.16;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../loihiSetup.sol";
// import "../../IAdapter.sol";

// contract UnbalancedSwapByOriginTest is LoihiSetup, DSMath, DSTest {
//     uint256 CUsdcNM10;

//     function setUp() public {

//         setupFlavors();
//         setupAdapters();
//         setupLoihi();
//         approveFlavors(address(l));
//         executeLoihiApprovals(address(l));
//         includeAdapters(address(l), 1);

//         l.proportionalDeposit(300 * (10 ** 18));

//         address[] memory addr = new address[](1);
//         uint256[] memory amt = new uint256[](1);
//         addr[0] = dai;
//         amt[0] = 30 * WAD;
//         uint256 burned = l.selectiveWithdraw(addr, amt, 500 * WAD, now + 500);

//         addr[0] = usdt;
//         amt[0] = 30 * 1000000;
//         uint256 deposited = l.selectiveDeposit(addr, amt, 0, now + 500);

//         CUsdcNM10 = IAdapter(cusdcAdapter).viewRawAmount(10*(10**18));

//     }

//     // function testUnbalancedOriginSwapZtoY () public {
//     //     uint256 projectedAmount = l.viewOriginTrade(usdt, usdc, 10 * 1000000);
//     //     uint256 targetAmount = l.swapByOrigin(usdt, usdc, 10 * 1000000, 5 * (10 ** 6), now);
//     //     assertEq(targetAmount, projectedAmount);
//     //     assertEq(targetAmount, 9845074);
//     //     emit log_named_uint("projected", projectedAmount);
//     //     emit log_named_uint("targetAmount", targetAmount);
//     // }

//     function testUnbalancedOriginSwapCUsdcToCDai () public {
//         uint256 projectedAmount = l.viewOriginTrade(cusdc, cdai, CUsdcNM10);
//         uint256 targetAmount = l.swapByOrigin(cusdc, cdai, CUsdcNM10, 5 * (10 ** 8), now);
//         assertEq(projectedAmount, targetAmount);
//         uint256 numeraireAmount = IAdapter(cdaiAdapter).getNumeraireAmount(targetAmount);
//         assertEq(numeraireAmount / (10**13), 984507);
//         emit log_named_uint("projected", projectedAmount);
//         emit log_named_uint("targetAmount", targetAmount);
//     }

//     function testUnbalancedOriginSwapCUsdcToChai () public {
//         uint256 projectedAmount = l.viewOriginTrade(cusdc, chai, CUsdcNM10);
//         uint256 targetAmount = l.swapByOrigin(cusdc, chai, CUsdcNM10, 5 * (10 ** 8), now);
//         assertEq(projectedAmount, targetAmount);
//         uint256 numeraireAmount = IAdapter(chaiAdapter).getNumeraireAmount(targetAmount);
//         assertEq(numeraireAmount/(10**13), 984507);
//         emit log_named_uint("projected", projectedAmount);
//         emit log_named_uint("targetAmount", targetAmount);
//     }

//     function testUnbalancedOriginSwapCUsdcToDai () public {
//         uint256 projectedAmount = l.viewOriginTrade(cusdc, dai, CUsdcNM10);
//         uint256 targetAmount = l.swapByOrigin(cusdc, dai, CUsdcNM10, 5 * (10 ** 8), now);
//         assertEq(projectedAmount, targetAmount);
//         assertEq(targetAmount / (10**13), 984507);
//         emit log_named_uint("projected", projectedAmount);
//         emit log_named_uint("targetAmount", targetAmount);
//     }

//     function testUnbalancedOriginSwapYtoX () public {
//         uint256 projectedAmount = l.viewOriginTrade(usdc, dai, 10 * (10 ** 6));
//         uint256 targetAmount = l.swapByOrigin(usdc, dai, 10 * (10 ** 6), 5 * WAD, now);
//         assertEq(projectedAmount, targetAmount);
//         targetAmount /= (10**13);
//         assertEq(targetAmount, 984507);
//         emit log_named_uint("projected", projectedAmount);
//         emit log_named_uint("targetAmount", targetAmount);
//     }

//     function testUnbalancedOriginSwapZtoX () public {
//         uint256 projectedAmount = l.viewOriginTrade(usdt, dai, 10 * 1000000);
//         uint256 targetAmount = l.swapByOrigin(usdt, dai, 10 * 1000000, 5 * WAD, now);
//         assertEq(projectedAmount, targetAmount);
//         targetAmount /= 10000000000;
//         assertEq(targetAmount, 969887563);
//         emit log_named_uint("projected", projectedAmount);
//         emit log_named_uint("targetAmount", targetAmount);
//     }

//     function testUnbalancedOriginSwapXtoZ () public {
//         uint256 projectedAmount = l.viewOriginTrade(dai, usdt, 10 * WAD);
//         uint256 targetAmount = l.swapByOrigin(dai, usdt, 10 * WAD, 5 * 1000000, now);
//         assertEq(targetAmount, projectedAmount);
//         assertEq(targetAmount, 9995000);
//         emit log_named_uint("projected", projectedAmount);
//         emit log_named_uint("targetAmount", targetAmount);
//     }

//     function testFailUnbalancedOriginSwap () public {
//         uint256 targetAmount = l.swapByOrigin(dai, cusdc, 80 * WAD, 9 * WAD, now);
//     }

// }