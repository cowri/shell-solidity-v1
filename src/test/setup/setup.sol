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

    function getLoihiSuiteOne () public returns (Loihi loihi_) {
        loihi_ = setupLocalLoihiSuiteOne();
        // loihi_ = setupRPCLoihiSuiteOne();
    }

    function getLoihiSuiteTwo () public returns (Loihi loihi_) {
        loihi_ = setupLocalLoihiSuiteTwo();
        // loihi_ = setupRPCLoihiSuiteTwo();
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