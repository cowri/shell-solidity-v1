// pragma solidity ^0.5.15;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../../loihiSetup.sol";

// contract UnbalancedSelectiveWithdrawTest is LoihiSetup, DSMath, DSTest {

//     function setUp() public {

//         setupFlavors();
//         setupAdapters();
//         setupLoihi();
//         approveFlavors(address(l));
//         executeLoihiApprovals(address(l));
//         includeAdapters(address(l), 1);


//         address[] memory addr = new address[](3);
//         uint256[] memory amt = new uint256[](3);
//         addr[0] = dai; amt[0] = 70 * WAD;
//         addr[1] = usdc; amt[1] = 100 * (10**6);
//         addr[2] = usdt; amt[2] = 130 * (10**6);

//         l.selectiveDeposit(addr, amt, 0, now + 500);

//     }

//     function testUnbalancedSelectiveWithdraw10x5y0z () public {
//         uint256[] memory amounts = new uint256[](2);
//         address[] memory tokens = new address[](2);

//         tokens[0] = dai; amounts[0] = 10 * WAD;
//         tokens[1] = usdc; amounts[1] = 5 * (10**6);

//         uint256 shellsBurned = l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);
//         shellsBurned /= 10000000000;
//         assertEq(shellsBurned, 1512471981);
//     }

//     function testUnbalancedSelectiveWithdraw0x10y10z () public {
//         uint256[] memory amounts = new uint256[](2);
//         address[] memory tokens = new address[](2);

//         tokens[0] = usdc; amounts[0] = 10 * 1000000;
//         tokens[1] = usdt; amounts[1] = 1000000 * 10;

//         uint256 shellsBurned = l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);
//         shellsBurned /= 10000000000;
//         assertEq(shellsBurned, 2000833256);
//     }

//     function testUnbalancedSelectiveWithdraw10x0y5z () public {

//         uint256 shellsBefore = l.totalSupply();
//         (uint256 reserveBefore, uint256[] memory coinsBefore) = l.totalReserves();

//         uint256[] memory amounts = new uint256[](2);
//         address[] memory tokens = new address[](2);

//         tokens[0] = dai; amounts[0] = WAD * 10;
//         tokens[1] = usdt; amounts[1] = 1000000 * 5;

//         uint256 shellsBurned = l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);
//         shellsBurned /= 10000000000;
//         assertEq(shellsBurned, 1512471981);

//         uint256 shellsAfter = l.totalSupply();
//         (uint256 reserveAfter, uint256[] memory coinsAfter) = l.totalReserves();

//         emit log_named_uint("shellsBefore", shellsBefore);
//         emit log_named_uint("reserve beofre", reserveBefore);
//         emit log_uints("coins before", coinsBefore);

//         emit log_named_uint("shellsAfter", shellsAfter);
//         emit log_named_uint("reserve after", reserveAfter);
//         emit log_uints("coins after", coinsAfter);

//     }

//     event log_uints(bytes32, uint256[]);

//     function testFailUnbalancedSelectiveWithdraw65x0y0z () public {
//         uint256[] memory amounts = new uint256[](1);
//         address[] memory tokens = new address[](1);

//         tokens[0] = dai; amounts[0] = 65*WAD;

//         l.selectiveWithdraw(tokens, amounts, WAD * 500, now + 500);
//     }

// }