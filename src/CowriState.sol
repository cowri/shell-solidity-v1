pragma solidity ^0.5.0;

import "ds-math/math.sol";
import "./Shell.sol";
import "./ERC20Token.sol";

contract CowriState {

    uint256 public minCapital;
    address[] public supportedTokens;
    Shell[] public shellList;
<<<<<<< HEAD
    mapping(address => mapping(address => Shell[])) public pairsToActiveShells;
    mapping(address => mapping(address => address[])) public pairsToActiveShellAddresses;
    mapping(address => mapping(address => Shell[])) public pairsToAllShells;
    mapping(address => mapping(address => address[])) public pairsToAllShellAddresses;
=======
    mapping(address => mapping(address => Shell[])) public pairsToShells;
    mapping(address => mapping(address => address[])) public pairsToShellAddresses;
>>>>>>> master
    mapping(address => mapping(address => uint)) public shells;

}