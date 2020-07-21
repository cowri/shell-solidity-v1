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

interface ILoihi {

    function viewOriginTrade (
        address origin,
        address target,
        uint originAmount
    ) external view returns (uint);

    function viewTargetTrade (
        address origin,
        address target,
        uint targetAmount
    ) external view returns (uint);

    function swapByOrigin (
        address origin,
        address target,
        uint originAmount,
        uint minTargetAmount,
        uint deadline
    ) external returns (uint);

    function transferByOrigin (
        address origin,
        address target,
        uint originAmount,
        uint targetMin,
        uint deadline,
        address recipient
    ) external returns (uint);

    function swapByTarget (
        address origin,
        address target,
        uint targetAmount,
        uint maxOriginAmount,
        uint deadline
    ) external returns (uint);

    function tansferByTarget (
        address origin,
        address target,
        uint targetAmount,
        uint maxOriginAmount,
        address recipient,
        uint deadline
    ) external returns (uint);

    function selectiveDeposit (
        address[] calldata _flavors,
        uint[] calldata _amounts,
        uint _minShells,
        uint _deadline
    ) external returns (uint);

    function selectiveWithdraw (
        address[] calldata _flavors,
        uint[] calldata _amounts,
        uint _maxShells,
        uint _deadline
    ) external returns (uint);

    function proportionalDeposit (
        uint totalStablecoins,
        uint deadline
    ) external returns (uint shells_, uint[] memory);

    function proportionalWithdraw (
        uint shellTokens,
        uint deadline
    ) external returns (uint[] memory);

    function owner () external view returns (address);

    function includeAsset (address _numeraire, address _nAssim, address _reserve, address _rAssim, uint _weight) external;
    function includeAssimilator (address _numeraire, address _derivative, address _assimilator) external;
    function excluseAssimilator (address _assimilator) external;
    function freeze (bool _toFreezeOrNotToFreeze) external;
    function transferOwnership (address _newOwner) external;
    function setParams (uint _alpha, uint _beta, uint _epsilon, uint _max, uint _lambda) external;
    function prime () external;
    function liquidity () external view returns (uint, uint[] memory);

    function decimals() external view returns (uint);
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
    function approve(address spender, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
    event ShellsMinted(address indexed minter, uint amount, address[] indexed coins, uint[] amounts);
    event ShellsBurned(address indexed burner, uint amount, address[] indexed coins, uint[] amounts);
    event ShellsBurned(address indexed burner, uint amount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Trade(address indexed trader, address indexed origin, address indexed target, uint originAmount, uint targetAmount);

}