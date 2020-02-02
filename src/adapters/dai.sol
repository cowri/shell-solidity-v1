
pragma solidity ^0.5.12;

import "ds-math/math.sol";
import "../ERC20I.sol";

contract DaiAdaptation is DSMath {
    ERC20I dai;
    ChaiI chai;

    constructor (address _dai, address _chai) {
        dai = ERC20I(_dai);
        chai = ChaiI(_chai);
    }

    // transfers dai in
    // wraps it in chai
    function intakeRaw (uint256 amount) public returns (uint256) {
        dai.transferFrom(msg.sender, amount);
        dai.approve(address(chai), amount);
        chai.join(address(this), amount);
        return amount;
    }

    function intakeNumeraire (uint256) public returns (uint256) {
        dai.transferFrom(msg.sender, amount);
        dai.approve(address(chai), amount);
        chai.join(address(this), amount);
    }

    // unwraps chai
    // transfers out dai
    function outputRaw (address dst, uint256 amount) public returns (uint256) {
        chai.draw(address(this), amount);
        dai.transfer(dst, amount);
        return amount;
    }

    function outputNumeraire (address dst, uint256 amount) public {
        chai.draw(address(this), amount);
        dai.transfer(dst, amount);
    }

    // returns amount, already in numeraire
    function getNumeraireAmount (uint256 amount) public returns (uint256) {
        return amount;
    }

    // returns numeraire amount of chai balance
    function getNumeraireBalance () public returns (uint256) {
        return chai.dai(address(this));
    }

}