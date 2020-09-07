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

import "../../../LoihiStorage.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

import "../../../interfaces/IAToken.sol";

import "../../../interfaces/IAssimilator.sol";

contract LocalSUsdToASUsdAssimilator is IAssimilator, LoihiStorage {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    constructor (address _susd, address _asusd) public {

        susd = IERC20(_susd);

        asusd = IAToken(_asusd);

    }

    function getASUsd () public view returns (IAToken) {

        return asusd;

    }

    // takes raw amount, transfers it in, wraps it in asusd, returns numeraire amount
    function intakeRaw (uint256 _amount) public returns (int128 amount_) {

        susd.transferFrom(msg.sender, address(this), _amount);

        asusd.deposit(_amount);

        amount_ = _amount.divu(1e18);

    }

    // takes raw amount, transfers it in, wraps it in asusd, returns numeraire amount
    function intakeRawAndGetBalance (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        susd.transferFrom(msg.sender, address(this), _amount);

        asusd.deposit(_amount);

        uint256 _balance = asusd.balanceOf(address(this));

        balance_ = _balance.divu(1e18);

        amount_ = _amount.divu(1e18);

    }

    // takes numeraire amount of susd, transfers it in, wraps it in asusd, returns raw amount
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

        susd.transferFrom(msg.sender, address(this), amount_);

        asusd.deposit(amount_);


    }

    // takes raw amount, transfers to destination, returns numeraire amount
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_) {

        asusd.redeem(_amount);

        susd.transfer(_dst, _amount);

        amount_ = _amount.divu(1e18);

    }

    // takes raw amount, transfers to destination, returns numeraire amount
    function outputRawAndGetBalance (address _dst, uint256 _amount) public returns (int128 amount_, int128 balance_) {

        asusd.redeem(_amount);

        susd.transfer(_dst, _amount);

        uint256 _balance = asusd.balanceOf(address(this));

        amount_ = _amount.divu(1e18);

        balance_ = _balance.divu(1e18);

    }

    // takes numeraire amount, transfers to destination, returns raw amount
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

        getASUsd().redeem(amount_);

        susd.transfer(_dst, amount_);

    }

    // takes numeraire amount, returns raw amount
    function viewRawAmount (int128 _amount) public view returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

    }

    // takes raw amount, returns numeraire amount
    function viewNumeraireAmount (uint256 _amount) public view returns (int128 amount_) {

        amount_ = _amount.divu(1e18);

    }

    // returns numeraire value of reserve asset, in this case ASUsd
    function viewNumeraireBalance (address _addr) public view returns (int128 balance_) {

        uint256 _balance = getASUsd().balanceOf(_addr);

        balance_ = _balance.divu(1e18);

    }

    // takes raw amount, returns numeraire amount
    function viewNumeraireAmountAndBalance (address _addr, uint256 _amount) public view returns (int128 amount_, int128 balance_) {

        amount_ = _amount.divu(1e18);

        uint256 _balance = getASUsd().balanceOf(_addr);

        balance_ = _balance.divu(1e18);

    }

}