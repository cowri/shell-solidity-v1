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

import "../../../LoihiRoot.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

import "../../../interfaces/ICToken.sol";

import "../../../interfaces/IAssimilator.sol";

contract LocalCUsdcToCUsdcAssimilator is IAssimilator, LoihiRoot {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    constructor (address _cusdc) public {

        cusdc = ICToken(_cusdc);

    }

    // takes raw cusdc amount and transfers it in
    function intakeRaw (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        cusdc.transferFrom(msg.sender, address(this), _amount);

        uint256 _rate = cusdc.exchangeRateStored();

        uint256 _balance = cusdc.balanceOf(address(this));

        amount_ = ( ( _amount * _rate ) / 1e18 ).divu(1e6);

        balance_ = ( ( _balance * _rate ) / 1e18 ).divu(1e6);

    }

    // takes numeraire amount and transfers corresponding cusdc in
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        uint256 _rate = cusdc.exchangeRateStored();

        amount_ = ( _amount.mulu(1e6) * 1e18 ) / _rate;

        cusdc.transferFrom(msg.sender, address(this), amount_);

    }

    // takes numeraire amount
    // transfers corresponding cusdc to destination
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        uint256 _rate = cusdc.exchangeRateStored();

        amount_ = ( _amount.mulu(1e6) * 1e18 ) / _rate;

        cusdc.transfer(_dst, amount_);

    }

    // takes raw amount
    // transfers that amount to destination
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_, int128 balance_) {

        uint256 _balanceBefore = cusdc.balanceOf(address(this));

        cusdc.transfer(_dst, _amount);

        uint256 _rate = cusdc.exchangeRateStored();

        uint256 _balance = cusdc.balanceOf(address(this));

        amount_ = ( ( _amount * _rate ) / 1e18 ).divu(1e6);

        balance_ = ( ( _balance * _rate ) / 1e18 ).divu(1e6);

    }

    // takes raw amount of cUsdc, returns numeraire amount
    function viewRawAmount (int128 _amount) public returns (uint256 amount_) {

        uint256 _rate = cusdc.exchangeRateStored();

        amount_ = ( ( _amount.mulu(1e6) * 1e18 ) / _rate );

    }

    // takes numeraire amount, returns raw amount of cUsdc
    function viewNumeraireAmount (uint256 _amount) public returns (int128 amount_) {

        uint256 _rate = cusdc.exchangeRateStored();

        amount_ = ( ( _amount * _rate ) / 1e18 ).divu(1e6);

    }

    // returns numeraire balance of reserve, in this case cUsdc
    function viewNumeraireBalance (address _addr) public returns (int128 balance_) {

        uint256 _rate = cusdc.exchangeRateStored();

        uint256 _balance = cusdc.balanceOf(_addr);

        if (_balance == 0) return ABDKMath64x64.fromUInt(0);

        balance_ = ( ( _balance * _rate ) / 1e18 ).divu(1e6);

    }

}