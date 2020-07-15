pragma solidity ^0.5.0;

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