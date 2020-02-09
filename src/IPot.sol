pragma solidity ^0.5.0;

interface IPot {
    function rho () external returns (uint256);
    function drip () external returns (uint256);
    function chi () external returns (uint256);
}