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

import "../../../interfaces/IERC20NoBool.sol";

import "../../../interfaces/IAssimilator.sol";

contract MainnetCUsdtToUsdtAssimilator is IAssimilator {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    IERC20NoBool constant usdt = IERC20NoBool(0xdAC17F958D2ee523a2206206994597C13D831ec7);
    ICToken constant cusdt = ICToken(0xf650C3d88D12dB855b8bf7D11Be6C55A4e07dCC9);

    constructor () public { }

    // takes raw cusdt amount and transfers it in
    function intakeRawAndGetBalance (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        bool _transferSuccess = cusdt.transferFrom(msg.sender, address(this), _amount);

        require(_transferSuccess, "Shell/cUSDT-transfer-from-failed");

        uint _redeemSuccess = cusdt.redeem(_amount);

        require(_redeemSuccess == 0, "Shell/cUSDT-redeem-failed");

        uint256 _balance = usdt.balanceOf(address(this));

        uint256 _rate = cusdt.exchangeRateStored();

        balance_ = _balance.divu(1e6);

        amount_ = ( ( _amount * _rate) / 1e18).divu(1e6);

    }

    // takes raw cusdt amount and transfers it in
    function intakeRaw (uint256 _amount) public returns (int128 amount_) {

        bool _transferSuccess = cusdt.transferFrom(msg.sender, address(this), _amount);

        require(_transferSuccess, "Shell/cUSDT-transfer-from-failed");

        uint _redeemSuccess = cusdt.redeem(_amount);

        require(_redeemSuccess == 0, "Shell/cUSDT-redeem-failed");

        uint256 _rate = cusdt.exchangeRateStored();

        amount_ = ( ( _amount * _rate ) / 1e18 ).divu(1e6);

    }

    // takes numeraire amount and transfers corresponding cusdt in
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        uint256 _rate = cusdt.exchangeRateCurrent();

        amount_ = ( _amount.mulu(1e6) * 1e18 ) / _rate;

        bool _transferSuccess = cusdt.transferFrom(msg.sender, address(this), amount_);

        require(_transferSuccess, "Shell/cUSDT-transfer-from-failed");

        uint _redeemSuccess = cusdt.redeem(amount_);

        require(_redeemSuccess == 0, "Shell/cUSDT-redeem-failed");

    }

    // takes numeraire amount
    // transfers corresponding cusdt to destination
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        uint _mintSuccess = cusdt.mint( _amount.mulu(1e6) );

        require(_mintSuccess == 0, "Shell/cUSDT-mint-failed");

        amount_ = cusdt.balanceOf(address(this));

        bool _transferSuccess = cusdt.transfer(_dst, amount_);

        require(_transferSuccess, "Shell/cUSDT-transfer-failed");

    }

    // takes raw amount
    // transfers that amount to destination
    function outputRawAndGetBalance (address _dst, uint256 _amount) public returns (int128 amount_, int128 balance_) {

        uint256 _rate = cusdt.exchangeRateCurrent();

        uint256 _usdcAmount = ( _amount * _rate ) / 1e18;

        uint _mintSuccess = cusdt.mint(_usdcAmount);
        
        require(_mintSuccess == 0, "Shell/cUSDT-mint-failed");
        
        _amount = cusdt.balanceOf(address(this));

        bool _transferSuccess = cusdt.transfer(_dst, _amount);

        require(_transferSuccess, "Shell/cUSDT-transfer-failed");

        uint256 _balance = usdt.balanceOf(address(this));

        amount_ = _usdcAmount.divu(1e6);

        balance_ = _balance.divu(1e6);

    }

    // takes raw amount
    // transfers that amount to destination
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_) {

        uint256 _rate = cusdt.exchangeRateCurrent();

        uint256 _usdcAmount = ( _amount * _rate ) / 1e18;

        uint _mintSuccess = cusdt.mint(_usdcAmount);
        
        _amount = cusdt.balanceOf(address(this));

        require(_mintSuccess == 0, "Shell/cUSDT-mint-failed");

        bool _transferSuccess = cusdt.transfer(_dst, _amount);

        require(_transferSuccess, "Shell/cUSDT-transfer-failed");

        amount_ = _amount.divu(1e6);

    }

    // takes raw amount of cUsdc, returns numeraire amount
    function viewRawAmount (int128 _amount) public view returns (uint256 amount_) {

        uint256 _rate = cusdt.exchangeRateStored();
        
        uint256 _supplyRate = cusdt.supplyRatePerBlock();

        uint256 _prevBlock = cusdt.accrualBlockNumber();

        _rate += _rate * _supplyRate * (block.number - _prevBlock) / 1e18;

        amount_ = ( _amount.mulu(1e6) * 1e18 ) / _rate;

    }

    // takes numeraire amount, returns raw amount of cUsdc
    function viewNumeraireAmount (uint256 _amount) public view returns (int128 amount_) {

        uint256 _rate = cusdt.exchangeRateStored();
        
        uint256 _supplyRate = cusdt.supplyRatePerBlock();

        uint256 _prevBlock = cusdt.accrualBlockNumber();

        _rate += _rate * _supplyRate * (block.number - _prevBlock) / 1e18;

        amount_ = ( ( _amount * _rate ) / 1e18 ).divu(1e6);

    }

    // returns numeraire balance of reserve, in this case cUsdc
    function viewNumeraireBalance (address _addr) public view returns (int128 balance_) {

        uint256 _balance = usdt.balanceOf(_addr);

        balance_ = _balance.divu(1e6);

    }

    // takes numeraire amount, returns raw amount of cUsdc
    function viewNumeraireAmountAndBalance (address _addr, uint256 _amount) public view returns (int128 amount_, int128 balance_) {

        uint256 _rate = cusdt.exchangeRateStored();
        
        uint256 _supplyRate = cusdt.supplyRatePerBlock();

        uint256 _prevBlock = cusdt.accrualBlockNumber();

        _rate += _rate * _supplyRate * (block.number - _prevBlock) / 1e18;

        amount_ = ( ( _amount * _rate ) / 1e18 ).divu(1e6);

        uint256 _balance = usdt.balanceOf(_addr);

        balance_ = _balance.divu(1e6);

    }

}
