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

import "../../../interfaces/ICToken.sol";
import "../../../interfaces/IERC20.sol";

import "../../../interfaces/IAssimilator.sol";

contract KovanCUsdcToUsdcAssimilator is IAssimilator {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    IERC20 constant usdc = IERC20(0xb7a4F3E9097C08dA09517b5aB877F7a917224ede);
    ICToken constant cusdc = ICToken(0x4a92E71227D294F041BD82dd8f78591B75140d63);

    constructor () public { }

    // takes raw cusdc amount and transfers it in
    function intakeRawAndGetBalance (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        bool _transferSuccess = cusdc.transferFrom(msg.sender, address(this), _amount);

        require(_transferSuccess, "Shell/cUSDC-transfer-from-failed");

        uint256 _rate = cusdc.exchangeRateStored();

        _amount = ( _amount * _rate ) / 1e18;

        uint _redeemSuccess = cusdc.redeemUnderlying(_amount);

        require(_redeemSuccess == 0, "Shell/cUSDC-redeem-underlying-failed");

        uint256 _balance = usdc.balanceOf(address(this));

        amount_ = _amount.divu(1e6);

        balance_ = _balance.divu(1e6);

    }

    // takes raw cusdc amount and transfers it in
    function intakeRaw (uint256 _amount) public returns (int128 amount_) {

        bool _transferSuccess = cusdc.transferFrom(msg.sender, address(this), _amount);

        require(_transferSuccess, "Shell/cUSDC-transfer-from-failed");

        uint256 _rate = cusdc.exchangeRateStored();

        _amount = ( _amount * _rate ) / 1e18;

        uint _redeemSuccess = cusdc.redeemUnderlying(_amount);

        require(_redeemSuccess == 0, "Shell/cUSDC-redeem-underlying-failed");

        amount_ = _amount.divu(1e6);

    }

    // takes numeraire amount and transfers corresponding cusdc in
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        uint256 _rate = cusdc.exchangeRateStored();

        amount_ = ( _amount.mulu(1e6) * 1e18 ) / _rate;

        bool _transferSuccess = cusdc.transferFrom(msg.sender, address(this), amount_);

        require(_transferSuccess, "Shell/cUSDC-transfer-from-failed");

        uint _redeemSuccess = cusdc.redeem(amount_);

        require(_redeemSuccess == 0, "Shell/cUSDC-redeem-failed");

    }

    // takes numeraire amount
    // transfers corresponding cusdc to destination
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e6);

        uint _mintSuccess = cusdc.mint(amount_);

        require(_mintSuccess == 0, "Shell/cUSDC-mint-failed");

        uint256 _rate = cusdc.exchangeRateStored();

        amount_ = ( amount_ * 1e18 ) / _rate;

        bool _transferSuccess = cusdc.transfer(_dst, amount_);

        require(_transferSuccess, "Shell/cUSDC-transfer-failed");

    }

    event log_uint(bytes32, uint256);

    // takes raw amount
    // transfers that amount to destination
    function outputRawAndGetBalance (address _dst, uint256 _amount) public returns (int128 amount_, int128 balance_) {

        uint256 _rate = cusdc.exchangeRateStored();

        uint256 _usdcAmount = ( _amount * _rate ) / 1e18 + 1;

        uint _mintSuccess = cusdc.mint(_usdcAmount);

        require(_mintSuccess == 0, "Shell/cUSDC-mint-failed");

        bool _transferSuccess = cusdc.transfer(_dst, _amount);

        require(_transferSuccess, "Shell/cUSDC-transfer-failed");

        uint256 _balance = usdc.balanceOf(address(this));

        amount_ = _usdcAmount.divu(1e6);

        balance_ = _balance.divu(1e6);

    }

    // takes raw amount
    // transfers that amount to destination
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_) {

        uint256 _rate = cusdc.exchangeRateStored();

        uint256 _usdcAmount = ( _amount * _rate ) / 1e18 + 1;

        uint _mintSuccess = cusdc.mint(_usdcAmount);

        require(_mintSuccess == 0, "Shell/cUSDC-mint-failed");

        bool _transferSuccess = cusdc.transfer(_dst, _amount);

        require(_transferSuccess, "Shell/cUSDC-transfer-failed");

        amount_ = _amount.divu(1e6);

    }

    // takes raw amount of cUsdc, returns numeraire amount
    function viewRawAmount (int128 _amount) public view returns (uint256 amount_) {

        uint256 _rate = cusdc.exchangeRateStored();

        amount_ = ( _amount.mulu(1e6) * 1e18 ) / _rate;

    }

    // takes numeraire amount, returns raw amount of cUsdc
    function viewNumeraireAmount (uint256 _amount) public view returns (int128 amount_) {

        uint256 _rate = cusdc.exchangeRateStored();

        amount_ = ( ( _amount * _rate ) / 1e18 ).divu(1e6);

    }

    // takes numeraire amount, returns raw amount of cUsdc
    function viewNumeraireAmountAndBalance (address _addr, uint256 _amount) public view returns (int128 amount_, int128 balance_) {

        uint256 _rate = cusdc.exchangeRateStored();

        amount_ = ( ( _amount * _rate ) / 1e18 ).divu(1e6);

        uint256 _balance = usdc.balanceOf(_addr);

        balance_ = _balance.divu(1e6);

    }

    // returns numeraire balance of reserve, in this case cUsdc
    function viewNumeraireBalance (address _addr) public view returns (int128 balance_) {

        uint256 _balance = usdc.balanceOf(_addr);

        balance_ = _balance.divu(1e6);

    }

}