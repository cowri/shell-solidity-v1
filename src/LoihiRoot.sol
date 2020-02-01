pragma solidity ^0.5.0;

import "openzeppelin-contracts/contracts/ownership/Ownable.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20Burnable.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20Detailed.sol";
import "ds-math/math.sol";

contract LoihiRoot is ERC20Mintable, ERC20Burnable, DSMath, Ownable {

    mapping(address => uint256) public reserves;
    mapping(address => Flavor) public flavors;
    address[] public reservesList;
    address[] public numeraireAssets;
    struct Flavor { address adapter; uint256 weight; }

    uint256 alpha = 950000000000000000; // 95%
    uint256 beta = 475000000000000000; // half of 95%
    uint256 feeBase = 500000000000000; // 5 bps
    uint256 feeDerivative = 52631578940000000; // marginal fee will be 5% at alpha point


}