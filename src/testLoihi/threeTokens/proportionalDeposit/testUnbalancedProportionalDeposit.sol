// pragma solidity ^0.5.15;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../../loihiSetup.sol";
// import "../../../interfaces/IAdapter.sol";

// contract LoihiTest is LoihiSetup, DSMath, DSTest {

//     function setUp() public {

//         setupFlavors();
//         setupAdapters();
//         setupLoihi();
//         approveFlavors(address(l));
//         executeLoihiApprovals(address(l));
//         includeAdapters(address(l), 1);

//         uint256[] memory amounts = new uint256[](3);
//         address[] memory coins = new address[](3);

//         coins[0] = dai; amounts[0] = 70 * WAD;
//         coins[1] = usdc; amounts[1] = 100 * (10**6);
//         coins[2] = usdt; amounts[2] = 130 * (10**6);

//         l.selectiveDeposit(coins, amounts, 0, now + 5000);

//     }

//     function testUnbalancedProportionalDepositPoint75x () public {

//         uint256 mintedShells = l.proportionalDeposit(224981250000000000000);
//         assertEq(mintedShells, 224962502312505938396);

//     }

//     function testUnbalancedProportionalDeposit3x () public {

//         uint256 mintedShells = l.proportionalDeposit(450*WAD);
//         assertEq(mintedShells, 449962501499936703356);

//     }

// }