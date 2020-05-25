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

import "abdk-libraries-solidity/ABDKMath64x64.sol";

contract MainnetCUsdcAdapter {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;
    using AssimilatorMath for uint;

    uint256 constant ZEN_DELTA = 1e6;

    ICToken constant cusdc = ICToken(0x39AA39c021dfbaE8faC545936693aC917d5E7563);

    constructor () public { }

    function toZen (uint256 _amount, uint256 _rate) internal pure returns (int128 amount_) {

        amount_ = _amount.wmul(_rate).fromUInt().divu(ZEN_DELTA);

    }

    function fromZen (int128 _amount, uint256 _rate) internal pure returns (uint256 amount_) {

        amount_ = _amount.mulu(ZEN_DELTA).toUInt().wdiv(_rate);

    }

    // takes raw cusdc amount and transfers it in
    function intakeRaw (uint256 _amount) public returns (int128 amount_) {

        bool success = cusdc.transferFrom(msg.sender, address(this), _amount);

        if (!success) revert("CUsdc/transferFrom-failed");

        uint256 _rate = cusdc.exchangeRateCurrent();

        amount_ = toZen(_amount, _rate);

    }

    // takes numeraire amount and transfers corresponding cusdc in
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        uint256 _rate = cusdc.exchangeRateCurrent();

        amount_ = fromZen(_amount, _rate);

        bool success = cusdc.transferFrom(msg.sender, address(this), amount_);

        if (!success) revert("CUsdc/transferFrom-failed");

    }

    // takes numeraire amount
    // transfers corresponding cusdc to destination
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        uint256 _rate = cusdc.exchangeRateCurrent();

        amount_ = fromZen(_amount, _rate);

        bool success = cusdc.transfer(_dst, amount_);

        if (!success) revert("CUsdc/transfer-failed");

    }

    // takes raw amount
    // transfers that amount to destination
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_) {

        bool success = cusdc.transfer(_dst, _amount);

        if (!success) revert("CUsdc/transfer-failed");

        uint256 _rate = cusdc.exchangeRateStored();

        amount_ = toZen(_amount, _rate);

    }

    // takes raw amount of cUsdc, returns numeraire amount
    function viewRawAmount (int128 _amount) public view returns (uint256 amount_) {

        uint256 _rate = cusdc.exchangeRateStored();

        amount_ = fromZen(_amount, _rate);

    }

    // takes numeraire amount, returns raw amount of cUsdc
    function viewNumeraireAmount (uint256 _amount) public view returns (int128 amount_) {

        uint256 _rate = cusdc.exchangeRateStored();

        amount_ = toZen(_amount, _rate);

    }

    // returns numeraire balance of reserve, in this case cUsdc
    function viewNumeraireBalance () public view returns (int128 amount_) {

        uint256 _rate = cusdc.exchangeRateStored();

        uint256 _balance = cusdc.balanceOf(address(this));

        if (_balance == 0) return ABDKMath64x64.fromUInt(0);

        amount_ = toZen(_balance, _rate);

    }

}