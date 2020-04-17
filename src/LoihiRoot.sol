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


import "./LoihiMath.sol";
import "./interfaces/ICToken.sol";
import "./interfaces/IAToken.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IChai.sol";
import "./interfaces/IPot.sol";

contract LoihiRoot is LoihiMath {

    string  public constant name = "Shells";
    string  public constant symbol = "SHL";
    uint8   public constant decimals = 18;

    mapping (address => uint256) internal balances;
    mapping (address => mapping (address => uint256)) internal allowances;
    uint256 public totalSupply;

    struct Flavor { address adapter; address reserve; }
    mapping(address => Flavor) public flavors;

    address[] public reserves;
    address[] public numeraires;
    uint256[] public weights;

    address public owner;
    bool internal notEntered = true;
    bool public frozen = false;

    uint256 public alpha;
    uint256 public beta;
    uint256 public delta;
    uint256 public epsilon;
    uint256 public lambda;
    uint256 internal omega;

    bytes4 constant internal ERC20ID = 0x36372b07;
    bytes4 constant internal ERC165ID = 0x01ffc9a7;

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


    // address constant exchange = 0xfb8443545771E2BB15bB7cAdDa43A16a1Ab69c0B;
    // address constant liquidity = 0xA3f4A860eFa4a60279E6E50f2169FDD080aAb655;
    // address constant views = 0x81dBd2ec823cB2691f34c7b5391c9439ec5c80E3;
    // address constant erc20 = 0x7DB32869056647532f80f482E5bB1fcb311493cD;
    address exchange;
    address liquidity;
    address views;
    address erc20;

    event ShellsMinted(address indexed minter, uint256 amount, address[] indexed coins, uint256[] amounts);
    event ShellsBurned(address indexed burner, uint256 amount, address[] indexed coins, uint256[] amounts);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Trade(address indexed trader, address indexed origin, address indexed target, uint256 originAmount, uint256 targetAmount);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);

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

}