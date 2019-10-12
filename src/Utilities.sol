pragma solidity ^0.5.0;

import "ds-math/math.sol";
import "./Shell.sol";
import "./ERC20Token.sol";

contract Utilities is DSMath {

    function makeKey(address a, address b) internal pure returns (uint256) {
        return add(uint256(a), uint256(b));
    }

    function adjustedTransferFrom (ERC20Token token, address source, uint256 amount) internal returns (uint256) {

        uint256 decimals = token.decimals();
        uint256 adjustedAmount = decimals <= 18
            ? amount / pow(10, 18 - decimals)
            : mul(amount, pow(10, decimals - 18));

        assert(token.transferFrom(
            source,
            address(this),
            adjustedAmount
        ));

        return adjustedAmount;

    }

    function adjustedTransfer (ERC20Token token, address recipient, uint256 amount) internal returns (uint256) {

        uint256 decimals = token.decimals();
        uint256 adjustedAmount = decimals <= 18
            ? amount / pow(10, 18 - decimals)
            : mul(amount, pow(10, decimals - 18));

        assert(token.transfer(
            recipient,
            adjustedAmount
        ));

        return adjustedAmount;

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

}