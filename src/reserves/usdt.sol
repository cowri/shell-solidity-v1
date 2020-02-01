pragma solidity ^0.5.12;

import "../LoihiRoot.sol";

contract UsdtReserve is LoihiRoot {
    address reserve;

    constructor () public { }

    function getReserves (address addr) public returns (uint256) {
        return reserves[reserve];
    }

    function unwrap (uint256 amount) public returns (uint256) {
        return amount;
    }

    function wrap (uint256 amount) public returns (uint256) {
        return amount;
    }

    function transfer (uint256 amount) public returns (uint256) {
        return amount;
    }

    function transferFrom (uint256 amount) public returns (uint256) {
        return amount;
    }
}