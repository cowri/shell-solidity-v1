pragma solidity ^0.5.0;

interface PotI {
    function rho () external returns (uint256);
    function drip () external returns (uint256);
    function chi () external returns (uint256);
}