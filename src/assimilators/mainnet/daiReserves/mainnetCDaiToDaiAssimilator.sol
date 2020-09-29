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

contract MainnetCDaiToDaiAssimilator is IAssimilator {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    ICToken constant cdai = ICToken(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);
    IERC20 constant dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);

    constructor () public { }

    // takes raw cdai amount, transfers it in, calculates corresponding numeraire amount and returns it
    function intakeRawAndGetBalance (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        bool _transferSuccess = cdai.transferFrom(msg.sender, address(this), _amount);

        require(_transferSuccess, "Shell/cDAI-transfer-from-failed");

        uint _redeemSuccess = cdai.redeem(_amount);

        require(_redeemSuccess == 0, "Shell/cDAI-redeem-failed");

        uint256 _balance = dai.balanceOf(address(this));

        uint256 _rate = cdai.exchangeRateStored();

        balance_ = _balance.divu(1e18);

        amount_ = ( ( _amount * _rate ) / 1e18 ).divu(1e18);

    }

    // takes raw cdai amount, transfers it in, calculates corresponding numeraire amount and returns it
    function intakeRaw (uint256 _amount) public returns (int128 amount_) {

        bool _transferSuccess = cdai.transferFrom(msg.sender, address(this), _amount);

        require(_transferSuccess, "Shell/cDAI-transfer-from-failed");

        uint _redeemSuccess = cdai.redeem(_amount);

        require(_redeemSuccess == 0, "Shell/cDAI-redeem-failed");

        uint256 _rate = cdai.exchangeRateStored();

        amount_ = ( ( _amount * _rate ) / 1e18 ).divu(1e18);

    }

    // takes a numeraire amount, calculates the raw amount of cDai, transfers it in and returns the corresponding raw amount
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        uint256 _rate = cdai.exchangeRateCurrent();

        amount_ = ( _amount.mulu(1e18) * 1e18 ) / _rate;

        bool _transferSuccess = cdai.transferFrom(msg.sender, address(this), amount_);

        require(_transferSuccess, "Shell/cDAI-transfer-from-failed");

        uint _redeemSuccess = cdai.redeem(amount_);

        require(_redeemSuccess == 0, "Shell/cDAI-redeem-failed");

    }

    // takes a raw amount of cDai and transfers it out, returns numeraire value of the raw amount
    function outputRawAndGetBalance (address _dst, uint256 _amount) public returns (int128 amount_, int128 balance_) {

        uint256 _rate = cdai.exchangeRateCurrent();

        uint256 _daiAmount = ( ( _amount ) * _rate ) / 1e18;

        uint _mintSuccess = cdai.mint(_daiAmount);
        
        require(_mintSuccess == 0, "Shell/cDAI-mint-failed");

        _amount = cdai.balanceOf(address(this));

        bool _transferSuccess = cdai.transfer(_dst, _amount);

        require(_transferSuccess, "Shell/cDAI-transfer-failed");

        uint256 _balance = dai.balanceOf(address(this));

        amount_ = _daiAmount.divu(1e18);

        balance_ = _balance.divu(1e18);

    }

    // takes a raw amount of cDai and transfers it out, returns numeraire value of the raw amount
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_) {

        uint256 _rate = cdai.exchangeRateCurrent();

        uint256 _daiAmount = ( _amount * _rate ) / 1e18;

        uint _mintSuccess = cdai.mint(_daiAmount);

        require(_mintSuccess == 0, "Shell/cDAI-mint-failed");

        _amount = cdai.balanceOf(address(this));

        bool _transferSuccess = cdai.transfer(_dst, _amount);

        require(_transferSuccess, "Shell/cDAI-transfer-failed");

        amount_ = _daiAmount.divu(1e18);

    }

    // takes a numeraire value of CDai, figures out the raw amount, transfers raw amount out, and returns raw amount
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        uint _mintSuccess = cdai.mint( _amount.mulu(1e18) );

        require(_mintSuccess == 0, "Shell/cDAI-mint-failed");

        amount_ = cdai.balanceOf(address(this));

        bool _transferSuccess = cdai.transfer(_dst, amount_);

        require(_transferSuccess, "Shell/cDAI-transfer-failed");

    }

    // takes a numeraire amount and returns the raw amount
    function viewRawAmount (int128 _amount) public view returns (uint256 amount_) {

        uint256 _rate = cdai.exchangeRateStored();
        
        uint256 _supplyRate = cdai.supplyRatePerBlock();

        uint256 _prevBlock = cdai.accrualBlockNumber();

        _rate += _rate * _supplyRate * (block.number - _prevBlock) / 1e18;

        amount_ = ( _amount.mulu(1e18) * 1e18 ) / _rate;

    }

    // takes a raw amount and returns the numeraire amount
    function viewNumeraireAmount (uint256 _amount) public view returns (int128 amount_) {

        uint256 _rate = cdai.exchangeRateStored();

        uint256 _supplyRate = cdai.supplyRatePerBlock();

        uint256 _prevBlock = cdai.accrualBlockNumber();

        _rate += _rate * _supplyRate * (block.number - _prevBlock) / 1e18;

        amount_ = ( ( _amount * _rate ) / 1e18 ).divu(1e18);

    }

    // views the numeraire value of the current balance of the reserve, in this case CDai
    function viewNumeraireBalance (address _addr) public view returns (int128 balance_) {

        uint256 _balance = dai.balanceOf(_addr);

        if (_balance == 0) return ABDKMath64x64.fromUInt(0);

        balance_ = _balance.divu(1e18);

    }

    // views the numeraire value of the current balance of the reserve, in this case CDai
    function viewNumeraireAmountAndBalance (address _addr, uint256 _amount) public view returns (int128 amount_, int128 balance_) {

        uint256 _rate = cdai.exchangeRateStored();
        
        uint256 _supplyRate = cdai.supplyRatePerBlock();

        uint256 _prevBlock = cdai.accrualBlockNumber();

        _rate += _rate * _supplyRate * (block.number - _prevBlock) / 1e18;

        amount_ = ( ( _amount * _rate ) / 1e18 ).divu(1e18);

        uint256 _balance = dai.balanceOf(_addr);

        balance_ = _balance.divu(1e18);

    }

}