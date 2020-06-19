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

pragma solidity ^0.5.15;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20NoBool.sol";
import "./interfaces/ICToken.sol";
import "./interfaces/IAToken.sol";
import "./interfaces/IChai.sol";
import "./interfaces/IPot.sol";

import "./Assimilators.sol";
import "./Shells.sol";

contract LoihiRoot {

    int128 constant ONE = 0x10000000000000000;

    string  public constant name = "Shells";
    string  public constant symbol = "SHL";
    uint8   public constant decimals = 18;

    Shells.Shell public shell;

    address public owner;
    bool internal notEntered = true;
    bool public frozen = false;

    uint maxFee; 

    bytes4 constant internal ERC20ID = 0x36372b07;
    bytes4 constant internal ERC165ID = 0x01ffc9a7;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


    modifier onlyOwner() {
        require(msg.sender == owner, "Shell/caller-is-not-owner");
        _;
    }

    event log(bytes32);

    modifier nonReentrant() {
        require(notEntered, "Shell/re-entered");
        emit log("entered");
        notEntered = false;
        _;
        emit log("exited");
        notEntered = true;
    }

    modifier notFrozen () {
        require(!frozen, "Shell/frozen-only-allowing-proportional-withdraw");
        _;
    }

    IERC20 dai; ICToken cdai; IChai chai; IPot pot;
    IERC20 usdc; ICToken cusdc;
    IERC20NoBool usdt; IAToken ausdt;
    IERC20 susd; IAToken asusd;

    function includeTestAssimilatorState(IERC20 _dai, ICToken _cdai, IChai _chai, IPot _pot, IERC20 _usdc, ICToken _cusdc, IERC20NoBool _usdt, IAToken _ausdt, IERC20 _susd, IAToken _asusd) public {
        dai = _dai; cdai = _cdai; chai = _chai; pot = _pot;
        usdc = _usdc; cusdc = _cusdc;
        usdt = _usdt; ausdt = _ausdt;
        susd = _susd; asusd = _asusd;
    }

    function setTestHalts (bool _testOrNotToTest) public {

        shell.testHalts = _testOrNotToTest;

    }


}