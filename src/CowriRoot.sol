pragma solidity ^0.5.0;

import "openzeppelin-contracts/contracts/ownership/Ownable.sol";
import "ds-math/math.sol";
import "./CowriShell.sol";
import "./ERC20Token.sol";

contract CowriRoot is DSMath, Ownable {

    uint256 internal constant BASIS = 10000;
    uint256 public liquidityFee = 20;
    uint256 public protocolFee = 1;
    uint256 public shellActivationThreshold;
    address[] public supportedTokens;
    address[] public shellList;
    address public shellFactory;
    mapping(address => bool) public shells;
    mapping(address => uint256) public omnibusIndexes;
    mapping(address => uint256) public revenue;
    mapping(uint256 => uint256) public shellBalances;
    mapping(address => uint256) public shellInvariants;
    mapping(uint256 => address[]) public pairsToAllShells;
    mapping(uint256 => address[]) public pairsToActiveShells;
    bytes16 private constant POSITIVE_ZERO = 0x00000000000000000000000000000000;
    bytes16 private constant NEGATIVE_ZERO = 0x80000000000000000000000000000000;
    bytes16 private constant POSITIVE_INFINITY = 0x7FFF0000000000000000000000000000;
    bytes16 private constant NEGATIVE_INFINITY = 0xFFFF0000000000000000000000000000;
    bytes16 private constant NaN = 0x7FFF8000000000000000000000000000;

    function makeKey(address a, address b) internal pure returns (uint256) {
        return add(uint256(a), uint256(b));
    }

    function adjustedTransferFrom (ERC20Token token, address source, uint256 amount) internal returns (uint256) {

        uint256 decimals = token.decimals();
        uint256 adjustedAmount = decimals <= 18
            ? amount / pow(10, 18 - decimals)
            : mul(amount, pow(10, decimals - 18));

        token.transferFrom(
            source,
            address(this),
            adjustedAmount
        );

        return adjustedAmount;

    }

    function adjustedTransfer (ERC20Token token, address recipient, uint256 amount) internal returns (uint256) {

        uint256 decimals = token.decimals();
        uint256 adjustedAmount = decimals <= 18
            ? amount / pow(10, 18 - decimals)
            : mul(amount, pow(10, decimals - 18));

        token.transfer(
            recipient,
            adjustedAmount
        );

        return adjustedAmount;

    }

    function getTotalCapital(address shell) public view returns (uint totalCapital) {
        address[] memory tokens = CowriShell(shell).getTokens();
        for (uint i = 0; i < tokens.length; i++) {
            totalCapital = add(
                totalCapital,
                shellBalances[makeKey(shell, tokens[i])]
            );
         }
        return totalCapital;
    }

    function wpow(uint x, uint n) internal pure returns (uint z) {
        z = n % 2 != 0 ? x : WAD;

        for (n /= 2; n != 0; n /= 2) {
            x = wmul(x, x);

            if (n % 2 != 0) {
                z = wmul(z, x);
            }
        }
    }

    function pow(uint x, uint n) internal pure returns (uint z) {
        z = n % 2 != 0 ? x : 1;

        for (n /= 2; n != 0; n /= 2) {
            x = mul(x, x);

            if (n % 2 != 0) {
                z = mul(z, x);
            }
        }
    }

    function refineRoot (uint256 guess, uint256 base, uint256 root, uint256 max_iterations) public returns (uint256) {

        for (uint32 i = 0; i < max_iterations; i++) {

            uint256 divisor_rhs = wpow(guess, root - 1);
            uint256 exponentiated_guess = wmul(guess, divisor_rhs);

            if (exponentiated_guess == base) return guess;

            if (exponentiated_guess < base) {

                uint256 dividend = sub(base, exponentiated_guess);
                uint256 divisor = wmul(root, divisor_rhs);
                uint256 quotient = wdiv(dividend, divisor) / WAD;
                if (quotient == 0) return guess;
                guess = add(guess, quotient);

            } else {

                uint256 dividend = sub(exponentiated_guess, base);
                uint256 divisor = wmul(root, divisor_rhs);
                uint256 quotient = wdiv(dividend, divisor) / WAD;
                if (quotient == 0) return guess;
                guess = sub(guess, quotient);

            }
        }

        return guess;

    }

    function fastAprxRoot (uint256 base, uint256 root) internal  returns (uint256) {

        uint128 root_constant;
        if (root == 2) root_constant = 0x1FFF7A3BEA91D9B1B79D909F1F14983D;
        else if (root == 3) root_constant = 0x2AA9F84FE36D22424A276B7ED41B75A7;
        else if (root == 4) root_constant = 0x2FFF3759DFDAC68A936C58EEAE9EE45C;
        else if (root == 5) root_constant = 0x33325D2CAA82F5E925C8E764FE8759FB;
        else if (root == 6) root_constant = 0x35547663DC486AD2DCB1465E89225311;
        else if (root == 7) root_constant = 0x36DA8866B6B0E2E783E98A3559DA298D;
        else if (root == 8) root_constant = 0x33325D2CAA82F5E925C8E764FE8759FB;
        else if (root == 9) root_constant = 0x38E2A06A849183030D89E4A91ACF4789;
        else if (root == 10) root_constant = 0x3998A8D23FD354A64A8204519E58453B;
        else if (root == 11) root_constant = 0x3A2D986CF04F002BD97B9295ACDFA06F;
        else if (root == 12) root_constant = 0x3AA9B56DD8B60F1B25F633CE63A5C1C6;
        else if (root == 13) root_constant = 0x3B12BA473AE5E0AA8E0F3260D6EAF1AC;
        else if (root == 14) root_constant = 0x3B6CBE6F45EA4B25799255B9CC01AD04;
        else if (root == 15) root_constant = 0x3BBAC2097198C990016A634B28F33E50;

        // raise magnitude by 10^18
        return toUInt(float_mul(
            bytes16(root_constant + (uint128(fromUInt(base)) / uint128(root))),
            bytes16(0x403abc16d674ec800000000000000000)
        ));

    }

    /**
    * Convert unsigned 256-bit integer number into quadruple precision number.
    *
    * @param x unsigned 256-bit integer number
    * @return quadruple precision number
    */
    function fromUInt (uint256 x) internal pure returns (bytes16) {
        if (x == 0) return bytes16 (0);
        else {
        uint256 result = x;

        uint256 msb = msb (result);
        if (msb < 112) result <<= 112 - msb;
        else if (msb > 112) result >>= msb - 112;

        result = result & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF | 16383 + msb << 112;

        return bytes16 (uint128 (result));
        }
    }

    /**
    * Convert quadruple precision number into unsigned 256-bit integer number
    * rounding towards zero.  Revert on underflow.  Note, that negative floating
    * point numbers in range (-1.0 .. 0.0) may be converted to unsigned integer
    * without error, because they are rounded to zero.
    *
    * @param x quadruple precision number
    * @return unsigned 256-bit integer number
    */
    function toUInt (bytes16 x) internal pure returns (uint256) {
        uint256 exponent = uint128 (x) >> 112 & 0x7FFF;

        if (exponent < 16383) return 0; // Underflow

        require (uint128 (x) < 0x80000000000000000000000000000000); // Negative

        require (exponent <= 16638); // Overflow
        uint256 result = uint256 (uint128 (x)) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF |
        0x10000000000000000000000000000;

        if (exponent < 16495) result >>= 16495 - exponent;
        else if (exponent > 16495) result <<= exponent - 16495;

        return result;
    }

    /**
    * Calculate x * y.  Special values behave in the following way:
    *
    * NaN * x = NaN for any x.
    * Infinity * x = Infinity for any finite positive x.
    * Infinity * x = -Infinity for any finite negative x.
    * -Infinity * x = -Infinity for any finite positive x.
    * -Infinity * x = Infinity for any finite negative x.
    * Infinity * 0 = NaN.
    * -Infinity * 0 = NaN.
    * Infinity * Infinity = Infinity.
    * Infinity * -Infinity = -Infinity.
    * -Infinity * Infinity = -Infinity.
    * -Infinity * -Infinity = Infinity.
    *
    * @param x quadruple precision number
    * @param y quadruple precision number
    * @return quadruple precision number
    */
    function float_mul (bytes16 x, bytes16 y) internal pure returns (bytes16) {
        uint256 xExponent = uint128 (x) >> 112 & 0x7FFF;
        uint256 yExponent = uint128 (y) >> 112 & 0x7FFF;

        if (xExponent == 0x7FFF) {
            if (yExponent == 0x7FFF) {
                if (x == y) return x ^ y & 0x80000000000000000000000000000000;
                else if (x ^ y == 0x80000000000000000000000000000000) return x | y;
                else return NaN;
            } else {
                if (y & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF == 0) return NaN;
                else return x ^ y & 0x80000000000000000000000000000000;
            }
        } else if (yExponent == 0x7FFF) {
            if (x & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF == 0) return NaN;
            else return y ^ x & 0x80000000000000000000000000000000;
        } else {
            uint256 xSignifier = uint128 (x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            if (xExponent == 0) xExponent = 1;
            else xSignifier |= 0x10000000000000000000000000000;

            uint256 ySignifier = uint128 (y) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            if (yExponent == 0) yExponent = 1;
            else ySignifier |= 0x10000000000000000000000000000;

            xSignifier *= ySignifier;
            if (xSignifier == 0)
                return (x ^ y) & 0x80000000000000000000000000000000 > 0 ?
                    NEGATIVE_ZERO : POSITIVE_ZERO;

            xExponent += yExponent;

            uint256 msb =
                xSignifier >= 0x200000000000000000000000000000000000000000000000000000000 ? 225 :
                xSignifier >= 0x100000000000000000000000000000000000000000000000000000000 ? 224 :
                msb (xSignifier);

            if (xExponent + msb < 16496) { // Underflow
                xExponent = 0;
                xSignifier = 0;
            } else if (xExponent + msb < 16608) { // Subnormal
                if (xExponent < 16496)
                    xSignifier >>= 16496 - xExponent;
                else if (xExponent > 16496)
                    xSignifier <<= xExponent - 16496;
                xExponent = 0;
            } else if (xExponent + msb > 49373) {
                xExponent = 0x7FFF;
                xSignifier = 0;
            } else {
                if (msb > 112)
                    xSignifier >>= msb - 112;
                else if (msb < 112)
                    xSignifier <<= 112 - msb;

                xSignifier &= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

                xExponent = xExponent + msb - 16607;
            }

            return bytes16 (uint128 (uint128 ((x ^ y) & 0x80000000000000000000000000000000) |
                xExponent << 112 | xSignifier));
        }
    }

    /**
    * Get index of the most significant non-zero bit in binary representation of
    * x.  Reverts if x is zero.
    *
    * @return index of the most significant non-zero bit in binary representation
    *         of x
    */
    function msb (uint256 x) private pure returns (uint256) {
        require (x > 0);

        uint256 result = 0;

        if (x >= 0x100000000000000000000000000000000) { x >>= 128; result += 128; }
        if (x >= 0x10000000000000000) { x >>= 64; result += 64; }
        if (x >= 0x100000000) { x >>= 32; result += 32; }
        if (x >= 0x10000) { x >>= 16; result += 16; }
        if (x >= 0x100) { x >>= 8; result += 8; }
        if (x >= 0x10) { x >>= 4; result += 4; }
        if (x >= 0x4) { x >>= 2; result += 2; }
        if (x >= 0x2) result += 1; // No need to shift x anymore

        return result;
    }

}