// pragma solidity ^0.5.6;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../../loihiSetup.sol";
// import "../../../interfaces/IAdapter.sol";

// contract BalancedSelectiveDepositTest is LoihiSetup, DSMath, DSTest {

//     function setUp() public {

//         setupFlavors();
//         setupAdapters();
//         setupLoihi();
//         approveFlavors(address(l));
//         executeLoihiApprovals(address(l));
//         includeAdapters(address(l), 1);

//         uint256 shells = l.proportionalDeposit(300 * (10 ** 18));

//     }

//     function testSelectiveDeposit10x0y0z () public {
//         uint256[] memory amounts = new uint256[](1);
//         address[] memory tokens = new address[](1);

//         tokens[0] = dai; amounts[0] = 10 * WAD;

//         uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
//         newShells /= 100000000000;
//         assertEq(newShells, 100000001);

//     }

//     function testSelectiveDeposit10x15y0z () public {
//         uint256[] memory amounts = new uint256[](2);
//         address[] memory tokens = new address[](2);

//         tokens[0] = dai; amounts[0] = 10 * WAD;
//         tokens[1] = usdc; amounts[1] = 15 * 1000000;

//         uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
//         newShells /= 1000000000000;
//         assertEq(newShells, 25000000);
//     }

//     function testSelectiveDeposit10x25y20z () public {
//         uint256[] memory amounts = new uint256[](3);
//         address[] memory tokens = new address[](3);

//         tokens[0] = dai; amounts[0] = 10 * WAD;
//         tokens[1] = usdc; amounts[1] = 15 * 1000000;
//         tokens[2] = usdt; amounts[2] = 20 * 1000000;

//         uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
//         newShells /= 1000000000000;
//         assertEq(newShells, 45000000);

//     }

//     function testSelectiveDeposit42point857x0y0z () public {
//         uint256[] memory amounts = new uint256[](1);
//         address[] memory tokens = new address[](1);

//         tokens[0] = dai; amounts[0] = 42857000000000000000;

//         uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
//         newShells /= 1000000000000;
//         assertEq(newShells, 42857000);

//     }

//     function testSelectiveDeposit45x0y0z () public {
//         uint256[] memory amounts = new uint256[](1);
//         address[] memory tokens = new address[](1);

//         tokens[0] = dai; amounts[0] = 45 * WAD;

//         uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
//         newShells /= 1000000000000;
//         assertEq(newShells, 44998641);

//     }

//     function testSelectiveDeposit99point99x0y0z () public {
//         uint256[] memory amounts = new uint256[](1);
//         address[] memory tokens = new address[](1);

//         tokens[0] = dai; amounts[0] = 99990000000000000000;

//         uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
//         newShells /= 1000000000000;
//         assertEq(newShells, 99156938);

//     }

//     function testFailSelectiveDeposit150x0y0z () public {
//         uint256[] memory amounts = new uint256[](1);
//         address[] memory tokens = new address[](1);

//         tokens[0] = dai; amounts[0] = 150 * WAD;

//         uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);

//     }

//     function testSelectiveDeposit10x0y60z () public {
//         uint256[] memory amounts = new uint256[](2);
//         address[] memory tokens = new address[](2);

//         tokens[0] = dai; amounts[0] = 10 * WAD;
//         tokens[1] = usdt; amounts[1] = 60 * 1000000;

//         uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
//         newShells /= 1000000000000;
//         assertEq(newShells, 69972410);

//     }

//     function testSelectiveDeposit100chai100cusdc25usdt () public {

//         uint256 chaiBalBefore = IERC20(chai).balanceOf(address(this));
//         uint256 cusdcBalBefore = IERC20(cusdc).balanceOf(address(this));
//         uint256 usdtBalBefore = IERC20(usdt).balanceOf(address(this));

//         uint256[] memory amounts = new uint256[](3);
//         address[] memory tokens = new address[](3);

//         uint256 chaiOf100Numeraire = IAdapter(chaiAdapter).viewRawAmount(100*WAD);
//         uint256 cusdcOf100Numeraire = IAdapter(cusdcAdapter).viewRawAmount(100*WAD);

//         tokens[0] = chai; amounts[0] = chaiOf100Numeraire;
//         tokens[1] = cusdc; amounts[1] = cusdcOf100Numeraire;
//         tokens[2] = usdt; amounts[2] = 25 * 1000000;

//         uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
//         newShells /= 10000000000000;
//         assertEq(newShells, 22500000);

//         uint256 chaiBalAfter = IERC20(chai).balanceOf(address(this));
//         uint256 cusdcBalAfter = IERC20(cusdc).balanceOf(address(this));
//         uint256 usdtBalAfter = IERC20(usdt).balanceOf(address(this));

