pragma solidity ^0.5.12;

import "../../ICToken.sol";

contract KovanCDaiAdapter {

    constructor () public { }

    // takes raw cdai amount
    // unwraps it into dai
    // deposits dai amount in chai
    function intakeRaw (uint256 amount) public {
        ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c).transferFrom(msg.sender, address(this), amount);
    }

    function intakeNumeraire (uint256 amount) public returns (uint256) {
        uint256 rate = ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c).exchangeRateCurrent();
        uint256 cdaiAmount = wmul(rate, amount);
        ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c).transferFrom(msg.sender, address(this), cdaiAmount);
        return cdaiAmount;
    }

    // unwraps numeraire amount of dai from chai
    // wraps it into cdai amount
    // sends that to destination
    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {
        uint rate = ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c).exchangeRateCurrent();
        uint cdaiAmount = wmul(amount, rate);
        ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c).transfer(dst, cdaiAmount);
        return cdaiAmount;
    }

    function viewRawAmount (uint256 amount) public view returns (uint256) {
        uint256 rate = ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c).exchangeRateStored();
        return wmul(amount, rate);
    }

    function viewNumeraireAmount (uint256 amount) public view returns (uint256) {
        uint256 rate = ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c).exchangeRateStored();
        return wdiv(amount, rate);
    }

    function viewNumeraireBalance (address addr) public view returns (uint256) {
        uint256 rate = ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c).exchangeRateStored();
        uint256 balance = ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c).balanceOf(addr);
        return wmul(balance, rate);
    }

    // takes raw amount and gives numeraire amount
    function getNumeraireAmount (uint256 amount) public returns (uint256) {
        uint256 rate = ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c).exchangeRateCurrent();
        return wmul(amount, rate);
    }

    function getNumeraireBalance () public returns (uint256) {
        return ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c).balanceOfUnderlying(address(this));
    }
    
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "ds-math-add-overflow");
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
    }

    function wmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), 1000000000000000000 / 2) / 1000000000000000000;
    }

    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, 1000000000000000000), y / 2) / y;
    }

}