pragma solidity ^0.5.6;

import "ds-math/math.sol";

contract ChaiAdapter is YieldWrapperI {
    Chai token;

    constructor (address chai) public {
        token = Chai(chai);
    }

    function getNumeraireAmount (
        uint256 tokenAmount
    ) public returns (uint256) {
        uint256 dais = token.dai(address(this));
        uint256 chais = token.balanceOf(address(this));
        return numeraire = wmul(
            amount,
            wdiv(dais, chais)
        );
    }

    function getTokenAmount (
        uint256 numeraireAmount
    ) public returns (uint256) {
        uint256 dais = token.dai(address(this));
        uint256 chais = token.balanceOf(address(this));
        return numeraire = wmul(
            amount,
            wdiv(chais, dais)
        );
    }

    function wrap (
        uint256 numeraireAmount
    ) public returns (uint256) {
        uint256 chais = token.join(address(this), numeraireAmount);
        return chais;
    }

    function unwrap (
        uint256 chaiAmount
    ) public returns (uint256) {
        uint256 = token.exit(address(this), chaiAmount);
        return numeraireAmount;
    }

    function canRedeem (
        uint256 numeraireAmount
    ) public returns (uint256) {
        return true;
    }

}