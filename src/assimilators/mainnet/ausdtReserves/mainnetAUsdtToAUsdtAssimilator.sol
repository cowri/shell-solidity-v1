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

import "../../../interfaces/IAToken.sol";

import "../../aaveResources/ILendingPoolAddressesProvider.sol";

import "../../aaveResources/ILendingPool.sol";

import "../../../interfaces/IAssimilator.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

contract MainnetAUsdtToAUsdtAssimilator is IAssimilator {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    address constant usdt = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    ILendingPoolAddressesProvider constant lpProvider = ILendingPoolAddressesProvider(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);

    constructor () public { }

    function getAUsdt () private view returns (IAToken) {

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());
        (,,,,,,,,,,,address aTokenAddress,) = pool.getReserveData(usdt);
        return IAToken(aTokenAddress);

    }

    // intakes raw amount of AUSsdt and returns the corresponding raw amount
    function intakeRaw (uint256 _amount) public returns (int128 amount_) {

        getAUsdt().transferFrom(msg.sender, address(this), _amount);

        amount_ = _amount.divu(1e6);

    }

    // intakes raw amount of AUSsdt and returns the corresponding raw amount
    function intakeRawAndGetBalance (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        IAToken _ausdt = getAUsdt();

        _ausdt.transferFrom(msg.sender, address(this), _amount);

        uint256 _balance = _ausdt.balanceOf(address(this));

        amount_ = _amount.divu(1e6);

        balance_ = _balance.divu(1e6);

    }

    // intakes a numeraire amount of AUsdt and returns the corresponding raw amount
    // intakes a numeraire amount of AUsdt and returns the corresponding raw amount
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

        getAUsdt().transferFrom(msg.sender, address(this), amount_);

    }

    // outputs a raw amount of AUsdt and returns the corresponding numeraire amount
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_) {

        getAUsdt().transfer(_dst, _amount);

        amount_ = _amount.divu(1e6);

    }

    // outputs a raw amount of AUsdt and returns the corresponding numeraire amount
    function outputRawAndGetBalance (address _dst, uint256 _amount) public returns (int128 amount_, int128 balance_) {

        IAToken _ausdt = getAUsdt();

        _ausdt.transfer(_dst, _amount);

        uint256 _balance = _ausdt.balanceOf(address(this));

        amount_ = _amount.divu(1e6);

        balance_ = _balance.divu(1e6);

    }

    // outputs a numeraire amount of AUsdt and returns the corresponding numeraire amount
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e6);

        getAUsdt().transfer(_dst, amount_);

    }

    // takes a numeraire amount and returns the raw amount
    function viewRawAmount (int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e6);

    }

    // takes a raw amount and returns the numeraire amount
    function viewNumeraireAmount (uint256 _amount) public returns (int128 amount_) {

        amount_ = _amount.divu(1e6);

    }

    // views the numeraire value of the current balance of the reserve, in this case AUsdt
    function viewNumeraireBalance () public returns (int128 balance_) {

        uint256 _balance = getAUsdt().balanceOf(address(this));

        balance_ = _balance.divu(1e6);

    }

    // takes a raw amount and returns the numeraire amount
    function viewNumeraireAmountAndBalance (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        amount_ = _amount.divu(1e6);

        uint256 _balance = getAUsdt().balanceOf(address(this));

        balance_ = _balance.divu(1e6);

    }

}