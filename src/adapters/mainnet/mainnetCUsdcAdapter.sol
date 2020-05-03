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

import "../../interfaces/ICToken.sol";
import "../adapterDSMath.sol";

contract MainnetCUsdcAdapter is AdapterDSMath {

    constructor () public { }

    ICToken constant cusdc = ICToken(0x39AA39c021dfbaE8faC545936693aC917d5E7563);
    
    // takes raw cusdc amount and transfers it in
    function intakeRaw (uint256 amount) public returns (uint256) {

        bool success = cusdc.transferFrom(msg.sender, address(this), amount);

        if (!success) {
            if (cusdc.balanceOf(msg.sender) < amount) revert("CUsdc/insufficient-balance");
            else revert("CUsdc/transferFrom-failed");
        }

        uint256 rate = cusdc.exchangeRateCurrent();
        return wmul(amount, rate) * 1000000000000;

    }
    
    // takes numeraire amount and transfers corresponding cusdc in
    function intakeNumeraire (uint256 amount) public returns (uint256) {

        uint256 rate = cusdc.exchangeRateCurrent();
        uint256 cusdcAmount = wdiv(amount / 1000000000000, rate);

        bool success = cusdc.transferFrom(msg.sender, address(this), cusdcAmount);

        if (!success) {
            if (cusdc.balanceOf(msg.sender) < cusdcAmount) revert("CUsdc/insufficient-balance");
            else revert("CUsdc/transferFrom-failed");
        }

        return cusdcAmount;

    }

    // takes numeraire amount
    // transfers corresponding cusdc to destination
    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {

        uint256 rate = cusdc.exchangeRateCurrent();
        amount = wdiv(amount / 1000000000000, rate);

        bool success = cusdc.transfer(dst, amount);

        if (!success) {
            if (cusdc.balanceOf(msg.sender) < amount) revert("CUsdc/insufficient-balance");
            else revert("CUsdc/transfer-failed");
        }

        return amount;

    }

    // takes raw amount
    // transfers that amount to destination
    function outputRaw (address dst, uint256 amount) public returns (uint256) {

        bool success = cusdc.transfer(dst, amount);

        if (!success) {
            if (cusdc.balanceOf(msg.sender) < amount) revert("CUsdc/insufficient-balance");
            else revert("CUsdc/transfer-failed");
        }

        uint256 rate = cusdc.exchangeRateStored();

        return wmul(amount, rate) * 1000000000000;

    }

    // takes raw amount of cUsdc, returns numeraire amount
    function viewRawAmount (uint256 amount) public view returns (uint256) {

        amount /= 1000000000000;
        uint256 rate = cusdc.exchangeRateStored();
        return wdiv(amount, rate);

    }

    // takes numeraire amount, returns raw amount of cUsdc
    function viewNumeraireAmount (uint256 amount) public view returns (uint256) {

        uint256 rate = cusdc.exchangeRateStored();
        return wmul(amount, rate) * 1000000000000;

    }

    // returns numeraire balance of reserve, in this case cUsdc
    function viewNumeraireBalance (address addr) public view returns (uint256) {

        uint256 rate = cusdc.exchangeRateStored();
        uint256 balance = cusdc.balanceOf(addr);
        if (balance == 0) return 0;
        return wmul(balance, rate) * 1000000000000;

    }

}