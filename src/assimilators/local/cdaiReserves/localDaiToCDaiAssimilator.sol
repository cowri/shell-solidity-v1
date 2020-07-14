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

import "../../../Loihi.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

import "../../../interfaces/ICToken.sol";

import "../../../interfaces/IAssimilator.sol";

contract LocalDaiToCDaiAssimilator is IAssimilator, Loihi {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    constructor (address _dai, address _cdai) public {

        dai = IERC20(_dai);

        cdai = ICToken(_cdai);

    }

    event log_uint(bytes32, uint256);
    event log_int(bytes32, int256);

    // transfers raw amonut of dai in, wraps it in cDai, returns numeraire amount
    function intakeRaw (uint256 _amount) public returns (int128 amount_) {

        uint256 gas = gasleft();

        dai.transferFrom(msg.sender, address(this), _amount);

        uint256 _rate = cdai.exchangeRateStored();

        cdai.mint(_amount);

        // convert numeraire amount into cdai amount and back
        // provides precise dai amount as was understood by compound
        amount_ = ( ( ( ( _amount * 1e18 ) / _rate / 1e2 * 1e2 ) * _rate ) / 1e18 ).divu(1e18);

    }

    // transfers raw amonut of dai in, wraps it in cDai, returns numeraire amount
    function intakeRawAndGetBalance (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        uint256 gas = gasleft();

        dai.transferFrom(msg.sender, address(this), _amount);

        uint256 _rate = cdai.exchangeRateStored();

        cdai.mint(_amount);

        uint256 _balance = cdai.balanceOf(address(this));

        // convert numeraire amount into cdai amount and back
        // provides precise dai amount as was understood by compound
        amount_ = ( ( ( ( _amount * 1e18 ) / _rate / 1e2 * 1e2 ) * _rate ) / 1e18 ).divu(1e18);

        // convert cdai balance into numeraire amount
        balance_ = ( ( ( _balance / 1e2 * 1e2 ) * _rate ) / 1e18 ).divu(1e18);

        emit log_uint("gas", gas-gasleft());

    }

    // transfers numeraire amount of dai in, wraps it in cDai, returns raw amount
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

        dai.transferFrom(msg.sender, address(this), amount_);

        cdai.mint(amount_);

    }

    // takes raw amount of dai, unwraps that from cDai, transfers it out, returns numeraire amount
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_) {

        cdai.redeemUnderlying(_amount);

        dai.transfer(_dst, _amount);

        amount_ = _amount.divu(1e18);

    }

    // takes raw amount of dai, unwraps that from cDai, transfers it out, returns numeraire amount
    function outputRawAndGetBalance (address _dst, uint256 _amount) public returns (int128 amount_, int128 balance_) {

        cdai.redeemUnderlying(_amount);

        uint256 _balance = cdai.balanceOf(address(this));

        uint256 _rate = cdai.exchangeRateStored();

        dai.transfer(_dst, _amount);

        amount_ = _amount.divu(1e18);

        balance_ = ( ( _balance * _rate ) / 1e18 ).divu(1e18);

    }

    // takes numeraire amount of dai, unwraps corresponding amount of cDai, transfers that out, returns numeraire amount
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

        cdai.redeemUnderlying(amount_);

        dai.transfer(_dst, amount_);

        return amount_;

    }

    // takes numeraire amount and returns raw amount
    function viewRawAmount (int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

    }

    // takes raw amount and returns numeraire amount
    function viewNumeraireAmount (uint256 _amount) public returns (int128 amount_) {

        amount_ = _amount.divu(1e18);

    }

    // returns current balance in numeraire
    function viewNumeraireBalance (address _addr) public returns (int128 balance_) {

        uint256 _rate = cdai.exchangeRateStored();

        uint256 _balance = cdai.balanceOf(address(this));

        if (_balance == 0) return ABDKMath64x64.fromUInt(0);

        balance_ = ( ( _balance * _rate ) / 1e18 ).divu(1e18);

    }

    // takes raw amount and returns numeraire amount
    function viewNumeraireAmountAndBalance (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        amount_ = _amount.divu(1e18);

        uint256 _rate = cdai.exchangeRateStored();

        uint256 _balance = cdai.balanceOf(address(this));

        if (_balance == 0) return (amount_, ABDKMath64x64.fromUInt(0));

        balance_ = ( ( _balance * _rate ) / 1e18 ).divu(1e18);

    }

}