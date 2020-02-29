// pragma solidity ^0.5.15;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../../loihiSetup.sol";
// import "../../../interfaces/IAdapter.sol";


// contract BalancedSelectiveWithdrawTest is LoihiSetup, DSMath, DSTest {

//     function setUp() public {

//         setupFlavors();
//         setupAdapters();
//         setupLoihi();
//         approveFlavors(address(l));
//         executeLoihiApprovals(address(l));
//         includeAdapters(address(l), 1);

//         uint256 shells = l.proportionalDeposit(300 * (10 ** 18));

//     }

//     function testBalancedSelectiveWithdraw10dai0y0z () public {
//         uint256[] memory amounts = new uint256[](1);
//         address[] memory tokens = new address[](1);

//         tokens[0] = dai; amounts[0] = 10 * WAD;

//         uint256 shellsBurned = l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);
//         shellsBurned /= 100000000000;
//         assertEq(shellsBurned, 100049999);
//     }

//     function testBalancedSelectiveWithdraw10cdai0y0z () public {

//         uint256 cdaiBalBefore = IERC20(cdai).balanceOf(address(this));

//         uint256[] memory amounts = new uint256[](1);
//         address[] memory tokens = new address[](1);

//         uint256 cdaiOfTenNumeraires = IAdapter(cdaiAdapter).viewRawAmount(10*WAD);

//         tokens[0] = cdai; amounts[0] = cdaiOfTenNumeraires;

//         uint256 shellsBurned = l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);
//         shellsBurned /= 100000000000;
//         assertEq(shellsBurned, 100049999);
        
//         uint256 cdaiBalAfter = IERC20(cdai).balanceOf(address(this));

//         assertEq(cdaiBalAfter - cdaiOfTenNumeraires, cdaiBalBefore);

//     }

//     function testBalancedSelectiveWithdraw10chai15cusdc0z () public {

//         uint256 chaiBalBefore = IERC20(chai).balanceOf(address(this));
//         uint256 cusdcBalBefore = IERC20(cusdc).balanceOf(address(this));

//         uint256[] memory amounts = new uint256[](2);
//         address[] memory tokens = new address[](2);

//         uint256 chaiOfTenNumeraires = IAdapter(chaiAdapter).viewRawAmount(10*WAD);
//         uint256 cusdcOfTenNumeraires = IAdapter(cusdcAdapter).viewRawAmount(15*WAD);

//         tokens[0] = chai; amounts[0] = chaiOfTenNumeraires;
//         tokens[1] = cusdc; amounts[1] = cusdcOfTenNumeraires;

//         uint256 shellsBurned = l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);
//         shellsBurned /= 1000000000000;
//         assertEq(shellsBurned, 25012499);

//         uint256 chaiBalAfter = IERC20(chai).balanceOf(address(this));
//         uint256 cusdcBalAfter = IERC20(cusdc).balanceOf(address(this));

//         assertEq(chaiBalAfter - chaiOfTenNumeraires, chaiBalBefore);
//         assertEq(cusdcBalAfter - cusdcOfTenNumeraires, cusdcBalBefore);
//     }

//     function testBalancedSelectiveWithdraw10dai15usdc0z () public {

//         uint256 daiBalBefore = IERC20(dai).balanceOf(address(this));
//         uint256 usdcBalBefore = IERC20(usdc).balanceOf(address(this));

//         uint256[] memory amounts = new uint256[](2);
//         address[] memory tokens = new address[](2);

//         tokens[0] = dai; amounts[0] = 10 * WAD;
//         tokens[1] = usdc; amounts[1] = 15 * 1000000;

//         uint256 shellsBurned = l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);
//         shellsBurned /= 1000000000000;
//         assertEq(shellsBurned, 25012499);

//         uint256 daiBalAfter = IERC20(dai).balanceOf(address(this));
//         uint256 usdcBalAfter = IERC20(usdc).balanceOf(address(this));

//         assertEq(daiBalAfter - 10 * WAD, daiBalBefore);
//         assertEq(usdcBalAfter - 15 * (10**6), usdcBalBefore);
//     }

//     function testBalancedSelectiveWithdraw10cdai15usdc20ausdt () public {

//         uint256 cdaiBalBefore = IERC20(cdai).balanceOf(address(this));
//         uint256 usdcBalBefore = IERC20(usdc).balanceOf(address(this));
//         uint256 ausdtBalBefore = IERC20(ausdt).balanceOf(address(this));

//         uint256[] memory amounts = new uint256[](3);
//         address[] memory tokens = new address[](3);

//         uint256 cdaiOfTenNumeraires = IAdapter(cdaiAdapter).viewRawAmount(10*WAD);

//         tokens[0] = cdai; amounts[0] = cdaiOfTenNumeraires;
//         tokens[1] = usdc; amounts[1] = 15 * 1000000;
//         tokens[2] = ausdt; amounts[2] = 20 * 1000000;

//         uint256 shellsBurned = l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);
//         shellsBurned /= 1000000000000;
//         assertEq(shellsBurned, 45022499);

//         uint256 cdaiBalAfter = IERC20(cdai).balanceOf(address(this));
//         uint256 usdcBalAfter = IERC20(usdc).balanceOf(address(this));
//         uint256 ausdtBalAfter = IERC20(ausdt).balanceOf(address(this));

