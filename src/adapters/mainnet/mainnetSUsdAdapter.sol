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
import "../aaveResources/ILendingPool.sol";
import "../aaveResources/ILendingPoolAddressesProvider.sol";
import "../../interfaces/IAToken.sol";
import "../adapterDSMath.sol";

contract MainnetSUsdAdapter is AdapterDSMath {

    constructor () public { }

    ILendingPoolAddressesProvider constant lpProvider = ILendingPoolAddressesProvider(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);
    IERC20 constant susd = IERC20(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51);

    function getASUsd () public view returns (IAToken) {

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());
        (,,,,,,,,,,,address aTokenAddress,) = pool.getReserveData(address(susd));
        return IAToken(aTokenAddress);

    }

    // takes raw amount, transfers it in, wraps it in asusd, returns numeraire amount
    function intakeRaw (uint256 amount) public returns (uint256) {
        
        susd.transferFrom(msg.sender, address(this), amount);
        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());
        pool.deposit(address(susd), amount, 0);
        return amount;

    }

    // takes numeraire amount of susd, transfers it in, wraps it in asusd, returns raw amount
    function intakeNumeraire (uint256 amount) public returns (uint256) {

        safeTransferFrom(susd, msg.sender, address(this), amount);
        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());
        pool.deposit(address(susd), amount, 0);
        return amount;

    }

    // takes raw amount, transfers to destination, returns numeraire amount
    function outputRaw (address dst, uint256 amount) public returns (uint256) {

        getASUsd().redeem(amount);
        safeTransfer(susd, dst, amount);
        return amount;

    }

    // takes numeraire amount, transfers to destination, returns raw amount
    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {

        getASUsd().redeem(amount);
        safeTransfer(susd, dst, amount);
        return amount;

    }

    // takes numeraire amount, returns raw amount
    function viewRawAmount (uint256 amount) public pure returns (uint256) {

        return amount;

    }

    // takes raw amount, returns numeraire amount
    function viewNumeraireAmount (uint256 amount) public pure returns (uint256) {

        return amount;

    }

    // returns numeraire value of reserve asset, in this case ASUsd
    function viewNumeraireBalance (address addr) public view returns (uint256) {

        return getASUsd().balanceOf(addr);

    }

    function safeTransfer(IERC20 token, address to, uint256 value) internal {

        callOptionalReturn(address(token), abi.encodeWithSelector(0xa9059cbb, to, value));

    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {

        callOptionalReturn(address(token), abi.encodeWithSelector(token.transferFrom.selector, from, to, value));

    }

    function callOptionalReturn(address token, bytes memory data) private {

        (bool success, bytes memory returndata) = token.call(data);
        require(success, "SafeERC20: low-level call failed");

    }
}