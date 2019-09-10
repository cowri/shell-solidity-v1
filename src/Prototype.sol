
pragma solidity ^0.5.0;

import "./LiquidityMembrane.sol";
import "./ExchangeEngine.sol";
import "./ShellGovernance.sol";
import "./CowriState.sol";

contract Prototype is ShellGovernance, LiquidityMembrane, ExchangeEngine {

    function __init__ () public { }

}