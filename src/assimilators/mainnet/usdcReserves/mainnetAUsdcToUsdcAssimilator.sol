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

contract MainnetAUsdcToUsdcAssimilator is IAssimilator {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    IERC20 constant usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    ILendingPoolAddressesProvider constant lpProvider = ILendingPoolAddressesProvider(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);

    constructor () public { }

    function getAUsdc () public view returns (IAToken) {

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());
        (,,,,,,,,,,,address aTokenAddress,) = pool.getReserveData(address(usdc));
        return IAToken(aTokenAddress);

    }

    // intakes raw amount of AUsdc and returns the corresponding raw amount
    function intakeRawAndGetBalance (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        IAToken _ausdc = getAUsdc();

        bool _success = _ausdc.transferFrom(msg.sender, address(this), _amount);

        require(_success, "Shell/aUSDC-transfer-from-failed");

        _ausdc.redeem(_amount);

        uint256 _balance = usdc.balanceOf(address(this));

        amount_ = _amount.divu(1e6);

        balance_ = _balance.divu(1e6);

    }

    // intakes raw amount of AUsdc and returns the corresponding raw amount
    function intakeRaw (uint256 _amount) public returns (int128 amount_) {

        IAToken _ausdc = getAUsdc();

        bool _success = _ausdc.transferFrom(msg.sender, address(this), _amount);

        require(_success, "Shell/aUSDC-transfer-from-failed");

        _ausdc.redeem(_amount);

        amount_ = _amount.divu(1e6);

    }

    // intakes a numeraire amount of AUsdc and returns the corresponding raw amount
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e6);

        IAToken _ausdc = getAUsdc();

        bool _success = _ausdc.transferFrom(msg.sender, address(this), amount_);

        require(_success, "Shell/aUSDC-transfer-from-failed");

        _ausdc.redeem(amount_);

    }

    // outputs a raw amount of AUsdc and returns the corresponding numeraire amount
    function outputRawAndGetBalance (address _dst, uint256 _amount) public returns (int128 amount_, int128 balance_) {

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());

        pool.deposit(address(usdc), _amount, 0);

        IAToken _ausdc = getAUsdc();

        bool _success = _ausdc.transfer(_dst, _amount);

        require(_success, "Shell/aUSDC-transfer-failed");

        uint256 _balance = usdc.balanceOf(address(this));

        amount_ = _amount.divu(1e6);

        balance_ = _balance.divu(1e6);

    }

    // outputs a raw amount of AUsdc and returns the corresponding numeraire amount
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_) {

        IAToken _ausdc = getAUsdc();

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());

        pool.deposit(address(usdc), _amount, 0);

        bool _success = _ausdc.transfer(_dst, _amount);

        require(_success, "Shell/aUSDC-transfer-failed");

        amount_ = _amount.divu(1e6);

    }

    // outputs a numeraire amount of AUsdc and returns the corresponding numeraire amount
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e6);

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());

        pool.deposit(address(usdc), amount_, 0);

        IAToken _ausdc = getAUsdc();

        bool _success = _ausdc.transfer(_dst, amount_);

        require(_success, "Shell/aUSDC-transfer-failed");

    }

    // takes a numeraire amount and returns the raw amount
    function viewRawAmount (int128 _amount) public view returns (uint256 amount_) {

        amount_ = _amount.mulu(1e6);

    }

    // takes a raw amount and returns the numeraire amount
    function viewNumeraireAmount (uint256 _amount) public view returns (int128 amount_) {

        amount_ = _amount.divu(1e6);

    }

    // views the numeraire value of the current balance of the reserve, in this case AUsdc
    function viewNumeraireBalance (address _addr) public view returns (int128 amount_) {

        uint256 _balance = usdc.balanceOf(_addr);

        amount_ = _balance.divu(1e6);

    }

    // takes a raw amount and returns the numeraire amount
    function viewNumeraireAmountAndBalance (address _addr, uint256 _amount) public view returns (int128 amount_, int128 balance_) {

        amount_ = _amount.divu(1e6);

        uint256 _balance = usdc.balanceOf(_addr);

        balance_ = _balance.divu(1e6);

    }


}