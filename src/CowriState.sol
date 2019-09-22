pragma solidity ^0.5.0;

import "ds-math/math.sol";
import "./Shell.sol";
import "./ERC20Token.sol";

contract CowriState {

    uint256 public minCapital;
    address[] public supportedTokens;
    address[] public shellList;
    address public shellFactory;
    mapping(address => mapping(address => address[])) public pairsToActiveShells;
    mapping(address => mapping(address => address[])) public pairsToAllShells;
    mapping(address => mapping(address => uint)) public shellBalances;
    mapping(address => bool) public shells;

}