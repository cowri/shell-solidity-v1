
pragma solidity ^0.5.12;

import "ds-math/math.sol";
import "../ERC20I.sol";
import "../ChaiI.sol";
import "../BadERC20I.sol";
import "../CTokenI.sol";
import "../PotI.sol";
import "../LoihiRoot.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract cUsdcAdapter is LoihiRoot {

    ChaiI chai;
    CTokenI cdai;
    ERC20I dai;
    PotI pot;
    CTokenI cusdc;
    ERC20I usdc;
    IERC20 usdt;

    constructor () public { }

    // takes raw cusdc amount and transfers it in
    function intakeRaw (uint256 amount) public {
        cusdc.transferFrom(msg.sender, address(this), amount);
    }
    
    // takes numeraire amount and transfers corresponding cusdc in
    function intakeNumeraire (uint256 amount) public returns (uint256) {
        uint256 rate = cusdc.exchangeRateCurrent();
        amount = wmul(amount, rate);
        cusdc.transferFrom(msg.sender, address(this), amount);
        return amount;
    }

    // takes numeraire amount
    // transfers corresponding cusdc to destination
    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {
        uint256 rate = cusdc.exchangeRateCurrent();
        amount = wmul(amount / 10000000000, rate);
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
        return wmul(amount, rate);
    }

    // returns numeraire amount of balance
    function getNumeraireBalance () public returns (uint256) {
        uint256 rate = cusdc.exchangeRateCurrent();
        uint256 bal = cusdc.balanceOf(address(this));
        return wmul(bal, rate);
    }

}