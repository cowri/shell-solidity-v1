
pragma solidity ^0.5.12;

import "ds-math/math.sol";
import "../CTokenI.sol";
import "../ERC20I.sol";

contract cDaiAdaptation is DSMath {
    ChaiI chai;
    CTokenI cDai;
    ERC20I dai;

    constructor (address _dai, address _cDai, address _chai) public {
        chai = ChaiI(_chai);
        dai = ERC20I(_dai);
        cDai = CTokenI(_cDai);
    }

    // takes raw cDai amount 
    // unwraps it into dai
    // deposits dai amount in chai
    function intakeRaw (uint256 amount) public returns (uint256) {
        cDai.transferFrom(msg.sender, address(this), amount);
        uint256 bal = dai.balanceOf(address(this));
        cDai.redeem(amount);
        bal = sub(dai.balanceOf(address(this)), bal));
        dai.approve(chai, bal);
        chai.join(address(this), bal);
    }

    // unwraps numeraire amount of dai from chai 
    // wraps it into cdai amount
    // sends that to destination
    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {
        chai.draw(address(this), amount);
        dai.approve(cDai, amount);
        uint256 bal = cDai.balanceOf(address(this));
        cDai.mint(amount);
        bal = sub(cDai.balanceOf(address(this), bal);
        cDai.transfer(dst, bal);
        return bal;
    }

    // takes raw cdai amount
    // gets numeraire dai amount
    // unwraps dai amount of chai
    // wraps dai into cdai and sends to destination
    function outputRaw (address dst, uint256 amount) public returns (uint256) {
        uint256 numeraire = getNumeraireAmount(amount);
        chai.draw(numeraire);
        cdai.mint(numeraire);
        cdai.transfer(dst, numeraire);
        return numeraire;
    }

    
    // takes raw amount and gives numeraire amount
    function getNumeraireAmount (uint256 amount) public returns (uint256) {
        uint256 rate = cDai.exchangeRateCurrent();
        return wdiv(amount / 10 ** 10, rate);
    }

    function getNumeraireBalance () public returns (uint256) {
        return chai.dai(address(this));
    }

}