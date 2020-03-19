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
import "../../LoihiRoot.sol";

contract LocalDaiAdapter is LoihiRoot {

    ICToken _cdai;

    constructor (address __cdai) public { 
        _cdai = ICToken(__cdai);
    }

    uint256 constant WAD = 10 ** 18;

    // transfers dai in
    // wraps it in chai
    function intakeRaw (uint256 amount) public returns (uint256) {

        dai.transferFrom(msg.sender, address(this), amount);
        cdai.mint(amount);
        return amount;

    }

    event log_addr(bytes32, address);
    event log_erc20(bytes32, IERC20);


    // transfers dai in
    // wraps it in cdai
    function intakeNumeraire (uint256 amount) public returns (uint256) {
        dai.transferFrom(msg.sender, address(this), amount);
        cdai.mint(amount);
        return amount;
    }

    event log_uint(bytes32, uint256);

    // unwraps chai
    // transfers out dai
    function outputRaw (address dst, uint256 amount) public returns (uint256) {

        cdai.redeemUnderlying(amount);
        dai.transfer(dst, amount);
        return amount;

    }

    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {
        
        cdai.redeemUnderlying(amount);
        dai.transfer(dst, amount);
        return amount;
        
    }

    function viewRawAmount (uint256 amount) public pure returns (uint256) {
        return amount;
    }

    function viewNumeraireAmount (uint256 amount) public pure returns (uint256) {
        return amount;
    }

    function viewNumeraireBalance (address addr) public  returns (uint256) {
        
        uint256 rate = _cdai.exchangeRateCurrent();
        uint256 balance = _cdai.balanceOf(addr);
        emit log_uint("balance", balance);
        return wmul(balance, rate);

    }

    function getRawAmount (uint256 amount) public pure returns (uint256) {

        return amount;

    }

    // returns amount, already in numeraire
    function getNumeraireAmount (uint256 amount) public pure returns (uint256) {

        return amount;

    }

    // returns numeraire amount of chai balance
    function getNumeraireBalance () public returns (uint256) {

        return cdai.balanceOfUnderlying(address(this));

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