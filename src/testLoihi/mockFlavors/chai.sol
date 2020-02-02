pragma solidity ^0.5.6;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20Detailed.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "ds-math/math.sol";

contract ChaiMock is ERC20, ERC20Detailed, ERC20Mintable, DSMath {
    ERC20 underlying;
    constructor(address _underlying, string memory _name, string memory _symbols, uint8 _decimals, uint256 _amount)
    ERC20Detailed(_name, _symbols, _decimals) public {
        _mint(msg.sender, _amount);
        underlying = ERC20(_underlying);
        emit log_uint("balanceOf", balanceOf(msg.sender));
    }

    event log_uint(bytes32, uint256);

    function draw (address src, uint wad) public {
        _burnFrom(src, wad / 2);
        underlying.transfer(msg.sender, wad);
    }

    function exit (address src, uint wad) public {
        _burnFrom(src, wad);
        underlying.transfer(msg.sender, wad * 2);
    }

    function join (address dst, uint wad) public {
        underlying.transferFrom(msg.sender, dst, wad);
        mint(dst, wad / 2);
    }

    event log_address(bytes32, address);
    function dai (address usr) public returns (uint wad) {
        emit log_address("dai", usr);
        return balanceOf(usr) * 2;
    }

    function move (address src, address dst, uint wad) public returns (bool) {
        transferFrom(src, dst, wad/2);
        return true;
    }

}