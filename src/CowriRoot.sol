pragma solidity ^0.5.0;

import "openzeppelin-contracts/contracts/ownership/Ownable.sol";
import "ds-math/math.sol";
import "./Shell.sol";
import "./ERC20Token.sol";

contract CowriRoot is DSMath, Ownable {

    uint256 internal constant DOT = 1000000;
    uint256 internal constant DOT_DIVISOR = 1000000000000;
    bytes16 internal constant FLOAT_DOT = 0x4012e848000000000000000000000000;
    bytes16 internal constant FLOAT_WAD = 0x403abc16d674ec800000000000000000;
    uint256 internal BASIS = 10000;
    uint256 public liquidityFee = 20;
    uint256 public platformFee = 1;
    uint256 public shellActivationThreshold;
    address[] public supportedTokens;
    address[] public shellList;
    address public shellFactory;
    mapping(address => bool) public shells;
    mapping(address => uint256) public omnibusIndexes;
    mapping(address => uint256) public revenue;
    mapping(uint256 => uint256) public shellBalances;
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
        address[] memory tokens = Shell(shell).getTokens();
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

    event log_named_uint(bytes32, uint256);
    event ping(bytes32);

    function refine_root_wad (uint256 guess, uint256 base, uint256 root, uint256 max_iterations) public returns (uint256) {

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

    event log_bytes16(bytes16);

    function fast_aprx_root_wad (bytes16 base, uint256 root) internal  returns (bytes16) {
        // emit log_bytes16(base);
        // emit log_named_uint("root", root);

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

        return float_mul(
            bytes16(root_constant + (uint128(base) / uint128(root))),
            FLOAT_WAD
        );

    }

    function fast_aprx_root_float (bytes16 base, uint256 root) internal  returns (bytes16) {

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

        return bytes16(root_constant + (uint128(base) / uint128(root)));

    }

    /**
    * Newton's method for approximating square roots. Returns the guess
    * if maximum number of iterations has been reached or returns guess
    * if it is equal to the base the root is being derived on.
    * Newton's formula for a single iteration is
    * guess' = guess - (guess^exponent - base) / (exponent * guess^(exponent - 1);
    *
    * @param guess quadruple precision number
    * @param base quadruple precision number
    * @param root uint256
    * @param max_iterations uint256
    */

    function refine_root_float (bytes16 guess, bytes16 base, uint256 root, uint256 max_iterations) public pure returns (bytes16) {

        for (uint i = 0; i < max_iterations; i++) {

            bytes16 divisor_rhs = guess;
            bytes16 divisor_lhs = fromUInt(root);

            for (uint j = 1; j < root - 1; j++) divisor_rhs = float_mul(divisor_rhs, guess);

            bytes16 dividend_lhs = float_mul(divisor_rhs, guess);
            if (float_eq(dividend_lhs, base)) return guess; // best way to check for convergence - guess ^ root == base?
            bytes16 dividend = float_sub(dividend_lhs, base);
            bytes16 divisor = float_mul(divisor_lhs, divisor_rhs);
            bytes16 quotient = float_div(dividend, divisor);
            guess = float_sub(guess, quotient);

        }

        return guess;

    }

    /**
    * Calculate x - y.  Special values behave in the following way:
    *
    * NaN - x = NaN for any x.
    * Infinity - x = Infinity for any finite x.
    * -Infinity - x = -Infinity for any finite x.
    * Infinity - -Infinity = Infinity.
    * -Infinity - Infinity = -Infinity.
    * Infinity - Infinity = -Infinity - -Infinity = NaN.
    *
    * @param x quadruple precision number
    * @param y quadruple precision number
    * @return quadruple precision number
    */
    function float_sub (bytes16 x, bytes16 y) internal pure returns (bytes16) {
        return float_add (x, y ^ 0x80000000000000000000000000000000);
    }


    /**
    * Calculate x + y.  Special values behave in the following way:
    *
    * NaN + x = NaN for any x.
    * Infinity + x = Infinity for any finite x.
    * -Infinity + x = -Infinity for any finite x.
    * Infinity + Infinity = Infinity.
    * -Infinity + -Infinity = -Infinity.
    * Infinity + -Infinity = -Infinity + Infinity = NaN.
    *
    * @param x quadruple precision number
    * @param y quadruple precision number
    * @return quadruple precision number
   */
    function float_add (bytes16 x, bytes16 y) internal pure returns (bytes16) {
        uint256 xExponent = uint128 (x) >> 112 & 0x7FFF;
        uint256 yExponent = uint128 (y) >> 112 & 0x7FFF;

        if (xExponent == 0x7FFF) {
            if (yExponent == 0x7FFF) {
                if (x == y) return x;
                else return NaN;
            } else return x;
        } else if (yExponent == 0x7FFF) return y;
        else {
            bool xSign = uint128 (x) >= 0x80000000000000000000000000000000;
            uint256 xSignifier = uint128 (x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            if (xExponent == 0) xExponent = 1;
            else xSignifier |= 0x10000000000000000000000000000;

            bool ySign = uint128 (y) >= 0x80000000000000000000000000000000;
            uint256 ySignifier = uint128 (y) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            if (yExponent == 0) yExponent = 1;
            else ySignifier |= 0x10000000000000000000000000000;

            if (xSignifier == 0) return y == NEGATIVE_ZERO ? POSITIVE_ZERO : y;
            else if (ySignifier == 0) return x == NEGATIVE_ZERO ? POSITIVE_ZERO : x;
            else {
                int256 delta = int256 (xExponent) - int256 (yExponent);
    
                if (xSign == ySign) {
                    if (delta > 112) return x;
                    else if (delta > 0) ySignifier >>= delta;
                    else if (delta < -112) return y;
                    else if (delta < 0) {
                        xSignifier >>= -delta;
                        xExponent = yExponent;
                    }
    
                    xSignifier += ySignifier;
    
                    if (xSignifier >= 0x20000000000000000000000000000) {
                        xSignifier >>= 1;
                        xExponent += 1;
                    }
    
                    if (xExponent == 0x7FFF)
                        return xSign ? NEGATIVE_INFINITY : POSITIVE_INFINITY;
                    else {
                        if (xSignifier < 0x10000000000000000000000000000) xExponent = 0;
                        else xSignifier &= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            
                        return bytes16 (uint128 (
                            (xSign ? 0x80000000000000000000000000000000 : 0) |
                            (xExponent << 112) |
                            xSignifier));
                    }
                } else {
                    if (delta > 0) {
                        xSignifier <<= 1;
                        xExponent -= 1;
                    } else if (delta < 0) {
                        ySignifier <<= 1;
                        xExponent = yExponent - 1;
                    }

                    if (delta > 112) ySignifier = 1;
                    else if (delta > 1) ySignifier = (ySignifier - 1 >> delta - 1) + 1;
                    else if (delta < -112) xSignifier = 1;
                    else if (delta < -1) xSignifier = (xSignifier - 1 >> -delta - 1) + 1;

                    if (xSignifier >= ySignifier) xSignifier -= ySignifier;
                    else {
                        xSignifier = ySignifier - xSignifier;
                        xSign = ySign;
                    }

                    if (xSignifier == 0)
                        return POSITIVE_ZERO;

                    uint256 msb = msb (xSignifier);

                    if (msb == 113) {
                        xSignifier = xSignifier >> 1 & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
                        xExponent += 1;
                    } else if (msb < 112) {
                        uint256 shift = 112 - msb;
                        if (xExponent > shift) {
                        xSignifier = xSignifier << shift & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
                        xExponent -= shift;
                        } else {
                        xSignifier <<= xExponent - 1;
                        xExponent = 0;
                        }
                    } else xSignifier &= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

                    if (xExponent == 0x7FFF)
                        return xSign ? NEGATIVE_INFINITY : POSITIVE_INFINITY;
                    else return bytes16 (uint128 (
                        (xSign ? 0x80000000000000000000000000000000 : 0) |
                        (xExponent << 112) |
                        xSignifier));
                }
            }
        }
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
    * Calculate x / y.  Special values behave in the following way:
    *
    * NaN / x = NaN for any x.
    * x / NaN = NaN for any x.
    * Infinity / x = Infinity for any finite non-negative x.
    * Infinity / x = -Infinity for any finite negative x including -0.
    * -Infinity / x = -Infinity for any finite non-negative x.
    * -Infinity / x = Infinity for any finite negative x including -0.
    * x / Infinity = 0 for any finite non-negative x.
    * x / -Infinity = -0 for any finite non-negative x.
    * x / Infinity = -0 for any finite non-negative x including -0.
    * x / -Infinity = 0 for any finite non-negative x including -0.
    *
    * Infinity / Infinity = NaN.
    * Infinity / -Infinity = -NaN.
    * -Infinity / Infinity = -NaN.
    * -Infinity / -Infinity = NaN.
    *
    * Division by zero behaves in the following way:
    *
    * x / 0 = Infinity for any finite positive x.
    * x / -0 = -Infinity for any finite positive x.
    * x / 0 = -Infinity for any finite negative x.
    * x / -0 = Infinity for any finite negative x.
    * 0 / 0 = NaN.
    * 0 / -0 = NaN.
    * -0 / 0 = NaN.
    * -0 / -0 = NaN.
    *
    * @param x quadruple precision number
    * @param y quadruple precision number
    * @return quadruple precision number
    */
    function float_div (bytes16 x, bytes16 y) internal pure returns (bytes16) {
        uint256 xExponent = uint128 (x) >> 112 & 0x7FFF;
        uint256 yExponent = uint128 (y) >> 112 & 0x7FFF;

        if (xExponent == 0x7FFF) {
            if (yExponent == 0x7FFF) return NaN;
            else return x ^ y & 0x80000000000000000000000000000000;
        } else if (yExponent == 0x7FFF) {
            if (y & 0x0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF != 0) return NaN;
            else return POSITIVE_ZERO | (x ^ y) & 0x80000000000000000000000000000000;
        } else if (y & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF == 0) {
            if (x & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF == 0) return NaN;
            else return POSITIVE_INFINITY | (x ^ y) & 0x80000000000000000000000000000000;
        } else {
            uint256 ySignifier = uint128 (y) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            if (yExponent == 0) yExponent = 1;
            else ySignifier |= 0x10000000000000000000000000000;

            uint256 xSignifier = uint128 (x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            if (xExponent == 0) {
                if (xSignifier != 0) {
                    uint shift = 226 - msb (xSignifier);

                    xSignifier <<= shift;

                    xExponent = 1;
                    yExponent += shift - 114;
                }
            } else {
                xSignifier = (xSignifier | 0x10000000000000000000000000000) << 114;
            }

            xSignifier = xSignifier / ySignifier;
            if (xSignifier == 0)
                return (x ^ y) & 0x80000000000000000000000000000000 > 0 ?
                    NEGATIVE_ZERO : POSITIVE_ZERO;

            assert (xSignifier >= 0x1000000000000000000000000000);

            uint256 msb =
                xSignifier >= 0x80000000000000000000000000000 ? msb (xSignifier) :
                xSignifier >= 0x40000000000000000000000000000 ? 114 :
                xSignifier >= 0x20000000000000000000000000000 ? 113 : 112;

            if (xExponent + msb > yExponent + 16497) { // Overflow
                xExponent = 0x7FFF;
                xSignifier = 0;
            } else if (xExponent + msb + 16380  < yExponent) { // Underflow
                xExponent = 0;
                xSignifier = 0;
            } else if (xExponent + msb + 16268  < yExponent) { // Subnormal
                if (xExponent + 16380 > yExponent)
                    xSignifier <<= xExponent + 16380 - yExponent;
                else if (xExponent + 16380 < yExponent)
                    xSignifier >>= yExponent - xExponent - 16380;

                xExponent = 0;
            } else { // Normal
                if (msb > 112)
                    xSignifier >>= msb - 112;

                xSignifier &= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

                xExponent = xExponent + msb + 16269 - yExponent;
            }

            return bytes16 (uint128 (uint128 ((x ^ y) & 0x80000000000000000000000000000000) |
                xExponent << 112 | xSignifier));
        }
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
    /**
    * Test whether x equals y.  NaN, infinity, and -infinity are not equal to
    * anything.
    *
    * @param x quadruple precision number
    * @param y quadruple precision number
    * @return true if x equals to y, false otherwise
    */
    function float_eq (bytes16 x, bytes16 y) internal pure returns (bool) {
        if (x == y) {
            return uint128 (x) & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF <
            0x7FFF0000000000000000000000000000;
        } else return false;
    }

}