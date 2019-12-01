pragma solidity ^0.5.0;

import "./CowriShell.sol";

contract CowriShellFactory {

    constructor() public { }

    function createShell (address[] memory tokens) public returns (address) {

        CowriShell shell = new CowriShell(tokens);
        return address(shell);

    }

}