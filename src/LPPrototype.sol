pragma solidity ^0.5.6;

contract Dapp {
    uint256 public num;

    constructor () public {
        num = 5;
    }

    function getNum () public view returns (uint256) {
        return num;
    }

    function setNum (uint256 x) public {
        num = x;
    }

}
