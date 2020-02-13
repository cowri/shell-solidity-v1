
pragma solidity ^0.5.12;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../../ICToken.sol";
import "../../IChai.sol";
import "../../IPot.sol";

contract KovanChaiAdapter {

    uint256 internal constant WAD = 10**18;
    uint256 internal constant RAY = 10**27;

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
        IERC20(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa).approve(0xB641957b6c29310926110848dB2d464C8C3c3f38, amount);
        uint256 chaiBal = IChai(0xB641957b6c29310926110848dB2d464C8C3c3f38).balanceOf(dst);
        IChai(0xB641957b6c29310926110848dB2d464C8C3c3f38).join(dst, amount);
        return IChai(0xB641957b6c29310926110848dB2d464C8C3c3f38).balanceOf(dst) - chaiBal;
    }

    // transfers corresponding chai to destination address
    function outputRaw (address dst, uint256 amount) public returns (uint256) {
        uint256 daiAmt = rmul(amount, IPot(0xEA190DBDC7adF265260ec4dA6e9675Fd4f5A78bb).chi());
        ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c).redeemUnderlying(daiAmt);
        IERC20(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa).approve(0xB641957b6c29310926110848dB2d464C8C3c3f38, daiAmt);
        uint256 chaiAmt = IChai(0xB641957b6c29310926110848dB2d464C8C3c3f38).balanceOf(dst);
        IChai(0xB641957b6c29310926110848dB2d464C8C3c3f38).join(dst, daiAmt);
        return IChai(0xB641957b6c29310926110848dB2d464C8C3c3f38).balanceOf(dst) - chaiAmt;
    }
    
    // pass it a numeraire and get the raw amount
    function viewRawAmount (uint256 amount) public view returns (uint256) {
        uint256 chi = IPot(0xEA190DBDC7adF265260ec4dA6e9675Fd4f5A78bb).chi();
        return rdivup(amount, chi);
    }

    // pass it a raw amount and get the numeraire amount
    function viewNumeraireAmount (uint256 amount) public view returns (uint256) {
        uint256 chi = IPot(0xEA190DBDC7adF265260ec4dA6e9675Fd4f5A78bb).chi();
        return rmul(amount, chi);
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
        return rmul(amount, chi);
    }

    function getRawAmount (uint256 amount) public returns (uint256) {
        uint chi = (now > IPot(0xEA190DBDC7adF265260ec4dA6e9675Fd4f5A78bb).rho())
          ? IPot(0xEA190DBDC7adF265260ec4dA6e9675Fd4f5A78bb).drip()
          : IPot(0xEA190DBDC7adF265260ec4dA6e9675Fd4f5A78bb).chi();
        return rdivup(amount, chi);
    }

    // tells numeraire balance
    function getNumeraireBalance () public returns (uint256) {
        return ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c).balanceOfUnderlying(address(this));
    }
    
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "ds-math-add-overflow");
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x);
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
    }

    function wmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), WAD / 2) / WAD;
    }

    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, WAD), y / 2) / y;
    }

    function rmul(uint x, uint y) internal pure returns (uint z) {
        // always rounds down
        z = mul(x, y) / RAY;
    }
    function rdiv(uint x, uint y) internal pure returns (uint z) {
        // always rounds down
        z = mul(x, RAY) / y;
    }
    function rdivup(uint x, uint y) internal pure returns (uint z) {
        // always rounds up
        z = add(mul(x, RAY), sub(y, 1)) / y;
    }

}