
pragma solidity ^0.5.0;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../loihiSetup.sol";
import "../../interfaces/IAdapter.sol";
import "abdk-libraries-solidity/ABDKMath64x64.sol";

library SignedSafeMath {
    int256 constant private _INT256_MIN = -2**255;

    /**
     * @dev Multiplies two signed integers, reverts on overflow.
     */
    function mul(int256 a, int256 b) internal pure returns (int256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");

        int256 c = a * b;
        require(c / a == b, "SignedSafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
     */
    function div(int256 a, int256 b) internal pure returns (int256) {
        require(b != 0, "SignedSafeMath: division by zero");
        require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");

        int256 c = a / b;

        return c;
    }

    /**
     * @dev Subtracts two signed integers, reverts on overflow.
     */
    function sub(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a - b;
        require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");

        return c;
    }

    /**
     * @dev Adds two signed integers, reverts on overflow.
     */
    function add(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a + b;
        require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");

        return c;
    }
}

/// @dev Implements simple fixed point math add, sub, mul and div operations.
/// @author Alberto Cuesta Cañada
library DecimalMath {
    using SafeMath for uint256;
    using SignedSafeMath for int256;

    /// @dev Returns 1 in the fixed point representation, with `decimals` decimals.
    function unit(uint8 decimals) internal pure returns (uint256) {
        require(decimals <= 77, "Too many decimals");
        return 10**uint256(decimals);
    }

    /// @dev Adds x and y, assuming they are both fixed point with 18 decimals.
    function addd(uint256 x, uint256 y) internal pure returns (uint256) {
        return x.add(y);
    }

    /// @dev Adds x and y, assuming they are both fixed point with 18 decimals.
    function addd(int256 x, int256 y) internal pure returns (int256) {
        return x.add(y);
    }

    /// @dev Substracts y from x, assuming they are both fixed point with 18 decimals.
    function subd(uint256 x, uint256 y) internal pure returns (uint256) {
        return x.sub(y);
    }

    /// @dev Substracts y from x, assuming they are both fixed point with 18 decimals.
    function subd(int256 x, int256 y) internal pure returns (int256) {
        return x.sub(y);
    }

    /// @dev Multiplies x and y, assuming they are both fixed point with 18 digits.
    function muld(uint256 x, uint256 y) internal pure returns (uint256) {
        return muld(x, y, 18);
    }

    /// @dev Multiplies x and y, assuming they are both fixed point with 18 digits.
    function muld(int256 x, int256 y) internal pure returns (int256) {
        return muld(x, y, 18);
    }

    /// @dev Multiplies x and y, assuming they are both fixed point with `decimals` digits.
    function muld(uint256 x, uint256 y, uint8 decimals)
        internal pure returns (uint256)
    {
        return x.mul(y).div(unit(decimals));
    }

    /// @dev Multiplies x and y, assuming they are both fixed point with `decimals` digits.
    function muld(int256 x, int256 y, uint8 decimals)
        internal pure returns (int256)
    {
        return x.mul(y).div(int256(unit(decimals)));
    }

    /// @dev Divides x between y, assuming they are both fixed point with 18 digits.
    function divd(uint256 x, uint256 y) internal pure returns (uint256) {
        return divd(x, y, 18);
    }

    /// @dev Divides x between y, assuming they are both fixed point with 18 digits.
    function divd(int256 x, int256 y) internal pure returns (int256) {
        return divd(x, y, 18);
    }

    /// @dev Divides x between y, assuming they are both fixed point with `decimals` digits.
    function divd(uint256 x, uint256 y, uint8 decimals)
        internal pure returns (uint256)
    {
        return x.mul(unit(decimals)).div(y);
    }

    /// @dev Divides x between y, assuming they are both fixed point with `decimals` digits.
    function divd(int256 x, int256 y, uint8 decimals)
        internal pure returns (int256)
    {
        return x.mul(int(unit(decimals))).div(y);
    }
}





contract DebugTest is LoihiSetup, DSMath, DSTest {

    using ABDKMath64x64 for uint256;
    using ABDKMath64x64 for int128;

    using DecimalMath for uint256;
    using DecimalMath for int256;

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

    function testMath () public logs_gas {
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

        dai = dai.divd(half);
        
        emit log_named_uint("uint DecimalMath div", gas - gasleft());

        gas = gasleft();

        dai = dai.muld(half);

        emit log_named_uint("uint DecimalMath mul", gas - gasleft());
        
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