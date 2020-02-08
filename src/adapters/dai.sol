
pragma solidity ^0.5.12;

import "ds-math/math.sol";
import "../ERC20I.sol";
import "../ChaiI.sol";
import "../BadERC20I.sol";
import "../CTokenI.sol";
import "../PotI.sol";
import "../LoihiRoot.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract DaiAdapter is LoihiRoot {

    ChaiI chai;
    CTokenI cdai;
    ERC20I dai;
    PotI pot;
    CTokenI cusdc;
    ERC20I usdc;
    IERC20 usdt;

    constructor () public { }

    // transfers dai in
    // wraps it in chai
    function intakeRaw (uint256 amount) public {
        dai.transferFrom(msg.sender, address(this), amount);
        dai.approve(address(cdai), amount);
        cdai.mint(amount);
    }

    // transfers dai in
    // wraps it in chai
    function intakeNumeraire (uint256 amount) public returns (uint256) {
        dai.transferFrom(msg.sender, address(this), amount);
        dai.approve(address(cdai), amount);
        cdai.mint(amount);
        return amount;
    }

    // unwraps chai
    // transfers out dai
    function outputRaw (address dst, uint256 amount) public {
        cdai.redeemUnderlying(amount);
        dai.transfer(dst, amount);
    }

    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {
        cdai.redeemUnderlying(amount);
        dai.transfer(dst, amount);
        return amount;
    }

    // returns amount, already in numeraire
    function getNumeraireAmount (uint256 amount) public returns (uint256) {
        return amount;
    }

    // returns numeraire amount of chai balance
    function getNumeraireBalance () public returns (uint256) {
        return cdai.balanceOfUnderlying(address(this));
    }

}