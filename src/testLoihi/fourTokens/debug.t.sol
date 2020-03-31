
// pragma solidity ^0.5.6;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../loihiSetup.sol";
// import "../../interfaces/IAdapter.sol";

// contract TargetSwapTest is LoihiSetup, DSMath, DSTest {

//     function setUp() public {

//         // setupLoihi();
//         // setupFlavors();
//         setupAdapters();
//         // approveFlavors();
//         // executeApprovals();
//         // includeAdapters(3);

//     }

//     function withdraw (address waddr, uint256 wamount, address xaddr, uint256 xamount, address yaddr, uint256 yamount, address zaddr, uint256 zamount) public returns (uint256) {
//         address[] memory addrs = new address[](4);
//         uint256[] memory amounts = new uint256[](4);

//         addrs[0] = waddr; amounts[0] = wamount;
//         addrs[1] = xaddr; amounts[1] = xamount;
//         addrs[2] = yaddr; amounts[2] = yamount;
//         addrs[3] = zaddr; amounts[3] = zamount;

//         return l1.selectiveWithdraw(addrs, amounts, 50000*WAD, now + 500);
//     }

//     function deposit (address waddr, uint256 wamount, address xaddr, uint256 xamount, address yaddr, uint256 yamount, address zaddr, uint256 zamount) public returns (uint256) {
//         address[] memory addrs = new address[](4);
//         uint256[] memory amounts = new uint256[](4);

//         addrs[0] = waddr; amounts[0] = wamount;
//         addrs[1] = xaddr; amounts[1] = xamount;
//         addrs[2] = yaddr; amounts[2] = yamount;
//         addrs[3] = zaddr; amounts[3] = zamount;

//         return l1.selectiveDeposit(addrs, amounts, 0, now + 500);
//     }


//     function delegateTo(address callee, bytes memory data) internal returns (bytes memory) {
//         (bool success, bytes memory returnData) = callee.delegatecall(data);
//         assembly {
//             if eq(success, 0) {
//                 revert(add(returnData, 0x20), returndatasize)
//             }
//         }
//         return returnData;
//     }

//     function staticTo(address callee, bytes memory data) internal view returns (bytes memory) {
//         (bool success, bytes memory returnData) = callee.staticcall(data);
//         assembly {
//             if eq(success, 0) {
//                 revert(add(returnData, 0x20), returndatasize)
//             }
//         }
//         return returnData;
//     }


//     function testDebug () public {
//         uint256 gas1 = gasleft();
//         emit log_named_address("daiadapter", daiAdapter);
//         bytes memory result = staticTo(daiAdapter, abi.encodeWithSignature("viewNumeraireBalance(address)", address(this)));
//         uint256 daiBalView = abi.decode(result, (uint256));
//         uint256 gas2 = gasleft();
//         result = delegateTo(daiAdapter, abi.encodeWithSignature("getNumeraireBalance()"));
//         uint256 daiBalGet = abi.decode(result, (uint256));
//         uint256 gas3 = gasleft();
//         result = staticTo(chaiAdapter, abi.encodeWithSignature("viewNumeraireBalance(address)", address(this)));
//         uint256 chaiBalView = abi.decode(result, (uint256));
//         uint256 gas4 = gasleft();
//         result = delegateTo(chaiAdapter, abi.encodeWithSignature("getNumeraireBalance()"));
//         uint256 chaiBalGet = abi.decode(result, (uint256));
//         uint256 gas5 = gasleft();
//         emit log_named_uint("gas view dai", gas1 - gas2);
//         emit log_named_uint("dai bal view", daiBalView);
//         emit log_named_uint("gas get dai", gas2 - gas3);
//         emit log_named_uint("dai bal get", daiBalGet);
//         emit log_named_uint("gas view chai", gas3 - gas4);
//         emit log_named_uint("chai bal view", chaiBalView);
//         emit log_named_uint("gas get chai", gas4 - gas5);
//         emit log_named_uint("chai bal get", chaiBalGet);

//     }
// }