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

import "ds-math/math.sol";

import "./interfaces/IAToken.sol";
import "./interfaces/ICToken.sol";
import "./interfaces/IChai.sol";
import "./interfaces/IPot.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract LoihiRoot is DSMath {

    string  public constant name = "Shells";
    string  public constant symbol = "SHL";
    uint8   public constant decimals = 18;

    mapping (address => uint256) internal balances;
    mapping (address => mapping (address => uint256)) internal allowances;
    uint256 public totalSupply;

    struct Flavor { address adapter; address reserve; uint256 weight; }
    mapping(address => Flavor) public flavors;

    address[] public reserves;
    address[] public numeraires;
    uint256[] public weights;

    address public owner;
    bool internal notEntered = true;
    bool internal frozen = false;

    uint256 alpha;
    uint256 beta;
    uint256 feeBase;
    uint256 feeDerivative;
    uint256 arbPiece;

    bytes4 constant internal ERC20ID = 0x36372b07;
    bytes4 constant internal ERC165ID = 0x01ffc9a7;

    address exchange;
    address views;
    address liquidity;
    address erc20;

    IERC20 dai;
    ICToken cdai;
    IChai chai;
    IPot pot;

    IERC20 usdc;
    ICToken cusdc;

    IERC20 usdt;
    IAToken ausdt;

    IERC20 susd;
    IAToken asusd;

    event log_addr(bytes32, address);

    function includeTestAdapterState(address _dai, address _cdai, address _chai, address _pot, address _usdc, address _cusdc, address _usdt, address _ausdt, address _susd, address _asusd) public {

        dai = IERC20(_dai);
        cdai = ICToken(_cdai);
        chai = IChai(_chai);
        pot = IPot(_pot);

        usdc = IERC20(_usdc);
        cusdc = ICToken(_cusdc);

        usdt = IERC20(_usdt);
        ausdt = IAToken(_ausdt);

        susd = IERC20(_susd);
        asusd = IAToken(_asusd);

    }

    // address internal constant exchange = 0xb40B60cD9687DAe6FE7043e8C62bb8Ec692632A3;
    // address internal constant views = 0x04a6cf4E770a9aF7E6b6733462d72E238B8Ab140;
    // address internal constant liquidity = 0x7dB66490D3436717f90d4681bf8297A2f2b8774A;
    // address internal constant erc20 = 0xfFa473D58C9f15e97B86AD281F876d9Dbf96241C;

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