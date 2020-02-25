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

contract MainnetUsdcAdapter {

    constructor () public { }

    IERC20 constant usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    ICToken constant cusdc = ICToken(0x39AA39c021dfbaE8faC545936693aC917d5E7563);
    uint256 constant WAD = 10 ** 18;

    // transfers usdc in
    // wraps it in csudc
    function intakeRaw (uint256 amount) public {

        usdc.transferFrom(msg.sender, address(this), amount);
        cusdc.mint(amount);

    }

    // transfers usdc in
    // wraps it in csudc
    function intakeNumeraire (uint256 amount) public returns (uint256) {

        amount /= 1000000000000;
        usdc.transferFrom(msg.sender, address(this), amount);
        cusdc.mint(amount);
        return amount;

    }

    function outputRaw (address dst, uint256 amount) public returns (uint256) {

        cusdc.redeemUnderlying(amount);
        usdc.transfer(dst, amount);
        return amount;

    }

    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {

        amount /= 1000000000000;
        cusdc.redeemUnderlying(amount);
        usdc.transfer(dst, amount);
        return amount;

    }

    function viewRawAmount (uint256 amount) public view returns (uint256) {

        return amount / 1000000000000;

    }

    function viewNumeraireAmount (uint256 amount) public pure returns (uint256) {

        return amount * 1000000000000;

    }

    function viewNumeraireBalance (address addr) public view returns (uint256) {

        uint256 rate = cusdc.exchangeRateStored();
        uint256 balance = cusdc.balanceOf(addr);
        return wmul(balance, rate) * 1000000000000;

    }

    function getRawAmount (uint256 amount) public pure returns (uint256) {

        return amount / 1000000000000;

    }

    // is already numeraire amount
    function getNumeraireAmount (uint256 amount) public pure returns (uint256) {

        return amount * 1000000000000;

    }

    // returns numeraire balance
    function getNumeraireBalance () public returns (uint256) {

        uint256 bal = cusdc.balanceOfUnderlying(address(this));
        return bal * 1000000000000;

    }

    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "ds-math-add-overflow");
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
    }

    function wmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), WAD / 2) / WAD;
    }

    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, WAD), y / 2) / y;
    }
}