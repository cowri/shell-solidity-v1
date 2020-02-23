// pragma solidity ^0.5.6;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../loihiSetup.sol";
// import "../../IAdapter.sol";

// contract LoihiTest is LoihiSetup, DSMath, DSTest {

//     function setUp() public {

//         setupFlavors();
//         setupAdapters();
//         setupLoihi();
//         approveFlavors(address(l));
        // executeLoihiApprovals(address(l));
//         includeAdapters(address(l), 1);

//         uint256 mintedShells = l.proportionalDeposit(100 * (10 ** 18));

//         uint256 cusdcBal = IERC20(cusdc).balanceOf(address(l)); // 165557372275ish
//         uint256 cdaiBal = IERC20(cdai).balanceOf(address(l)); // 163925889326ish
//         uint256 usdtBal = IERC20(usdt).balanceOf(address(l)); // 33333333333333333300

//         uint256 bal = l.balanceOf(address(this));

//         uint256[] memory amounts = new uint256[](2);
//         address[] memory coins = new address[](2);

//         coins[0] = dai;
//         amounts[0] = 25 * WAD;
//         coins[1] = usdc;
//         amounts[1] = 35 * (10**6);
//         mintedShells = l.selectiveDeposit(coins, amounts, 0, now + 5000);
//         emit log_named_uint("mintedShells", mintedShells);

//         l.swapByTarget(dai, usdc, 500*WAD, 10*(10**6), now + 50);
//         l.swapByOrigin(dai, usdc, 10*WAD, 0, now + 50);

//     }

//     function testUnbalancedProportionalDeposit100 () public {

//         uint256 mintedShells = l.proportionalDeposit(100 * (10 ** 18));
//         assertEq(mintedShells, 99850727479911345111);

//     }

// }