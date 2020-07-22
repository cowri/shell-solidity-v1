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

contract KovanASUsdToSUsdAssimilator is IAssimilator {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    IERC20 constant susd = IERC20(0xD868790F57B39C9B2B51b12de046975f986675f9);
    ILendingPoolAddressesProvider constant lpProvider = ILendingPoolAddressesProvider(0x506B0B2CF20FAA8f38a4E2B524EE43e1f4458Cc5);

    constructor () public { }

    function getASUsd () public view returns (IAToken) {

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());
        (,,,,,,,,,,,address aTokenAddress,) = pool.getReserveData(address(susd));
        return IAToken(aTokenAddress);

    }

    // intakes raw amount of ASUsd and returns the corresponding raw amount
    function intakeRawAndGetBalance (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        IAToken _asusd = getASUsd();

        bool _success = _asusd.transferFrom(msg.sender, address(this), _amount);

        require(_success, "Shell/aSUSD-transfer-from-failed");

        _asusd.redeem(_amount);

        uint256 _balance = susd.balanceOf(address(this));

        amount_ = _amount.divu(1e18);

        balance_ = _balance.divu(1e18);

    }

    // intakes raw amount of ASUsd and returns the corresponding raw amount
    function intakeRaw (uint256 _amount) public returns (int128 amount_) {

        IAToken _asusd = getASUsd();

        bool _success = _asusd.transferFrom(msg.sender, address(this), _amount);

        require(_success, "Shell/aSUSD-transfer-from-failed");

        _asusd.redeem(_amount);

        amount_ = _amount.divu(1e18);

    }

    // intakes a numeraire amount of ASUsd and returns the corresponding raw amount
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

        IAToken _asusd = getASUsd();

        bool _success = _asusd.transferFrom(msg.sender, address(this), amount_);

        require(_success, "Shell/aSUSD-transfer-from-failed");

        _asusd.redeem(amount_);

    }

    // outputs a raw amount of ASUsd and returns the corresponding numeraire amount
    function outputRawAndGetBalance (address _dst, uint256 _amount) public returns (int128 amount_, int128 balance_) {

        IAToken _asusd = getASUsd();

        _asusd.deposit(_amount);

        bool _success = _asusd.transfer(_dst, _amount);

        require(_success, "Shell/aSUSD-transfer-failed");

        uint256 _balance = susd.balanceOf(address(this));

        amount_ = _amount.divu(1e18);

        balance_ = _balance.divu(1e18);

    }

    // outputs a raw amount of ASUsd and returns the corresponding numeraire amount
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_) {

        IAToken _asusd = getASUsd();

        _asusd.deposit(_amount);

        bool _success = _asusd.transfer(_dst, _amount);

        require(_success, "Shell/aSUSD-transfer-failed");

        amount_ = _amount.divu(1e18);

    }

    // outputs a numeraire amount of ASUsd and returns the corresponding numeraire amount
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

        IAToken _asusd = getASUsd();

        _asusd.deposit(amount_);

        bool _success = _asusd.transfer(_dst, amount_);

        require(_success, "Shell/aSUSD-transfer-failed");

    }

    // takes a numeraire amount and returns the raw amount
    function viewRawAmount (int128 _amount) public view returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

    }

    // takes a raw amount and returns the numeraire amount
    function viewNumeraireAmount (uint256 _amount) public view returns (int128 amount_) {

        amount_ = _amount.divu(1e18);

    }

    // takes a raw amount and returns the numeraire amount
    function viewNumeraireAmountAndBalance (address _addr, uint256 _amount) public view returns (int128 amount_, int128 balance_) {

        amount_ = _amount.divu(1e18);

        uint256 _balance = susd.balanceOf(_addr);

        balance_ = _balance.divu(1e18);

    }

    // views the numeraire value of the current balance of the reserve, in this case ASUsd
    function viewNumeraireBalance (address _addr) public view returns (int128 amount_) {

        uint256 _balance = susd.balanceOf(_addr);

        amount_ = _balance.divu(1e18);

    }

}