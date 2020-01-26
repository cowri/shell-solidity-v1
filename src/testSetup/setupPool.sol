pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "../Loihi.sol";

contract LoihiSetup {

    Loihi loihi;

    function setupLoihi () public {
        loihi = new Loihi();
    }

}