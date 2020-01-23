pragma solidity ^0.5.6;

import "ds-math/math.sol";

contract CTokenAdapter is YieldWrapperI {
    CToken token;

    constructor (address ctoken) public {
        token = CToken(ctoken);
    }

    function getNumeraireAmount (
        uint256 tokenAmount
    ) public returns (uint256) {
        uint256 exchangeRate = token.exchangeRateCurrent();
        return wmul(amount, exchangeRateCurrent);
    }

    function getTokenAmount (
        uint256 numeraireAmount
    ) public returns (uint256) {
        uint256 exchangeRate = token.exchangeRateCurrent();
        return wdiv(numeraireAmount, exchangeRate);
    }

    function wrap (
        uint256 amount
    ) public returns (uint256) {
        uint256 wrappedAmount = token.mint(amount);
        return wrappedAmount;
    }

    function unwrap (
        uint256 amount
    ) public returns (uint256) {
        uint256 redeemedAmount = token.redeem(amount);
        return redeemedAmount;
    }

    function canRedeem (
        uint256 numeraireAmount
    ) public returns (bool) {
        return token.getPriorCash() >= numeraireAmount ? true : false;
    }

}