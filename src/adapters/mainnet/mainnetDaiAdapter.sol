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

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../../interfaces/ICToken.sol";
import "../adapterDSMath.sol";

contract MainnetDaiAdapter is AdapterDSMath {

    constructor () public { }

    ICToken constant cdai = ICToken(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);
    IERC20 constant dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    uint256 constant WAD = 10 ** 18;

    // transfers raw amonut of dai in, wraps it in cDai, returns numeraire amount
    function intakeRaw (uint256 amount) public returns (uint256) {

        dai.transferFrom(msg.sender, address(this), amount);
        uint256 success = cdai.mint(amount);
        if (success != 0) revert("CDai/mint-failed");
        return amount;

    }

    // transfers numeraire amount of dai in, wraps it in cDai, returns raw amount
    function intakeNumeraire (uint256 amount) public returns (uint256) {

        dai.transferFrom(msg.sender, address(this), amount);
        uint256 success = cdai.mint(amount);
        if (success != 0) revert("CDai/mint-failed");
        return amount;

    }

    // takes raw amount of dai, unwraps that from cDai, transfers it out, returns numeraire amount 
    function outputRaw (address dst, uint256 amount) public returns (uint256) {

        uint256 success = cdai.redeemUnderlying(amount);
        if (success != 0) revert("CDai/redeemUnderlying-failed");
        dai.transfer(dst, amount);
        return amount;

    }

    // takes numeraire amount of dai, unwraps corresponding amount of cDai, transfers that out, returns numeraire amount
    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {
        
        uint256 success = cdai.redeemUnderlying(amount);
        if (success != 0) revert("CDai/redeemUnderlying-failed");
        dai.transfer(dst, amount);
        return amount;
        
    }

    // takes numeraire amount and returns raw amount
    function viewRawAmount (uint256 amount) public pure returns (uint256) {
        return amount;
    }

    // takes raw amount and returns numeraire amount
    function viewNumeraireAmount (uint256 amount) public pure returns (uint256) {
        return amount;
    }

    // returns current balance in numeraire
    function viewNumeraireBalance (address addr) public view returns (uint256) {

        uint256 rate = cdai.exchangeRateStored();
        uint256 balance = cdai.balanceOf(addr);
        if (balance == 0) return 0;
        return wmul(balance, rate);

    }

}