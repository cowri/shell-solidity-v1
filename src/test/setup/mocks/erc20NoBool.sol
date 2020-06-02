pragma solidity ^0.5.0;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20NoBoolDetailed.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20NoBoolMintable.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20NoBool.sol";

contract ERC20NoBoolMock is ERC20NoBool, ERC20NoBoolDetailed, ERC20NoBoolMintable {
      constructor( string memory _name, string memory _symbols, uint8 _decimals, uint256 _amount)
      ERC20NoBoolDetailed(_name, _symbols, _decimals)
      public { _mint(msg.sender, _amount); }
}