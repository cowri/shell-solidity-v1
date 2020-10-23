pragma solidity ^0.5.0;


import "./Ownable.sol";

interface IBorrower {
    function executeOnFlashMint(uint256 amount) external;
}