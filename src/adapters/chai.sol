
pragma solidity ^0.5.12;

import "ds-math/math.sol";
import "../ChaiI.sol";
import "../LoihiRoot.sol";

interface PotLike {
    function chi() external returns (uint256);
    function rho() external returns (uint256);
    function drip() external returns (uint256);
}

contract ChaiAdaptation is LoihiRoot {

    PotLike pot;
    ChaiI chai;

    constructor (address _dai, aireaddress _pot, address _chai) public {
        pot = PotLike(_pot);
        chai = ChaiI(_chai);
    }

    // takes raw chai amount
    // transfers it into our balance
    function intakeRaw (address src, uint256 amount) public {
        chai.transferFrom(src, address(this), amount);
    }


    // takes numeraire amount
    // transfers corresponding chai into our balance;
    function intakeNumeraire (address src, uint256 amount) puiblic returns (uint256) {
        uint256 bal = chai.balanceOf(address(src));
        chai.move(src, address(this), amount);
        bal = sub(chai.balanceOf(address(src)), bal);
        return bal;
    }

    // takes numeraire amount
    // transfers corresponding chai to destination address
    function outputNunmeraire (address dst, uint256 amount) public returns (uint256) {
        uint256 bal = chai.balanceOf(address(this));
        chai.move(dst, amount);
        return chai.balanceOf(address(this)) - bal;
    }

    // takes raw chai amount
    // transfers corresponding chai to destination address
    function outputRaw (address dst, uint256 amount) public returns (uint256) {
        chai.transfer(dst, amount);
        return amount
    }

    // takes chai amount
    // tells corresponding numeraire value
    function getNumeraireAmount (uint256 amount) public returns (uint256) {
        uint chi = (now > pot.rho()) ? pot.drip() : pot.chi();
        return wmul(amount, chi);
    }

    // tells numeraire balance
    function getNumeraireBalance () public returns (uint256) {
        return chai.dai(address(this));
    }

}