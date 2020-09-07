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

contract LocalAUsdtToUsdtAssimilator is IAssimilator, LoihiStorage {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    constructor (address _usdt, address _ausdt) public {

        ausdt = IAToken(_ausdt);

        usdt = IERC20NoBool(_usdt);

    }

    // intakes raw amount of AUSsdt and returns the corresponding raw amount
    function intakeRawAndGetBalance (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        ausdt.transferFrom(msg.sender, address(this), _amount);

        ausdt.redeem(_amount);

        uint256 _balance = usdt.balanceOf(address(this));

        amount_ = _amount.divu(1e6);

        balance_ = _balance.divu(1e6);

    }

    // intakes a numeraire amount of AUsdt and returns the corresponding raw amount

    // intakes raw amount of AUSsdt and returns the corresponding raw amount
    function intakeRaw (uint256 _amount) public returns (int128 amount_) {

        ausdt.transferFrom(msg.sender, address(this), _amount);

        ausdt.redeem(_amount);

        amount_ = _amount.divu(1e6);

    }

    // intakes a numeraire amount of AUsdt and returns the corresponding raw amount
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e6);

        ausdt.transferFrom(msg.sender, address(this), amount_);

        ausdt.redeem(amount_);

    }

    // outputs a raw amount of AUsdt and returns the corresponding numeraire amount
    function outputRawAndGetBalance (address _dst, uint256 _amount) public returns (int128 amount_, int128 balance_) {

        ausdt.deposit(_amount);

        ausdt.transfer(_dst, _amount);

        uint256 _balance = usdt.balanceOf(address(this));

        amount_ = _amount.divu(1e6);

        balance_ = _balance.divu(1e6);

    }

    // outputs a raw amount of AUsdt and returns the corresponding numeraire amount
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_) {

        ausdt.deposit(_amount);

        ausdt.transfer(_dst, _amount);

        amount_ = _amount.divu(1e6);

    }

    // outputs a numeraire amount of AUsdt and returns the corresponding numeraire amount
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e6);

        ausdt.deposit(amount_);

        ausdt.transfer(_dst, amount_);

    }

    // takes a numeraire amount and returns the raw amount
    function viewRawAmount (int128 _amount) public view returns (uint256 amount_) {

        amount_ = _amount.mulu(1e6);

    }

    // takes a raw amount and returns the numeraire amount
    function viewNumeraireAmount (uint256 _amount) public view returns (int128 amount_) {

        amount_ = _amount.divu(1e6);

    }

    // views the numeraire value of the current balance of the reserve, in this case AUsdt
    function viewNumeraireBalance (address _addr) public view returns (int128 balance_) {

        uint256 _balance = usdt.balanceOf(_addr);

        balance_ = _balance.divu(1e6);

    }

    // takes a raw amount and returns the numeraire amount
    function viewNumeraireAmountAndBalance (address _addr, uint256 _amount) public view returns (int128 amount_, int128 balance_) {

        amount_ = _amount.divu(1e6);

        uint256 _balance = usdt.balanceOf(_addr);

        balance_ = _balance.divu(1e6);

    }


}