//         assertEq(chaiBalAfter + chaiOf100Numeraire, chaiBalBefore);
//         assertEq(cusdcBalAfter + cusdcOf100Numeraire, cusdcBalBefore);
//         assertEq(usdtBalAfter + 5 * (10**6), usdtBalBefore);

//     }

//     function testSelectiveDeposit175cdai175cusdc5usdt () public {

//         uint256 cdaiBalBefore = IERC20(cdai).balanceOf(address(this));
//         uint256 cusdcBalBefore = IERC20(cusdc).balanceOf(address(this));
//         uint256 usdtBalBefore = IERC20(usdt).balanceOf(address(this));

//         uint256[] memory amounts = new uint256[](3);
//         address[] memory tokens = new address[](3);

//         uint256 cdaiOf175Numeraire = IAdapter(cdaiAdapter).viewRawAmount(175*WAD);
//         uint256 cusdcOf175Numeraire = IAdapter(cusdcAdapter).viewRawAmount(175*WAD);

//         tokens[0] = cdai; amounts[0] = cdaiOf175Numeraire;
//         tokens[1] = cusdc; amounts[1] = cusdcOf175Numeraire;
//         tokens[2] = usdt; amounts[2] = 5 * 1000000;

//         uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
//         newShells /= 10000000000000;
//         assertEq(newShells, 35499602);

//         uint256 cdaiBalAfter = IERC20(cdai).balanceOf(address(this));
//         uint256 cusdcBalAfter = IERC20(cusdc).balanceOf(address(this));
//         uint256 usdtBalAfter = IERC20(usdt).balanceOf(address(this));

//         emit log_named_uint("cdaiBalBefore", cdaiBalBefore);
//         emit log_named_uint("cdaiBalAfter", cdaiBalAfter);
//         emit log_named_uint("cdai of 175 numeraire", cdaiOf175Numeraire);

//         emit log_named_uint("cusdcBalBefore", cusdcBalBefore);
//         emit log_named_uint("cusdcBalAfter", cusdcBalAfter);
//         emit log_named_uint("cusdc of 175 numeraire", cusdcOf175Numeraire);

//         assertEq(cdaiBalAfter + cdaiOf175Numeraire, cdaiBalBefore);
//         assertEq(cusdcBalAfter + cusdcOf175Numeraire, cusdcBalBefore);
//         assertEq(usdtBalAfter + 5 * (10**6), usdtBalBefore);

//     }

//     function testSelectiveDeposit175dai175usdc5usdt () public {

//         uint256 daiBalBefore = IERC20(dai).balanceOf(address(this));
//         uint256 usdcBalBefore = IERC20(usdc).balanceOf(address(this));
//         uint256 usdtBalBefore = IERC20(usdt).balanceOf(address(this));

//         uint256[] memory amounts = new uint256[](3);
//         address[] memory tokens = new address[](3);

//         tokens[0] = dai; amounts[0] = 175 * WAD;
//         tokens[1] = usdc; amounts[1] = 175 * 1000000;
//         tokens[2] = usdt; amounts[2] = 5 * 1000000;

//         uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
//         newShells /= 10000000000000;
//         assertEq(newShells, 35499602);

//         uint256 daiBalAfter = IERC20(dai).balanceOf(address(this));
//         uint256 usdcBalAfter = IERC20(usdc).balanceOf(address(this));
//         uint256 usdtBalAfter = IERC20(usdt).balanceOf(address(this));

//         assertEq(daiBalAfter + 175*WAD, daiBalBefore);
//         assertEq(usdcBalAfter + 175 * (10**6), usdcBalBefore);
//         assertEq(usdtBalAfter + 5 * (10**6), usdtBalBefore);

//     }

//     function testFailSelectiveDeposit10x10y200z () public {

//         uint256 daiBalBefore = IERC20(dai).balanceOf(address(this));
//         uint256 usdcBalBefore = IERC20(usdc).balanceOf(address(this));
//         uint256 usdtBalBefore = IERC20(usdt).balanceOf(address(this));

//         uint256[] memory amounts = new uint256[](3);
//         address[] memory tokens = new address[](3);

//         tokens[0] = dai; amounts[0] = 10 * WAD;
//         tokens[1] = usdc; amounts[1] = 10 * 1000000;
//         tokens[2] = usdt; amounts[2] = 200 * 1000000;

//         uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
//         assertEq(newShells, 42856999999999999957);

//         uint256 daiBalAfter = IERC20(dai).balanceOf(address(this));
//         uint256 usdcBalAfter = IERC20(usdc).balanceOf(address(this));
//         uint256 usdtBalAfter = IERC20(usdt).balanceOf(address(this));

//         assertEq(daiBalAfter + 10*WAD, daiBalBefore);
//         assertEq(usdcBalAfter + 10 * (10**6), usdcBalBefore);
//         assertEq(usdtBalAfter + 200 * (10**6), usdtBalBefore);


//     }

// }