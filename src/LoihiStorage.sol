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

import "abdk-libraries-solidity/ABDKMath64x64.sol";

import "./Orchestrator.sol";

import "./PartitionedLiquidity.sol";

import "./ProportionalLiquidity.sol";

import "./SelectiveLiquidity.sol";

import "./Shells.sol";

import "./Swaps.sol";

import "./ViewLiquidity.sol";

import "./interfaces/IERC20.sol";
import "./interfaces/IERC20NoBool.sol";
import "./interfaces/IAToken.sol";
import "./interfaces/ICToken.sol";
import "./interfaces/IChai.sol";
import "./interfaces/IPot.sol";

contract LoihiStorage {

    string  public constant name = "Shells";
    string  public constant symbol = "SHL";
    uint8   public constant decimals = 18;

    struct Shell {
        int128 alpha;
        int128 beta;
        int128 delta;
        int128 epsilon;
        int128 lambda;
        int128 omega;
        int128[] weights;
        uint totalSupply;
        mapping (address => uint) balances;
        mapping (address => mapping (address => uint)) allowances;
        Assimilator[] assets;
        mapping (address => Assimilator) assimilators;
    }

    struct Assimilator {
        address addr;
        uint8 ix;
    }

    Shell public shell;

    struct PartitionTicket {
        uint[] claims;
        bool initialized;
    }

    mapping (address => PartitionTicket) public partitionTickets;

    address[] public derivatives;
    address[] public numeraires;
    address[] public reserves;

    bool public partitioned = false;
    bool public frozen = false;

    address public owner;
    bool internal notEntered = true;

    // uint public maxFee;

}