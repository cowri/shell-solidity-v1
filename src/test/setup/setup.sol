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

        loihi_ = getLoihiSuiteOneKovanFromFactory();

    }

    function getLoihiSuiteOneKovanFromFactory () public returns (Loihi loihi_) {
        
        setupStablecoinsKovan();
        
        setupAssimilatorsSetOneKovan();
        
        // LoihiFactory lf = new LoihiFactory();

        // address[] memory _assets = new address[](20);
        // uint[] memory _assetWeights = new uint[](4);
        // // address[] memory _derivativeAssimilators = new address[](5);
        // address[] memory _derivativeAssimilators = new address[](25);

        // _assets[0] = address(dai);
        // _assets[1] = address(daiAssimilator);
        // _assets[2] = address(dai);
        // _assets[3] = address(daiAssimilator);
        // _assets[4] = address(dai);
        // _assetWeights[0] = .3e18;

        // _assets[5] = address(usdc);
        // _assets[6] = address(usdcAssimilator);
        // _assets[7] = address(usdc);
        // _assets[8] = address(usdcAssimilator);
        // _assets[9] = address(usdc);
        // _assetWeights[1] = .3e18;

        // _assets[10] = address(usdt);
        // _assets[11] = address(usdtAssimilator);
        // _assets[12] = address(usdt);
        // _assets[13] = address(usdtAssimilator);
        // _assets[14] = address(usdt);
        // _assetWeights[2] = .3e18;

        // _assets[15] = address(susd);
        // _assets[16] = address(susdAssimilator);
        // _assets[17] = address(susd);
        // _assets[18] = address(susdAssimilator);
        // _assets[19] = address(susd);
        // _assetWeights[3] = .1e18;
        
        // _derivativeAssimilators[0] = address(chai);
        // _derivativeAssimilators[1] = address(dai);
        // _derivativeAssimilators[2] = address(cdai);
        // _derivativeAssimilators[3] = address(chaiAssimilator);
        // _derivativeAssimilators[4] = address(chai);

        // _derivativeAssimilators[5] = address(cdai);
        // _derivativeAssimilators[6] = address(dai);
        // _derivativeAssimilators[7] = address(dai);
        // _derivativeAssimilators[8] = address(cdaiAssimilator);
        // _derivativeAssimilators[9] = address(cdai);

        // _derivativeAssimilators[10] = address(cusdc);
        // _derivativeAssimilators[11] = address(usdc);
        // _derivativeAssimilators[12] = address(usdc);
        // _derivativeAssimilators[13] = address(cusdcAssimilator);
        // _derivativeAssimilators[14] = address(cusdc);

        // _derivativeAssimilators[15] = address(ausdt);
        // _derivativeAssimilators[16] = address(usdt);
        // _derivativeAssimilators[17] = address(usdt);
        // _derivativeAssimilators[18] = address(ausdtAssimilator);
        // _derivativeAssimilators[19] = address(aaveLpCore);

        // _derivativeAssimilators[20] = address(asusd);
        // _derivativeAssimilators[21] = address(susd);
        // _derivativeAssimilators[22] = address(susd);
        // _derivativeAssimilators[23] = aerfaerwfdress(aaveLpCore);

        // loihi_ = lf.newShell(
        //     _assets,
        //     _assetWeights,
        //     _derivativeAssimilators
        // );
        
        loihi_ = Loihi(0x4B6F91a106fEd779EFE013d1e9693cB5f4943071);

        setParamsSetOne(loihi_);

        approveStablecoins(address(loihi_));

    }

}