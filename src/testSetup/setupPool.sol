


pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../CowriPool.sol";
import "../ShellFactory.sol";

contract PoolSetup {

    ShellFactory shellFactory;
    CowriPool pool;

    function setupPool () public {
        shellFactory = new ShellFactory();
        pool = new CowriPool(address(shellFactory));
    }
}