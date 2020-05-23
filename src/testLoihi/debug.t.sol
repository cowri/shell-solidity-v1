
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
        // uint256 wad = 1e18;

        // uint256 whole = 18446744073709551999;
        // whole /= 2;
        // emit log_named_uint("whole", whole);
        // whole /= 2;
        // emit log_named_uint("whole", whole);
        // whole += (whole/2);
        // emit log_named_uint("whole", whole);
        // whole += (whole/4);
        // emit log_named_uint("whole", whole);
        // whole += (whole/8);
        // emit log_named_uint("whole", whole);
        // int128 whole64 = whole.fromUInt();

        int128 max64 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        emit log_named_uint("max64", max64.toUInt());

        // uint256 pad = 1e6;
        int128 pad64 = 18446744073709551616000000;
        uint256 usdc = 548112585854;

        emit log_named_uint("whole usdc", usdc);
        emit log_named_int("pad64", pad64);

        uint256 gas = gasleft();

        int128 usdc64 = usdc.fromUInt();
        
        emit log_named_uint("from uint", gas - gasleft());
        gas = gasleft();

        usdc64 = usdc64.div(pad64);

        emit log_named_uint("apply decimals", gas - gasleft());
        gas = gasleft();

        usdc64 = usdc64.mul(pad64);

        emit log_named_uint("remove decimals", gas - gasleft());
        gas = gasleft();

        usdc = usdc64.toUInt();

        emit log_named_uint("to uint", gas - gasleft());
        gas = gasleft();

        usdc64.unsafe_div(pad64);

        emit log_named_uint("unsafe 64x64 div", gas - gasleft());
        gas = gasleft();

        usdc64.unsafe_mul(pad64);

        emit log_named_uint("unsafe 64x64 mul", gas - gasleft());

        emit log_named_uint("whole usdc", usdc);

        uint256 dai = 494338447553444333191;
        uint256 half = 1e18/2;
        emit log_named_uint("dai", dai/1e18);

        gas = gasleft();

        dai = wmul(dai, half);

        emit log_named_uint("uint safe fixed mul", gas - gasleft());

        gas = gasleft();

        dai = fmul(dai, half);

        emit log_named_uint("uint unsafe fixed mul", gas - gasleft());

        gas = gasleft();

        dai = fdiv(dai, half);

        emit log_named_uint("uint unsafe fixed div", gas - gasleft());

        gas = gasleft();


        uint256 octopus = 1e6;

        int128 octopus64 = octopus.fromUInt();
        int128 octopus6464 = 18446744073709551616000000;
        emit log_named_int("octopus 64", octopus64);
        emit log_named_int("octopus 6464", octopus6464);

        uint256 zero = 0;
        int128 zero64 = zero.fromUInt();
        
        // uint256 half = 4611686018427388000;
        // int128 half64 = half.fromUInt();

        // int128 whole64 = half64.add(half64);

    }

    function fmul(uint x, uint y) internal pure returns (uint z) {
        z = ((x * y) + .5e18) / 1e18;
    }

    function fdiv(uint x, uint y) internal pure returns (uint z) {
        z = ((x * 1e18) + (y / 2)) / y;
    }


}