pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../CowriPool.sol";
import "../CowriShellFactory.sol";

contract PoolSetup {

    CowriShellFactory shellFactory;
    CowriPool pool;

    function setupPool () public {
        shellFactory = new CowriShellFactory();
        pool = new CowriPool(address(shellFactory));
    }
}