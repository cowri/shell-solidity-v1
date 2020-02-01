
pragma solidity ^0.5.12;

import "ds-math/math.sol";
import "../CTokenI.sol";

contract cUsdcAdaptation is DSMath {

    CTokenI cUsdc;
    ERC20I usdc;

    constructor (address cUsdc, address usdc) public {
        cUsdc = CTokenI(cUsdc);
        usdc = ERC20I(usdc);
    }

    // takes raw cUsdc amount and transfers it in
    function intake (uint256 amount) public returns (uint256) {
        cUsdc.transferFrom(msg.sender, address(this), amount);
    }

    // takes numeraire amount
    // transfers corresponding cusdc to destination
    function output (address dst, uint256 amount) public returns (uint256) {
        uint256 rate = cUsdc.exchangeRateCurrent();
        amount = wmul(amount / 10000000000, rate);
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
        return wdiv(amount / 10000000000, rate);
    }

}