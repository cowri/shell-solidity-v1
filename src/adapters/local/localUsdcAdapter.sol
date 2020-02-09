
pragma solidity ^0.5.12;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../../IChai.sol";
import "../../ICToken.sol";
import "../../IPot.sol";
import "../../LoihiRoot.sol";

contract LocalUsdcAdapter is LoihiRoot {

    IChai chai;
    ICToken cdai;
    IERC20 dai;
    IPot pot;
    ICToken cusdc;
    IERC20 usdc;
    IERC20 usdt;

    constructor () public { }

    // transfers usdc in
    // wraps it in csudc
    function intakeRaw (uint256 amount) public {
        usdc.transferFrom(msg.sender, address(this), amount);
        usdc.approve(address(cusdc), amount);
        cusdc.mint(amount);
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
        return wdiv(bal, rate);
    }
}