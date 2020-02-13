
pragma solidity ^0.5.12;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../../IChai.sol";
import "../../ICToken.sol";
import "../../IPot.sol";
import "../../LoihiRoot.sol";

contract LocalUsdcAdapter is LoihiRoot {

    constructor () public { }

    // transfers usdc in
    // wraps it in csudc
    function intakeRaw (uint256 amount) public {
        usdc.transferFrom(msg.sender, address(this), amount);
        usdc.approve(address(cusdc), amount);
        cusdc.mint(amount);
    }

    function intakeNumeraire (uint256 amount) public returns (uint256) {
        amount /= 1000000000000;
        usdc.transferFrom(msg.sender, address(this), amount);
        usdc.approve(address(cusdc), amount);
        cusdc.mint(amount);
        return amount;
    }

    function outputRaw (address dst, uint256 amount) public returns (uint256) {
        cusdc.redeemUnderlying(amount);
        usdc.transfer(dst, amount);
        return amount;
    }

    function outputNumeraire (address dst, uint256 amount) public {
        amount /= 1000000000000;
        cusdc.redeemUnderlying(amount);
        usdc.transfer(dst, amount);
    }

    function viewRawAmount (uint256 amount) public view returns (uint256) {
        return amount / 1000000000000;
    }

    function viewNumeraireAmount (uint256 amount) public pure returns (uint256) {
        return amount * 1000000000000;
    }

    function viewNumeraireBalance (address addr) public view returns (uint256) {
        uint256 rate = cusdc.exchangeRateStored();
        uint256 balance = cusdc.balanceOf(addr);
        return wmul(balance, rate) * 1000000000000;
    }

    // is already numeraire amount
    function getNumeraireAmount (uint256 amount) public returns (uint256) {
        return amount * 1000000000000;
    }

    // returns numeraire balance
    function getNumeraireBalance () public returns (uint256) {
        return cusdc.balanceOfUnderlying(address(this)) * 1000000000000;   
    }
}