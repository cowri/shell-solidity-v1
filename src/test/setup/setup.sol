pragma solidity ^0.5.0;

import "../../Loihi.sol";

import "./stablecoins.sol";
import "./assimilators.sol";
import "./loihi.sol";

contract Setup is StablecoinSetup, AssimilatorSetup, LoihiSetup {

    function getLoihiSuiteOne () public returns (Loihi loihi_) {

        // loihi_ = getLoihiSuiteOneLocal();
        loihi_ = getLoihiSuiteOneKovan();
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

        setParamsSetOne(loihi_);

        approveStablecoins(address(loihi_));


    }

    function getLoihiSuiteOneMainnet () public returns (Loihi loihi_) {

        setupStablecoinsMainnet();
        setupAssimilatorsSetOneMainnet();

        loihi_ = new Loihi();

        includeAssetsSetOne(loihi_);
        setParamsSetOne(loihi_);

        approveStablecoins(address(loihi_));

    }

    function getLoihiSuiteOneKovan () public returns (Loihi loihi_) {

        setupStablecoinsKovan();
        setupAssimilatorsSetOneKovan();

        loihi_ = new Loihi();
        // loihi_ = Loihi(0x1f47CEee00830AC4C8e4C76Ae8d8F3Bc1F3dB85A);

        includeAssetsSetOne(loihi_);
        setParamsSetOne(loihi_);

        approveStablecoins(address(loihi_));

    }

}