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

contract MainnetSUsdAdapter {

    constructor () public { }

    ILendingPoolAddressesProvider constant lpProvider = ILendingPoolAddressesProvider(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);
    IERC20 constant susd = IERC20(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51);

    function getASUsd () public view returns (IAToken) {

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());
        (,,,,,,,,,,,address aTokenAddress,) = pool.getReserveData(address(susd));
        return IAToken(aTokenAddress);

    }

    event log_uint(bytes32, uint256);

    // transfers susd in
    function intakeRaw (uint256 amount) public returns (uint256) {

        susd.transferFrom(msg.sender, address(this), amount);
        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());
        pool.deposit(address(susd), amount, 0);
        uint256 bal = getASUsd().balanceOf(address(this));
        emit log_uint("BAL AFTER", bal);
        return amount;

    }

    // transfers susd in
    function intakeNumeraire (uint256 amount) public returns (uint256) {

        safeTransferFrom(susd, msg.sender, address(this), amount);
        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());
        pool.deposit(address(susd), amount, 0);
        uint256 bal = getASUsd().balanceOf(address(this));
        emit log_uint("BAL AFTER", bal);
        return amount;

    }

    // transfers susd out of our balance
    function outputRaw (address dst, uint256 amount) public returns (uint256) {

        getASUsd().redeem(amount);
        safeTransfer(susd, dst, amount);
        return amount;

    }

    // transfers susd to destination
    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {

        getASUsd().redeem(amount);
        uint256 susdbalbefore = susd.balanceOf(address(this));
        safeTransfer(susd, dst, amount);
        uint256 susdbalafter = susd.balanceOf(address(this));
        return amount;

    }

    function viewRawAmount (uint256 amount) public pure returns (uint256) {

        return amount;

    }

    function viewNumeraireAmount (uint256 amount) public pure returns (uint256) {

        return amount;

    }

    function viewNumeraireBalance (address addr) public view returns (uint256) {

        return getASUsd().balanceOf(addr);

    }

    function getRawAmount (uint256 amount) public pure returns (uint256) {

        return amount;

    }

    // returns amount, is already numeraire amount
    function getNumeraireAmount (uint256 amount) public returns (uint256) {

        return amount;

    }

    // returns balance
    function getNumeraireBalance () public returns (uint256) {

        return getASUsd().balanceOf(address(this));

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