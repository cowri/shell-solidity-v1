pragma solidity ^0.5.0;

import "./stablecoins.sol";
import "./assimilators.sol";
import "./loihi.sol";

contract Setup is StablecoinSetup, AssimilatorSetup, LoihiSetup {

    function start () public {
        // startMainnet();
        // startKovan();
        startLocal();
    }

    function getALoihi () public returns (Loihi loihi_) {
        loihi_ = setupLoihi30_30_30_10_Local();
        // loihi_ = setupLoihi30_30_30_10_RPC();
    }

    function startMainnet () public {
        setupStablecoinsMainnet();
        setupAssimilatorsMainnet();
    }

    function startKovan () public {
        setupStablecoinsKovan();
        setupAssimilatorsKovan();
    }

    function startLocal () public {
        setupStablecoinsLocal();
        setupAssimilatorsLocal();
    }

}