// pragma solidity ^0.5.6;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../../loihiSetup.sol";
// import "../../../interfaces/IAdapter.sol";

// contract SelectiveDepositTest is LoihiSetup, DSMath, DSTest {

//     function setUp() public {

//         setupFlavors();
//         setupAdapters();
//         setupLoihi();
//         approveFlavors(address(l));
//         executeLoihiApprovals(address(l));
//         includeAdapters(address(l), 0);

//         uint256 shells = l.proportionalDeposit(300 * (10 ** 18));

//     }

//     function setReserveState (address waddr, uint256 wamount, address xaddr, uint256 xamount, address yaddr, uint256 yamount, address zaddr, uint256 zamount) public {
//         address[] memory addrs = new address[](4);
//         uint256[] memory amounts = new uint256[](4);

//         addrs[0] = waddr; amounts[0] = wamount;
//         addrs[1] = xaddr; amounts[1] = xamount;
//         addrs[2] = yaddr; amounts[2] = yamount;
//         addrs[3] = zaddr; amounts[3] = zamount;

//         l.selectiveDeposit(addrs, amounts, 0, now + 500);
//     }

//     function testNoFeeOriginSwap5SusdDai () public {
//         setReserveState(dai, 90*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 30*WAD);

//         uint256 targetAmount = l.swapByOrigin(susd, dai, 5*WAD, 0, now + 500);
//         assertEq(targetAmount, 4997500000000000000);
//     }

//     function testNoFeeOriginSwap3UsdcSusd () public {
//         setReserveState(dai, 80*WAD, usdc, 100*(10**6), usdt, 90*(10**6), susd, 30*WAD);

//         uint256 targetAmount = l.swapByOrigin(usdc, susd, 3*(10**6), 0, now + 500);
//         assertEq(targetAmount, 2998500000000000000);
//     }

//     function testFeeCrossOriginSwap10SusdUsdc () public {
//         setReserveState(dai, 100*WAD, usdc, 70*(10**6), usdt, 100*(10**6), susd, 30*WAD);

//         uint256 targetAmount = l.swapByOrigin(susd, usdc, 10*WAD, 0, now + 500);
//         assertEq(targetAmount, 9912054);
//     }

//     function testFeeCrossOriginSwap14DaiSusd () public {
//         setReserveState(dai, 100*WAD, usdc, 80*(10**6), usdt, 89*(10**6), susd, 31*WAD);

//         uint256 targetAmount = l.swapByOrigin(dai, susd, 14*WAD, 0, now + 500);
//         assertEq(targetAmount, 13993000000000000000);
//     }

//     function testTotalFeeOriginSwap1Point75SusdUsdc () public {
//         setReserveState(dai, 95*WAD, usdc, 100*(10**6), usdt, 65*(10**6), susd, 40*WAD);

//         uint256 targetAmount = l.swapByOrigin(susd, usdt, 1750000000000000000, 0, now + 500);
//         assertEq(targetAmount, 1716250);
//     }

//     function testTotalFeeOriginSwap4Point32UsdcSusd () public {
//         setReserveState(dai, 73*WAD, usdc, 115*(10**6), usdt, 90*(10**6), susd, 22*WAD);

//         uint256 targetAmount = l.swapByOrigin(usdc, susd, 4320000, 0, now + 500);
//         assertEq(targetAmount, 4.7085156);
//     }

//     function testUppertHalt10OriginSwap12Point05SusdDai () public {
//         setReserveState(dai, 81*WAD, usdc, 99*(10**6), usdt, 87*(10**6), susd, 33*WAD);

//         (bool success, ) = address(l).call(
//             abi.encodeWithSelector(l.swapByOrigin.selector, susd, dai, 12050000000000000000, 0, now + 500)
//         );
//         assertTrue(!success);
//     }

//     function testUpperHalt30OriginSwap13Point75UsdcUsdt () public {
//         setReserveState(dai, 81*WAD, usdc, 99*(10**6), usdt, 87*(10**6), susd, 33*WAD);

//         (bool success, bytes memory result) = address(l).call(
//             abi.encodeWithSelector(l.swapByOrigin.selector, usdc, usdt, 13750000000000000000, 0, now + 500)
//         );
//         assertTrue(!success);
//     }

//     function testLowerHalt10OriginSwap7Point01UsdtSusd () public {
//         setReserveState(dai, 87*WAD, usdc, 101*(10**6), usdt, 90*(10**6), susd, 22*WAD);

//         (bool success, bytes memory result) = address(l).call(
//             abi.encodeWithSelector(l.swapByOrigin.selector, usdt, susd, 7010000, 0, now + 500)
//         );
//         assertTrue(!success);

//     }

//     function testLowerHalt30OriginSwap42Point52UsdtDai () public {
//         setReserveState(dai, 87*WAD, usdc, 101*(10**6), usdt, 90*(10**6), susd, 22*WAD);

//         (bool success, ) = address(l).call(
//             abi.encodeWithSelector(l.swapByOrigin.selector, usdt, dai, 42520000, 0, now + 500)
//         );
//         assertTrue(!success);
//     }

// }