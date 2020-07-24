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

import "../../../interfaces/ICToken.sol";

import "../../../interfaces/IERC20.sol";

import "../../../interfaces/IAssimilator.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

contract MainnetDaiToCDaiAssimilator is IAssimilator {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    ICToken constant cdai = ICToken(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);
    IERC20 constant dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);

    constructor () public { }

    event log_uint(bytes32, uint256);
    event log_int(bytes32, int256);

    // transfers raw amonut of dai in, wraps it in cDai, returns numeraire amount
    function intakeRaw (uint256 _amount) public returns (int128 amount_) {

        bool _transferSuccess = dai.transferFrom(msg.sender, address(this), _amount);

        require(_transferSuccess, "Shell/DAI-transfer-from-failed");

        uint256 _mintSuccess = cdai.mint(_amount);

        require(_mintSuccess == 0, "Shell/cDAI-redeem-underlying-failed");

        uint256 _rate = cdai.exchangeRateStored();

        amount_ = ( ( ( ( _amount * 1e18 ) / _rate ) * _rate ) / 1e18 ).divu(1e18);

    }

    // transfers raw amonut of dai in, wraps it in cDai, returns numeraire amount
    function intakeRawAndGetBalance (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        bool _transferSuccess = dai.transferFrom(msg.sender, address(this), _amount);

        require(_transferSuccess, "Shell/DAI-transfer-from-failed");

        uint256 _mintSuccess = cdai.mint(_amount);

        require(_mintSuccess == 0, "Shell/cDAI-redeem-underlying-failed");

        uint256 _rate = cdai.exchangeRateStored();

        uint256 _balance = cdai.balanceOf(address(this));

        amount_ = ( ( ( ( _amount * 1e18 ) / _rate ) * _rate ) / 1e18 ).divu(1e18);

        balance_ = ( ( _balance * _rate ) / 1e18 ).divu(1e18);

    }

    // transfers numeraire amount of dai in, wraps it in cDai, returns raw amount
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

        bool _transferSuccess = dai.transferFrom(msg.sender, address(this), amount_);

        require(_transferSuccess, "Shell/DAI-transfer-from-failed");

        uint256 _mintSuccess = cdai.mint(amount_);

        require(_mintSuccess == 0, "Shell/cDAI-mint-failed");

    }

    // takes raw amount of dai, unwraps that from cDai, transfers it out, returns numeraire amount
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_) {

        uint256 _redeemSuccess = cdai.redeemUnderlying(_amount);

        require(_redeemSuccess == 0, "Shell/cDAI-redeem-underlying-failed");

        bool _transferSuccess = dai.transfer(_dst, _amount);

        require(_transferSuccess, "Shell/DAI-transfer-failed");

        amount_ = _amount.divu(1e18);

    }

    // takes raw amount of dai, unwraps that from cDai, transfers it out, returns numeraire amount
    function outputRawAndGetBalance (address _dst, uint256 _amount) public returns (int128 amount_, int128 balance_) {

        uint256 _redeemSuccess = cdai.redeemUnderlying(_amount);

        require(_redeemSuccess == 0, "Shell/cDAI-redeem-underlying-failed");

        uint256 _balance = cdai.balanceOf(address(this));

        uint256 _rate = cdai.exchangeRateStored();

        bool _transferSuccess = dai.transfer(_dst, _amount);

        require(_transferSuccess, "Shell/DAI-transfer-failed");

        amount_ = _amount.divu(1e18);

        balance_ = ( ( _balance * _rate ) / 1e18 ).divu(1e18);

    }

    // takes numeraire amount of dai, unwraps corresponding amount of cDai, transfers that out, returns numeraire amount
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

        uint256 _redeemSuccess = cdai.redeemUnderlying(amount_);

        require(_redeemSuccess == 0, "Shell/cDAI-redeem-underlying-failed");

        bool _transferSuccess = dai.transfer(_dst, amount_);

        require(_transferSuccess, "Shell/DAI-transfer-failed");

    }

    // takes numeraire amount and returns raw amount
    function viewRawAmount (int128 _amount) public view returns (uint256 amount_) {

        uint256 _rate = cdai.exchangeRateStored();

        amount_ = ( _amount.mulu(1e18) * 1e18 ) / _rate;

    }

    // takes raw amount and returns numeraire amount
    function viewNumeraireAmount (uint256 _amount) public view returns (int128 amount_) {

        uint256 _rate = cdai.exchangeRateStored();

        amount_ = ( ( _amount * _rate ) / 1e18 ).divu(1e18);

    }

    // returns current balance in numeraire
    function viewNumeraireBalance (address _addr) public view returns (int128 balance_) {

        uint256 _rate = cdai.exchangeRateStored();

        uint256 _balance = cdai.balanceOf(_addr);

        if (_balance == 0) return ABDKMath64x64.fromUInt(0);

        balance_ = ( ( _balance * _rate ) / 1e18 ).divu(1e18);

    }

    function viewNumeraireAmountAndBalance (address _addr, uint256 _amount) public view returns (int128 amount_, int128 balance_) {

        uint256 _rate = cdai.exchangeRateStored();

        amount_ = ( ( _amount * _rate ) / 1e18 ).divu(1e18);

        uint256 _balance = cdai.balanceOf(_addr);

        if (_balance == 0) return ( amount_, ABDKMath64x64.fromUInt(0) );

        balance_ = ( ( _balance * _rate ) / 1e18 ).divu(1e18);

    }

}