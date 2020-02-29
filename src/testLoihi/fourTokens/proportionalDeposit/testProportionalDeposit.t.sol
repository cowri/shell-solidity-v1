// pragma solidity ^0.5.15;


// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../../loihiSetup.sol";
// import "../../flavorsSetup.sol";
// import "../../../interfaces/IAdapter.sol";

// contract LoihiTest is LoihiSetup, DSMath, DSTest {

//     function setUp() public {

//         setupFlavors();
//         setupAdapters();
//         setupLoihi();
//         approveFlavors(address(l));
//         executeLoihiApprovals(address(l));
//         includeAdapters(address(l), 0);

//     }

//     function setReserveState (address waddr, uint256 wamount, address xaddr, uint256 xamount, address yaddr, uint256 yamount, address zaddr, uint256 zamount) public returns (uint256) {
//         address[] memory addrs = new address[](4);
//         uint256[] memory amounts = new uint256[](4);

//         addrs[0] = waddr; amounts[0] = wamount;
//         addrs[1] = xaddr; amounts[1] = xamount;
//         addrs[2] = yaddr; amounts[2] = yamount;
//         addrs[3] = zaddr; amounts[3] = zamount;

//         return l.selectiveDeposit(addrs, amounts, 0, now + 500);
//     }

//     function testNoFeeUnbalancedProportionalDeposit () public {

//         uint256 initialShells = setReserveState(dai, 100*WAD, usdc, 80*(10**6), usdt, 90*(10**6), susd, 21*WAD);

//         emit log_named_uint("initialShells", initialShells);

//         uint256 mintedShells = l.proportionalDeposit(55*WAD);

//         assertEq(mintedShells, 55*WAD);

//     }

//     function testFullFeeUnbalancedProportionalDeposit () public {
//         uint256 initialShells = setReserveState(dai, 130*WAD, usdc, 59*(10**6), usdt, 71*(10**6), susd, 40*WAD);
//         uint256 mintedShells = l.proportionalDeposit(38*WAD);
//         assertEq(mintedShells / (10**12), 37954259);
//     }

// }