
pragma solidity ^0.5.12;

import "ds-math/math.sol";
import "../CTokenI.sol";
import "../ERC20I.sol";

contract cUsdcAdapter is DSMath {

    CTokenI cUsdc;
    ERC20I usdc;

    constructor (address _cUsdc, address _usdc) public {
        cUsdc = CTokenI(_cUsdc);
        usdc = ERC20I(_usdc);
    }

    // takes raw cUsdc amount and transfers it in
    function intakeRaw (uint256 amount) public returns (uint256) {
        cUsdc.transferFrom(msg.sender, address(this), amount);
    }

    // takes numeraire amount
    // transfers corresponding cusdc to destination
    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {
        uint256 rate = cUsdc.exchangeRateCurrent();
        amount = wmul(amount / 10000000000, rate);
        cUsdc.transfer(dst, amount);
        return amount;
    }

    // takes raw amount
    // transfers that amount to destination
    function outputRaw (address dst, uint256 amount) public returns (uint256) {
        cUsdc.transfer(dst, amount);
        return amount;
    }

    // takes raw cusdc amount
    // returns corresponding numeraire amount
    function getNumeraireAmount (uint256 amount) public returns (uint256) {
        uint256 rate = cUsdc.exchangeRateCurrent();
        return wdiv(amount / 10000000000, rate);
    }

    // returns numeraire amount of balance
    function getNumeraireBalance () public returns (uint256) {
        uint256 rate = cUsdc.exchangeRateCurrent();
        uint256 bal = cUsdc.balanceOf(address(this));
        return wdiv(bal / 10000000000, rate);
    }

}