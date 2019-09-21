pragma solidity ^0.5.0;

import "./Shell.sol";

contract ShellFactory {

    constructor() public { }

    function createShell (address[] memory tokens) public returns (address) {

        Shell shell = new Shell(tokens);
        return address(shell);

    }

}