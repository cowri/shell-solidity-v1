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

import "../AssimilatorMath.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

contract MainnetSUsdAssimilator {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;
    using AssimilatorMath for uint;

    ILendingPoolAddressesProvider constant lpProvider = ILendingPoolAddressesProvider(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);

    IERC20 constant susd = IERC20(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51);

    uint256 constant ZEN_DELTA = 1e18;

    constructor () public { }

    function getASUsd () public view returns (IAToken) {

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());
        (,,,,,,,,,,,address aTokenAddress,) = pool.getReserveData(address(susd));
        return IAToken(aTokenAddress);

    }

    function toZen (uint256 _amount) internal pure returns (int128 zenAmt_) {

        zenAmt_ = _amount.divu(ZEN_DELTA);

    }

    function fromZen (int128 _zenAmt) internal pure returns (uint256 amount_) {

        amount_ = _zenAmt.mulu(ZEN_DELTA);

    }

    // takes raw amount, transfers it in, wraps it in asusd, returns numeraire amount
    function intakeRaw (uint256 _amount) public returns (int128 amount_) {

        susd.transferFrom(msg.sender, address(this), _amount);

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());

        pool.deposit(address(susd), _amount, 0);

        amount_ = toZen(_amount);

    }

    // takes numeraire amount of susd, transfers it in, wraps it in asusd, returns raw amount
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        amount_ = fromZen(_amount);

        susd.transferFrom(msg.sender, address(this), amount_);

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());

        pool.deposit(address(susd), amount_, 0);


    }

    // takes raw amount, transfers to destination, returns numeraire amount
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_) {

        getASUsd().redeem(_amount);

        susd.transfer(_dst, _amount);

        amount_ = toZen(_amount);

    }

    // takes numeraire amount, transfers to destination, returns raw amount
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        amount_ = fromZen(_amount);

        getASUsd().redeem(amount_);

        susd.transfer(_dst, amount_);

    }

    // takes numeraire amount, returns raw amount
    function viewRawAmount (int128 _amount) public pure returns (uint256 amount_) {

        amount_ = fromZen(_amount);

    }

    // takes raw amount, returns numeraire amount
    function viewNumeraireAmount (uint256 _amount) public pure returns (int128 amount_) {

        amount_ = toZen(_amount);

    }

    // returns numeraire value of reserve asset, in this case ASUsd
    function viewNumeraireBalance () public view returns (int128 amount_) {

        amount_ = toZen(getASUsd().balanceOf(address(this)));

    }

}