
pragma solidity ^0.5.0;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20Burnable.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "../Shell.sol";

contract TestGas {
    using SafeMath for uint256;
    Shell shell;
    mapping(address => address) addressMap;
    mapping(address => Shell) shellMap;

    constructor() public {
        address[] memory addrs = new address[](1);
        addrs[0] = address(this);
        shell = new Shell(addrs);
        addressMap[address(this)] = address(shell);
        shellMap[address(this)] = shell;
    }

    function testMappingAddress () public returns (address) {
        address addr = addressMap[address(this)];
        return addr;
    }

    function testMappingShell () public returns (Shell) {
        Shell _shell = shellMap[address(this)];
        return _shell;
    }

}