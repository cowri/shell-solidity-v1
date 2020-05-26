// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

pragma solidity ^0.5.0;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../../interfaces/ICToken.sol";
import "../../interfaces/IChai.sol";
import "../../interfaces/IPot.sol";

contract KovanChaiAssimilator {

    uint256 internal constant WAD = 10**18;
    uint256 internal constant RAY = 10**27;
    IChai constant chai = IChai(0xB641957b6c29310926110848dB2d464C8C3c3f38);
    IERC20 constant dai = IERC20(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa);
    ICToken constant cdai = ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c);
    IPot constant pot = IPot(0xEA190DBDC7adF265260ec4dA6e9675Fd4f5A78bb);

    constructor () public { }

    // takes raw chai amount
    // transfers it into our balance
    function intakeRaw (uint256 amount) public {
        uint256 daiAmt = dai.balanceOf(address(this));
        chai.exit(msg.sender, amount);
        daiAmt = dai.balanceOf(address(this)) - daiAmt;
        cdai.mint(daiAmt);
    }

    // takes numeraire amount
    // transfers corresponding chai into our balance;
    function intakeNumeraire (uint256 amount) public returns (uint256) {
        chai.draw(msg.sender, amount);
        cdai.mint(amount);
        return amount;
    }

    // takes numeraire amount
    // transfers corresponding chai to destination address
    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {
        cdai.redeemUnderlying(amount);
        uint256 chaiBal = chai.balanceOf(dst);
        chai.join(dst, amount);
        return chai.balanceOf(dst) - chaiBal;
    }

    // transfers corresponding chai to destination address
    function outputRaw (address dst, uint256 amount) public returns (uint256) {
        uint256 daiAmt = rmul(amount, pot.chi());
        cdai.redeemUnderlying(daiAmt);
        uint256 chaiAmt = chai.balanceOf(dst);
        chai.join(dst, daiAmt);
        return chai.balanceOf(dst) - chaiAmt;
    }
    
    // pass it a numeraire and get the raw amount
    function viewRawAmount (uint256 amount) public view returns (uint256) {
        return rdivup(amount, pot.chi());
    }

    // pass it a raw amount and get the numeraire amount
    function viewNumeraireAmount (uint256 amount) public view returns (uint256) {
        return rmul(amount, pot.chi());
    }

    function viewNumeraireBalance (address addr) public view returns (uint256) {
        uint256 rate = cdai.exchangeRateStored();
        uint256 balance = cdai.balanceOf(addr);
        return wmul(balance, rate);
    }

    // takes chai amount
    // tells corresponding numeraire value
    function getNumeraireAmount (uint256 amount) public returns (uint256) {
        uint chi = (now > pot.rho()) ? pot.drip() : pot.chi();
        return rmul(amount, chi);
    }

    function getRawAmount (uint256 amount) public returns (uint256) {
        uint chi = (now > pot.rho())
          ? pot.drip()
          : pot.chi();
        return rdivup(amount, chi);
    }

    // tells numeraire balance
    function getNumeraireBalance () public returns (uint256) {
        return cdai.balanceOfUnderlying(address(this));
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