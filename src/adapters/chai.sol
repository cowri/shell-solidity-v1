
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
    function intake (address src, uint256 amount) public returns (uint256) {
        chai.transferFrom(src, address(this), amount);
        return amount;
    }

    // takes numeraire amount
    // transfers corresponding chai to destination address
    function output (address dst, uint256 amount) public returns (uint256) {
        uint chi = (now > pot.rho()) ? pot.drip() : pot.chi();
        chai.move(dst, amount);
        return wdiv(amount, chi);
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