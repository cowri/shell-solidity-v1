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

pragma solidity ^0.5.17;

import "../../../Loihi.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

import "../../../interfaces/ICToken.sol";

import "../../../interfaces/IAssimilator.sol";

contract LocalCUsdcToUsdcAssimilator is IAssimilator, Loihi {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    constructor (address _usdc, address _cusdc) public {

        usdc = IERC20(_usdc);

        cusdc = ICToken(_cusdc);

    }

    // takes raw cusdc amount and transfers it in
    function intakeRawAndGetBalance (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        cusdc.transferFrom(msg.sender, address(this), _amount);

        uint256 _rate = cusdc.exchangeRateStored();

        _amount = ( _amount * _rate ) / 1e18;

        cusdc.redeemUnderlying(_amount);

        uint256 _balance = usdc.balanceOf(address(this));

        amount_ = _amount.divu(1e6);

        balance_ = _balance.divu(1e6);

    }

    // takes raw cusdc amount and transfers it in
    function intakeRaw (uint256 _amount) public returns (int128 amount_) {

        cusdc.transferFrom(msg.sender, address(this), _amount);

        uint256 _rate = cusdc.exchangeRateStored();

        _amount = ( _amount * _rate ) / 1e18;

        cusdc.redeemUnderlying(_amount);

        amount_ = _amount.divu(1e6);

    }

    // takes numeraire amount and transfers corresponding cusdc in
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        uint256 _rate = cusdc.exchangeRateStored();

        amount_ = ( _amount.mulu(1e6) * 1e18 ) / _rate;

        cusdc.transferFrom(msg.sender, address(this), amount_);

        cusdc.redeem(amount_);

    }

    // takes numeraire amount
    // transfers corresponding cusdc to destination
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e6);

        cusdc.mint(amount_);

        uint256 _rate = cusdc.exchangeRateStored();

        amount_ = ( amount_ * 1e18 ) / _rate;

        cusdc.transfer(_dst, amount_);

    }

    event log_uint(bytes32, uint256);

    // takes raw amount
    // transfers that amount to destination
    function outputRawAndGetBalance (address _dst, uint256 _amount) public returns (int128 amount_, int128 balance_) {

        uint256 _rate = cusdc.exchangeRateStored();

        uint256 _usdcAmount = ( _amount * _rate ) / 1e18;

        cusdc.mint(_usdcAmount);

        cusdc.transfer(_dst, _amount);

        uint256 _balance = usdc.balanceOf(address(this));

        amount_ = _usdcAmount.divu(1e6);

        balance_ = _balance.divu(1e6);

    }

    // takes raw amount
    // transfers that amount to destination
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_) {

        uint256 _rate = cusdc.exchangeRateStored();

        uint256 _usdcAmount = ( _amount * _rate ) / 1e18;

        cusdc.mint(_usdcAmount);

        cusdc.transfer(_dst, _amount);

        amount_ = _amount.divu(1e6);

    }

    // takes raw amount of cUsdc, returns numeraire amount
    function viewRawAmount (int128 _amount) public returns (uint256 amount_) {

        uint256 _rate = cusdc.exchangeRateStored();

        amount_ = ( _amount.mulu(1e6) * 1e18 ) / _rate;

    }

    // takes numeraire amount, returns raw amount of cUsdc
    function viewNumeraireAmount (uint256 _amount) public returns (int128 amount_) {

        uint256 _rate = cusdc.exchangeRateStored();

        amount_ = ( ( _amount * _rate ) / 1e18 ).divu(1e6);

    }

    // returns numeraire balance of reserve, in this case cUsdc
    function viewNumeraireBalance (address _addr) public returns (int128 balance_) {

        uint256 _balance = usdc.balanceOf(address(this));

        balance_ = _balance.divu(1e6);

    }

    // takes numeraire amount, returns raw amount of cUsdc
    function viewNumeraireAmountAndBalance (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        uint256 _rate = cusdc.exchangeRateStored();

        amount_ = ( ( _amount * _rate ) / 1e18 ).divu(1e6);

        uint256 _balance = usdc.balanceOf(address(this));

        balance_ = _balance.divu(1e6);

    }

}