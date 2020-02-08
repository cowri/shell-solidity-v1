
pragma solidity ^0.5.12;

import "ds-math/math.sol";
import "../ERC20I.sol";
import "../ChaiI.sol";
import "../BadERC20I.sol";
import "../CTokenI.sol";
import "../PotI.sol";
import "../LoihiRoot.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract ChaiAdapter is LoihiRoot {

    ChaiI chai;
    CTokenI cdai;
    ERC20I dai;
    PotI pot;
    CTokenI cusdc;
    ERC20I usdc;
    IERC20 usdt;

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

    // takes chai amount
    // tells corresponding numeraire value
    function getNumeraireAmount (uint256 amount) public returns (uint256) {
        uint chi = (now > pot.rho()) ? pot.drip() : pot.chi();
        return wmul(amount, chi);
    }

    // tells numeraire balance
    function getNumeraireBalance () public returns (uint256) {
        return cdai.balanceOfUnderlying(address(this));
    }

}