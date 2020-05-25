
pragma solidity ^0.5.0;

import "ds-test/test.sol";
import "ds-math/math.sol";
// import "../loihiSetup.sol";
import "../interfaces/IAdapter.sol";
import "abdk-libraries-solidity/ABDKMath64x64.sol";

// contract DebugTest is LoihiSetup, DSMath, DSTest {
contract DebugTest is DSMath, DSTest {

    using ABDKMath64x64 for uint256;
    using ABDKMath64x64 for int128;

    function setUp() public {

        // setupLoihi();
        // setupFlavors();
        // setupAdapters();
        // approveFlavors();
        // executeApprovals();
        // includeAdapters(0);

    }

    // function withdraw (address waddr, uint256 wamount, address xaddr, uint256 xamount, address yaddr, uint256 yamount, address zaddr, uint256 zamount) public returns (uint256) {
    //     address[] memory addrs = new address[](4);
    //     uint256[] memory amounts = new uint256[](4);

    //     addrs[0] = waddr; amounts[0] = wamount;
    //     addrs[1] = xaddr; amounts[1] = xamount;
    //     addrs[2] = yaddr; amounts[2] = yamount;
    //     addrs[3] = zaddr; amounts[3] = zamount;

    //     return l1.selectiveWithdraw(addrs, amounts, 50000*WAD, now + 500);
    // }

    // function deposit (address waddr, uint256 wamount, address xaddr, uint256 xamount, address yaddr, uint256 yamount, address zaddr, uint256 zamount) public returns (uint256) {
    //     address[] memory addrs = new address[](4);
    //     uint256[] memory amounts = new uint256[](4);

    //     addrs[0] = waddr; amounts[0] = wamount;
    //     addrs[1] = xaddr; amounts[1] = xamount;
    //     addrs[2] = yaddr; amounts[2] = yamount;
    //     addrs[3] = zaddr; amounts[3] = zamount;

    //     return l1.selectiveDeposit(addrs, amounts, 0, now + 500);
    // }


    // function delegateTo(address callee, bytes memory data) internal returns (bytes memory) {
    //     (bool success, bytes memory returnData) = callee.delegatecall(data);
    //     assembly {
    //         if eq(success, 0) {
    //             revert(add(returnData, 0x20), returndatasize)
    //         }
    //     }
    //     return returnData;
    // }

    // function staticTo(address callee, bytes memory data) internal view returns (bytes memory) {
    //     (bool success, bytes memory returnData) = callee.staticcall(data);
    //     assembly {
    //         if eq(success, 0) {
    //             revert(add(returnData, 0x20), returndatasize)
    //         }
    //     }
    //     return returnData;
    // }


    // function testDebug () public {

    //     uint256 a = uint256(-1);

    //     emit log_named_uint("a", a);

    //     emit log_named_uint("overflow", a + 50000000);

    // }

    function testMath () public {

        uint256 a = 654323456543456;

        int128 a64 = a.fromUInt();

        a = a64.toUInt();

        emit log_named_uint("aU64", a);


    }

    function fmul(uint x, uint y) internal pure returns (uint z) {
        z = ((x * y) + .5e18) / 1e18;
    }

    function fdiv(uint x, uint y) internal pure returns (uint z) {
        z = ((x * 1e18) + (y / 2)) / y;
    }


}