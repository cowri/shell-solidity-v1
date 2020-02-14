// pragma solidity ^0.5.6;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../loihiSetup.sol";


// contract UnbalancedSwapByTargetTest is LoihiSetup, DSMath, DSTest {

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
//         uint256 burned = l.selectiveWithdraw(addr, amt, 50 * WAD, now + 500);

//         addr[0] = usdt;
//         amt[0] = 30 * (10**6);
//         uint256 deposited = l.selectiveDeposit(addr, amt, 0, now + 500);

//     }

//     function testUnbalancedTargetSwap10yToZ () public {
//         uint256 originAmount = l.swapByTarget(usdt, usdc, 20 * (10 ** 6), 10 * 1000000, now);
//         assertEq(originAmount, 10155125);
//     }

//     function testUnbalancedTargetSwap10zToY () public {
//         uint256 targetAmount = l.swapByTarget(usdc, usdt, 30 * (10**6), 10 * (10**6), now);
//         assertEq(targetAmount, 10005000);
//     }

//     function testUnbalancedTargetSwap10xToZ () public {
//         uint256 targetAmount = l.swapByTarget(usdt, dai, 20 * (10**6), 10 * WAD, now);
//         assertEq(targetAmount, 10308975);
//     }

//     function testUnbalancedTargetSwap10zToX () public {
//         uint256 targetAmount = l.swapByTarget(dai, usdt, 20 * WAD, 10 * (10**6), now);
//         assertEq(targetAmount, 10005000000000000000);
//     }

//     function testFailUnbalancedSwap51Target () public {
//         uint256 targetAmount = l.swapByTarget(dai, usdc, 9 * WAD, 51 * 1000000, now);
//     }

// }