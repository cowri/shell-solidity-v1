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

import "../../aaveResources/ILendingPool.sol";

import "../../aaveResources/ILendingPoolAddressesProvider.sol";

import "../../../interfaces/IAToken.sol";

import "../../../interfaces/IAssimilator.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

contract MainnetSUsdToASUsdAssimilator is IAssimilator {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    ILendingPoolAddressesProvider constant lpProvider = ILendingPoolAddressesProvider(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);

    IERC20 constant susd = IERC20(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51);

    constructor () public { }

    function getASUsd () public returns (IAToken) {

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());
        (,,,,,,,,,,,address aTokenAddress,) = pool.getReserveData(address(susd));
        return IAToken(aTokenAddress);

    }

    // takes raw amount, transfers it in, wraps it in asusd, returns numeraire amount
    function intakeRaw (uint256 _amount) public returns (int128 amount_) {

        susd.transferFrom(msg.sender, address(this), _amount);

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());

        pool.deposit(address(susd), _amount, 0);

        amount_ = _amount.divu(1e18);

    }

    function intakeRawAndGetBalance (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        susd.transferFrom(msg.sender, address(this), _amount);

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());

        pool.deposit(address(susd), _amount, 0);

        uint256 _balance = getASUsd().balanceOf(address(this));

        amount_ = _amount.divu(1e18);

        balance_ = _balance.divu(1e18);

    }

    // takes numeraire amount of susd, transfers it in, wraps it in asusd, returns raw amount
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

        susd.transferFrom(msg.sender, address(this), amount_);

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());

        pool.deposit(address(susd), amount_, 0);

    }

    // takes raw amount, transfers to destination, returns numeraire amount
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_) {

        getASUsd().redeem(_amount);

        susd.transfer(_dst, _amount);

        amount_ = _amount.divu(1e18);

    }

    // takes raw amount, transfers to destination, returns numeraire amount
    function outputRawAndGetBalance (address _dst, uint256 _amount) public returns (int128 amount_, int128 balance_) {

        IAToken _asusd = getASUsd();

        _asusd.redeem(_amount);

        susd.transfer(_dst, _amount);

        uint256 _balance = _asusd.balanceOf(address(this));

        amount_ = _amount.divu(1e18);

        balance_ = _balance.divu(1e18);

    }

    // takes numeraire amount, transfers to destination, returns raw amount
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

        getASUsd().redeem(amount_);

        susd.transfer(_dst, amount_);

    }

    // takes numeraire amount, returns raw amount
    function viewRawAmount (int128 _amount) public  returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

    }

    // takes raw amount, returns numeraire amount
    function viewNumeraireAmount (uint256 _amount) public  returns (int128 amount_) {

        amount_ = _amount.divu(1e18);

    }

    // returns numeraire value of reserve asset, in this case ASUsd
    function viewNumeraireBalance () public returns (int128 balance_) {

        uint256 _balance = getASUsd().balanceOf(address(this));

        balance_ = _balance.divu(1e18);

    }

    // takes raw amount, returns numeraire amount
    function viewNumeraireAmountAndBalance (uint256 _amount) public  returns (int128 amount_, int128 balance_) {

        amount_ = _amount.divu(1e18);

        uint256 _balance = getASUsd().balanceOf(address(this));

        balance_ = _balance.divu(1e18);

    }

}