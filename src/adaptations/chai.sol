
pragma solidity ^0.5.12;

import "ds-math/math.sol";
import "../ChaiI.sol";

contract PotLike { function chi() external returns (uint256); }

contract ChaiAdaptation is DSMath {

        /**
        takes raw stablecoin amount and wraps it into an amount of flavor
        returns amount of flavor
     */
    function wrap (uint256 amount) public returns (uint256) {
        return amount;

    }

    /**
        takes (numeraire/flavor?) amount and unwraps it into raw stablecoin amount
        returns raw stablecoin amount
     */
    function unwrap (uint256 amount) public returns (uint256) {
        return amount;

    }

    /**
        takes number of flavor and returns corresponding number of numeraire
     */
    function getNumeraireAmount (uint256 amount) public returns (uint256) {
        return amount;

    }


}