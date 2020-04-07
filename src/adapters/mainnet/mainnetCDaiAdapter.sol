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

pragma solidity ^0.5.12;

import "../../interfaces/ICToken.sol";
import "../adapterDSMath.sol";

contract MainnetCDaiAdapter is AdapterDSMath {

    constructor () public { }

    ICToken constant cdai = ICToken(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);

    // takes raw cdai amount
    // unwraps it into dai
    // deposits dai amount in chai
    function intakeRaw (uint256 amount) public returns (uint256) {

        bool success = cdai.transferFrom(msg.sender, address(this), amount);

        if (!success) {
            if (cdai.balanceOf(msg.sender) < amount) revert("CDai/insufficient-balance");
            else revert("CDai/transferFrom-failed");
        }

        uint256 rate = cdai.exchangeRateStored();
        return wmul(amount, rate);

    }

    function intakeNumeraire (uint256 amount) public returns (uint256) {

        uint256 rate = cdai.exchangeRateCurrent();
        uint256 cdaiAmount = wdiv(amount, rate);

        bool success = cdai.transferFrom(msg.sender, address(this), cdaiAmount);

        if (!success) {
            if (cdai.balanceOf(msg.sender) < cdaiAmount) revert("CDai/insufficient-balance");
            else revert("CDai/transferFrom-failed");
        }

        return cdaiAmount;

    }

    function outputRaw (address dst, uint256 amount) public returns (uint256) {

        bool success = cdai.transfer(msg.sender, amount);

        if (!success) {
            if (cdai.balanceOf(address(this)) < amount) revert("CDai/insufficient-balance");
            else revert("CDai/transfer-failed");
        }

        uint256 rate = cdai.exchangeRateStored();

        return wmul(amount, rate);

    }

    // unwraps numeraire amount of dai from chai
    // wraps it into cdai amount
    // sends that to destination
    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {

        uint rate = cdai.exchangeRateCurrent();
        uint cdaiAmount = wdiv(amount, rate);

        bool success = cdai.transfer(dst, cdaiAmount);

        if (!success) {
            if (cdai.balanceOf(address(this)) < cdaiAmount) revert("CDai/insufficient-balance");
            else revert("CDai/transfer-failed");
        }

        return cdaiAmount;

    }

    function viewRawAmount (uint256 amount) public view returns (uint256) {

        uint256 rate = cdai.exchangeRateStored();
        return wdiv(amount, rate);

    }

    function viewNumeraireAmount (uint256 amount) public view returns (uint256) {

        uint256 rate = cdai.exchangeRateStored();
        return wmul(amount, rate);

    }

    function viewNumeraireBalance (address addr) public view returns (uint256) {

        uint256 rate = cdai.exchangeRateStored();
        uint256 balance = cdai.balanceOf(addr);
        if (balance == 0) return 0;
        return wmul(balance, rate);

    }

}