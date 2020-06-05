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

contract LocalUsdcToUsdcAssimilator is LoihiRoot {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    constructor (address _usdc) public {

        usdc = IERC20(_usdc);

    }

    // takes raw amount of usdc, transfers it in, wraps it in cusdc, returns numeraire amount
    function intakeRaw (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        usdc.transferFrom(msg.sender, address(this), _amount);

        uint256 _balance = usdc.balanceOf(address(this));

        amount_ = _amount.divu(1e6);

        balance_ = _balance.divu(1e6);

    }

    // takes numeraire amount of usdc, calculates raw amount, transfers it in and wraps it in cusdc, returns raw amount
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e6);

        usdc.transferFrom(msg.sender, address(this), amount_);

    }

    // takes raw amount of usdc, unwraps it from cusdc, transfers that out, returns numeraire amount
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_, int128 balance_) {

        cusdc.redeemUnderlying(_amount);

        usdc.transfer(_dst, _amount);

        uint256 _balance = usdc.balanceOf(address(this));

        amount_ = _amount.divu(1e6);

        balance_ = _balance.divu(1e6);

    }

    // takes numeraire amount of usdc, calculates raw amount, unwraps raw amount of cusdc, transfers that out, returns raw amount
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e6);

        usdc.transfer(_dst, amount_);

    }

    // takes numeraire amount, returns raw amount
    function viewRawAmount (int128 _amount) public view returns (uint256 amount_) {

        amount_ = _amount.mulu(1e6);

    }

    // takes raw amount, returns numeraire amount
    function viewNumeraireAmount (uint256 _amount) public pure returns (int128 amount_) {

        amount_ = _amount.divu(1e6);

    }

    // returns numeraire amount of reserve asset, in this case cUsdc
    function viewNumeraireBalance (address _addr) public view returns (int128 balance_) {

        uint256 _balance = usdc.balanceOf(_addr);

        if (_balance == 0) return ABDKMath64x64.fromUInt(0);

        balance_ = _balance.divu(1e6);

    }

}