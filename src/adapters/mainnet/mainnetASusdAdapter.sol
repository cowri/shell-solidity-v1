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

import "../../interfaces/IAToken.sol";
import "../aaveResources/ILendingPoolAddressesProvider.sol";
import "../aaveResources/ILendingPool.sol";
import "../adapterDSMath.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract MainnetASUsdAdapter is AdapterDSMath {

    address constant susd = 0x57Ab1ec28D129707052df4dF418D58a2D46d5f51;
    ILendingPoolAddressesProvider constant lpProvider = ILendingPoolAddressesProvider(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);

    constructor () public { }

    function getASUsd () public view returns (IAToken) {

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());
        (,,,,,,,,,,,address aTokenAddress,) = pool.getReserveData(susd);
        return IAToken(aTokenAddress);

    }

    // intakes raw amount of ASUsd and returns the corresponding raw amount
    function intakeRaw (uint256 amount) public returns (uint256) {

        getASUsd().transferFrom(msg.sender, address(this), amount);
        return amount;

    }

    // intakes a numeraire amount of ASUsd and returns the corresponding raw amount
    function intakeNumeraire (uint256 amount) public returns (uint256) {

        getASUsd().transferFrom(msg.sender, address(this), amount);
        return amount;

    }

    // outputs a raw amount of ASUsd and returns the corresponding numeraire amount
    function outputRaw (address dst, uint256 amount) public returns (uint256) {

        IAToken asusd = getASUsd();
        asusd.transfer(dst, amount);
        return amount;

    }

    // outputs a numeraire amount of ASUsd and returns the corresponding numeraire amount
    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {

        getASUsd().transfer(dst, amount);
        return amount;

    }

    // takes a numeraire amount and returns the raw amount
    function viewRawAmount (uint256 amount) public view returns (uint256) {

        return amount;

    }

    // takes a raw amount and returns the numeraire amount
    function viewNumeraireAmount (uint256 amount) public view returns (uint256) {

        return amount;

    }

    // views the numeraire value of the current balance of the reserve, in this case ASUsd
    function viewNumeraireBalance (address addr) public view returns (uint256) {

        return getASUsd().balanceOf(addr);

    }

}