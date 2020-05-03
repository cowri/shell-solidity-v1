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

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../../interfaces/ICToken.sol";
import "../adapterDSMath.sol";

contract MainnetUsdcAdapter is AdapterDSMath {

    constructor () public { }

    IERC20 constant usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    ICToken constant cusdc = ICToken(0x39AA39c021dfbaE8faC545936693aC917d5E7563);
    uint256 constant WAD = 10 ** 18;

    // takes raw amount of usdc, transfers it in, wraps it in cusdc, returns numeraire amount
    function intakeRaw (uint256 amount) public returns (uint256) {

        usdc.transferFrom(msg.sender, address(this), amount);
        uint256 success = cusdc.mint(amount);
        if (success != 0) revert("CUsdc/mint-failed");
        return amount * 1000000000000;

    }

    // takes numeraire amount of usdc, calculates raw amount, transfers it in and wraps it in cusdc, returns raw amount
    function intakeNumeraire (uint256 amount) public returns (uint256) {

        amount /= 1000000000000;
        usdc.transferFrom(msg.sender, address(this), amount);
        uint256 success = cusdc.mint(amount);
        if (success != 0) revert("CUsdc/mint-failed");
        return amount;

    }

    // takes raw amount of usdc, unwraps it from cusdc, transfers that out, returns numeraire amount
    function outputRaw (address dst, uint256 amount) public returns (uint256) {

        uint256 success = cusdc.redeemUnderlying(amount);
        if (success != 0) revert("CUsdc/redeemUnderlying-failed");
        usdc.transfer(dst, amount);
        return amount * 1000000000000;

    }

    // takes numeraire amount of usdc, calculates raw amount, unwraps raw amount of cusdc, transfers that out, returns raw amount
    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {

        amount /= 1000000000000;
        uint256 success = cusdc.redeemUnderlying(amount);
        if (success != 0) revert("CUsdc/redeemUnderlying-failed");
        usdc.transfer(dst, amount);
        return amount;

    }


    // takes numeraire amount, returns raw amount
    function viewRawAmount (uint256 amount) public view returns (uint256) {

        return amount / 1000000000000;

    }

    // takes raw amount, returns numeraire amount
    function viewNumeraireAmount (uint256 amount) public pure returns (uint256) {

        return amount * 1000000000000;

    }

    // returns numeraire amount of reserve asset, in this case cUsdc
    function viewNumeraireBalance (address addr) public view returns (uint256) {

        uint256 rate = cusdc.exchangeRateStored();
        uint256 balance = cusdc.balanceOf(addr);
        if (balance == 0) return 0;
        return wmul(balance, rate) * 1000000000000;

    }

}