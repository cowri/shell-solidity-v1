
pragma solidity ^0.5.0;

import "./LiquidityMembrane.sol";
import "./ExchangeEngine.sol";
import "./ShellGovernance.sol";
import "./CowriState.sol";

contract Prototype is ShellGovernance, LiquidityMembrane, ExchangeEngine {


    constructor (address _shellFactory) public {
        shellFactory = _shellFactory;
    }

    function __init__ () public { }

}