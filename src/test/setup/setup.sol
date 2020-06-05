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

    function getLoihiSuiteTwo () public returns (Loihi loihi_) {
        loihi_ = getLoihiSuiteTwoLocal();
        // loihi_ = getLoihiSuiteTwoMainnet();
    }

    function getLoihiSuiteOneLocal () public returns (Loihi loihi_) {

        setupStablecoinsLocal();
        setupAssimilatorsSetOneLocal();

        loihi_ = new Loihi();

        includeAssimilators(loihi_);
        setNumeraireAssets30_30_30_10(loihi_);
        approveStablecoins(address(loihi_));
        interApproveStablecoinsLocal(address(loihi_));
        setLoihiParamsSetNumberOne(loihi_);

        loihi_.includeTestAdapterState(
            dai, cdai, chai, pot,
            usdc, cusdc,
            usdt, ausdt,
            susd, asusd
        );

    }

    function getLoihiSuiteOneMainnet () public returns (Loihi loihi_) {

        setupStablecoinsMainnet();
        setupAssimilatorsSetOneMainnet();

        loihi_ = new Loihi();

        includeAssimilators(loihi_);
        setNumeraireAssets30_30_30_10(loihi_);
        approveStablecoins(address(loihi_));
        interApproveStablecoinsRPC(address(loihi_));
        setLoihiParamsSetNumberOne(loihi_);

    }

    function getLoihiSuiteTwoLocal () public returns (Loihi loihi_) {

        setupStablecoinsLocal();
        setupAssimilatorsSetOneLocal();

        loihi_ = new Loihi();

        includeAssimilators(loihi_);
        setNumeraireAssets30_30_30_10(loihi_);
        approveStablecoins(address(loihi_));
        interApproveStablecoinsLocal(address(loihi_));
        setLoihiParamsSetNumberTwo(loihi_);

        loihi_.includeTestAdapterState(
            dai, cdai, chai, pot,
            usdc, cusdc,
            usdt, ausdt,
            susd, asusd
        );

    }

}