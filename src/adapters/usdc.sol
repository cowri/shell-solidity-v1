
pragma solidity ^0.5.12;

import "ds-math/math.sol";
import "../ERC20I.sol";

contract UsdcAdaptation is DSMath {
    ERC20I usdc;
    CTokenI cusdc;

    constructor (address _usdc, address _cusdc) public {
        usdc = ERC20I(_usdc);
        cusdc = CTokenI(_cusdc);
    }

    // transfers usdc in
    // wraps it in csudc
    function intakeRaw (uint256 amount) public {
        usdc.transferFrom(msg.sender, address(this), amount);
        usdc.approve(address(cusdc), amount);
        cusdc.mint(amount);
        return amount;
    }

    function intakeNumeraire (uint256 amount) public returns (uint256) {
        usdc.transferFrom(msg.sender, address(this), amount);
        usdc.approve(address(cusdc), amount);
        cusdc.mint(amount);
        return amount;
    }

    // redeems numeraire amount from cusdc
    // transfers it to destination
    function outputNumeraire (address dst, uint256 amount) public {
        cusdc.redeemUnderlying(amount);
        usdc.transfer(dst, amount);
    }

    function outputRaw (address dst, uint256 amount) public returns (uint256) {
        uint256 bal = usdc.balanceOf(address(this));
        cusdc.redeem(amount);
        bal = usdc.balanceOf(address(this)) - bal;
        usdc.transfer(dst, amount);
        return bal;
    }

    // is already numeraire amount
    function getNumeraireAmount (uint256 amount) public returns (uint256) {
        return amount;
    }

    // returns numeraire balance
    function getNumeraireBalance () public returns (uint256) {
        uint256 rate = cusdc.exchangeRateCurrent();
        uint256 bal = cusdc.balanceOf(address(this));
        return wmul(amount * 10000000000, rate);
    }
}