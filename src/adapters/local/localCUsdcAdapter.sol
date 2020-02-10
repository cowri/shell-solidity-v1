
pragma solidity ^0.5.12;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../../IChai.sol";
import "../../ICToken.sol";
import "../../IPot.sol";
import "../../LoihiRoot.sol";

contract LocalCUsdcAdapter is LoihiRoot {

    IChai chai;
    ICToken cdai;
    IERC20 dai;
    IPot pot;
    ICToken cusdc;
    IERC20 usdc;
    IERC20 usdt;

    constructor () public { }

    // takes raw cusdc amount and transfers it in
    function intakeRaw (uint256 amount) public {
        cusdc.transferFrom(msg.sender, address(this), amount);
    }
    
    // takes numeraire amount and transfers corresponding cusdc in
    function intakeNumeraire (uint256 amount) public returns (uint256) {
        uint256 rate = cusdc.exchangeRateCurrent();
        amount = wdiv(amount, rate);
        cusdc.transferFrom(msg.sender, address(this), amount);
        return amount;
    }

    // takes numeraire amount
    // transfers corresponding cusdc to destination
    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {
        uint256 rate = cusdc.exchangeRateCurrent();
        amount = wmul(amount / 1000000000000, rate);
        cusdc.transfer(dst, amount);
        return amount;
    }

    // takes raw amount
    // transfers that amount to destination
    function outputRaw (address dst, uint256 amount) public returns (uint256) {
        cusdc.transfer(dst, amount);
        return amount;
    }

    // takes raw cusdc amount
    // returns corresponding numeraire amount
    function getNumeraireAmount (uint256 amount) public returns (uint256) {
        uint256 rate = cusdc.exchangeRateCurrent();
        return wmul(amount, rate) * 1000000000000;
    }

    // returns numeraire amount of balance
    function getNumeraireBalance () public returns (uint256) {
        return cusdc.balanceOfUnderlying(address(this)) * 1000000000000;
    }

}