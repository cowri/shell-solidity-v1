
pragma solidity ^0.5.12;

import "ds-math/math.sol";
import "../CTokenI.sol";

contract CDAIAdaptation is DSMath {

    /**
        takes raw stablecoin amount and wraps it into an amount of flavor
        returns amount of flavor
     */
    function wrap (uint256 amount) public returns (uint256) {
        return CTokenI(address(0)).mint(amount);
    }

    /**
        takes (numeraire/flavor?) amount and unwraps it into raw stablecoin amount
        returns raw stablecoin amount
     */
    function unwrap (uint256 amount) public returns (uint256) {
        CTokenI(address(0)).redeem(amount);
        CTokenI(address(0)).redeemUnderlying(amount);
    }

    /**
        takes number of flavor and returns corresponding number of numeraire
     */
    function getNumeraireAmount (uint256 amount) public returns (uint256) {
        uint256 rate = CTokenI(address(0)).exchangeRateCurrent();
        return amount;
    }

}