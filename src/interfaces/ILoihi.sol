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
        uint256 originAmount
    ) external view returns (uint256);

    function viewTargetTrade (
        address origin,
        address target,
        uint256 targetAmount
    ) external view returns (uint256);

    function swapByOrigin (
        address origin,
        address target,
        uint256 originAmount,
        uint256 minTargetAmount,
        uint256 deadline
    ) external returns (uint256);

    function transferByOrigin (
        address origin,
        address target,
        uint256 originAmount,
        uint256 targetMin,
        uint256 deadline,
        address recipient
    ) external returns (uint256);

    function swapByTarget (
        address origin,
        address target,
        uint256 targetAmount,
        uint256 maxOriginAmount,
        uint256 deadline
    ) external returns (uint256);

    function tansferByTarget (
        address origin,
        address target,
        uint256 targetAmount,
        uint256 maxOriginAmount,
        address recipient,
        uint256 deadline
    ) external returns (uint256);

    function selectiveDeposit (
        address[] calldata _flavors,
        uint256[] calldata _amounts,
        uint256 _minShells,
        uint256 _deadline
    ) external returns (uint256);

    function selectiveWithdraw (
        address[] calldata _flavors,
        uint256[] calldata _amounts,
        uint256 _maxShells,
        uint256 _deadline
    ) external returns (uint256);

    function proportionalDeposit (
        uint256 totalStablecoins
    ) external returns (uint256[] memory);

    function proportionalWithdraw (
        uint256 shellTokens
    ) external returns (uint256[] memory);

    function transferOwnership (
        address newOwner
    ) external;

    function owner () external view returns (address);

    function includeNumeraireReserveAndWeight (address numeraire, address reserve, uint256 weight) external;
    function includeAdapter (address flavor, address adapter, address reserve, uint256 weight) external;
    function excludeAdapter (address flavor) external;
    function setParams (uint256 alpha, uint256 beta, uint256 feeDerivative, uint256 feeBase) external;
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function liquidity () external view returns (uint256, uint256[] memory);
    function getNumeraires () external view returns (address[] memory);
    function getReserves () external view returns (address[] memory);
    function getAdapter (address flavor) external view returns (address[] memory);
    function executeApprovals (address[] calldata targets, address[] calldata spenders) external;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event ShellsMinted(address indexed minter, uint256 amount, address[] indexed coins, uint256[] amounts);
    event ShellsBurned(address indexed burner, uint256 amount, address[] indexed coins, uint256[] amounts);
    event ShellsBurned(address indexed burner, uint256 amount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Trade(address indexed trader, address indexed origin, address indexed target, uint256 originAmount, uint256 targetAmount);

}