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

contract MainnetAUsdtAdapter is AdapterDSMath {

    address constant usdt = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    ILendingPoolAddressesProvider constant lpProvider = ILendingPoolAddressesProvider(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);

    constructor () public { }

    function getAUsdt () private view returns (IAToken) {

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());
        (,,,,,,,,,,,address aTokenAddress,) = pool.getReserveData(usdt);
        return IAToken(aTokenAddress);

    }

    function intakeRaw (uint256 amount) public returns (uint256) {

        getAUsdt().transferFrom(msg.sender, address(this), amount);
        return amount * 1000000000000;

    }

    function intakeNumeraire (uint256 amount) public returns (uint256) {

        amount /= 1000000000000;
        getAUsdt().transferFrom(msg.sender, address(this), amount);
        return amount;

    }

    function outputRaw (address dst, uint256 amount) public returns (uint256) {

        getAUsdt().transfer(dst, amount);
        return amount * 1000000000000;

    }

    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {

        amount /= 1000000000000;
        getAUsdt().transfer(dst, amount);
        return amount;

    }

    function viewRawAmount (uint256 amount) public view returns (uint256) {

        return amount / 1000000000000;

    }

    function viewNumeraireAmount (uint256 amount) public view returns (uint256) {

        return amount * 1000000000000;

    }

    function viewNumeraireBalance (address addr) public view returns (uint256) {

        return getAUsdt().balanceOf(address(addr)) * 1000000000000;

    }

}