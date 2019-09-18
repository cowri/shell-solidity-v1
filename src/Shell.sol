pragma solidity ^0.5.0;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20Detailed.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20Burnable.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "./ERC20Token.sol";

contract Shell is ERC20Mintable, ERC20Burnable {
    using SafeMath for uint256;
    address[] public tokens;

    constructor(address[] memory _tokens) public {
        tokens = _tokens;
    }

    function testBurn(address account, uint amount) public {
        _burn(account, amount);
    }

    function getTokens() public view returns(address[] memory) {
        return tokens;
    }

}