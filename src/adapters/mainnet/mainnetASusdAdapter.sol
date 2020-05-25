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

import "../../interfaces/IAToken.sol";
import "../aaveResources/ILendingPoolAddressesProvider.sol";
import "../aaveResources/ILendingPool.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

contract MainnetASUsdAdapter {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    uint256 constant ZEN_DELTA = 1e18;

    address constant susd = 0x57Ab1ec28D129707052df4dF418D58a2D46d5f51;
    ILendingPoolAddressesProvider constant lpProvider = ILendingPoolAddressesProvider(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);

    constructor () public { }

    function toZen (uint256 _amt) internal pure returns (int128 zenAmt_) {
        zenAmt_ = _amt.divu(ZEN_DELTA);
    }

    function fromZen (int128 _zenAmt) internal pure returns (uint256 amt_) {
        amt_ = _zenAmt.mulu(ZEN_DELTA);
    }

    function getASUsd () public view returns (IAToken) {

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());
        (,,,,,,,,,,,address aTokenAddress,) = pool.getReserveData(susd);
        return IAToken(aTokenAddress);

    }

    // intakes raw amount of ASUsd and returns the corresponding raw amount
    function intakeRaw (uint256 _amount) public returns (int128 amount_) {

        getASUsd().transferFrom(msg.sender, address(this), _amount);

        amount_ = toZen(_amount);

    }

    // intakes a numeraire amount of ASUsd and returns the corresponding raw amount
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        amount_ = fromZen(_amount);

        getASUsd().transferFrom(msg.sender, address(this), amount_);

    }

    // outputs a raw amount of ASUsd and returns the corresponding numeraire amount
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_) {

        getASUsd().transfer(_dst, _amount);

        amount_ = toZen(_amount);

    }

    // outputs a numeraire amount of ASUsd and returns the corresponding numeraire amount
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        amount_ = fromZen(_amount);

        getASUsd().transfer(_dst, amount_);

    }

    // takes a numeraire amount and returns the raw amount
    function viewRawAmount (int128 _amount) public view returns (uint256 amount_) {

        amount_ = fromZen(_amount);

    }

    // takes a raw amount and returns the numeraire amount
    function viewNumeraireAmount (uint256 _amount) public view returns (int128 amount_) {

        amount_ = toZen(_amount);

    }

    // views the numeraire value of the current balance of the reserve, in this case ASUsd
    function viewNumeraireBalance () public view returns (int128 amount_) {

        amount_ = toZen(getASUsd().balanceOf(address(this)));

    }

}