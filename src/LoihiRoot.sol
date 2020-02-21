pragma solidity ^0.5.0;

import "ds-math/math.sol";

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

    address internal exchange;
    address internal views;
    address internal liquidity;
    address internal erc20;

    address internal constant exchange = 0x7F763137Fe652A1b05d1012053C91D5629b81dA;
    address internal constant views = 0xdB264f3b85F838b1E1cAC5F160E9eb1dD8644BA7;
    address internal constant liquidity = 0xe39E5864850DB2EC709cD11576589baa51f0fE35;
    address internal constant erc20 = 0x2d5cBAB179Be33Ade692A1C95908AD5d556E2c65;

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