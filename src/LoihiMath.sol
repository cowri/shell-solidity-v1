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

pragma solidity >0.4.13;

contract LoihiMath {

    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "loihi-math-add-overflow");
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, "loihi-math-sub-underflow");
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "loihi-math-mul-overflow");
    }

    uint constant OCTOPUS = 10 ** 18;

    function omul(uint x, uint y) internal pure returns (uint z) {
        z = ((x*y) + (OCTOPUS/2)) / OCTOPUS;
    }

    function odiv(uint x, uint y) internal pure returns (uint z) {
        z = ((x*OCTOPUS) + (y/2)) / y;
    }

    function somul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), OCTOPUS / 2) / OCTOPUS;
    }

    function sodiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, OCTOPUS), y / 2) / y;
    }

}
