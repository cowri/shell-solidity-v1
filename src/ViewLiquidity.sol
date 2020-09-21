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

import "./ShellStorage.sol";

import "./Assimilators.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

library ViewLiquidity {

    using ABDKMath64x64 for int128;

    function viewLiquidity (
        ShellStorage.Shell storage shell
    ) external view returns (
        uint total_,
        uint[] memory individual_
    ) {

        uint _length = shell.assets.length;

        uint[] memory individual_ = new uint[](_length);
        uint total_;

        for (uint i = 0; i < _length; i++) {

            uint _liquidity = Assimilators.viewNumeraireBalance(shell.assets[i].addr).mulu(1e18);

            total_ += _liquidity;
            individual_[i] = _liquidity;

        }

        return (total_, individual_);

    }

}