
pragma solidity ^0.5.12;

import "ds-math/math.sol";
import "../ERC20I.sol";

contract UsdtAdaptation is DSMath {

    /** this is a first class stablecoin, just returns the amount */
    function intake (uint256 amount) public returns (uint256) { return amount; }
    /** this is a first class stablecoin, just returns the amount; */
    function output (uint256 amount) public returns (uint256) { return amount; }
    /** this is a first class stablecoin, just returns the amount; */
    function getNumeraireAmount (uint256 amount) public returns (uint256) { return amount; }

}