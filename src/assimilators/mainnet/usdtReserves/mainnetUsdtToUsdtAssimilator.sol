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

import "../../../interfaces/IERC20NoBool.sol";

import "../../../interfaces/IAssimilator.sol";

contract MainnetUsdtToUsdtAssimilator is IAssimilator {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    IERC20NoBool constant usdt = IERC20NoBool(0xdAC17F958D2ee523a2206206994597C13D831ec7);

    constructor () public { }

    // takes raw amount, transfers it in, wraps that in aUsdt, returns numeraire amount
    function intakeRawAndGetBalance (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        safeTransferFrom(usdt, msg.sender, address(this), _amount);

        uint256 _balance = usdt.balanceOf(address(this));

        amount_ = _amount.divu(1e6);

        balance_ = _balance.divu(1e6);

    }

    // takes raw amount, transfers it in, wraps that in aUsdt, returns numeraire amount
    function intakeRaw (uint256 _amount) public returns (int128 amount_) {

        safeTransferFrom(usdt, msg.sender, address(this), _amount);

        amount_ = _amount.divu(1e6);

    }

    // takes numeraire amount, calculates raw amount, transfers that in, wraps it in aUsdt, returns raw amount
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e6);

        safeTransferFrom(usdt, msg.sender, address(this), amount_);

    }

    // takes raw amount, redeems that from aUsdt, transfers it out, returns numeraire amount
    function outputRawAndGetBalance (address _dst, uint256 _amount) public returns (int128 amount_, int128 balance_) {

        safeTransfer(usdt, _dst, _amount);

        uint256 _balance = usdt.balanceOf(address(this));

        balance_ = _balance.divu(1e6);

        amount_ = _amount.divu(1e6);

    }

    // takes raw amount, redeems that from aUsdt, transfers it out, returns numeraire amount
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_) {

        safeTransfer(usdt, _dst, _amount);

        amount_ = _amount.divu(1e6);

    }

    // takes numeraire amount, calculates raw amount, redeems that from aUsdt, transfers it out, returns raw amount
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e6);

        safeTransfer(usdt, _dst, amount_);

    }

    // takes numeraire amount, returns raw amount
    function viewRawAmount (int128 _amount) public view returns (uint256 amount_) {

        amount_ = _amount.mulu(1e6);

    }

    // takes raw amount, returns numeraire amount
    function viewNumeraireAmount (uint256 _amount) public view returns (int128 amount_) {

        amount_ = _amount.divu(1e6);

    }

    // takes raw amount, returns numeraire amount
    function viewNumeraireAmountAndBalance (address _addr, uint256 _amount) public view returns (int128 amount_, int128 balance_) {

        uint256 _balance = usdt.balanceOf(_addr);

        amount_ = _amount.divu(1e6);

        balance_ = _balance.divu(1e6);

    }

    // returns numeraire amount of reserve asset, in this case aUSDT
    function viewNumeraireBalance (address _addr) public view returns (int128 balance_) {

        uint256 _balance = usdt.balanceOf(_addr);

        balance_ = _balance.divu(1e6);

    }

    function safeTransfer(IERC20NoBool token, address to, uint256 value) internal {

        callOptionalReturn(address(token), abi.encodeWithSelector(token.transfer.selector, to, value));

    }

    function safeTransferFrom(IERC20NoBool token, address from, address to, uint256 value) internal {

        callOptionalReturn(address(token), abi.encodeWithSelector(token.transferFrom.selector, from, to, value));

    }

    function callOptionalReturn(address token, bytes memory data) private {

        (bool success, bytes memory returnData) = token.call(data);

        assembly { if eq(success, 0) { revert(add(returnData, 0x20), returndatasize) } }

    }
}