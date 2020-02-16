pragma solidity ^0.5.0;

import "openzeppelin-contracts/contracts/ownership/Ownable.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20Burnable.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20Detailed.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "ds-math/math.sol";
import "./IChai.sol";
import "./IPot.sol";
import "./ICToken.sol";

contract LoihiRoot is DSMath {

    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowances;
    uint256 public totalSupply;

    mapping(address => Flavor) public flavors;
    address[] public reserves;
    address[] public numeraires;
    struct Flavor { address adapter; address reserve; uint256 weight; }

    address public owner;

    uint256 alpha = 950000000000000000; // 95%
    uint256 beta = 475000000000000000; // half of 95%
    uint256 feeBase = 500000000000000; // 5 bps
    uint256 feeDerivative = 52631578940000000; // marginal fee will be 5% at alpha point

    bool internal notEntered = true;

    bytes4 constant internal ERC20ID = 0x36372b07;
    bytes4 constant internal ERC165ID = 0x01ffc9a7;

    // address internal exchange;
    // address internal views;
    // address internal liquidity;
    // address internal erc20;

    address internal constant exchange = 0xD645FDeB248690F3C8d4478DbE1D2D65f1903943;
    address internal constant views = 0x98B01ed6D3f173719DF0C369AFF2a9DD4CDB50dE;
    address internal constant liquidity = 0xC67F65A52A598519A46Bf0e90F1f0F21E55848DE;
    address internal constant erc20 = 0xf00558eE9bfd7749FaF63bbFd1DA1b9AD60b441c;

    // IChai chai;
    // ICToken cdai;
    // IERC20 dai;
    // IPot pot;
    // ICToken cusdc;
    // IERC20 usdc;
    // IERC20 usdt;

    event ShellsMinted(address indexed minter, uint256 amount, address[] indexed coins, uint256[] amounts);
    event ShellsBurned(address indexed burner, uint256 amount, address[] indexed coins, uint256[] amounts);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    event Trade(address indexed trader, address indexed origin, address indexed target, uint256 originAmount, uint256 targetAmount);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);

    modifier nonReentrant() {
        require(notEntered, "re-entered");
        notEntered = false;
        _;
        notEntered = true;
    }

}