//         assertEq(cdaiBalAfter - cdaiOfTenNumeraires, cdaiBalBefore);
//         assertEq(usdcBalAfter - 15 * (10**6), usdcBalBefore);
//         assertEq(ausdtBalAfter - 20 * (10**6), ausdtBalBefore);

//     }

//     function testBalancedSelectiveWithdraw10dai15usdc20usdt () public {

//         uint256 daiBalBefore = IERC20(dai).balanceOf(address(this));
//         uint256 usdcBalBefore = IERC20(usdc).balanceOf(address(this));
//         uint256 usdtBalBefore = IERC20(usdt).balanceOf(address(this));

//         uint256[] memory amounts = new uint256[](3);
//         address[] memory tokens = new address[](3);

//         tokens[0] = dai; amounts[0] = 10 * WAD;
//         tokens[1] = usdc; amounts[1] = 15 * 1000000;
//         tokens[2] = usdt; amounts[2] = 20 * 1000000;

//         uint256 shellsBurned = l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);
//         shellsBurned /= 1000000000000;
//         assertEq(shellsBurned, 45022499);

//         uint256 daiBalAfter = IERC20(dai).balanceOf(address(this));
//         uint256 usdcBalAfter = IERC20(usdc).balanceOf(address(this));
//         uint256 usdtBalAfter = IERC20(usdt).balanceOf(address(this));

//         assertEq(daiBalAfter - 10 * WAD, daiBalBefore);
//         assertEq(usdcBalAfter - 15 * (10**6), usdcBalBefore);
//         assertEq(usdtBalAfter - 20 * (10**6), usdtBalBefore);

//     }

//     function testBalancedSelectiveWithdraw33333333333333dai0y0z () public {

//         uint256 daiBalBefore = IERC20(dai).balanceOf(address(this));

//         uint256[] memory amounts = new uint256[](1);
//         address[] memory tokens = new address[](1);

//         tokens[0] = dai; amounts[0] = 33333333333333333333;

//         uint256 shellsBurned = l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);
//         shellsBurned /= 1000000000000;
//         assertEq(shellsBurned, 33350000);

//         uint256 daiBalAfter = IERC20(dai).balanceOf(address(this));

//         assertEq(daiBalAfter - 33333333333333333333, daiBalBefore);

//     }

//     function testBalancedSelectiveWithdraw45dai0y0z () public {

//         uint256 daiBalBefore = IERC20(dai).balanceOf(address(this));

//         uint256[] memory amounts = new uint256[](1);
//         address[] memory tokens = new address[](1);

//         tokens[0] = dai; amounts[0] = 45 * WAD;

//         uint256 shellsBurned = l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);
//         shellsBurned /= 1000000000000;
//         assertEq(shellsBurned, 45112618);

//         uint256 daiBalAfter = IERC20(dai).balanceOf(address(this));

//         assertEq(daiBalAfter - 45*WAD, daiBalBefore);

//     }

//     function testBalancedSelectiveWithdraw60dai0y0z () public {

//         uint256 daiBalBefore = IERC20(dai).balanceOf(address(this));

//         uint256[] memory amounts = new uint256[](1);
//         address[] memory tokens = new address[](1);

//         tokens[0] = dai; amounts[0] = 59999000000000000000;

//         uint256 shellsBurned = l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);
//         shellsBurned /= 1000000000000;
//         assertEq(shellsBurned, 60529209);

//         uint256 daiBalAfter = IERC20(dai).balanceOf(address(this));

//         assertEq(daiBalAfter - 59999000000000000000, daiBalBefore);
//     }

//     function testFailBalancedSelectiveWithdraw150x0y0z () public {
//         uint256[] memory amounts = new uint256[](1);
//         address[] memory tokens = new address[](1);

//         tokens[0] = dai; amounts[0] = 150 * WAD;

//         l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);

//     }

//     function testBalancedSelectiveWithdraw10dai0y50usdt () public {
//         uint256[] memory amounts = new uint256[](2);
//         address[] memory tokens = new address[](2);

//         tokens[0] = dai; amounts[0] = 10 * WAD;
//         tokens[1] = usdt; amounts[1] = 50 * 1000000;

//         uint256 shellsBurned = l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);
//         shellsBurned /= 10000000000000;
//         assertEq(shellsBurned, 6015506);

//     }

//     function testBalancedSelectiveWithdraw75dai75usdc5usdt () public {
//         uint256[] memory amounts = new uint256[](3);
//         address[] memory tokens = new address[](3);

//         tokens[0] = dai; amounts[0] = 75 * WAD;
//         tokens[1] = usdc; amounts[1] = 75 * 1000000;
//         tokens[2] = usdt; amounts[2] = 5 * 1000000;

//         uint256 shellsBurned = l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);
//         shellsBurned /= 100000000000000;
//         assertEq(shellsBurned, 1556014);
//     }

//     function testFailBalancedSelectiveWithdraw10dai10usdc90usdt () public {
//         uint256[] memory amounts = new uint256[](3);
//         address[] memory tokens = new address[](3);

//         tokens[0] = dai; amounts[0] = 10 * WAD;
//         tokens[1] = usdc; amounts[1] = 10 * 1000000;
//         tokens[2] = usdt; amounts[2] = 90 * 1000000;

//         uint256 shellsBurned = l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);
//         assertEq(shellsBurned, 354996024173027989465);

//     }

// }