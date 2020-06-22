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

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

import "../../../interfaces/ICToken.sol";

import "../../../interfaces/IChai.sol";

import "../../../interfaces/IPot.sol";

import "../../AssimilatorMath.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

contract MainnetChaiToCDaiAssimilator {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;
    using AssimilatorMath for uint;

    IChai constant chai = IChai(0x06AF07097C9Eeb7fD685c692751D5C66dB49c215);
    IERC20 constant dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    ICToken constant cdai = ICToken(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);
    IPot constant pot = IPot(0x197E90f9FAD81970bA7976f33CbD77088E5D7cf7);

    constructor () public { }

    // takes raw chai amount, transfers it in, unwraps into dai, wraps into the reserve, and finally returns the numeraire amount
    function intakeRaw (uint256 _amount) public returns (int128 amount_) {

        chai.exit(msg.sender, _amount);

        _amount = _amount.rmul(pot.chi());

        uint256 success = cdai.mint(_amount);

        if (success != 0) revert("CDai/mint-failed");

        uint256 _rate = cdai.exchangeRateStored();

        amount_ = ( ( ( ( _amount * 1e18 ) / _rate ) * _rate ) / 1e18 ).divu(1e18);

    }

    // takes raw chai amount, transfers it in, unwraps into dai, wraps into the reserve, and finally returns the numeraire amount
    function intakeRawAndGetBalance (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        chai.exit(msg.sender, _amount);

        _amount = _amount.rmul(pot.chi());

        uint256 success = cdai.mint(_amount);

        if (success != 0) revert("CDai/mint-failed");

        uint256 _rate = cdai.exchangeRateStored();

        uint256 _balance = cdai.balanceOf(address(this));

        amount_ = ( ( ( ( _amount * 1e18 ) / _rate ) * _rate ) / 1e18 ).divu(1e18);

        balance_ = ( ( _balance * _rate ) / 1e18 ).divu(1e18);

    }

    // takes numeraire amount, exits that from chai, wraps it in cdai, and returns the raw amount of chai
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

        chai.draw(msg.sender, amount_);

        uint256 success = cdai.mint(amount_);

        if (success != 0) revert("CDai/mint-failed");

        amount_ = amount_.rdivup(pot.chi());

    }

    // takes numeraire amount, redeems dai from cdai, wraps it in chai and sends it to the destination, and returns the raw amount
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

        uint256 success = cdai.redeemUnderlying(amount_);

        if (success != 0) revert("CDai/redeemUnderlying-failed");

        chai.join(_dst, amount_);

        amount_ = amount_.rdivup(pot.chi());

    }

    // takes raw amount of chai, calculates the numeraire amount, redeems that from cdai, wraps it in chai and sends to destination, then returns the numeraire amount
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_) {

        _amount = _amount.rmul(pot.chi());

        uint256 success = cdai.redeemUnderlying(_amount);

        if (success != 0) revert("CDai/redeemUnderlying-failed");

        chai.join(_dst, _amount);

        amount_ = _amount.divu(1e18);

    }

    // takes raw amount of chai, calculates the numeraire amount, redeems that from cdai, wraps it in chai and sends to destination, then returns the numeraire amount
    function outputRawAndGetBalance (address _dst, uint256 _amount) public returns (int128 amount_, int128 balance_) {

        _amount = _amount.rmul(pot.chi());

        uint256 success = cdai.redeemUnderlying(_amount);

        if (success != 0) revert("CDai/redeemUnderlying-failed");

        chai.join(_dst, _amount);

        uint256 _rate = cdai.exchangeRateStored();

        uint256 _balance = cdai.balanceOf(address(this));

        amount_ = _amount.divu(1e18);

        balance_ = ( ( _balance * _rate ) / 1e18 ).divu(1e18);

    }

    // pass it a numeraire amount and get the raw amount
    function viewRawAmount (int128 _amount) public view returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18).rdivup(pot.chi());

    }

    // pass it a raw amount and get the numeraire amount
    function viewNumeraireAmount (uint256 _amount) public view returns (int128 amount_) {

        amount_ = _amount.rmul(pot.chi()).divu(1e18);

    }

    // returns the numeraire balance for this numeraire's reserve, in this case cDai
    function viewNumeraireBalance () public view returns (int128 balance_) {

        uint256 _rate = cdai.exchangeRateStored();

        uint256 _balance = cdai.balanceOf(address(this));

        if (_balance == 0) return ABDKMath64x64.fromUInt(0);

        balance_ = ( ( _balance * _rate ) / 1e18 ).divu(1e18);
    }

}