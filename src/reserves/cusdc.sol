pragma solidity ^0.5.12;

import "../CTokenI.sol";
import "../LoihiRoot.sol";

contract cUsdcReserve is LoihiRoot {
    address reserve;

    constructor () public { }

    function getReserves () public returns (uint256) {
        return reserves[reserve];
    }

    function unwrap () public returns (uint256) {

    }

    function wrap () public returns (uint256) {

    }

    function transfer () public returns (uint256) {

    }

    function transferFrom () public returns (uint256) {

    }
}