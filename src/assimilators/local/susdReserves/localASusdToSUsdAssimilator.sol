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

import "abdk-libraries-solidity/ABDKMath64x64.sol";

import "../../../interfaces/IAToken.sol";

import "../../../LoihiRoot.sol";

contract LocalASUsdToSUsdAssimilator is LoihiRoot {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    constructor (address _susd, address _asusd) public {

        susd = IERC20(_susd);

        asusd = IAToken(_asusd);

    }

    function getASUsd () public view returns (IAToken) {

        return asusd;

    }

    // intakes raw amount of ASUsd and returns the corresponding raw amount
    function intakeRaw (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        asusd.transferFrom(msg.sender, address(this), _amount);

        asusd.redeem(_amount);

        uint256 _balance = susd.balanceOf(address(this));

        amount_ = _amount.divu(1e18);

        balance_ = _balance.divu(1e18);

    }

    // intakes a numeraire amount of ASUsd and returns the corresponding raw amount
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

        asusd.transferFrom(msg.sender, address(this), amount_);

        asusd.redeem(amount_);

    }

    // outputs a raw amount of ASUsd and returns the corresponding numeraire amount
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_, int128 balance_) {

        asusd.deposit(_amount);

        asusd.transfer(_dst, _amount);

        uint256 _balance = susd.balanceOf(address(this));

        amount_ = _amount.divu(1e18);

        balance_ = _balance.divu(1e18);

    }

    // outputs a numeraire amount of ASUsd and returns the corresponding numeraire amount
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

        asusd.deposit(amount_);

        asusd.transfer(_dst, amount_);

    }

    // takes a numeraire amount and returns the raw amount
    function viewRawAmount (int128 _amount) public view returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

    }

    // takes a raw amount and returns the numeraire amount
    function viewNumeraireAmount (uint256 _amount) public view returns (int128 amount_) {

        amount_ = _amount.divu(1e18);

    }

    // views the numeraire value of the current balance of the reserve, in this case ASUsd
    function viewNumeraireBalance (address _addr) public view returns (int128 amount_) {

        uint256 _balance = susd.balanceOf(_addr);

        amount_ = _balance.divu(1e18);

    }

}