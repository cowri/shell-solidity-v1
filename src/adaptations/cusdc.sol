
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

    // takes numeraire amount and sends corresponding cUsdc
    // amount to destination
    function output (address dst, uint256 amount) public returns (uint256) {
        uint256 rate = cUsdc.exchangeRateCurrent();
        amount = wmul(amount / 10000000000, rate);
        cUsdc.transfer(dst, amount);
        return amount;
    }

    function lock (uint256 amount) public {
        usdc.approve(amount);
        cUsdc.mint(amount);
    }

    function unlock (uint256 amount) public {
        uint256 rate = cUsdc.exchangeRateCurrent();
        cUsdc.redeemUnderlying(amount);
    }

    /**
        takes number of flavor and returns corresponding number of numeraire
     */
    function getNumeraireAmount (uint256 amount) public returns (uint256) {
        uint256 rate = cUsdc.exchangeRateCurrent();
        return wdiv(amount / 10000000000, rate);
    }

}