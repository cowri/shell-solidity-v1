
pragma solidity ^0.5.12;

import "ds-math/math.sol";
import "../ERC20I.sol";

contract DaiAdaptation is DSMath {
    ERC20i dai;

    constructor (address _dai) {
        dai = _dai;
    }

    function intake (uint256 amount) public returns (uint256) {
        return dai.transferFrom(msg.sender, amount);
    }

    function output (uint256 amount) public returns (uint256) {
        return dai.transfer(msg.sender, amount);
    }

    /** this is a first class stablecoin, just returns the amount; */
    function getNumeraireAmount (uint256 amount) public returns (uint256) { return amount; }

}