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

import "../../../interfaces/IERC20NoBool.sol";

import "../../../interfaces/IAssimilator.sol";

contract MainnetAUsdtToUsdtAssimilator is IAssimilator {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    IERC20NoBool constant usdt = IERC20NoBool(0xdAC17F958D2ee523a2206206994597C13D831ec7);
    ILendingPoolAddressesProvider constant lpProvider = ILendingPoolAddressesProvider(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);

    constructor () public { }

    function getAUsdt () private view returns (IAToken) {

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());
        (,,,,,,,,,,,address aTokenAddress,) = pool.getReserveData(address(usdt));
        return IAToken(aTokenAddress);

    }

    // intakes raw amount of AUSsdt and returns the corresponding raw amount
    function intakeRawAndGetBalance (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        IAToken _ausdt = getAUsdt();

        bool _success = _ausdt.transferFrom(msg.sender, address(this), _amount);

        require(_success, "Shell/aUSDT-transfer-from-failed");

        _ausdt.redeem(_amount);

        uint256 _balance = usdt.balanceOf(address(this));

        amount_ = _amount.divu(1e6);

        balance_ = _balance.divu(1e6);

    }

    // intakes a numeraire amount of AUsdt and returns the corresponding raw amount

    // intakes raw amount of AUSsdt and returns the corresponding raw amount
    function intakeRaw (uint256 _amount) public returns (int128 amount_) {

        IAToken _ausdt = getAUsdt();

        bool _success = _ausdt.transferFrom(msg.sender, address(this), _amount);

        require(_success, "Shell/aUSDT-transfer-from-failed");

        _ausdt.redeem(_amount);

        amount_ = _amount.divu(1e6);

    }

    // intakes a numeraire amount of AUsdt and returns the corresponding raw amount
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e6);

        IAToken _ausdt = getAUsdt();

        bool _success = _ausdt.transferFrom(msg.sender, address(this), amount_);

        require(_success, "Shell/aUSDT-transfer-from-failed");

        _ausdt.redeem(amount_);

    }

    // outputs a raw amount of AUsdt and returns the corresponding numeraire amount
    function outputRawAndGetBalance (address _dst, uint256 _amount) public returns (int128 amount_, int128 balance_) {

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());

        pool.deposit(address(usdt), _amount, 0);

        IAToken _ausdt = getAUsdt();

        bool _success = _ausdt.transfer(_dst, _amount);

        require(_success, "Shell/aUSDT-transfer-failed");

        uint256 _balance = usdt.balanceOf(address(this));

        amount_ = _amount.divu(1e6);

        balance_ = _balance.divu(1e6);

    }

    // outputs a raw amount of AUsdt and returns the corresponding numeraire amount
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_) {

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());

        pool.deposit(address(usdt), _amount, 0);

        IAToken _ausdt = getAUsdt();

        bool _success = _ausdt.transfer(_dst, _amount);

        require(_success, "Shell/aUSDT-transfer-failed");

        amount_ = _amount.divu(1e6);

    }

    // outputs a numeraire amount of AUsdt and returns the corresponding numeraire amount
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e6);

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());

        pool.deposit(address(usdt), amount_, 0);

        IAToken _ausdt = getAUsdt();

        bool _success = _ausdt.transfer(_dst, amount_);

        require(_success, "Shell/aUSDT-transfer-failed");

    }

    // takes a numeraire amount and returns the raw amount
    function viewRawAmount (int128 _amount) public view returns (uint256 amount_) {

        amount_ = _amount.mulu(1e6);

    }

    // takes a raw amount and returns the numeraire amount
    function viewNumeraireAmount (uint256 _amount) public view returns (int128 amount_) {

        amount_ = _amount.divu(1e6);

    }

    // takes a raw amount and returns the numeraire amount
    function viewNumeraireAmountAndBalance (address _addr, uint256 _amount) public view returns (int128 amount_, int128 balance_) {

        amount_ = _amount.divu(1e6);

        uint256 _balance = usdt.balanceOf(_addr);

        balance_ = _balance.divu(1e6);

    }

    // views the numeraire value of the current balance of the reserve, in this case AUsdt
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