
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
        chai.transferFrom(msg.sender, address(this), amount);
    }


    // takes numeraire amount
    // transfers corresponding chai into our balance;
    function intakeNumeraire (uint256 amount) public returns (uint256) {
        uint256 bal = chai.balanceOf(address(this));
        chai.move(msg.sender, address(this), amount);
        return sub(chai.balanceOf(address(this)), bal);
    }

    event log_uint(bytes32, uint256);
    event log_addr(bytes32, address);
    event log(bytes32);

    // takes numeraire amount
    // transfers corresponding chai to destination address
    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {
        emit log("Wtf");
        emit log_addr("dst", dst);
        uint256 bal = chai.balanceOf(address(this));
        emit log_uint("bal", bal);
        chai.move(address(this), dst, amount);
        bal = chai.balanceOf(address(this)) - bal;
        emit log_uint("bal2", bal);
        return bal;
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