pragma solidity ^0.5.0;

import "openzeppelin-contracts/contracts/ownership/Ownable.sol";
import "ds-math/math.sol";
import "./Shell.sol";
import "./ERC20Token.sol";

contract CowriRoot is DSMath, Ownable {

    uint256 internal BASIS = 10000;
    uint256 public liquidityFee = 20;
    uint256 public platformFee = 1;
    uint256 public shellActivationThreshold;
    address[] public supportedTokens;
    address[] public shellList;
    address public shellFactory;
    mapping(address => bool) public shells;
    mapping(address => uint256) public revenue;
    mapping(uint256 => uint256) public shellBalances;
    mapping(uint256 => address[]) public pairsToAllShells;
    mapping(uint256 => address[]) public pairsToActiveShells;



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

}