pragma solidity ^0.5.0;

import "../../Loihi.sol";

import "../../LoihiFactory.sol";

import "./stablecoins.sol";
import "./assimilators.sol";
import "./loihi.sol";

contract Setup is StablecoinSetup, AssimilatorSetup, LoihiSetup {

    function getLoihiFactorySuiteOne () public returns (LoihiFactory loihiFactory_) {

        loihiFactory_ = getLoihiFactorySuiteOneLocal();

    }

    function getLoihiSuiteOne () public returns (Loihi loihi_) {

        loihi_ = getLoihiSuiteOneLocalFromFactory();

        // loihi_ = getLoihiSuiteOneLocal();
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

    function getLoihiSuiteSix () public returns (Loihi loihi_) {

        loihi_ = getLoihiSuiteSixLocal();

    }

    function getLoihiSuiteSixClone () public returns (Loihi loihi_) {

        loihi_ = getLoihiSuiteSixLocalClone();

    }

    function getLoihiFactorySuiteOneLocal () public returns (LoihiFactory loihiFactory_) {

        setupStablecoinsLocal();

        setupAssimilatorsSetOneLocal();

        loihiFactory_ = new LoihiFactory();

    }
    

    function newLoihi () public returns (Loihi loihi_) {
        
        address[] memory _assets = new address[](0);
        uint[] memory _weights = new uint[](0);
        address[] memory _derivatives = new address[](0);        
        
        loihi_ = new Loihi(
            _assets,
            _weights,
            _derivatives
        );

    }

    event log(bytes32);
    
    function getLoihiSuiteOneLocalFromFactory () public returns (Loihi loihi_) {
        
        
        setupStablecoinsLocal();
        
        setupAssimilatorsSetOneLocal();
        
        LoihiFactory lf = new LoihiFactory();

        address[] memory _assets = new address[](20);
        uint[] memory _assetWeights = new uint[](4);
        address[] memory _derivativeAssimilators = new address[](0);

        _assets[0] = address(dai);
        _assets[1] = address(daiAssimilator);
        _assets[2] = address(dai);
        _assets[3] = address(daiAssimilator);
        _assets[4] = address(dai);
        _assetWeights[0] = .3e18;

        _assets[5] = address(usdc);
        _assets[6] = address(usdcAssimilator);
        _assets[7] = address(usdc);
        _assets[8] = address(usdcAssimilator);
        _assets[9] = address(usdc);
        _assetWeights[1] = .3e18;

        _assets[10] = address(usdt);
        _assets[11] = address(usdtAssimilator);
        _assets[12] = address(usdt);
        _assets[13] = address(usdtAssimilator);
        _assets[14] = address(usdt);
        _assetWeights[2] = .3e18;

        _assets[15] = address(susd);
        _assets[16] = address(susdAssimilator);
        _assets[17] = address(susd);
        _assets[18] = address(susdAssimilator);
        _assets[19] = address(susd);
        _assetWeights[3] = .1e18;
        
        loihi_ = lf.newShell(
            _assets,
            _assetWeights,
            _derivativeAssimilators
        );
        
        emit log("mew shell");
        
        loihi_.TEST_includeAssimilatorState(
            dai, cdai, chai, pot,
            usdc, cusdc,
            usdt, ausdt,
            susd, asusd
        );
        
        emit log("after assim state");
        
        setParamsSetOne(loihi_);

        approveStablecoins(address(loihi_));

        interApproveStablecoinsLocal(address(loihi_));

    }
    
    function getLoihiSuiteOneLocal () public returns (Loihi loihi_) {

        // setupStablecoinsLocal();
        // setupAssimilatorsSetOneLocal();

        // loihi_ = newLoihi();
        
        // loihi_.TEST_includeAssimilatorState(
        //     dai, cdai, chai, pot,
        //     usdc, cusdc,
        //     usdt, ausdt,
        //     susd, asusd
        // );

        // includeAssetsSetOne(loihi_);
        // includeAssimilatorsSetOne(loihi_);

        // setParamsSetOne(loihi_);

        // approveStablecoins(address(loihi_));
        // interApproveStablecoinsLocal(address(loihi_));


    }

    function getLoihiSuiteOneMainnet () public returns (Loihi loihi_) {

        // setupStablecoinsMainnet();
        // setupAssimilatorsSetOneMainnet();

        // loihi_ = newLoihi();

        // includeAssetsSetOne(loihi_);
        // includeAssimilatorsSetOne(loihi_);
        // setParamsSetOne(loihi_);

        // approveStablecoins(address(loihi_));
        // interApproveStablecoinsRPC(address(loihi_));

    }

    function getLoihiSuiteTwoLocal () public returns (Loihi loihi_) {

        // setupStablecoinsLocal();
        // setupAssimilatorsSetOneLocal();

        // loihi_ = newLoihi();

        // loihi_.TEST_includeAssimilatorState(
        //     dai, cdai, chai, pot,
        //     usdc, cusdc,
        //     usdt, ausdt,
        //     susd, asusd
        // );

        // includeAssetsSetOne(loihi_);
        // includeAssimilatorsSetOne(loihi_);
        // setParamsSetTwo(loihi_);

        // approveStablecoins(address(loihi_));
        // interApproveStablecoinsLocal(address(loihi_));

    }

    function getLoihiSuiteThreeLocal () public returns (Loihi loihi_) {

        // setupStablecoinsLocal();
        // setupAssimilatorsSetTwoLocal();

        // loihi_ = newLoihi();
        
        // loihi_.TEST_includeAssimilatorState(
        //     dai, cdai, chai, pot,
        //     usdc, cusdc,
        //     usdt, ausdt,
        //     susd, asusd
        // );

        // includeAssetsSetTwo(loihi_);
        // includeAssimilatorsSetTwo(loihi_);
        // setParamsSetOne(loihi_);

        // approveStablecoins(address(loihi_));
        // interApproveStablecoinsLocal(address(loihi_));

    }

    function getLoihiSuiteFourLocal () public returns (Loihi loihi_) {

        // setupStablecoinsLocal();
        // setupAssimilatorsSetTwoLocal();

        // loihi_ = newLoihi();

        // loihi_.TEST_includeAssimilatorState(
        //     dai, cdai, chai, pot,
        //     usdc, cusdc,
        //     usdt, ausdt,
        //     susd, asusd
        // );

        // includeAssetsSetTwo(loihi_);
        // includeAssimilatorsSetTwo(loihi_);
        // setParamsSetTwo(loihi_);

        // approveStablecoins(address(loihi_));
        // interApproveStablecoinsLocal(address(loihi_));

    }

    function getLoihiSuiteFiveLocal () public returns (Loihi loihi_) {

        // setupStablecoinsLocal();
        // setupAssimilatorsSetOneLocal();

        // loihi_ = newLoihi();
        
        // loihi_.TEST_includeAssimilatorState(
        //     dai, cdai, chai, pot,
        //     usdc, cusdc,
        //     usdt, ausdt,
        //     susd, asusd
        // );

        // includeAssetsSetOne(loihi_);
        // includeAssimilatorsSetOne(loihi_);
        // setParamsSetFour(loihi_);

        // approveStablecoins(address(loihi_));
        // interApproveStablecoinsLocal(address(loihi_));

    }

    function getLoihiSuiteSixLocal () public returns (Loihi loihi_) {

        // setupStablecoinsLocal();
        // setupAssimilatorsSetOneLocal();

        // loihi_ = newLoihi();

        // loihi_.TEST_includeAssimilatorState(
        //     dai, cdai, chai, pot,
        //     usdc, cusdc,
        //     usdt, ausdt,
        //     susd, asusd
        // );

        // includeAssetsSetOne(loihi_);
        // includeAssimilatorsSetOne(loihi_);
        // setParamsSetThree(loihi_);

        // approveStablecoins(address(loihi_));
        // interApproveStablecoinsLocal(address(loihi_));

    }

    function getLoihiSuiteSixLocalClone () public returns (Loihi loihi_) {

        // loihi_ = newLoihi();

        // loihi_.TEST_includeAssimilatorState(
        //     dai, cdai, chai, pot,
        //     usdc, cusdc,
        //     usdt, ausdt,
        //     susd, asusd
        // );

        // includeAssetsSetOne(loihi_);
        // includeAssimilatorsSetOne(loihi_);
        // setParamsSetThree(loihi_);

        // approveStablecoins(address(loihi_));
        // interApproveStablecoinsLocal(address(loihi_));

    }

    function getLoihiSuiteSeven () public returns (Loihi loihi_) {

        // setupStablecoinsLocal();
        // setupAssimilatorsSetOneLocal();

        // loihi_ = newLoihi();

        // loihi_.TEST_includeAssimilatorState(
        //     dai, cdai, chai, pot,
        //     usdc, cusdc,
        //     usdt, ausdt,
        //     susd, asusd
        // );

        // includeAssetsSetOne(loihi_);
        // includeAssimilatorsSetOne(loihi_);
        // setParamsSetFive(loihi_);

        // approveStablecoins(address(loihi_));
        // interApproveStablecoinsLocal(address(loihi_));

    }

}