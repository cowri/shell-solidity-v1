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
import "../aaveResources/ILendingPool.sol";
import "../aaveResources/ILendingPoolAddressesProvider.sol";
import "../../interfaces/IAToken.sol";

contract KovanSUsdAssimilator {

    constructor () public { }

    ILendingPoolAddressesProvider constant lpProvider = ILendingPoolAddressesProvider(0x506B0B2CF20FAA8f38a4E2B524EE43e1f4458Cc5);
    IERC20 constant susd = IERC20(0xD868790F57B39C9B2B51b12de046975f986675f9);

    function getASUsd () public view returns (IAToken) {
        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());
        (,,,,,,,,,,,address aTokenAddress,) = pool.getReserveData(address(susd));
        return IAToken(aTokenAddress);
    }

    // transfers susd in
    function intakeRaw (uint256 amount) public returns (uint256) {

        susd.transferFrom(msg.sender, address(this), amount);
        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());
        pool.deposit(address(susd), amount, 0);
        return amount;

    }

    // transfers susd in
    function intakeNumeraire (uint256 amount) public returns (uint256) {

        amount /= 1000000000000;
        safeTransferFrom(susd, msg.sender, address(this), amount);
        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());
        pool.deposit(address(susd), amount, 0);
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

        amount /= 1000000000000;
        getASUsd().redeem(amount);
        safeTransfer(susd, dst, amount);
        return amount;

    }

    function viewRawAmount (uint256 amount) public pure returns (uint256) {
        return amount / 1000000000000;
    }

    function viewNumeraireAmount (uint256 amount) public pure returns (uint256) {
        return amount * 1000000000000;
    }

    function viewNumeraireBalance (address addr) public view returns (uint256) {
        return getASUsd().balanceOf(addr) * 1000000000000;
    }

    function getRawAmount (uint256 amount) public pure returns (uint256) {
        return amount / 1000000000000;
    }

    // returns amount, is already numeraire amount
    function getNumeraireAmount (uint256 amount) public returns (uint256) {
        return amount * 1000000000000;
    }

    // returns balance
    function getNumeraireBalance () public returns (uint256) {
        return getASUsd().balanceOf(address(this)) * 1000000000000;
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