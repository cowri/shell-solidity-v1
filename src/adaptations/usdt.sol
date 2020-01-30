
pragma solidity ^0.5.12;

import "ds-math/math.sol";
import "../ERC20I.sol";

contract USDTAdaptation is DSMath {

    /** this is a first class stablecoin, just returns the amount */
    function wrap (uint256 amount) public returns (uint256) { return amount; }
    /** this is a first class stablecoin, just returns the amount; */
    function unwrap (uint256 amount) public returns (uint256) { return amount; }
    /** this is a first class stablecoin, just returns the amount; */
    function getNumeraireAmount (uint256 amount) public returns (uint256) { return amount; }

}