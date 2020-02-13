
pragma solidity ^0.5.12;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../../IChai.sol";
import "../../ICToken.sol";
import "../../IPot.sol";
import "../../LoihiRoot.sol";

contract LocalChaiAdapter is LoihiRoot {

    constructor () public { }

    // takes raw chai amount
    // transfers it into our balance
    function intakeRaw (uint256 amount) public {
        uint256 daiAmt = dai.balanceOf(address(this));
        chai.exit(msg.sender, amount);
        daiAmt = dai.balanceOf(address(this)) - daiAmt;
        dai.approve(address(cdai), daiAmt);
        cdai.mint(daiAmt);
    }


    // takes numeraire amount
    // transfers corresponding chai into our balance;
    function intakeNumeraire (uint256 amount) public returns (uint256) {
        chai.draw(msg.sender, amount);
        dai.approve(address(cdai), amount);
        cdai.mint(amount);
        return amount;
    }

    // takes numeraire amount
    // transfers corresponding chai to destination address
    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {
        cdai.redeemUnderlying(amount);
        uint256 chaiBal = chai.balanceOf(address(this));
        dai.approve(address(this), amount);
        chai.join(dst, amount);
        chaiBal = chaiBal - chai.balanceOf(address(this));
        return chaiBal;
    }

    // transfers corresponding chai to destination address
    function outputRaw (address dst, uint256 amount) public returns (uint256) {
        return amount;
    }


    function viewRawAmount (uint256 amount) public view returns (uint256) {
        uint256 chi = pot.chi();
        return wmul(amount, chi);
    }

    function viewNumeraireAmount (uint256 amount) public view returns (uint256) {
        uint256 chi = pot.chi();
        return wdiv(amount, chi);
    }

    function viewNumeraireBalance (address addr) public view returns (uint256) {
        uint256 rate = cdai.exchangeRateStored();
        uint256 balance = cdai.balanceOf(addr);
        return wmul(balance, rate);
    }

    // takes chai amount
    // tells corresponding numeraire value
    function getNumeraireAmount (uint256 amount) public returns (uint256) {
        uint chi = (now > pot.rho()) ? pot.drip() : pot.chi();
        return wdiv(amount, chi);
    }

    // tells numeraire balance
    function getNumeraireBalance () public returns (uint256) {
        return cdai.balanceOfUnderlying(address(this));
    }

}