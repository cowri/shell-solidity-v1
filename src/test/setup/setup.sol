pragma solidity ^0.5.0;

import "../../Shell.sol";

import "../../ShellFactory.sol";

import "./stablecoins.sol";
import "./assimilators.sol";
import "./shell.sol";

contract Setup is StablecoinSetup, AssimilatorSetup, ShellSetup {

    function getShellFactorySuiteOne () public returns (ShellFactory shellFactory_) {

    }

    function getShellSuiteOne () public returns (Shell shell_) {

        shell_ = getShellSuiteOneMainnet();

    }

    function getShellSuiteEight () public returns (Shell shell_) {

        shell_ = getShellSuiteEightMainnet();

    }

    function getShellSuiteOneMainnet () public returns (Shell shell_) {
        
        setupStablecoinsMainnet();
        
        setupAssimilatorsSetOneMainnet();
        
        address[] memory _assets = new address[](20);
        uint[] memory _assetWeights = new uint[](4);
        address[] memory _derivativeAssimilators = new address[](35);

        _assets[0] = address(dai);
        _assets[1] = address(daiAssimilator);
        _assets[2] = address(cdai);
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
        
        _derivativeAssimilators[0] = address(cdai);
        _derivativeAssimilators[1] = address(dai);
        _derivativeAssimilators[2] = address(dai);
        _derivativeAssimilators[3] = address(cdaiAssimilator);
        _derivativeAssimilators[4] = address(cdai);

        _derivativeAssimilators[5] = address(adai);
        _derivativeAssimilators[6] = address(dai);
        _derivativeAssimilators[7] = address(dai);
        _derivativeAssimilators[8] = address(adaiAssimilator);
        _derivativeAssimilators[9] = address(aaveLpCore);

        _derivativeAssimilators[10] = address(cusdc);
        _derivativeAssimilators[11] = address(usdc);
        _derivativeAssimilators[12] = address(usdc);
        _derivativeAssimilators[13] = address(cusdcAssimilator);
        _derivativeAssimilators[14] = address(cusdc);

        _derivativeAssimilators[15] = address(ausdc);
        _derivativeAssimilators[16] = address(usdc);
        _derivativeAssimilators[17] = address(usdc);
        _derivativeAssimilators[18] = address(ausdcAssimilator);
        _derivativeAssimilators[19] = address(aaveLpCore);

        _derivativeAssimilators[20] = address(ausdt);
        _derivativeAssimilators[21] = address(usdt);
        _derivativeAssimilators[22] = address(usdt);
        _derivativeAssimilators[23] = address(ausdtAssimilator);
        _derivativeAssimilators[24] = address(aaveLpCore);

        _derivativeAssimilators[25] = address(cusdt);
        _derivativeAssimilators[26] = address(usdt);
        _derivativeAssimilators[27] = address(usdt);
        _derivativeAssimilators[28] = address(cusdtAssimilator);
        _derivativeAssimilators[29] = address(cusdt);

        _derivativeAssimilators[30] = address(asusd);
        _derivativeAssimilators[31] = address(susd);
        _derivativeAssimilators[32] = address(susd);
        _derivativeAssimilators[33] = address(asusdAssimilator);
        _derivativeAssimilators[34] = address(aaveLpCore);

        shell_ = new Shell(
            _assets,
            _assetWeights,
            _derivativeAssimilators
        );
        
        setParamsSetOne(shell_);

        approveStablecoins(address(shell_));

    }

    function getShellSuiteEightMainnet () public returns (Shell shell_) {

        setupStablecoinsMainnet();
            
        setupAssimilatorsSetThreeMainnet();
        
        address[] memory _assets = new address[](15);
        uint[] memory _weights = new uint[](3);
        address[] memory _derivatives = new address[](0);

        _assets[0] = address(renBTC);
        _assets[1] = address(renbtcAssimilator);
        _assets[2] = address(renBTC);
        _assets[3] = address(renbtcAssimilator);
        _assets[4] = address(renBTC);
        _weights[0] = .4e18;

        _assets[5] = address(wBTC);
        _assets[6] = address(wbtcAssimilator);
        _assets[7] = address(wBTC);
        _assets[8] = address(wbtcAssimilator);
        _assets[9] = address(wBTC);
        _weights[1] = .5e18;

        _assets[10] = address(sBTC);
        _assets[11] = address(sbtcAssimilator);
        _assets[12] = address(sBTC);
        _assets[13] = address(sbtcAssimilator);
        _assets[14] = address(sBTC);
        _weights[2] = .1e18;

        shell_ = new Shell(_assets, _weights, _derivatives);

        setParamsSetOne(shell_);

        approveStablecoins(address(shell_));

    }

    function getShellSuiteNineMainnet () public returns (Shell shell_) {

        setupStablecoinsMainnet();
            
        setupAssimilatorsSetFourMainnet();
        
        address[] memory _assets = new address[](15);
        uint[] memory _weights = new uint[](3);
        address[] memory _derivatives = new address[](0);

        _assets[0] = address(ousd);
        _assets[1] = address(ousdAssimilator);
        _assets[2] = address(ousd);
        _assets[3] = address(ousdAssimilator);
        _assets[4] = address(ousd);
        _weights[0] = .5e18;

        _assets[5] = address(usdc);
        _assets[6] = address(usdcAssimilator);
        _assets[7] = address(usdc);
        _assets[8] = address(usdcAssimilator);
        _assets[9] = address(usdc);
        _weights[1] = .2e18;

        _assets[10] = address(usdt);
        _assets[11] = address(usdtAssimilator);
        _assets[12] = address(usdt);
        _assets[13] = address(usdtAssimilator);
        _assets[14] = address(usdt);
        _weights[2] = .3e18;

        shell_ = new Shell(_assets, _weights, _derivatives);

        setParamsSetOne(shell_);

        approveStablecoins(address(shell_));

    }

}