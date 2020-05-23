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
import "./interfaces/ICToken.sol";
import "./interfaces/IAToken.sol";
import "./interfaces/IChai.sol";
import "./interfaces/IPot.sol";

import "./Assimilators.sol";
import "./Shells.sol";

contract LoihiRoot {

    int128 constant ZEN = 18446744073709551616000000;

    string  public constant name = "Shells";
    string  public constant symbol = "SHL";
    uint8   public constant decimals = 18;

    Shells.Shell public shell;

    address public owner;
    bool internal notEntered = true;
    bool public frozen = false;

    bytes4 constant internal ERC20ID = 0x36372b07;
    bytes4 constant internal ERC165ID = 0x01ffc9a7;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


    modifier onlyOwner() {
        require(msg.sender == owner, "Ownable: caller is not the owner");
        _;
    }

    modifier nonReentrant() {
        require(notEntered, "re-entered");
        notEntered = false;
        _;
        notEntered = true;
    }

    modifier notFrozen () {
        require(!frozen, "swaps, selective deposits and selective withdraws have been frozen.");
        _;
    }

    IERC20 dai; ICToken cdai; IChai chai; IPot pot;
    IERC20 usdc; ICToken cusdc;
    IERC20 usdt; IAToken ausdt;
    IERC20 susd; IAToken asusd;

    function includeTestAdapterState(address _dai, address _cdai, address _chai, address _pot, address _usdc, address _cusdc, address _usdt, address _ausdt, address _susd, address _asusd) public {
        dai = IERC20(_dai); cdai = ICToken(_cdai); chai = IChai(_chai); pot = IPot(_pot);
        usdc = IERC20(_usdc); cusdc = ICToken(_cusdc);
        usdt = IERC20(_usdt); ausdt = IAToken(_ausdt);
        susd = IERC20(_susd); asusd = IAToken(_asusd);
    }


}