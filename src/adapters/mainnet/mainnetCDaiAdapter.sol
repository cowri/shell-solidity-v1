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

import "../../interfaces/ICToken.sol";
import "../AssimilatorMath.sol";

contract MainnetCDaiAdapter {

    using AssimilatorMath for uint;

    uint256 constant ZEN_DELTA = 1e12;

    ICToken constant cdai = ICToken(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);

    constructor () public { }

    function toZen (uint256 _amount, uint256 _rate) internal pure returns (int128 zenAmt_) {

        zenAmt_ = (_amount.wmul(_rate) / ZEN_DELTA).fromUInt();

    }

    function fromZen (int128 _zenAmt, uint256 _rate) internal pure returns (uint256 amount_) {

        amount_ = (_zenAmt.toUInt() * ZEN_DELTA).wdiv(_rate);

    }

    // takes raw cdai amount, transfers it in, calculates corresponding numeraire amount and returns it
    function intakeRaw (uint256 _amount) public returns (int128 amount_) {

        bool success = cdai.transferFrom(msg.sender, address(this), _amount);

        if (!success) revert("CDai/transferFrom-failed");

        uint256 rate = cdai.exchangeRateStored();

        amount_ = toZen(amount, rate);

    }

    // takes a numeraire amount, calculates the raw amount of cDai, transfers it in and returns the corresponding raw amount
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        uint256 _rate = cdai.exchangeRateCurrent();

        amount_ = fromZen(_amount, _rate);

        bool success = cdai.transferFrom(msg.sender, address(this), _amount);

        if (!success) revert("CDai/transferFrom-failed");

    }

    // takes a raw amount of cDai and transfers it out, returns numeraire value of the raw amount
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_) {

        bool success = cdai.transfer(msg.sender, _amount);

        if (!success) revert("CDai/transfer-failed");

        uint256 _rate = cdai.exchangeRateStored();

        amount_ = toZen(_amount, _rate);

    }

    // takes a numeraire value of CDai, figures out the raw amount, transfers raw amount out, and returns raw amount
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        uint _rate = cdai.exchangeRateCurrent();

        amount_ = fromZen(_amount, _rate);

        bool success = cdai.transfer(dst, amount_);

        if (!success) revert("CDai/transfer-failed");

    }

    // takes a numeraire amount and returns the raw amount
    function viewRawAmount (int128 _amount) public view returns (uint256 amount_) {

        uint256 _rate = cdai.exchangeRateStored();

        amount_ = fromZen(_amount, _rate);

    }

    // takes a raw amount and returns the numeraire amount
    function viewNumeraireAmount (uint256 _amount) public view returns (int128 amount_) {

        uint256 _rate = cdai.exchangeRateStored();

        amount_ = toZen(_amount, _rate);

    }

    // views the numeraire value of the current balance of the reserve, in this case CDai
    function viewNumeraireBalance () public view returns (int128 amount_) {

        uint256 _rate = cdai.exchangeRateStored();

        uint256 _balance = cdai.balanceOf(addr);

        if (balance == 0) return ABDKMath64x64.fromUInt(0);

        amount_ = toZen(_balance, _rate);

    }

}