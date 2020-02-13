// pragma solidity ^0.5.6;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../loihiSetup.sol";

// contract UnbalancedSelectiveDepositTest is LoihiSetup, DSMath, DSTest {

//     function setUp() public {

//         setupFlavors();
//         setupAdapters();
//         setupLoihi();
//         approveFlavors(address(l));

//         l.proportionalDeposit(300 * (10 ** 18));

//         address[] memory addr = new address[](1);
//         uint256[] memory amt = new uint256[](1);
//         addr[0] = dai;
//         amt[0] = 30 * WAD;
//         uint256 burned = l.selectiveWithdraw(addr, amt, 50*WAD, now + 500);

//         addr[0] = usdt;
//         amt[0] = 30 * 1000000;
//         uint256 deposited = l.selectiveDeposit(addr, amt, 20*WAD, now + 500);

//     }

//     function testUnbalancedSelectiveDeposit0x10y20z () public {
//         uint256[] memory amounts = new uint256[](2);
//         address[] memory tokens = new address[](2);

//         tokens[0] = usdc; amounts[0] = 10 * 1000000;
//         tokens[1] = usdt; amounts[1] = 20 * 1000000;

//         uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
//         newShells /= 1000000000000;
//         assertEq(newShells, 29853808);
//     }

//     function testUnbalancedSelectiveDeposit10x15y0z () public {
//         uint256[] memory amounts = new uint256[](2);
//         address[] memory tokens = new address[](2);

//         tokens[0] = dai; amounts[0] = 10 * WAD;
//         tokens[1] = usdc; amounts[1] = 15 * 1000000;

//         uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
//         newShells /= 1000000000000;
//         assertEq(newShells, 24996528);
//     }

//     function testUnbalancedSelectiveDeposit10x15y25z () public {
//         uint256[] memory amounts = new uint256[](3);
//         address[] memory tokens = new address[](3);

//         tokens[0] = dai; amounts[0] = 10 * WAD;
//         tokens[1] = usdc; amounts[1] = 15 * 1000000;
//         tokens[2] = usdt; amounts[2] = 25 * 1000000;

//         uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
//         newShells /= 1000000000000;
//         assertEq(newShells, 49921042);
//     }

//     function testFailUnbalancedSelectiveDeposit0x0y100z () public {
//         uint256[] memory amounts = new uint256[](2);
//         address[] memory tokens = new address[](2);

//         tokens[1] = usdc; amounts[1] = 0;
//         tokens[2] = usdt; amounts[2] = 100 * 1000000;

//         uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
//     }

// }