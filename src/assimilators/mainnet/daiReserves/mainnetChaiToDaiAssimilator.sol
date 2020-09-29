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

import "../../../interfaces/IChai.sol";

import "../../../interfaces/IPot.sol";

import "../../../interfaces/IERC20.sol";

import "../../../interfaces/IAssimilator.sol";

contract MainnetChaiToDaiAssimilator is IAssimilator {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    IChai constant chai = IChai(0x06AF07097C9Eeb7fD685c692751D5C66dB49c215);
    IERC20 constant dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    IPot constant pot = IPot(0x197E90f9FAD81970bA7976f33CbD77088E5D7cf7);

    constructor () public { }

    uint constant RAY = 1e27;

    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "ds-math-add-overflow");
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, "ds-math-sub-underflow");
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
    }

    function rmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), RAY / 2) / RAY;
    }

    function rdivup(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, RAY), sub(y, 1)) / y; // always rounds up
    }


    function toDai (uint256 _chai, uint256 _chi) internal pure returns (uint256 dai_) {
        dai_ = rmul(_chai, _chi);
    }

    function fromDai (uint256 _dai, uint256 _chi) internal pure returns (uint256 chai_) {
        chai_ = rdivup(_dai, _chi);
    }

    // takes raw chai amount, transfers it in, unwraps into dai, wraps into the reserve, and finally returns the numeraire amount
    function intakeRawAndGetBalance (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        _amount = rmul(_amount, pot.chi());

        chai.draw(msg.sender, _amount);

        uint256 _balance = dai.balanceOf(address(this));

        amount_ = _amount.divu(1e18);

        balance_ = _balance.divu(1e18);

    }

    // takes raw chai amount, transfers it in, unwraps into dai, wraps into the reserve, and finally returns the numeraire amount
    function intakeRaw (uint256 _amount) public returns (int128 amount_) {

        _amount = rmul(_amount, pot.chi());

        chai.draw(msg.sender, _amount);

        amount_ = _amount.divu(1e18);

    }

    // takes numeraire amount, exits that from chai, wraps it in cdai, and returns the raw amount of chai
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

        chai.draw(msg.sender, amount_);

        amount_ = rdivup(amount_, pot.chi());

    }

    // takes numeraire amount, redeems dai from cdai, wraps it in chai and sends it to the destination, and returns the raw amount
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

        chai.join(_dst, amount_);

        amount_ = rdivup(amount_, pot.chi());

    }

    // takes raw amount of chai, calculates the numeraire amount, redeems that from cdai, wraps it in chai and sends to destination, then returns the numeraire amount
    function outputRawAndGetBalance (address _dst, uint256 _amount) public returns (int128 amount_, int128 balance_) {

        _amount = rmul(_amount, pot.chi());

        chai.join(_dst, _amount);

        uint256 _balance = dai.balanceOf(address(this));

        amount_ = _amount.divu(1e18);

        balance_ = _balance.divu(1e18);

    }

    // takes raw amount of chai, calculates the numeraire amount, redeems that from cdai, wraps it in chai and sends to destination, then returns the numeraire amount
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_) {

        _amount = rmul(_amount, pot.chi());

        chai.join(_dst, _amount);

        amount_ = _amount.divu(1e18);

    }

    // pass it a numeraire amount and get the raw amount
    function viewRawAmount (int128 _amount) public view returns (uint256 amount_) {

        amount_ = rdivup(_amount.mulu(1e18), pot.chi());

    }

    // pass it a raw amount and get the numeraire amount
    function viewNumeraireAmount (uint256 _amount) public view returns (int128 amount_) {

        _amount = rmul(_amount, pot.chi());

        amount_ = _amount.divu(1e18);

    }

    function viewNumeraireBalance (address _addr) public view returns (int128 balance_) {

        uint256 _balance = dai.balanceOf(_addr);

        if (_balance == 0) return ABDKMath64x64.fromUInt(0);

        balance_ = _balance.divu(1e18);

    }

    function viewNumeraireAmountAndBalance (address _addr, uint256 _amount) public view returns (int128 amount_, int128 balance_) {

        uint256 _balance = dai.balanceOf(_addr);

        _amount = rmul(_amount, pot.chi());

        amount_ = _amount.divu(1e18);

        balance_ = _balance.divu(1e18);

    }

}