pragma solidity ^0.5.0;

import "openzeppelin-contracts/contracts/token/ERC20/BadERC20Detailed.sol";
import "openzeppelin-contracts/contracts/token/ERC20/BadERC20Mintable.sol";
import "openzeppelin-contracts/contracts/token/ERC20/BadERC20.sol";

contract BadERC20Mock is BadERC20, BadERC20Detailed, BadERC20Mintable {
      constructor( string memory _name, string memory _symbols, uint8 _decimals, uint256 _amount)
      BadERC20Detailed(_name, _symbols, _decimals)
      public { _mint(msg.sender, _amount); }
}