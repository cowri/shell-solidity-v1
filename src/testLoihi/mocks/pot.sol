pragma solidity ^0.5.6;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20Detailed.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "ds-math/math.sol";

contract PotMock {

    constructor () public {}

    function chi () public view returns (uint256) {
        return 1014865463929259205354699760;
    }
    
    function drip () public returns (uint256) {
        return 1014865463929259205354699760;
    }

    function rho () public returns (uint256) {
        return now;
    }
}