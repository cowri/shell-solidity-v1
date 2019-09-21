


pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../Prototype.sol";
import "../ShellFactory.sol";

contract PoolSetup {

    ShellFactory shellFactory;
    Prototype pool;

    function setupPool () public {
        shellFactory = new ShellFactory();
        pool = new Prototype(address(shellFactory));
    }
}