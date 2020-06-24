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

import "../../../interfaces/IChai.sol";
import "../../../interfaces/ICToken.sol";
import "../../../interfaces/IPot.sol";

contract LocalChaiToDaiAssimilator is LoihiRoot {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    constructor (address _dai, address _chai, address _pot) public {

        dai = IERC20(_dai);
        chai = IChai(_chai);
        pot = IPot(_pot);

    }

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

        _amount = toDai(_amount, pot.chi());

        chai.draw(msg.sender, _amount);

        uint256 _balance = dai.balanceOf(address(this));

        amount_ = _amount.divu(1e18);

        balance_ = _balance.divu(1e18);

        // amount_ = ( ( ( ( _amount * 1e18 ) / _rate / 1e2 * 1e2 ) * _rate ) / 1e18 ).divu(1e18);
        // balance_ = ( ( ( _balance / 1e2 * 1e2 ) * _rate ) / 1e18 ).divu(1e18);

    }

    // takes raw chai amount, transfers it in, unwraps into dai, wraps into the reserve, and finally returns the numeraire amount
    function intakeRaw (uint256 _amount) public returns (int128 amount_) {

        _amount = toDai(_amount, pot.chi());

        chai.draw(msg.sender, _amount);

        amount_ = _amount.divu(1e18);

        // amount_ = ( ( ( ( _amount * 1e18 ) / _rate / 1e2 * 1e2 ) * _rate ) / 1e18 ).divu(1e18);
        // balance_ = ( ( ( _balance / 1e2 * 1e2 ) * _rate ) / 1e18 ).divu(1e18);

    }

    // takes numeraire amount, exits that from chai, wraps it in cdai, and returns the raw amount of chai
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

        chai.draw(msg.sender, amount_);

        amount_ = fromDai(amount_, pot.chi());

    }

    // takes numeraire amount, redeems dai from cdai, wraps it in chai and sends it to the destination, and returns the raw amount
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

        chai.join(_dst, amount_);

        amount_ = fromDai(amount_, pot.chi());

    }

    // takes raw amount of chai, calculates the numeraire amount, redeems that from cdai, wraps it in chai and sends to destination, then returns the numeraire amount
    function outputRawAndGetBalance (address _dst, uint256 _amount) public returns (int128 amount_, int128 balance_) {

        _amount = toDai(_amount, pot.chi());

        chai.join(_dst, _amount);

        uint256 _balance = dai.balanceOf(address(this));

        amount_ = _amount.divu(1e18);

        balance_ = _balance.divu(1e18);

    }

    // takes raw amount of chai, calculates the numeraire amount, redeems that from cdai, wraps it in chai and sends to destination, then returns the numeraire amount
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_) {

        _amount = toDai(_amount, pot.chi());

        chai.join(_dst, _amount);

        amount_ = _amount.divu(1e18);

    }

    event log_uint(bytes32, uint);

    // pass it a numeraire amount and get the raw amount
    function viewRawAmount (int128 _amount) public returns (uint256 amount_) {

        amount_ = fromDai(_amount.mulu(1e18), pot.chi());

    }

    // pass it a raw amount and get the numeraire amount
    function viewNumeraireAmount (uint256 _amount) public returns (int128 amount_) {

        _amount = toDai(_amount, pot.chi());

        amount_ = _amount.divu(1e18);

    }

    function viewNumeraireBalance (address _addr) public returns (int128 balance_) {

        uint256 _balance = dai.balanceOf(_addr);

        if (_balance == 0) return ABDKMath64x64.fromUInt(0);

        balance_ = _balance.divu(1e18);

    }

    function viewNumeraireAmountAndBalance (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        uint256 _balance = dai.balanceOf(address(this));
        
        _amount = toDai(_amount, pot.chi());

        amount_ = _amount.divu(1e18);

        if (_balance == 0) return ( amount_, ABDKMath64x64.fromUInt(0));

        balance_ = _balance.divu(1e18);


    }

}