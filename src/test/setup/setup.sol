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
        
        loihi_.TEST_includeAssimilatorState(
            dai, cdai, chai, pot,
            usdc, cusdc,
            usdt, ausdt,
            susd, asusd
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
<<<<<<< HEAD
        // loihi_ = Loihi(0x1f47CEee00830AC4C8e4C76Ae8d8F3Bc1F3dB85A);

        includeAssetsSetOne(loihi_);
        setParamsSetOne(loihi_);

        approveStablecoins(address(loihi_));
=======

        loihi_.TEST_includeAssimilatorState(
            dai, cdai, chai, pot,
            usdc, cusdc,
            usdt, ausdt,
            susd, asusd
        );

        includeAssetsSetOne(loihi_);
        includeAssimilatorsSetOne(loihi_);
        setParamsSetTwo(loihi_);

        approveStablecoins(address(loihi_));
        interApproveStablecoinsLocal(address(loihi_));

    }

    function getLoihiSuiteThreeLocal () public returns (Loihi loihi_) {

        setupStablecoinsLocal();
        setupAssimilatorsSetTwoLocal();

        loihi_ = new Loihi();
        
        loihi_.TEST_includeAssimilatorState(
            dai, cdai, chai, pot,
            usdc, cusdc,
            usdt, ausdt,
            susd, asusd
        );

        includeAssetsSetTwo(loihi_);
        includeAssimilatorsSetTwo(loihi_);
        setParamsSetOne(loihi_);

        approveStablecoins(address(loihi_));
        interApproveStablecoinsLocal(address(loihi_));

    }

    function getLoihiSuiteFourLocal () public returns (Loihi loihi_) {

        setupStablecoinsLocal();
        setupAssimilatorsSetTwoLocal();

        loihi_ = new Loihi();

        loihi_.TEST_includeAssimilatorState(
            dai, cdai, chai, pot,
            usdc, cusdc,
            usdt, ausdt,
            susd, asusd
        );

        includeAssetsSetTwo(loihi_);
        includeAssimilatorsSetTwo(loihi_);
        setParamsSetTwo(loihi_);

        approveStablecoins(address(loihi_));
        interApproveStablecoinsLocal(address(loihi_));

    }

    function getLoihiSuiteFiveLocal () public returns (Loihi loihi_) {

        setupStablecoinsLocal();
        setupAssimilatorsSetOneLocal();

        loihi_ = new Loihi();
        
        loihi_.TEST_includeAssimilatorState(
            dai, cdai, chai, pot,
            usdc, cusdc,
            usdt, ausdt,
            susd, asusd
        );

        includeAssetsSetOne(loihi_);
        includeAssimilatorsSetOne(loihi_);
        setParamsSetFour(loihi_);

        approveStablecoins(address(loihi_));
        interApproveStablecoinsLocal(address(loihi_));

    }

    function getLoihiSuiteSixLocal () public returns (Loihi loihi_) {

        setupStablecoinsLocal();
        setupAssimilatorsSetOneLocal();

        loihi_ = new Loihi();

        loihi_.TEST_includeAssimilatorState(
            dai, cdai, chai, pot,
            usdc, cusdc,
            usdt, ausdt,
            susd, asusd
        );

        includeAssetsSetOne(loihi_);
        includeAssimilatorsSetOne(loihi_);
        setParamsSetThree(loihi_);

        approveStablecoins(address(loihi_));
        interApproveStablecoinsLocal(address(loihi_));

    }

    function getLoihiSuiteSixLocalClone () public returns (Loihi loihi_) {

        loihi_ = new Loihi();

        loihi_.TEST_includeAssimilatorState(
            dai, cdai, chai, pot,
            usdc, cusdc,
            usdt, ausdt,
            susd, asusd
        );

        includeAssetsSetOne(loihi_);
        includeAssimilatorsSetOne(loihi_);
        setParamsSetThree(loihi_);

        approveStablecoins(address(loihi_));
        interApproveStablecoinsLocal(address(loihi_));

    }

    function getLoihiSuiteSeven () public returns (Loihi loihi_) {

        setupStablecoinsLocal();
        setupAssimilatorsSetOneLocal();

        loihi_ = new Loihi();

        loihi_.TEST_includeAssimilatorState(
            dai, cdai, chai, pot,
            usdc, cusdc,
            usdt, ausdt,
            susd, asusd
        );

        includeAssetsSetOne(loihi_);
        includeAssimilatorsSetOne(loihi_);
        setParamsSetFive(loihi_);

        approveStablecoins(address(loihi_));
        interApproveStablecoinsLocal(address(loihi_));
>>>>>>> libraries

    }

}