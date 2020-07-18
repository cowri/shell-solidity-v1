pragma solidity ^0.5.0;

import "../../Loihi.sol";

import "./stablecoins.sol";
import "./assimilators.sol";
import "./loihi.sol";

contract Setup is StablecoinSetup, AssimilatorSetup, LoihiSetup {

    function getLoihiSuiteOne () public returns (Loihi loihi_) {

        loihi_ = getLoihiSuiteOneLocal();
        // loihi_ = getLoihiSuiteOneMainnet();

    }

    function getLoihiSuiteOneLocal () public returns (Loihi loihi_) {

        setupStablecoinsLocal();
        setupAssimilatorsSetOneLocal();

        loihi_ = new Loihi();

        loihi_.includeTestAssimilatorState(
            dai,
            usdc,
            usdt,
            susd
        );

        includeAssetsSetOne(loihi_);
        // includeAssimilatorsSetOne(loihi_);

        setParamsSetOne(loihi_);

        approveStablecoins(address(loihi_));


    }

    function getLoihiSuiteOneMainnet () public returns (Loihi loihi_) {

        setupStablecoinsMainnet();
        // setupAssimilatorsSetOneMainnet();

        loihi_ = new Loihi();

        includeAssetsSetOne(loihi_);
        // includeAssimilatorsSetOne(loihi_);
        setParamsSetOne(loihi_);

        approveStablecoins(address(loihi_));
        // interApproveStablecoinsRPC(address(loihi_));

    }

}