pragma solidity ^0.5.12;

import "../CTokenI.sol";

contract ChaiReserve {
    mapping(address => uint256) public reserves;
    address constant reserve;

    constructor () public { }

    function getReserves () public returns (uint256) {
        return reserves[address];
    }

    function unwrap () public returns (uint256) {

    }

    function wrap () public returns (uint256) {

    }

    function transfer () public returns (uint256) {

    }

    function transferFrom () public returns (uint256) {

    }
}