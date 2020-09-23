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

import "../../aaveResources/ILendingPoolAddressesProvider.sol";
import "../../aaveResources/ILendingPool.sol";

import "../../../interfaces/IAToken.sol";

import "../../../interfaces/IERC20.sol";

import "../../../interfaces/IAssimilator.sol";

contract MainnetADaiToDaiAssimilator is IAssimilator {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    IERC20 constant dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    ILendingPoolAddressesProvider constant lpProvider = ILendingPoolAddressesProvider(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);

    constructor () public { }

    function getADai () public view returns (IAToken) {

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());
        (,,,,,,,,,,,address aTokenAddress,) = pool.getReserveData(address(dai));
        return IAToken(aTokenAddress);

    }

    // intakes raw amount of ASUsd and returns the corresponding raw amount
    function intakeRawAndGetBalance (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        IAToken _adai = getADai();

        bool _success = _adai.transferFrom(msg.sender, address(this), _amount);

        require(_success, "Shell/aDAI-transfer-from-failed");

        _adai.redeem(_amount);

        uint256 _balance = dai.balanceOf(address(this));

        amount_ = _amount.divu(1e18);

        balance_ = _balance.divu(1e18);

    }

    // intakes raw amount of ASUsd and returns the corresponding raw amount
    function intakeRaw (uint256 _amount) public returns (int128 amount_) {

        IAToken _adai = getADai();

        bool _success = _adai.transferFrom(msg.sender, address(this), _amount);

        require(_success, "Shell/aDAI-transfer-from-failed");

        _adai.redeem(_amount);

        amount_ = _amount.divu(1e18);

    }

    // intakes a numeraire amount of ASUsd and returns the corresponding raw amount
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

        IAToken _adai = getADai();

        bool _success = _adai.transferFrom(msg.sender, address(this), amount_);

        require(_success, "Shell/aDAI-transfer-from-failed");

        _adai.redeem(amount_);

    }

    // outputs a raw amount of ASUsd and returns the corresponding numeraire amount
    function outputRawAndGetBalance (address _dst, uint256 _amount) public returns (int128 amount_, int128 balance_) {

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());

        pool.deposit(address(dai), _amount, 0);

        IAToken _adai = getADai();

        bool _success = _adai.transfer(_dst, _amount);

        require(_success, "Shell/aDAI-transfer-failed");

        uint256 _balance = dai.balanceOf(address(this));

        amount_ = _amount.divu(1e18);

        balance_ = _balance.divu(1e18);

    }

    // outputs a raw amount of ASUsd and returns the corresponding numeraire amount
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_) {

        IAToken _adai = getADai();

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());

        pool.deposit(address(dai), _amount, 0);

        bool _success = _adai.transfer(_dst, _amount);

        require(_success, "Shell/aDAI-transfer-failed");

        amount_ = _amount.divu(1e18);

    }

    // outputs a numeraire amount of ASUsd and returns the corresponding numeraire amount
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());

        pool.deposit(address(dai), amount_, 0);

        IAToken _adai = getADai();

        bool _success = _adai.transfer(_dst, amount_);

        require(_success, "Shell/aDAI-transfer-failed");

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

        uint256 _balance = dai.balanceOf(_addr);

        amount_ = _balance.divu(1e18);

    }

    // takes a raw amount and returns the numeraire amount
    function viewNumeraireAmountAndBalance (address _addr, uint256 _amount) public view returns (int128 amount_, int128 balance_) {

        amount_ = _amount.divu(1e18);

        uint256 _balance = dai.balanceOf(_addr);

        balance_ = _balance.divu(1e18);

    }


}