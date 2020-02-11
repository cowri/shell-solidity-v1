
pragma solidity ^0.5.12;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../../ICToken.sol";
import "../../IChai.sol";
import "../../IPot.sol";

contract KovanChaiAdapter {

    constructor () public { }

    // takes raw chai amount
    // transfers it into our balance
    function intakeRaw (uint256 amount) public {
        uint256 daiAmt = IERC20(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa).balanceOf(address(this));
        IChai(0xB641957b6c29310926110848dB2d464C8C3c3f38).exit(msg.sender, amount);
        daiAmt = IERC20(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa).balanceOf(address(this)) - daiAmt;
        IERC20(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa).approve(address(0xe7bc397DBd069fC7d0109C0636d06888bb50668c), daiAmt);
        ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c).mint(daiAmt);
    }


    // takes numeraire amount
    // transfers corresponding chai into our balance;
    function intakeNumeraire (uint256 amount) public returns (uint256) {
        IChai(0xB641957b6c29310926110848dB2d464C8C3c3f38).draw(msg.sender, amount);
        IERC20(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa).approve(address(0xe7bc397DBd069fC7d0109C0636d06888bb50668c), amount);
        ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c).mint(amount);
        return amount;
    }

    // takes numeraire amount
    // transfers corresponding chai to destination address
    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {
        ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c).redeemUnderlying(amount);
        uint256 chaiBal = IChai(0xB641957b6c29310926110848dB2d464C8C3c3f38).balanceOf(address(this));
        IERC20(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa).approve(address(this), amount);
        IChai(0xB641957b6c29310926110848dB2d464C8C3c3f38).join(dst, amount);
        chaiBal = chaiBal - IChai(0xB641957b6c29310926110848dB2d464C8C3c3f38).balanceOf(address(this));
        return chaiBal;
    }

    // transfers corresponding chai to destination address
    function outputRaw (address dst, uint256 amount) public returns (uint256) {
        uint256 chi = IPot(0xEA190DBDC7adF265260ec4dA6e9675Fd4f5A78bb).chi();
        return amount;
    }

    function viewRawAmount (uint256 amount) public view returns (uint256) {
        uint256 chi = IPot(0xEA190DBDC7adF265260ec4dA6e9675Fd4f5A78bb).chi();
        return wmul(amount, chi);
    }

    function viewNumeraireAmount (uint256 amount) public view returns (uint256) {
        uint256 chi = IPot(0xEA190DBDC7adF265260ec4dA6e9675Fd4f5A78bb).chi();
        return wdiv(amount, chi);
    }

    function viewNumeraireBalance (address addr) public view returns (uint256) {
        uint256 rate = ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c).exchangeRateStored();
        uint256 balance = ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c).balanceOf(addr);
        return wmul(balance, rate);
    }

    // takes chai amount
    // tells corresponding numeraire value
    function getNumeraireAmount (uint256 amount) public returns (uint256) {
        uint chi = (now > IPot(0xEA190DBDC7adF265260ec4dA6e9675Fd4f5A78bb).rho())
          ? IPot(0xEA190DBDC7adF265260ec4dA6e9675Fd4f5A78bb).drip()
          : IPot(0xEA190DBDC7adF265260ec4dA6e9675Fd4f5A78bb).chi();
        return wdiv(amount, chi);
    }

    // tells numeraire balance
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