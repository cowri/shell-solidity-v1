pragma solidity ^0.5.0;

import "../../Loihi.sol";

import "../../LoihiFactory.sol";

import "./stablecoins.sol";
import "./assimilators.sol";
import "./loihi.sol";

contract Setup is StablecoinSetup, AssimilatorSetup, LoihiSetup {

    function getLoihiFactorySuiteOne () public returns (LoihiFactory loihiFactory_) {

        // loihiFactory_ = getLoihiFactorySuiteOneKovan();

    }

    function getLoihiSuiteOne () public returns (Loihi loihi_) {

        // loihi_ = getLoihiSuiteOneLocalFromFactory();
        // loihi_ = getLoihiSuiteOneKovanFromFactory();

        setupStablecoinsKovan();
        
        setupAssimilatorsSetOneKovan();

        loihi_ = Loihi(0x32FA3bC6f7A4AF8F41D7096c292E9310F923915D);

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
    
    function getLoihiSuiteOneKovanFromFactory () public returns (Loihi loihi_) {
        
        setupStablecoinsKovan();
        
        setupAssimilatorsSetOneKovan();
        
        LoihiFactory lf = LoihiFactory(0x6d6d82bca905DC79f3e09fE1E5637cdC395050c3);

        address[] memory _assets = new address[](16);
        uint[] memory _assetWeights = new uint[](4);
        address[] memory _derivativeAssimilators = new address[](0);

        _assets[0] = address(dai);
        _assets[1] = address(daiAssimilator);
        _assets[2] = address(dai);
        _assets[3] = address(daiAssimilator);
        _assetWeights[0] = .3e18;

        _assets[4] = address(usdc);
        _assets[5] = address(usdcAssimilator);
        _assets[6] = address(usdc);
        _assets[7] = address(usdcAssimilator);
        _assetWeights[1] = .3e18;

        _assets[8] = address(usdt);
        _assets[9] = address(usdtAssimilator);
        _assets[10] = address(usdt);
        _assets[11] = address(usdtAssimilator);
        _assetWeights[2] = .3e18;

        _assets[12] = address(susd);
        _assets[13] = address(susdAssimilator);
        _assets[14] = address(susd);
        _assets[15] = address(susdAssimilator);
        _assetWeights[3] = .1e18;
        
        loihi_ = lf.newShell(
            _assets,
            _assetWeights,
            _derivativeAssimilators
        );
        
        setParamsSetOne(loihi_);

        approveStablecoins(address(loihi_));

        // interApproveStablecoinsKovan(address(loihi_));

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