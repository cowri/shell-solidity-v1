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

contract KovanWBtcToWBtcAssimilator is IAssimilator {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    IERC20 constant wbtc = IERC20(0xe0C9275E44Ea80eF17579d33c55136b7DA269aEb);

    constructor () public { }

    // transfers raw amonut of wbtc in, wraps it in cDai, returns numeraire amount
    function intakeRawAndGetBalance (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        bool _success = wbtc.transferFrom(msg.sender, address(this), _amount);

        require(_success, "Shell/wBTC-transfer-from-failed");

        uint256 _balance = wbtc.balanceOf(address(this));

        amount_ = _amount.divu(1e8);

        balance_ = _balance.divu(1e8);

    }

    // transfers raw amonut of wbtc in, wraps it in cDai, returns numeraire amount
    function intakeRaw (uint256 _amount) public returns (int128 amount_) {

        bool _success = wbtc.transferFrom(msg.sender, address(this), _amount);

        require(_success, "Shell/wBTC-transfer-from-failed");

        amount_ = _amount.divu(1e8);

    }

    event log_int(bytes32, int);

    // transfers numeraire amount of wbtc in, wraps it in cDai, returns raw amount
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        // truncate stray decimals caused by conversion
        amount_ = _amount.mulu(1e8) / 1e3 * 1e3;

        bool _success = wbtc.transferFrom(msg.sender, address(this), amount_);

        require(_success, "Shell/wBTC-transfer-from-failed");

    }

    // takes raw amount of wbtc, unwraps that from cDai, transfers it out, returns numeraire amount
    function outputRawAndGetBalance (address _dst, uint256 _amount) public returns (int128 amount_, int128 balance_) {

        bool _success = wbtc.transfer(_dst, _amount);

        require(_success, "Shell/wBTC-transfer-failed");

        uint256 _balance = wbtc.balanceOf(address(this));

        amount_ = _amount.divu(1e8);

        balance_ = _balance.divu(1e8);

    }

    // takes raw amount of wbtc, unwraps that from cDai, transfers it out, returns numeraire amount
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_) {

        bool _success = wbtc.transfer(_dst, _amount);

        require(_success, "Shell/wBTC-transfer-failed");

        amount_ = _amount.divu(1e8);

    }

    // takes numeraire amount of wbtc, unwraps corresponding amount of cDai, transfers that out, returns numeraire amount
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e8);

        bool _success = wbtc.transfer(_dst, amount_);

        require(_success, "Shelll/wBTC-transfer-failed");

        return amount_;

    }

    // takes numeraire amount and returns raw amount
    function viewRawAmount (int128 _amount) public view returns (uint256 amount_) {

        amount_ = _amount.mulu(1e8);

    }

    // takes raw amount and returns numeraire amount
    function viewNumeraireAmount (uint256 _amount) public view returns (int128 amount_) {

        amount_ = _amount.divu(1e8);

    }

    event log_addr(bytes32, address);
    event log_uint(bytes32, uint);

    // returns current balance in numeraire
    function viewNumeraireBalance (address _addr) public view returns (int128 balance_) {

        uint256 _balance = wbtc.balanceOf(_addr);

        balance_ = _balance.divu(1e8);

    }

    // takes raw amount and returns numeraire amount
    function viewNumeraireAmountAndBalance (address _addr, uint256 _amount) public view returns (int128 amount_, int128 balance_) {

        amount_ = _amount.divu(1e8);

        uint256 _balance = wbtc.balanceOf(_addr);

        balance_ = _balance.divu(1e8);

    }

}