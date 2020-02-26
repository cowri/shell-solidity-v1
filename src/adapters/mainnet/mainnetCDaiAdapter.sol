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

pragma solidity ^0.5.12;

import "../../interfaces/ICToken.sol";

contract MainnetCDaiAdapter {

    constructor () public { }

    ICToken constant cdai = ICToken(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);

    // takes raw cdai amount
    // unwraps it into dai
    // deposits dai amount in chai
    function intakeRaw (uint256 amount) public returns (uint256) {

        cdai.transferFrom(msg.sender, address(this), amount);
        uint256 rate = cdai.exchangeRateStored();
        return wmul(amount, rate);

    }

    function intakeNumeraire (uint256 amount) public returns (uint256) {

        uint256 rate = cdai.exchangeRateCurrent();
        uint256 cdaiAmount = wdiv(amount, rate);
        cdai.transferFrom(msg.sender, address(this), cdaiAmount);
        return cdaiAmount;

    }

    function outputRaw (address dst, uint256 amount) public returns (uint256) {

        cdai.transfer(msg.sender, amount);
        uint256 rate = cdai.exchangeRateStored();
        return wmul(amount, rate);

    }

    // unwraps numeraire amount of dai from chai
    // wraps it into cdai amount
    // sends that to destination
    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {

        uint rate = cdai.exchangeRateCurrent();
        uint cdaiAmount = wdiv(amount, rate);
        cdai.transfer(dst, cdaiAmount);
        return cdaiAmount;

    }

    function viewRawAmount (uint256 amount) public view returns (uint256) {

        uint256 rate = cdai.exchangeRateStored();
        return wdiv(amount, rate);

    }

    function viewNumeraireAmount (uint256 amount) public view returns (uint256) {

        uint256 rate = cdai.exchangeRateStored();
        return wmul(amount, rate);

    }

    function viewNumeraireBalance (address addr) public view returns (uint256) {

        uint256 rate = cdai.exchangeRateStored();
        uint256 balance = cdai.balanceOf(addr);
        return wmul(balance, rate);

    }

    // takes raw amount and gives numeraire amount
    function getRawAmount (uint256 amount) public returns (uint256) {

        uint256 rate = cdai.exchangeRateCurrent();
        return wdiv(amount, rate);

    }

    // takes raw amount and gives numeraire amount
    function getNumeraireAmount (uint256 amount) public returns (uint256) {


        uint256 rate = cdai.exchangeRateCurrent();
        uint256 numeraireAmount = wmul(amount, rate);
        return numeraireAmount;

    }

    function getNumeraireBalance () public returns (uint256) {

        return cdai.balanceOfUnderlying(address(this));

    }

    uint constant WAD = 10 ** 18;
    
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
        z = add(mul(x, y), WAD) / WAD;
    }

    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, WAD), y / 2) / y;
    }

    function wdivup(uint x, uint y) internal pure returns (uint z) {
        // always rounds up
        z = add(mul(x, WAD), sub(y, 1)) / y;
    }

}