pragma solidity ^0.5.12;

import "../ChaiI.sol";
import "../LoihiRoot.sol";

interface _PotLike {
    function chi() external returns (uint256);
    function rho() external returns (uint256);
    function drip() external returns (uint256);
}

contract ChaiReserve is LoihiRoot {
    address reserve;
    ChaiI chai;
    PotLike pot;

    constructor (address _pot, address _chai) public {
        reserve = address(this);
        pot = _PotLike(_pot);
        chai = ChaiI(_chai);
    }

    function getNumeraireReserves () public returns (uint256) {
        uint256 reserved = reserves[reserve];
        uint chi = (now > pot.rho()) ? pot.drip() : pot.chi();
        return wmul(reserved, chi);
    }

    function unwrap (uint256 amount) public returns (uint256) {
        chai.exit(address(this), amount);
        return wmul(amount, chi);
    }

    function wrap (uint256 amount) public returns (uint256) {
        chai.join(address(this, amount));
        uint chi = (now > pot.rho()) ? pot.drip() : pot.chi();
        return wdiv(amount, chi);
    }

}