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

import "../../../interfaces/IAssimilator.sol";

import "../../../interfaces/ICToken.sol";

contract LocalCDaiToDaiAssimilator is IAssimilator, LoihiRoot {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    constructor (address _dai, address _cdai) public {

        dai = IERC20(_dai);

        cdai = ICToken(_cdai);

    }

    // takes raw cdai amount, transfers it in, calculates corresponding numeraire amount and returns it
    function intakeRawAndGetBalance (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        cdai.transferFrom(msg.sender, address(this), _amount);

        uint256 _rate = cdai.exchangeRateStored();

        _amount = ( _amount * _rate ) / 1e18;

        cdai.redeemUnderlying(_amount);

        uint256 _balance = dai.balanceOf(address(this));

        balance_ = _balance.divu(1e18);

        amount_ = _amount.divu(1e18);

    }

    // takes raw cdai amount, transfers it in, calculates corresponding numeraire amount and returns it
    function intakeRaw (uint256 _amount) public returns (int128 amount_) {

        cdai.transferFrom(msg.sender, address(this), _amount);

        uint256 _rate = cdai.exchangeRateStored();

        _amount = ( _amount * _rate ) / 1e18;

        cdai.redeemUnderlying(_amount);

        amount_ = _amount.divu(1e18);

    }

    event log_uint(bytes32, uint256);

    // takes a numeraire amount, calculates the raw amount of cDai, transfers it in and returns the corresponding raw amount
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        uint256 _rate = cdai.exchangeRateStored();

        amount_ = ( _amount.mulu(1e18) * 1e18 ) / _rate;

        cdai.transferFrom(msg.sender, address(this), amount_);

        cdai.redeem(amount_);

    }

    // takes a raw amount of cDai and transfers it out, returns numeraire value of the raw amount
    function outputRawAndGetBalance (address _dst, uint256 _amount) public returns (int128 amount_, int128 balance_) {

        uint256 _rate = cdai.exchangeRateStored();

        uint256 _daiAmount = ( _amount * _rate ) / 1e18;

        cdai.mint(_daiAmount);

        cdai.transfer(_dst, _amount);

        uint256 _balance = dai.balanceOf(address(this));

        amount_ = _daiAmount.divu(1e18);

        balance_ = _balance.divu(1e18);

    }

    // takes a raw amount of cDai and transfers it out, returns numeraire value of the raw amount
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_) {

        uint256 _rate = cdai.exchangeRateStored();

        uint256 _daiAmount = ( _amount * _rate ) / 1e18;

        cdai.mint(_daiAmount);

        cdai.transfer(_dst, _amount);

        amount_ = _daiAmount.divu(1e18);

    }

    // takes a numeraire value of CDai, figures out the raw amount, transfers raw amount out, and returns raw amount
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

        cdai.mint(amount_);

        uint _rate = cdai.exchangeRateStored();

        amount_ = ( ( amount_ * 1e18 ) / _rate );

        cdai.transfer(_dst, amount_);

    }

    // takes a numeraire amount and returns the raw amount
    function viewRawAmount (int128 _amount) public returns (uint256 amount_) {

        uint256 _rate = cdai.exchangeRateStored();

        amount_ = ( _amount.mulu(1e18) * 1e18 ) / _rate;

    }

    // takes a raw amount and returns the numeraire amount
    function viewNumeraireAmount (uint256 _amount) public returns (int128 amount_) {

        uint256 _rate = cdai.exchangeRateStored();

        amount_ = ( ( _amount * _rate ) / 1e18 ).divu(1e18);

    }

    // views the numeraire value of the current balance of the reserve, in this case CDai
    function viewNumeraireBalance () public returns (int128 balance_) {

        uint256 _balance = dai.balanceOf(address(this));

        if (_balance == 0) return ABDKMath64x64.fromUInt(0);

        balance_ = _balance.divu(1e18);

    }

    // views the numeraire value of the current balance of the reserve, in this case CDai
    function viewNumeraireAmountAndBalance (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        uint256 _rate = cdai.exchangeRateStored();

        amount_ = ( ( _amount * _rate ) / 1e18 ).divu(1e18);

        uint256 _balance = dai.balanceOf(address(this));

        if (_balance == 0) return ( amount_, ABDKMath64x64.fromUInt(0));

        balance_ = _balance.divu(1e18);

    }

}