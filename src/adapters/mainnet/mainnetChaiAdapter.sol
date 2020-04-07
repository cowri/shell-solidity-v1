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
import "../../interfaces/IChai.sol";
import "../../interfaces/IPot.sol";
import "../adapterDSMath.sol";

contract MainnetChaiAdapter is AdapterDSMath {

    IChai constant chai = IChai(0x06AF07097C9Eeb7fD685c692751D5C66dB49c215);
    IERC20 constant dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    ICToken constant cdai = ICToken(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);
    IPot constant pot = IPot(0x197E90f9FAD81970bA7976f33CbD77088E5D7cf7);

    constructor () public { }

    // takes raw chai amount
    // transfers it into our balance
    function intakeRaw (uint256 amount) public returns (uint256) {

        uint256 daiAmt = dai.balanceOf(address(this));
        chai.exit(msg.sender, amount);
        daiAmt = dai.balanceOf(address(this)) - daiAmt;
        uint256 success = cdai.mint(daiAmt);
        if (success != 0) revert("CDai/mint-failed");
        return daiAmt;

    }

    // takes numeraire amount
    // transfers corresponding chai into our balance;
    function intakeNumeraire (uint256 amount) public returns (uint256) {

        uint256 chaiBal = chai.balanceOf(msg.sender);
        chai.draw(msg.sender, amount);
        uint256 success = cdai.mint(amount);
        if (success != 0) revert("CDai/mint-failed");
        return chaiBal - chai.balanceOf(msg.sender);

    }

    // takes numeraire amount
    // transfers corresponding chai to destination address
    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {

        uint256 success = cdai.redeemUnderlying(amount);
        if (success != 0) revert("CDai/redeemUnderlying-failed");
        uint256 chaiBal = chai.balanceOf(dst);
        chai.join(dst, amount);
        return chai.balanceOf(dst) - chaiBal;

    }

    // transfers corresponding chai to destination address
    function outputRaw (address dst, uint256 amount) public returns (uint256) {

        uint256 daiAmt = rmul(amount, pot.chi());
        uint256 success = cdai.redeemUnderlying(daiAmt);
        if (success != 0) revert("CDai/redeemUnderlying-failed");
        chai.join(dst, daiAmt);
        return daiAmt;

    }
    
    // pass it a numeraire and get the raw amount
    function viewRawAmount (uint256 amount) public view returns (uint256) {

        return rdivup(amount, pot.chi());

    }

    // pass it a raw amount and get the numeraire amount
    function viewNumeraireAmount (uint256 amount) public view returns (uint256) {

        return rmul(amount, pot.chi());

    }

    function viewNumeraireBalance (address addr) public view returns (uint256) {

        uint256 rate = cdai.exchangeRateStored();
        uint256 balance = cdai.balanceOf(addr);
        if (balance == 0) return 0;
        return wmul(balance, rate);

    }

}