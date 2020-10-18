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

import "../../../ShellStorage.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

import "../../../interfaces/IERC20.sol";

import "../../../interfaces/IAssimilator.sol";

contract MainnetPBTCToPBTCAssimilator is IAssimilator {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    IERC20 constant pBTC = IERC20(0x5228a22e72ccC52d415EcFd199F99D0665E7733b);

    function intakeRawAndGetBalance (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        bool _success = pBTC.transferFrom(msg.sender, address(this), _amount);

        require(_success, "Shell/pBTC-transfer-from-failed");

        uint256 _balance = pBTC.balanceOf(address(this));

        amount_ = _amount.divu(1e18);

        balance_ = _balance.divu(1e18);

    }

    function intakeRaw (uint256 _amount) public returns (int128 amount_) {

        bool _success = pBTC.transferFrom(msg.sender, address(this), _amount);

        require(_success, "Shell/pBTC-transfer-from-failed");

        amount_ = _amount.divu(1e18);

    }

    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

        bool _success = pBTC.transferFrom(msg.sender, address(this), amount_);

        require(_success, "Shell/pBTC-transfer-from-failed");

    }

    function outputRawAndGetBalance (address _dst, uint256 _amount) public returns (int128 amount_, int128 balance_) {

        bool _success = pBTC.transfer(_dst, _amount);

        require(_success, "Shell/pBTC-transfer-failed");

        uint256 _balance = pBTC.balanceOf(address(this));

        amount_ = _amount.divu(1e18);

        balance_ = _balance.divu(1e18);

    }

    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_) {

        bool _success = pBTC.transfer(_dst, _amount);

        require(_success, "Shell/pBTC-transfer-failed");

        amount_ = _amount.divu(1e18);

    }

    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

        bool _success = pBTC.transfer(_dst, amount_);

        require(_success, "Shelll/pBTC-transfer-failed");

        return amount_;

    }

    function viewRawAmount (int128 _amount) public view returns (uint256 amount_) {

        amount_ = _amount.mulu(1e18);

    }

    function viewNumeraireAmount (uint256 _amount) public view returns (int128 amount_) {

        amount_ = _amount.divu(1e18);

    }

    function viewNumeraireBalance (address _addr) public view returns (int128 balance_) {

        uint256 _balance = pBTC.balanceOf(_addr);

        balance_ = _balance.divu(1e18);

    }

    function viewNumeraireAmountAndBalance (address _addr, uint256 _amount) public view returns (int128 amount_, int128 balance_) {

        amount_ = _amount.divu(1e18);

        uint256 _balance = pBTC.balanceOf(_addr);

        balance_ = _balance.divu(1e18);

    }

}