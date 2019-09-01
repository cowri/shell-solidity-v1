pragma solidity ^0.5.0;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20Burnable.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract Shell is ERC20Mintable, ERC20Burnable {
    using SafeMath for uint256;
    ERC20[] public tokens;
    address[] public tokenAddresses;

    constructor(address[] memory _tokens) public {
        tokenAddresses = _tokens;
        for (uint8 i = 0; i < _tokens.length; i++) {
            tokens.push(ERC20(_tokens[i]));
        }
    }

    function testBurn(address account, uint amount) public {
        _burn(account, amount);
    }

    function getTokens() public view returns(ERC20[] memory) {
        return tokens;
    }

    function getTokenAddresses() public view returns (address[] memory) {
        return tokenAddresses;
    }

}