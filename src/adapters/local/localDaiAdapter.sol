
pragma solidity ^0.5.12;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../../IChai.sol";
import "../../ICToken.sol";
import "../../IPot.sol";
import "../../LoihiRoot.sol";

contract LocalDaiAdapter is LoihiRoot {

    constructor () public { }

    // transfers dai in
    // wraps it in chai
    function intakeRaw (uint256 amount) public {
        dai.transferFrom(msg.sender, address(this), amount);
        dai.approve(address(cdai), amount);
        cdai.mint(amount);
    }

    // transfers dai in
    // wraps it in chai
    function intakeNumeraire (uint256 amount) public returns (uint256) {
        dai.transferFrom(msg.sender, address(this), amount);
        dai.approve(address(cdai), amount);
        cdai.mint(amount);
        return amount;
    }

    // unwraps chai
    // transfers out dai
    function outputRaw (address dst, uint256 amount) public {
        cdai.redeemUnderlying(amount);
        dai.transfer(dst, amount);
    }

    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {
        cdai.redeemUnderlying(amount);
        dai.transfer(dst, amount);
        return amount;
    }

    function viewRawAmount (uint256 amount) public pure returns (uint256) {
        return amount;
    }

    function viewNumeraireAmount (uint256 amount) public pure returns (uint256) {
        return amount;
    }

    function viewNumeraireBalance (address addr) public view returns (uint256) {
        uint256 rate = cdai.exchangeRateStored();
        uint256 balance = cdai.balanceOf(addr);
        return wmul(balance, rate);
    }

    // returns amount, already in numeraire
    function getNumeraireAmount (uint256 amount) public returns (uint256) {
        return amount;
    }

    // returns numeraire amount of chai balance
    function getNumeraireBalance () public returns (uint256) {
        return cdai.balanceOfUnderlying(address(this));
    }

}