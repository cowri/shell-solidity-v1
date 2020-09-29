pragma solidity ^0.5.0;

import "../../Shell.sol";

import "../../ShellFactory.sol";

import "./stablecoins.sol";
import "./assimilators.sol";
import "./shell.sol";

contract Setup is StablecoinSetup, AssimilatorSetup, ShellSetup {

    function getShellFactorySuiteOne () public returns (ShellFactory shellFactory_) {

        shellFactory_ = getShellFactorySuiteOneLocal();

    }

    function getShellSuiteOne () public returns (Shell shell_) {

        shell_ = getShellSuiteOneLocalFromFactory();

    }

    function getShellSuiteTwo () public returns (Shell shell_) {

        shell_ = getShellSuiteTwoLocal();

    }

    function getShellSuiteThree () public returns (Shell shell_) {

        shell_ = getShellSuiteThreeLocal();

    }

    function getShellSuiteFive () public returns (Shell shell_) {

        shell_ = getShellSuiteFiveLocal();

    }

    function getShellSuiteSix () public returns (Shell shell_) {

        shell_ = getShellSuiteSixLocal();

    }

    function getShellSuiteSixClone () public returns (Shell shell_) {

        shell_ = getShellSuiteSixLocalClone();

    }

    function getShellFactorySuiteOneLocal () public returns (ShellFactory shellFactory_) {

        setupStablecoinsLocal();

        setupAssimilatorsSetOneLocal();

        shellFactory_ = new ShellFactory();

    }
    
    function newShell () public returns (Shell shell_) {
        
        address[] memory _assets = new address[](0);
        uint[] memory _weights = new uint[](0);
        address[] memory _derivatives = new address[](0);        
        
        shell_ = new Shell(
            _assets,
            _weights,
            _derivatives
        );

    }

    event log(bytes32);
    
    function getShellSuiteOneLocalFromFactory () public returns (Shell shell_) {
        
        setupStablecoinsLocal();
        
        setupAssimilatorsSetOneLocal();

        shell_ = getShellFromFactory();
        
        setParamsSetOne(shell_);

        approveStablecoins(address(shell_));

        interApproveStablecoinsLocal(address(shell_));

    }

    function getShellSuiteTwoLocal () public returns (Shell shell_) {

        setupStablecoinsLocal();

        setupAssimilatorsSetOneLocal();

        shell_ = getShellFromFactory();

        setParamsSetTwo(shell_);

        approveStablecoins(address(shell_));

        interApproveStablecoinsLocal(address(shell_));

    }

    
    function getShellSuiteOneLocal () public returns (Shell shell_) {

        // setupStablecoinsLocal();
        // setupAssimilatorsSetOneLocal();

        // shell_ = newShell();
        
        // shell_.TEST_includeAssimilatorState(
        //     dai, cdai, chai, pot,
        //     usdc, cusdc,
        //     usdt, ausdt,
        //     susd, asusd
        // );

        // includeAssetsSetOne(shell_);
        // includeAssimilatorsSetOne(shell_);

        // setParamsSetOne(shell_);

        // approveStablecoins(address(shell_));
        // interApproveStablecoinsLocal(address(shell_));


    }

    function getShellSuiteOneMainnet () public returns (Shell shell_) {

        setupStablecoinsMainnet();

        setupAssimilatorsSetOneMainnet();

        shell_ = getShellFromFactory();

        setParamsSetOne(shell_);

        approveStablecoins(address(shell_));

        interApproveStablecoinsRPC(address(shell_));

    }


    function getShellSuiteThreeLocal () public returns (Shell shell_) {

        setupStablecoinsLocal();

        setupAssimilatorsSetTwoLocal();

        shell_ = getShellFromFactory();

        setParamsSetOne(shell_);

        approveStablecoins(address(shell_));

        interApproveStablecoinsLocal(address(shell_));

    }

    function getShellSuiteFourLocal () public returns (Shell shell_) {

        setupStablecoinsLocal();

        setupAssimilatorsSetTwoLocal();

        shell_ = getShellFromFactory();

        setParamsSetTwo(shell_);

        approveStablecoins(address(shell_));

        interApproveStablecoinsLocal(address(shell_));

    }

    function getShellSuiteFiveLocal () public returns (Shell shell_) {

        setupStablecoinsLocal();
        setupAssimilatorsSetOneLocal();

        shell_ = getShellFromFactory();
        
        setParamsSetFour(shell_);

        approveStablecoins(address(shell_));

        interApproveStablecoinsLocal(address(shell_));

    }

    function getShellSuiteSixLocal () public returns (Shell shell_) {

        setupStablecoinsLocal();

        setupAssimilatorsSetOneLocal();

        shell_ = getShellFromFactory();
 
        setParamsSetThree(shell_);

        approveStablecoins(address(shell_));

        interApproveStablecoinsLocal(address(shell_));

    }

    function getShellSuiteSixLocalClone () public returns (Shell shell_) {

        // shell_ = newShell();

        // shell_.TEST_includeAssimilatorState(
        //     dai, cdai, chai, pot,
        //     usdc, cusdc,
        //     usdt, ausdt,
        //     susd, asusd
        // );

        // includeAssetsSetOne(shell_);
        // includeAssimilatorsSetOne(shell_);
        // setParamsSetThree(shell_);

        // approveStablecoins(address(shell_));
        // interApproveStablecoinsLocal(address(shell_));

    }

    function getShellSuiteSeven () public returns (Shell shell_) {

        setupStablecoinsLocal();

        setupAssimilatorsSetOneLocal();

        shell_ = getShellFromFactory();
        
        setParamsSetFive(shell_);

        approveStablecoins(address(shell_));

        interApproveStablecoinsLocal(address(shell_));

    }

    function getShellFromFactory () public returns (Shell shell_) {

        ShellFactory lf = new ShellFactory();

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
        
        shell_ = lf.newShell(
            _assets,
            _assetWeights,
            _derivativeAssimilators
        );
        
        shell_.TEST_includeAssimilatorState(
            dai, cdai, chai, pot,
            usdc, cusdc,
            usdt, ausdt,
            susd, asusd
        );
        
    }

}