pragma solidity ^0.5.0;

import "abdk-libraries-solidity/ABDKMath64x64.sol";

import "ds-test/test.sol";

import "../setup/setup.sol";

import "../setup/methods.sol";

import "../deposits/depositsTemplate.sol";

contract ShellFactorySuiteOne is SelectiveDepositTemplate, DSTest {

    using ABDKMath64x64 for uint;
    using ABDKMath64x64 for int128;

    using ShellMethods for Shell;

    ShellFactory lf;

    function setUp() public {

        // s = getShellSuiteOneLocalFromFactory();

    }

    function setupSuiteOneParameters (Shell _l) public {

        // _l.TEST_includeAssimilatorState(
        //     dai, cdai, chai, pot,
        //     usdc, cusdc,
        //     usdt, ausdt,
        //     susd, asusd
        // );

        // includeAssetsSetOne(_l);

        // includeAssimilatorsSetOne(_l);

        // setParamsSetOne(_l);

        // approveStablecoins(address(_l));

        // interApproveStablecoinsLocal(address(_l));

    }

    function newShell () public returns (Shell shell_) {
        
        address[] memory _assets = new address[](0);
        uint[] memory _weights = new uint[](0);
        address[] memory _derivatives = new address[](0);        
        
        shell_ = lf.newShell(
            _assets,
            _weights,
            _derivatives
        );

    }

    function test_s1_shellFactory () public {
        
        // Shell s1 = newShell();

        // setupSuiteOneParameters(s1);

        // Shell s2 = newShell();

        // setupSuiteOneParameters(s2);

        // bool s1IsShell = lf.isShell(address(s2));

        // bool s2IsShell = lf.isShell(address(s2));

        // assertTrue(s1IsShell);

        // assertTrue(s2IsShell);

    }
    
    function getShellSuiteOneFromFactory () public {
        
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
        
        s = lf.newShell(_assets, _assetWeights, _derivativeAssimilators);
                
        uint256 newShells = super.balanced_5DAI_1USDC_3USDT_1SUSD();

        assertEq(newShells, 9999999999999999991);
        
    }

}