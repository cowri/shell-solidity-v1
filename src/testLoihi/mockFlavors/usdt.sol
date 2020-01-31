pragma solidity ^0.5.6;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20Detailed.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract usdtMock is ERC20, ERC20Detailed, ERC20Mintable {
      constructor( string memory _name, string memory _symbols, uint8 _decimals, uint256 _amount)
      ERC20Detailed(_name, _symbols, _decimals)
      public { _mint(msg.sender, _amount); }

      function transfer (address recipient, uint256 amount) public {
            _transfer(_msgSender(), recipient, amount);
      }

      function transferFrom (address sender, address recipient, uint256 amount) public {
            _transfer(sender, recipient, amount);
            _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
      }
}