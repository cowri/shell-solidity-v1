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

import "./Loihi.sol";

import "./Assimilators.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

library Liquidity {

    using ABDKMath64x64 for int128;

    function liquidity (Loihi.Shell storage shell) external returns (uint, uint[] memory) {

        uint _length = shell.reserves.length;

        uint[] memory liquidity_ = new uint[](_length);
        uint totalLiquidity_;

        for (uint i = 0; i < _length; i++) {

            uint _liquidity = Assimilators.viewNumeraireBalance(shell.reserves[i].addr).mulu(1e18);

            totalLiquidity_ += _liquidity;
            liquidity_[i] = _liquidity;

        }

        return (totalLiquidity_, liquidity_);

    }

}