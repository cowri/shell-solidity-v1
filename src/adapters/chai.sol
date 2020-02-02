
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
    function intakeRaw (address src, uint256 amount) public {
        chai.transferFrom(src, address(this), amount);
    }


    // takes numeraire amount
    // transfers corresponding chai into our balance;
    function intakeNumeraire (address src, uint256 amount) public returns (uint256) {
        uint256 bal = chai.balanceOf(address(src));
        chai.move(src, address(this), amount);
        bal = sub(chai.balanceOf(address(src)), bal);
        return bal;
    }

    // takes numeraire amount
    // transfers corresponding chai to destination address
    function outputNunmeraire (address dst, uint256 amount) public returns (uint256) {
        uint256 bal = chai.balanceOf(address(this));
        chai.move(address(this), dst, amount);
        return chai.balanceOf(address(this)) - bal;
    }

    // takes raw chai amount
    // transfers corresponding chai to destination address
    function outputRaw (address dst, uint256 amount) public returns (uint256) {
        chai.transfer(dst, amount);
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
        return chai.dai(address(this));
    }

}