// pragma solidity ^0.5.16;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../loihiSetup.sol";


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

//     function testBalancedSelectiveWithdraw10x0y0z () public {
//         uint256[] memory amounts = new uint256[](1);
//         address[] memory tokens = new address[](1);

//         tokens[0] = dai; amounts[0] = 10 * WAD;

//         uint256 shellsBurned = l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);
//         shellsBurned /= 100000000000;
//         assertEq(shellsBurned, 100049999);
//     }

//     function testBalancedSelectiveWithdraw10x15y0z () public {
//         uint256[] memory amounts = new uint256[](2);
//         address[] memory tokens = new address[](2);

//         tokens[0] = dai; amounts[0] = 10 * WAD;
//         tokens[1] = usdc; amounts[1] = 15 * 1000000;

//         uint256 shellsBurned = l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);
//         shellsBurned /= 1000000000000;
//         assertEq(shellsBurned, 25012499);
//     }

//     function testBalancedSelectiveWithdraw10x15y20z () public {
//         uint256[] memory amounts = new uint256[](3);
//         address[] memory tokens = new address[](3);

//         tokens[0] = dai; amounts[0] = 10 * WAD;
//         tokens[1] = usdc; amounts[1] = 15 * 1000000;
//         tokens[2] = usdt; amounts[2] = 20 * 1000000;

//         uint256 shellsBurned = l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);
//         shellsBurned /= 1000000000000;
//         assertEq(shellsBurned, 45022499);
//     }

//     function testBalancedSelectiveWithdraw33333333333333x0y0z () public {
//         uint256[] memory amounts = new uint256[](1);
//         address[] memory tokens = new address[](1);

//         tokens[0] = dai; amounts[0] = 33333333333333333333;

//         uint256 shellsBurned = l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);
//         shellsBurned /= 1000000000000;
//         assertEq(shellsBurned, 33350000);
//     }

//     function testBalancedSelectiveWithdraw45x0y0z () public {
//         uint256[] memory amounts = new uint256[](1);
//         address[] memory tokens = new address[](1);

//         tokens[0] = dai; amounts[0] = 45 * WAD;

//         uint256 shellsBurned = l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);
//         shellsBurned /= 1000000000000;
//         assertEq(shellsBurned, 45112618);

//     }

//     function testBalancedSelectiveWithdraw60x0y0z () public {
//         uint256[] memory amounts = new uint256[](1);
//         address[] memory tokens = new address[](1);

//         tokens[0] = dai; amounts[0] = 59999000000000000000;

//         uint256 shellsBurned = l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);
//         shellsBurned /= 1000000000000;
//         assertEq(shellsBurned, 60529209);
//     }

//     function testFailBalancedSelectiveWithdraw150x0y0z () public {
//         uint256[] memory amounts = new uint256[](1);
//         address[] memory tokens = new address[](1);

//         tokens[0] = dai; amounts[0] = 150 * WAD;

//         l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);

//     }

//     function testBalancedSelectiveWithdraw10x0y50z () public {
//         uint256[] memory amounts = new uint256[](2);
//         address[] memory tokens = new address[](2);

//         tokens[0] = dai; amounts[0] = 10 * WAD;
//         tokens[1] = usdt; amounts[1] = 50 * 1000000;

//         uint256 shellsBurned = l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);
//         shellsBurned /= 10000000000000;
//         assertEq(shellsBurned, 6015506);

//     }

//     function testBalancedSelectiveWithdraw75x75y5z () public {
//         uint256[] memory amounts = new uint256[](3);
//         address[] memory tokens = new address[](3);

//         tokens[0] = dai; amounts[0] = 75 * WAD;
//         tokens[1] = usdc; amounts[1] = 75 * 1000000;
//         tokens[2] = usdt; amounts[2] = 5 * 1000000;

//         uint256 shellsBurned = l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);
//         shellsBurned /= 100000000000000;
//         assertEq(shellsBurned, 1556014);
//     }

//     function testFailBalancedSelectiveWithdraw10x10y90z () public {
//         uint256[] memory amounts = new uint256[](3);
//         address[] memory tokens = new address[](3);

//         tokens[0] = dai; amounts[0] = 10 * WAD;
//         tokens[1] = usdc; amounts[1] = 10 * 1000000;
//         tokens[2] = usdt; amounts[2] = 90 * 1000000;

//         uint256 shellsBurned = l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);
//         assertEq(shellsBurned, 354996024173027989465);

//     }

// }