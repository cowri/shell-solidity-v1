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

contract MainnetCUsdcToUsdcAssimilator is IAssimilator {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    IERC20 constant usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    ICToken constant cusdc = ICToken(0x39AA39c021dfbaE8faC545936693aC917d5E7563);

    constructor () public { }

    // takes raw cusdc amount and transfers it in
    function intakeRawAndGetBalance (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        bool _transferSuccess = cusdc.transferFrom(msg.sender, address(this), _amount);

        require(_transferSuccess, "Shell/cUSDC-transfer-from-failed");

        uint _redeemSuccess = cusdc.redeem(_amount);

        require(_redeemSuccess == 0, "Shell/cUSDC-redeem-failed");

        uint256 _balance = usdc.balanceOf(address(this));

        uint256 _rate = cusdc.exchangeRateStored();

        balance_ = _balance.divu(1e6);

        amount_ = ( ( _amount * _rate) / 1e18).divu(1e6);

    }

    // takes raw cusdc amount and transfers it in
    function intakeRaw (uint256 _amount) public returns (int128 amount_) {

        bool _transferSuccess = cusdc.transferFrom(msg.sender, address(this), _amount);

        require(_transferSuccess, "Shell/cUSDC-transfer-from-failed");

        uint _redeemSuccess = cusdc.redeem(_amount);

        require(_redeemSuccess == 0, "Shell/cUSDC-redeem-failed");

        uint256 _rate = cusdc.exchangeRateStored();

        amount_ = ( ( _amount * _rate ) / 1e18 ).divu(1e6);

    }

    // takes numeraire amount and transfers corresponding cusdc in
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        uint256 _rate = cusdc.exchangeRateCurrent();

        amount_ = ( _amount.mulu(1e6) * 1e18 ) / _rate;

        bool _transferSuccess = cusdc.transferFrom(msg.sender, address(this), amount_);

        require(_transferSuccess, "Shell/cUSDC-transfer-from-failed");

        uint _redeemSuccess = cusdc.redeem(amount_);

        require(_redeemSuccess == 0, "Shell/cUSDC-redeem-failed");

    }

    // takes numeraire amount
    // transfers corresponding cusdc to destination
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        uint _mintSuccess = cusdc.mint( _amount.mulu(1e6) );

        require(_mintSuccess == 0, "Shell/cUSDC-mint-failed");

        amount_ = cusdc.balanceOf(address(this));

        bool _transferSuccess = cusdc.transfer(_dst, amount_);

        require(_transferSuccess, "Shell/cUSDC-transfer-failed");

    }

    // takes raw amount
    // transfers that amount to destination
    function outputRawAndGetBalance (address _dst, uint256 _amount) public returns (int128 amount_, int128 balance_) {

        uint256 _rate = cusdc.exchangeRateCurrent();

        uint256 _usdcAmount = ( _amount * _rate ) / 1e18;

        uint _mintSuccess = cusdc.mint(_usdcAmount);
        
        require(_mintSuccess == 0, "Shell/cUSDC-mint-failed");
        
        _amount = cusdc.balanceOf(address(this));

        bool _transferSuccess = cusdc.transfer(_dst, _amount);

        require(_transferSuccess, "Shell/cUSDC-transfer-failed");

        uint256 _balance = usdc.balanceOf(address(this));

        amount_ = _usdcAmount.divu(1e6);

        balance_ = _balance.divu(1e6);

    }

    // takes raw amount
    // transfers that amount to destination
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_) {

        uint256 _rate = cusdc.exchangeRateCurrent();

        uint256 _usdcAmount = ( _amount * _rate ) / 1e18;

        uint _mintSuccess = cusdc.mint(_usdcAmount);
        
        _amount = cusdc.balanceOf(address(this));

        require(_mintSuccess == 0, "Shell/cUSDC-mint-failed");

        bool _transferSuccess = cusdc.transfer(_dst, _amount);

        require(_transferSuccess, "Shell/cUSDC-transfer-failed");

        amount_ = _amount.divu(1e6);

    }

    // takes raw amount of cUsdc, returns numeraire amount
    function viewRawAmount (int128 _amount) public view returns (uint256 amount_) {

        uint256 _rate = cusdc.exchangeRateStored();
        
        uint256 _supplyRate = cusdc.supplyRatePerBlock();

        uint256 _prevBlock = cusdc.accrualBlockNumber();

        _rate += _rate * _supplyRate * (block.number - _prevBlock) / 1e18;

        amount_ = ( _amount.mulu(1e6) * 1e18 ) / _rate;

    }

    // takes numeraire amount, returns raw amount of cUsdc
    function viewNumeraireAmount (uint256 _amount) public view returns (int128 amount_) {

        uint256 _rate = cusdc.exchangeRateStored();
        
        uint256 _supplyRate = cusdc.supplyRatePerBlock();

        uint256 _prevBlock = cusdc.accrualBlockNumber();

        _rate += _rate * _supplyRate * (block.number - _prevBlock) / 1e18;

        amount_ = ( ( _amount * _rate ) / 1e18 ).divu(1e6);

    }

    // returns numeraire balance of reserve, in this case cUsdc
    function viewNumeraireBalance (address _addr) public view returns (int128 balance_) {

        uint256 _balance = usdc.balanceOf(_addr);

        balance_ = _balance.divu(1e6);

    }

    // takes numeraire amount, returns raw amount of cUsdc
    function viewNumeraireAmountAndBalance (address _addr, uint256 _amount) public view returns (int128 amount_, int128 balance_) {

        uint256 _rate = cusdc.exchangeRateStored();
        
        uint256 _supplyRate = cusdc.supplyRatePerBlock();

        uint256 _prevBlock = cusdc.accrualBlockNumber();

        _rate += _rate * _supplyRate * (block.number - _prevBlock) / 1e18;

        amount_ = ( ( _amount * _rate ) / 1e18 ).divu(1e6);

        uint256 _balance = usdc.balanceOf(_addr);

        balance_ = _balance.divu(1e6);

    }

}