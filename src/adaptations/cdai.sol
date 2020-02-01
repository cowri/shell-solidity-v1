
pragma solidity ^0.5.12;

import "ds-math/math.sol";
import "../CTokenI.sol";
import "../ERC20I.sol";

contract cDaiAdaptation is DSMath {
    CTokenI cDai;
    ERC20I dai;

    constructor (address _dai, address _cDai) public {
        dai = ERC20I(_dai);
        cDai = CTokenI(_cDai);
    }

    // takes raw cToken amount and unwraps it into dai
    function intake (uint256 amount) public returns (uint256) {
        cDai.transferFrom(msg.sender, address(this), amount);
        cDai.redeem(amount);
    }

    // takes numeraire amount and wraps it into cdai amount
    // then sends that to destination
    function output (address dst, uint256 amount) public returns (uint256) {
        dai.approve(cDai, amount);
        uint256 bal = cDai.balanceOf(address(this));
        cDai.mint(amount);
        bal = sub(cDai.balanceOf(address(this), bal);
        cDai.transfer(dst, bal);
        return bal;
    }

    /**
        takes number of flavor and returns corresponding number of numeraire
     */
    function getNumeraireAmount (uint256 amount) public returns (uint256) {
        uint256 rate = cDai.exchangeRateCurrent();
        return wdiv(amount / 10 ** 10, rate);
    }

}