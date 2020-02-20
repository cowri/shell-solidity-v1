// pragma solidity ^0.5.6;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../loihiSetup.sol";

// contract UnbalancedSelectiveWithdrawTest is LoihiSetup, DSMath, DSTest {

//     function setUp() public {

//         setupFlavors();
//         setupAdapters();
//         setupLoihi();
//         approveFlavors(address(l));
//         includeAdapters(address(l), 1);

//         l.proportionalDeposit(300 * (10 ** 18));

//         address[] memory addr = new address[](1);
//         uint256[] memory amt = new uint256[](1);
//         addr[0] = dai;
//         amt[0] = 30 * WAD;
//         l.selectiveWithdraw(addr, amt, WAD * 500, now + 500);

//         addr[0] = usdt;
//         amt[0] = 30 * 1000000;
//         l.selectiveDeposit(addr, amt, 0, now + 500);

//     }

//     function testUnbalancedSelectiveWithdraw10x5y0z () public {
//         uint256[] memory amounts = new uint256[](2);
//         address[] memory tokens = new address[](2);

//         tokens[0] = dai; amounts[0] = 10 * WAD;
//         tokens[1] = usdc; amounts[1] = 5 * 1000000;

//         uint256 shellsBurned = l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);
//         shellsBurned /= 10000000000;
//         assertEq(shellsBurned, 1512387964);
//     }

//     function testUnbalancedSelectiveWithdraw0x10y10z () public {
//         uint256[] memory amounts = new uint256[](2);
//         address[] memory tokens = new address[](2);

//         tokens[0] = usdc; amounts[0] = 10 * 1000000;
//         tokens[1] = usdt; amounts[1] = 1000000 * 10;

//         uint256 shellsBurned = l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);
//         shellsBurned /= 10000000000;
//         assertEq(shellsBurned, 2000722112);
//     }

//     function testUnbalancedSelectiveWithdraw10x0y5z () public {
//         uint256[] memory amounts = new uint256[](2);
//         address[] memory tokens = new address[](2);

//         tokens[0] = dai; amounts[0] = WAD * 10;
//         tokens[1] = usdt; amounts[1] = 1000000 * 5;

//         uint256 shellsBurned = l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);
//         shellsBurned /= 10000000000;
//         assertEq(shellsBurned, 1512387964);
//     }

//     function testFailUnbalancedSelectiveWithdraw0x0y100z () public {
//         uint256[] memory amounts = new uint256[](1);
//         address[] memory tokens = new address[](1);

//         tokens[0] = usdt; amounts[0] = 1000000 * 100;

//         l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);
//     }

// }