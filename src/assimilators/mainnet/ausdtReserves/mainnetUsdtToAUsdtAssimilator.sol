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

import "../../aaveResources/ILendingPool.sol";

import "../../aaveResources/ILendingPoolAddressesProvider.sol";

import "../../../interfaces/IAToken.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

contract MainnetUsdtToAUsdtAssimilator {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    ILendingPoolAddressesProvider constant lpProvider = ILendingPoolAddressesProvider(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);
    IERC20 constant usdt = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);

    uint256 constant ZEN_DELTA = 1e6;

    constructor () public { }

    function getAUsdt () public view returns (IAToken) {

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());
        (,,,,,,,,,,,address aTokenAddress,) = pool.getReserveData(address(usdt));
        return IAToken(aTokenAddress);

    }

    function fromZen (int128 _amount) internal pure returns (uint256 amount_) {

        amount_ = _amount.mulu(ZEN_DELTA);

    }

    function toZen (uint256 _amount) internal pure returns (int128 amount_) {

        amount_ = _amount.divu(ZEN_DELTA);

    }

    // takes raw amount, transfers it in, wraps that in aUsdt, returns numeraire amount
    function intakeRaw (uint256 _amount) public returns (int128 amount_) {

        safeTransferFrom(usdt, msg.sender, address(this), _amount);

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());

        pool.deposit(address(usdt), _amount, 0);

        amount_ = toZen(_amount);

    }

    // takes numeraire amount, calculates raw amount, transfers that in, wraps it in aUsdt, returns raw amount
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        amount_ = fromZen(_amount);

        safeTransferFrom(usdt, msg.sender, address(this), amount_);

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());

        pool.deposit(address(usdt), amount_, 0);

    }

    // takes raw amount, redeems that from aUsdt, transfers it out, returns numeraire amount
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_) {

        getAUsdt().redeem(_amount);

        safeTransfer(usdt, _dst, _amount);

        amount_ = toZen(_amount);

    }

    // takes numeraire amount, calculates raw amount, redeems that from aUsdt, transfers it out, returns raw amount
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        amount_ = fromZen(_amount);

        getAUsdt().redeem(amount_);

        safeTransfer(usdt, _dst, amount_);

    }

    // takes numeraire amount, returns raw amount
    function viewRawAmount (int128 _amount) public pure returns (uint256 amount_) {

        amount_ = fromZen(_amount);

    }

    // takes raw amount, returns numeraire amount
    function viewNumeraireAmount (uint256 _amount) public pure returns (int128 amount_) {

        amount_ = toZen(_amount);

    }

    // returns numeraire amount of reserve asset, in this case aUSDT
    function viewNumeraireBalance () public view returns (int128 amount_) {

        amount_ = toZen(getAUsdt().balanceOf(address(this)));

    }

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        callOptionalReturn(address(token), abi.encodeWithSelector(token.transfer.selector, to, value));
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