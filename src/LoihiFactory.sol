// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is disstributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

pragma solidity ^0.5.0;

// Builds new BPools, logging their addresses and providing `isBPool(address) -> (bool)`

import "./Loihi.sol";

contract LoihiFactory {

    event NewShell(address indexed caller, address indexed shell);

    event CowriLabsSet(address indexed caller, address indexed clabs);

    mapping(address => bool) private _isShell;

    function isShell(address _shell) external view returns (bool) {

        return _isShell[_shell];

    }

    event log(bytes32);

    function newShell(
        address[] memory _assets,
        uint[] memory _assetWeights,
        address[] memory _derivativeAssimilators
    ) public returns (Loihi) {

        Loihi loihiShell = new Loihi(
            _assets,
            _assetWeights,
            _derivativeAssimilators
        );

        loihiShell.transferOwnership(msg.sender);

        _isShell[address(loihiShell)] = true;

        emit NewShell(msg.sender, address(loihiShell));

        return loihiShell;

    }

    address private cowriLabs;

    constructor() public {

        cowriLabs = msg.sender;

    }

    function getCowriLabs() external view returns (address) {

        return cowriLabs;

    }

    function setCowriLabs (address _c) external {

        require(msg.sender == cowriLabs, "ERR_NOT_BLABS");

        emit CowriLabsSet(msg.sender, _c);

        cowriLabs = _c;

    }

}