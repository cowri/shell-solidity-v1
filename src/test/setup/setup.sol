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

    function getLoihiSuiteThree () public returns (Loihi loihi_) {

        loihi_ = getLoihiSuiteThreeLocal();

    }

    function getLoihiSuiteFive () public returns (Loihi loihi_) {

        loihi_ = getLoihiSuiteFiveLocal();

    }

    event log(bytes32);

    function getLoihiSuiteOneLocal () public returns (Loihi loihi_) {

        setupStablecoinsLocal();
        setupAssimilatorsSetOneLocal();

        loihi_ = new Loihi();

        includeAssetsSetOne(loihi_);
        includeAssimilatorsSetOne(loihi_);

        emit log("before params set");

        setParamsSetOne(loihi_);

        emit log("after params set");

        approveStablecoins(address(loihi_));
        interApproveStablecoinsLocal(address(loihi_));

        loihi_.includeTestAssimilatorState(
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

        includeAssetsSetOne(loihi_);
        includeAssimilatorsSetOne(loihi_);
        setParamsSetOne(loihi_);

        approveStablecoins(address(loihi_));
        interApproveStablecoinsRPC(address(loihi_));

    }

    function getLoihiSuiteTwoLocal () public returns (Loihi loihi_) {

        setupStablecoinsLocal();
        setupAssimilatorsSetOneLocal();

        loihi_ = new Loihi();

        includeAssetsSetOne(loihi_);
        includeAssimilatorsSetOne(loihi_);
        setParamsSetTwo(loihi_);

        approveStablecoins(address(loihi_));
        interApproveStablecoinsLocal(address(loihi_));

        loihi_.includeTestAssimilatorState(
            dai, cdai, chai, pot,
            usdc, cusdc,
            usdt, ausdt,
            susd, asusd
        );

    }

    function getLoihiSuiteThreeLocal () public returns (Loihi loihi_) {

        setupStablecoinsLocal();
        setupAssimilatorsSetTwoLocal();

        loihi_ = new Loihi();

        includeAssetsSetTwo(loihi_);
        includeAssimilatorsSetTwo(loihi_);
        setParamsSetOne(loihi_);

        approveStablecoins(address(loihi_));
        interApproveStablecoinsLocal(address(loihi_));

        loihi_.includeTestAssimilatorState(
            dai, cdai, chai, pot,
            usdc, cusdc,
            usdt, ausdt,
            susd, asusd
        );

    }

    function getLoihiSuiteFourLocal () public returns (Loihi loihi_) {

        setupStablecoinsLocal();
        setupAssimilatorsSetTwoLocal();

        loihi_ = new Loihi();

        includeAssetsSetTwo(loihi_);
        includeAssimilatorsSetTwo(loihi_);
        setParamsSetTwo(loihi_);

        approveStablecoins(address(loihi_));
        interApproveStablecoinsLocal(address(loihi_));

        loihi_.includeTestAssimilatorState(
            dai, cdai, chai, pot,
            usdc, cusdc,
            usdt, ausdt,
            susd, asusd
        );

    }

    function getLoihiSuiteFiveLocal () public returns (Loihi loihi_) {

        setupStablecoinsLocal();
        setupAssimilatorsSetOneLocal();

        loihi_ = new Loihi();

        includeAssetsSetOne(loihi_);
        includeAssimilatorsSetOne(loihi_);
        setParamsSetFour(loihi_);

        approveStablecoins(address(loihi_));
        interApproveStablecoinsLocal(address(loihi_));

        loihi_.includeTestAssimilatorState(
            dai, cdai, chai, pot,
            usdc, cusdc,
            usdt, ausdt,
            susd, asusd
        );

    }
}