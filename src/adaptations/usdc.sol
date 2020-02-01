
pragma solidity ^0.5.12;

import "ds-math/math.sol";
import "../ERC20I.sol";

contract UsdcAdaptation is DSMath {
    ERC20I usdc;

    constructor (address _usdc) public {
        usdc = ERC20I(_usdc);
    }

    /** this is a first class stablecoin, just returns the amount */
    function intake (uint256 amount) public returns (uint256) {
        usdc.transferFrom(msg.sender, address(this), amount);
    }
    /** this is a first class stablecoin, just returns the amount; */
    function output (uint256 amount) public returns (uint256) {
        usdc.transfer(recipient, amount);
    }
    /** this is a first class stablecoin, just returns the amount; */
    function getNumeraireAmount (uint256 amount) public returns (uint256) {
        return amount;
    }
}