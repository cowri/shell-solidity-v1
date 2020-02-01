
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

    // takes raw chai amount and transfers it to contract address
    function intake (address src, uint256 amount) public returns (uint256) {
        chai.transferFrom(src, address(this), amount);
        return amount;
    }

    // takes numeraire dai amount and transfers corresponding chai to destination address
    function output (address dst, uint256 amount) public returns (uint256) {
        chai.move(dst, amount);
        return wdiv(amount, chi);
    }

    // takes numeraire amount and deposits into chai
    function lock (uint256 amount) public {
        chai.join(address(this), amount);
    }

    // takes numeraire amount and withdraws frmo chai
    function unlock (uint256 amount) public {
        chai.draw(address(this), amount);
    }

    /**
        takes number of flavor and returns corresponding number of numeraire
     */
    function getNumeraireAmount (uint256 amount) public returns (uint256) {
        uint chi = (now > pot.rho()) ? pot.drip() : pot.chi();
        return wmul(amount, chi);
    }


}