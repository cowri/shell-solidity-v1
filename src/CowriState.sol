pragma solidity ^0.5.0;

import "ds-math/math.sol";
import "./Shell.sol";
import "./ERC20Token.sol";

contract CowriState {

    uint256 public minCapital;
    address[] public supportedTokens;
    address[] public shellList;
    address public shellFactory;
    mapping(address => bool) public shells;
    mapping(uint256 => uint256) public shellBalances;
    mapping(uint256 => address[]) public pairsToAllShells;
    mapping(uint256 => address[]) public pairsToActiveShells;

}