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


contract ShellStorage {

    address public owner;

    string  public constant name = "Shells";
    string  public constant symbol = "SHL";
    uint8   public constant decimals = 18;

    Shell public shell;

    struct Shell {
        int128 alpha;
        int128 beta;
        int128 delta;
        int128 epsilon;
        int128 lambda;
        int128[] weights;
        uint totalSupply;
        Assimilator[] assets;
        mapping (address => Assimilator) assimilators;
        mapping (address => uint) balances;
        mapping (address => mapping (address => uint)) allowances;
        bool TEST_HALTS;
    }

    struct Assimilator {
        address addr;
        uint8 ix;
    }

    mapping (address => PartitionTicket) public partitionTickets;

    struct PartitionTicket {
        uint[] claims;
        bool initialized;
    }

    address[] public derivatives;
    address[] public numeraires;
    address[] public reserves;

    bool public partitioned = false;

    bool public frozen = false;

    bool internal notEntered = true;

    uint public maxFee;

    function TEST_setTestHalts (bool toTestOrNotToTest) external {

        shell.TEST_HALTS = toTestOrNotToTest;

    }

    IERC20 dai; ICToken cdai; IChai chai; IPot pot;
    IERC20 usdc; ICToken cusdc;
    IERC20NoBool usdt; IAToken ausdt;
    IERC20 susd; IAToken asusd;

    function TEST_includeAssimilatorState (
        IERC20 _dai, ICToken _cdai, IChai _chai, IPot _pot, 
        IERC20 _usdc, ICToken _cusdc, 
        IERC20NoBool _usdt, IAToken _ausdt, 
        IERC20 _susd, IAToken _asusd
    ) public {

        dai = _dai; cdai = _cdai; chai = _chai; pot = _pot;
        usdc = _usdc; cusdc = _cusdc;
        usdt = _usdt; ausdt = _ausdt;
        susd = _susd; asusd = _asusd;

    }

    function TEST_safeApprove(address _token, address _spender, uint256 _value) public {

        (bool success, bytes memory returndata) = _token.call(abi.encodeWithSignature("approve(address,uint256)", _spender, _value));

        require(success, "SafeERC20: low-level call failed");

    }


}