pragma solidity ^0.5.6;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20Detailed.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "ds-math/math.sol";

contract cDaiMock is ERC20, ERC20Detailed, ERC20Mintable, DSMath {
    ERC20 underlying;
    constructor(address _underlying, string memory _name, string memory _symbols, uint8 _decimals, uint256 _amount)
    ERC20Detailed(_name, _symbols, _decimals) public {
        _mint(msg.sender, _amount);
        underlying = ERC20(_underlying);
    }

    function mint (uint256 amount) public returns (uint) {
        _mint(msg.sender, amount / 2);
        underlying.transferFrom(msg.sender, address(this), amount);
        return amount / 2;
    }

    function redeem (uint256 amount) public returns (uint) {
        _burn(msg.sender, amount);
        underlying.transfer(msg.sender, amount * 2);
        return amount * 2;
    }

    function redeemUnderlying (uint256 amount) public returns (uint) {
        _burn(msg.sender, amount / 2);
        underlying.transfer(msg.sender, amount);
        return amount;
    }

    function getCash () external view returns (uint) {
        return underlying.balanceOf(address(this)) / 3;
    }

    function exchangeRateCurrent () external view returns (uint) {
        return wdiv(WAD, 2);
    }

    function balanceOfUnderlying (address account) public view returns (uint256) {
        uint256 balance = balanceOf(account);
        return balance * 2;
    }

}