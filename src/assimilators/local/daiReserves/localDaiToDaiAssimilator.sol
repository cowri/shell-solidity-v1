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

contract LocalDaiToDaiAssimilator is LoihiRoot {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    constructor (address _dai) public {

        dai = IERC20(_dai);

    }

    // transfers raw amonut of dai in, wraps it in cDai, returns numeraire amount
    function intakeRaw (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        dai.transferFrom(msg.sender, address(this), _amount);

        uint256 _balance = dai.balanceOf(address(this));

        amount_ = _amount.divu(1e18);

        balance_ = _balance.divu(1e18);

    }

    // transfers numeraire amount of dai in, wraps it in cDai, returns raw amount
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

        dai.transferFrom(msg.sender, address(this), amount_);

    }

    // takes raw amount of dai, unwraps that from cDai, transfers it out, returns numeraire amount
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_, int128 balance_) {

        dai.transfer(_dst, _amount);

        uint256 _balance = dai.balanceOf(address(this));

        amount_ = _amount.divu(1e18);

        balance_ = _balance.divu(1e18);

    }

    // takes numeraire amount of dai, unwraps corresponding amount of cDai, transfers that out, returns numeraire amount
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

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

        uint256 _balance = dai.balanceOf(_addr);

        balance_ = _balance.divu(1e18);

    }

}