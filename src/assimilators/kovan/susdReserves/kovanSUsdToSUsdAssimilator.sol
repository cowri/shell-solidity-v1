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

import "../../../interfaces/IERC20.sol";

import "../../../interfaces/IAssimilator.sol";

contract KovanSUsdToSUsdAssimilator is IAssimilator {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    IERC20 constant susd = IERC20(0xD868790F57B39C9B2B51b12de046975f986675f9);

    constructor () public { }

    function intakeRawAndGetBalance (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        bool _success = susd.transferFrom(msg.sender, address(this), _amount);

        require(_success, "Shell/SUSD-transfer-from-failed");

        uint256 _balance = susd.balanceOf(address(this));

        balance_ = _balance.divu(1e6);

        amount_ = _amount.divu(1e6);

    }

    function intakeRaw (uint256 _amount) public returns (int128 amount_) {

        bool _success = susd.transferFrom(msg.sender, address(this), _amount);

        require(_success, "Shell/SUSD-transfer-from-failed");

        amount_ = _amount.divu(1e6);

    }

    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        // truncate stray decimals caused by conversion
        amount_ = _amount.mulu(1e6) / 1e3 * 1e3;

        bool _success = susd.transferFrom(msg.sender, address(this), amount_);

        require(_success, "Shell/SUSD-transfer-from-failed");

    }

    function outputRawAndGetBalance (address _dst, uint256 _amount) public returns (int128 amount_, int128 balance_) {

        bool _success = susd.transfer(_dst, _amount);

        require(_success, "Shell/SUSD-transfer-failed");

        uint256 _balance = susd.balanceOf(address(this));

        amount_ = _amount.divu(1e6);

        balance_ = _balance.divu(1e6);

    }

    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_) {

        bool _success = susd.transfer(_dst, _amount);

        require(_success, "Shell/SUSD-transfer-failed");

        amount_ = _amount.divu(1e6);

    }

    // takes numeraire amount, transfers to destination, returns raw amount
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e6);

        bool _success = susd.transfer(_dst, amount_);

        require(_success, "Shell/SUSD-transfer-failed");

    }

    // takes numeraire amount, returns raw amount
    function viewRawAmount (int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e6);

    }

    // takes raw amount, returns numeraire amount
    function viewNumeraireAmount (uint256 _amount) public returns (int128 amount_) {

        amount_ = _amount.divu(1e6);

    }

    // takes raw amount, returns numeraire amount
    function viewNumeraireAmountAndBalance (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        amount_ = _amount.divu(1e6);

        uint256 _balance = susd.balanceOf(address(this));

        balance_ = _balance.divu(1e6);

    }

    // returns numeraire value of reserve asset, in this case ASUsd
    function viewNumeraireBalance (address _addr) public returns (int128 balance_) {

        uint256 _balance = susd.balanceOf(_addr);

        balance_ = _balance.divu(1e6);

    }

}