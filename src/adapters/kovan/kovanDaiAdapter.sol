
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

contract KovanDaiAdapter {

    constructor () public { }

    ICToken constant cdai = ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c);
    IERC20 constant dai = IERC20(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa);

    // transfers dai in
    // wraps it in chai
    function intakeRaw (uint256 amount) public {
        
        dai.transferFrom(msg.sender, address(this), amount);
        cdai.mint(amount);
        
    }

    // transfers dai in
    // wraps it in cdai
    function intakeNumeraire (uint256 amount) public returns (uint256) {
        
        dai.transferFrom(msg.sender, address(this), amount);
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

    function viewRawAmount (uint256 amount) public pure returns (uint256) {
        return amount;
    }

    function viewNumeraireAmount (uint256 amount) public pure returns (uint256) {
        return amount;
    }

    function viewNumeraireBalance (address addr) public view returns (uint256) {
        uint256 rate = cdai.exchangeRateStored();
        uint256 balance = cdai.balanceOf(addr);
        return wmul(balance, rate);
    }

    function getRawAmount (uint256 amount) public pure returns (uint256) {
        return amount;
    }

    // returns amount, already in numeraire
    function getNumeraireAmount (uint256 amount) public pure returns (uint256) {
        return amount;
    }

    // returns numeraire amount of chai balance
    function getNumeraireBalance () public returns (uint256) {
        
        return cdai.balanceOfUnderlying(address(this));
        
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