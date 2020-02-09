
pragma solidity ^0.5.12;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../../ICToken.sol";

contract KovanDaiAdapter {

    constructor () public { }

    // transfers dai in
    // wraps it in chai
    function intakeRaw (uint256 amount) public {
        
        IERC20(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa).transferFrom(msg.sender, address(this), amount);
        IERC20(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa).approve(address(0xe7bc397DBd069fC7d0109C0636d06888bb50668c), amount);
        ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c).mint(amount);
        
    }
    event log_uint(bytes32, uint256);

    // transfers dai in
    // wraps it in cdai
    function intakeNumeraire (uint256 amount) public returns (uint256) {
        
        IERC20(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa).transferFrom(msg.sender, address(this), amount);
        IERC20(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa).approve(address(0xe7bc397DBd069fC7d0109C0636d06888bb50668c), amount);
        uint bal = ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c).balanceOf(address(this));
        ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c).mint(amount);
        bal = ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c).balanceOf(address(this)) - bal;
        uint256 rate = ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c).exchangeRateCurrent();
        emit log_uint("rate", rate);
        emit log_uint("cDai contribution", bal);
        emit log_uint("numeraireAmount", amount);
        emit log_uint("amount/rate", amount/(rate/1000000000000000000));
        return amount;
        
    }

    // unwraps chai
    // transfers out dai
    function outputRaw (address dst, uint256 amount) public {
        
        ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c).redeemUnderlying(amount);
        IERC20(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa).transfer(dst, amount);
        
    }

    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {
        
        ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c).redeemUnderlying(amount);
        IERC20(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa).transfer(dst, amount);
        return amount;
        
    }

    // returns amount, already in numeraire
    function getNumeraireAmount (uint256 amount) public pure returns (uint256) {
        
        return amount;
        
    }

    // returns numeraire amount of chai balance
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