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

contract MainnetUsdtAdapter is AdapterDSMath {

    constructor () public { }

    ILendingPoolAddressesProvider constant lpProvider = ILendingPoolAddressesProvider(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);
    IERC20 constant usdt = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);

    function getAUsdt () public view returns (IAToken) {

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());
        (,,,,,,,,,,,address aTokenAddress,) = pool.getReserveData(address(usdt));
        return IAToken(aTokenAddress);

    }

    // takes raw amount, transfers it in, wraps that in aUsdt, returns numeraire amount
    function intakeRaw (uint256 amount) public returns (uint256) {
        
        safeTransferFrom(usdt, msg.sender, address(this), amount);
        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());
        pool.deposit(address(usdt), amount, 0);
        uint256 bal = getAUsdt().balanceOf(address(this));
        return amount * 1000000000000;

    }

    // takes numeraire amount, calculates raw amount, transfers that in, wraps it in aUsdt, returns raw amount
    function intakeNumeraire (uint256 amount) public returns (uint256) {

        amount /= 1000000000000;
        safeTransferFrom(usdt, msg.sender, address(this), amount);
        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());
        pool.deposit(address(usdt), amount, 0);
        return amount;

    }

    // takes raw amount, redeems that from aUsdt, transfers it out, returns numeraire amount
    function outputRaw (address dst, uint256 amount) public returns (uint256) {

        getAUsdt().redeem(amount);
        safeTransfer(usdt, dst, amount);
        return amount * 1000000000000;

    }

    // takes numeraire amount, calculates raw amount, redeems that from aUsdt, transfers it out, returns raw amount
    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {

        amount /= 1000000000000;
        getAUsdt().redeem(amount);
        safeTransfer(usdt, dst, amount);
        return amount;

    }

    // takes raw amount, returns numeraire amount
    function viewRawAmount (uint256 amount) public pure returns (uint256) {

        return amount / 1000000000000;

    }

    // takes raw amount, returns numeraire amount
    function viewNumeraireAmount (uint256 amount) public pure returns (uint256) {

        return amount * 1000000000000;

    }

    // returns numeraire amount of reserve asset, in this case aUSDT
    function viewNumeraireBalance (address addr) public view returns (uint256) {

        return getAUsdt().balanceOf(addr) * 1000000000000;

    }

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        callOptionalReturn(address(token), abi.encodeWithSelector(0xa9059cbb, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(address(token), abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function callOptionalReturn(address token, bytes memory data) private {
        (bool success, bytes memory returnData) = token.call(data);
        assembly {
            if eq(success, 0) {
                revert(add(returnData, 0x20), returndatasize)
            }
        }
    }
}