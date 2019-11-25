
pragma solidity ^0.5.0;

import "../../LiquidityMembrane.sol";
import "../../ExchangeEngine.sol";
import "./TestShellGovernance.sol";

contract TestCowriPool is TestShellGovernance, LiquidityMembrane, ExchangeEngine {

    constructor (address _shellFactory) public {
        shellFactory = _shellFactory;
    }

    function __init__ () public { }

}