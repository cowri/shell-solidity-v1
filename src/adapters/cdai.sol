
pragma solidity ^0.5.12;

import "ds-math/math.sol";
import "../ERC20I.sol";
import "../ChaiI.sol";
import "../BadERC20I.sol";
import "../CTokenI.sol";
import "../PotI.sol";
import "../LoihiRoot.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract cDaiAdapter is DSMath {

    ChaiI chai;
    CTokenI cdai;
    ERC20I dai;
    PotI pot;
    CTokenI cusdc;
    ERC20I usdc;
    IERC20 usdt;

    constructor () public { }

    // takes raw cdai amount
    // unwraps it into dai
    // deposits dai amount in chai
    function intakeRaw (uint256 amount) public {
        cdai.transferFrom(msg.sender, address(this), amount);
        uint256 bal = dai.balanceOf(address(this));
        cdai.redeem(amount);
        bal = sub(dai.balanceOf(address(this)), bal);
        dai.approve(address(chai), bal);
        chai.join(address(this), bal);
    }

    function intakeNumeraire (uint256 amount) public returns (uint256) {
        uint256 rate = cdai.exchangeRateCurrent();
        uint256 cdaiAmount = wmul(rate, amount);
        cdai.transferFrom(msg.sender, address(this), cdaiAmount);
        cdai.redeemUnderlying(amount);
        dai.approve(address(chai), amount);
        chai.join(address(this), amount);
        return cdaiAmount;
    }

    // unwraps numeraire amount of dai from chai
    // wraps it into cdai amount
    // sends that to destination
    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {
        chai.draw(address(this), amount);
        dai.approve(address(cdai), amount);
        uint256 bal = cdai.balanceOf(address(this));
        cdai.mint(amount);
        bal = sub(cdai.balanceOf(address(this)), bal);
        cdai.transfer(dst, bal);
        return bal;
    }

    // takes raw cdai amount
    // gets numeraire dai amount
    // unwraps dai amount of chai
    // wraps dai into cdai and sends to destination
    function outputRaw (address dst, uint256 amount) public returns (uint256) {
        uint256 numeraire = getNumeraireAmount(amount);
        chai.draw(address(this), numeraire);
        cdai.mint(numeraire);
        cdai.transfer(dst, numeraire);
        return numeraire;
    }

    
    // takes raw amount and gives numeraire amount
    function getNumeraireAmount (uint256 amount) public returns (uint256) {
        uint256 rate = cdai.exchangeRateCurrent();
        return wdiv(amount, rate);
    }

    function getNumeraireBalance () public returns (uint256) {
        return chai.dai(address(this));
    }

}