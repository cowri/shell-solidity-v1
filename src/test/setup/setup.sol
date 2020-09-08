pragma solidity ^0.5.0;

import "../../Loihi.sol";

import "../../LoihiFactory.sol";

import "./stablecoins.sol";
import "./assimilators.sol";
import "./loihi.sol";

contract Setup is StablecoinSetup, AssimilatorSetup, LoihiSetup {

    function getLoihiFactorySuiteOne () public returns (LoihiFactory loihiFactory_) {

    }

    function getLoihiSuiteOne () public returns (Loihi loihi_) {

        loihi_ = getLoihiSuiteOneMainnetFromFactory();

        // loihi_ = getLoihiSuiteOneLocal();
        // loihi_ = getLoihiSuiteOneMainnet();

    }

    function getLoihiSuiteTwo () public returns (Loihi loihi_) {

        // loihi_ = getLoihiSuiteTwoMainnet();

    }

    function getLoihiSuiteThree () public returns (Loihi loihi_) {


    }

    function getLoihiSuiteFive () public returns (Loihi loihi_) {


    }

    function getLoihiSuiteSix () public returns (Loihi loihi_) {


    }

    function getLoihiSuiteSixClone () public returns (Loihi loihi_) {


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
    
    function getLoihiSuiteOneMainnetFromFactory () public returns (Loihi loihi_) {
        
        setupStablecoinsMainnet();
        
        // setupAssimilatorsSetOneMainnet();
        setupAssimilatorsSetTwoMainnet();
        
        LoihiFactory lf = new LoihiFactory();

        address[] memory _assets = new address[](20);
        uint[] memory _assetWeights = new uint[](4);
        address[] memory _derivativeAssimilators = new address[](5);

        _assets[0] = address(dai);
        _assets[1] = address(daiAssimilator);
        _assets[2] = address(cdai);
        _assets[3] = address(cdaiAssimilator);
        _assets[4] = address(cdai);
        _assetWeights[0] = .3e18;

        _assets[5] = address(usdc);
        _assets[6] = address(usdcAssimilator);
        _assets[7] = address(cusdc);
        _assets[8] = address(cusdcAssimilator);
        _assets[9] = address(cusdc);
        _assetWeights[1] = .3e18;

        _assets[10] = address(usdt);
        _assets[11] = address(usdtAssimilator);
        _assets[12] = address(ausdt);
        _assets[13] = address(ausdtAssimilator);
        _assets[14] = address(aaveLpCore);
        _assetWeights[2] = .3e18;

        _assets[15] = address(susd);
        _assets[16] = address(susdAssimilator);
        _assets[17] = address(asusd);
        _assets[18] = address(asusdAssimilator);
        _assets[19] = address(aaveLpCore);
        _assetWeights[3] = .1e18;
        
        _derivativeAssimilators[0] = address(chai);
        _derivativeAssimilators[1] = address(dai);
        _derivativeAssimilators[2] = address(cdai);
        _derivativeAssimilators[3] = address(chaiAssimilator);
        _derivativeAssimilators[4] = address(chai);

        // _derivativeAssimilators[4] = address(cdai);
        // _derivativeAssimilators[5] = address(dai);
        // _derivativeAssimilators[6] = address(dai);
        // _derivativeAssimilators[7] = address(cdaiAssimilator);

        // _derivativeAssimilators[8] = address(cusdc);
        // _derivativeAssimilators[9] = address(usdc);
        // _derivativeAssimilators[10] = address(usdc);
        // _derivativeAssimilators[11] = address(cusdcAssimilator);

        // _derivativeAssimilators[12] = address(ausdt);
        // _derivativeAssimilators[13] = address(usdt);
        // _derivativeAssimilators[14] = address(usdt);
        // _derivativeAssimilators[15] = address(ausdtAssimilator);

        // _derivativeAssimilators[16] = address(asusd);
        // _derivativeAssimilators[17] = address(susd);
        // _derivativeAssimilators[18] = address(susd);
        // _derivativeAssimilators[19] = address(asusdAssimilator);

        loihi_ = lf.newShell(
            _assets,
            _assetWeights,
            _derivativeAssimilators
        );
        
        setParamsSetOne(loihi_);

        approveStablecoins(address(loihi_));

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


}