
pragma solidity ^0.5.0;

import "abdk-libraries-solidity/ABDKMath64x64.sol";

import "../../interfaces/IAssimilator.sol";

import "../setup/setup.sol";

import "../setup/methods.sol";

contract TargetSwapTemplate is Setup {

    using ABDKMath64x64 for uint;
    using ABDKMath64x64 for int128;

    using ShellMethods for Shell;

    Shell s;
    Shell s2;

    function noSlippage_balanced_DAI_to_10USDC_300Proportional () public returns (uint256 originAmount_) {

        s.proportionalDeposit(300e18, 1e50);

        originAmount_ = s.targetSwap(
            address(dai),
            address(usdc),
            10e6
        );

    }

    function noSlippage_unbalanced_USDC_to_3SUSD_with_80DAI_100USDC_85USDT_35SUSD () public returns (uint256 originAmount_) {

        s.deposit(
            address(dai), 80e18,
            address(usdc), 100e6,
            address(usdt), 85e6,
            address(susd), 35e18
        );

        originAmount_ = s.targetSwap(
            address(usdc),
            address(susd),
            3e18
        );

    }

    function noSlippage_balanced_10PctWeight_to_30PctWeight () public returns (uint256 originAmount_) {

        s.proportionalDeposit(300e18, 1e50);

        originAmount_ = s.targetSwap(
            address(susd),
            address(usdt),
            4e6
        );

    }

    function noSlippage_Balanced_10PctWeight_to_30PctWeight_AUSDT () public returns (uint256 originAmount_) {

        s.proportionalDeposit(300e18, 1e50);

        originAmount_ = s.targetSwap(
            address(susd),
            address(ausdt),
            4e6
        );

    }

    function partialUpperAndLowerSlippage_balanced_30PctWeight_to30PctWeight () public returns (uint256 originAmount_) {

        s.proportionalDeposit(300e18, 1e50);

        originAmount_ = s.targetSwap(
            address(usdc),
            address(dai),
            40e18
        );

    }

    function partialUpperAndLowerSlippage_balanced_30PctWeight_to_10PctWeight () public returns (uint256 originAmount_) {

        s.proportionalDeposit(300e18, 1e50);

        originAmount_ = s.targetSwap(
            address(usdc),
            address(susd),
            12e18
        );

    }

    function partialUpperAndLowerSLippage_balanced_30PctWeight_to_10PctWeight_ASUSD () public returns (uint256 originAmount_) {

        s.proportionalDeposit(300e18, 1e50);

        originAmount_ = s.targetSwap(
            address(usdc),
            address(asusd),
            12e18
        );

    }

    function partialUpperAndLowerSlippage_unbalanced_10PctWeight_to_30PctWeight () public returns (uint256 originAmount_) {

        s.deposit(
            address(dai), 65e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 30e18
        );

        originAmount_ = s.targetSwap(
            address(susd),
            address(dai),
            8e18
        );

    }

    function noSlippage_lightlyUnbalanced_30PctWeight_to_10PctWeight () public returns (uint256 originAmount_) {

        s.deposit(
            address(dai), 80e18,
            address(usdc), 100e6,
            address(usdt), 85e6,
            address(susd), 35e18
        );

        originAmount_ = s.targetSwap(
            address(usdc),
            address(susd),
            3e18
        );

    }

    function noSlippage_lightlyUnbalanced_30PctWeight_to_10PctWeight_CUSDC () public returns (uint256 originAmount_) {

        s.deposit(
            address(dai), 80e18,
            address(usdc), 100e6,
            address(usdt), 85e6,
            address(susd), 35e18
        );

        uint256 originAmount = s.targetSwap(
            address(cusdc),
            address(susd),
            3e18
        );

        originAmount_ = cusdcAssimilator.viewNumeraireAmount(originAmount).mulu(1e18);


    }

    function fullUpperAndLowerSlippage_unbalanced_30PctWeight () public returns (uint256 originAmount_) {

        s.deposit(
            address(dai), 135e18,
            address(usdc), 90e6,
            address(usdt), 65e6,
            address(susd), 30e18
        );

        originAmount_ = s.targetSwap(
            address(dai),
            address(usdt),
            5e6
        );

    }

    function fullUpperAndLowerSlippage_unbalanced_30PctWeight_to_10PctWeight () public returns (uint256 originAmount_) {

        s.deposit(
            address(dai), 135e18,
            address(usdc), 90e6,
            address(usdt), 65e6,
            address(susd), 25e18
        );

        originAmount_ = s.targetSwap(
            address(dai),
            address(susd),
            3e18
        );

    }

    function fullUpperAndLowerSlippage_unbalanced_10PctWeight_to_30PctWeight () public returns (uint256 originAmount_) {

        s.deposit(
            address(dai), 90e18,
            address(usdc), 55e6,
            address(usdt), 90e6,
            address(susd), 35e18
        );

        originAmount_ = s.targetSwap(
            address(susd),
            address(usdc),
            2.8e6
        );

    }

    function partialUpperAndLowerAntiSlippage_unbalanced_30PctWeight_to_30PctWeight () public returns (uint256 originAmount_) {

        s.deposit(
            address(dai), 135e18,
            address(usdc), 60e6,
            address(usdt), 90e6,
            address(susd), 30e18
        );

        originAmount_ = s.targetSwap(
            address(usdc),
            address(dai),
            30e18
        );

    }

    function partialUpperAndLowerAntiSlippage_unbalanced_CHAI_10PctWeight_to_30PctWeight () public returns (uint256 originAmount_) {

        s.deposit(
            address(dai), 135e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 25e18
        );

        uint256 chaiOf10Numeraire = chaiAssimilator.viewRawAmount(uint(10e18).divu(1e18));

        originAmount_ = s.targetSwap(
            address(susd),
            address(chai),
            chaiOf10Numeraire
        );

    }

    function partialUpperAndLowerAntiSlippage_unbalanced_10PctWeight_to_30PctWeight () public returns (uint256 originAmount_) {

        s.deposit(
            address(dai), 135e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 25e18
        );

        originAmount_ = s.targetSwap(
            address(susd),
            address(dai),
            10e18
        );

    }

    function partialUpperAndLowerAntiSlippage_unbalanced_30PctWeight_to_10PctWeight () public returns (uint256 originAmount_) {

        s.deposit(
            address(dai), 90e18,
            address(usdc), 90e6,
            address(usdt), 58e6,
            address(susd), 40e18
        );

        originAmount_ = s.targetSwap(
            address(usdt),
            address(susd),
            10e18
        );

    }

    function fullUpperAndLowerAntiSlippage_unbalanced_30PctWeight () public returns (uint256 originAmount_) {

        s.deposit(
            address(dai), 90e18,
            address(usdc), 135e6,
            address(usdt), 60e6,
            address(susd), 30e18
        );

        originAmount_ = s.targetSwap(
            address(usdt),
            address(usdc),
            5e6
        );

    }

    function fullUpperAndLowerAntiSlippage_10PctOrigin_to_30PctTarget () public returns (uint256 originAmount_) {

        s. deposit(
            address(dai), 90e18,
            address(usdc), 90e6,
            address(usdt), 135e6,
            address(susd), 25e18
        );

        originAmount_ = s.targetSwap(
            address(susd),
            address(usdt),
            3.6537e6
        );

    }

    function fullUpperAndLowerAntiSlippage_CDAI_30pct_to_10Pct () public returns (uint256 originAmount_) {

        s.deposit(
            address(dai), 58e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 40e18
        );

        uint256 originAmount = s.targetSwap(
            address(cdai),
            address(susd),
            2.349e18
        );

        originAmount_ = cdaiAssimilator.viewNumeraireAmount(originAmount).mulu(1e18);

    }

    function fullUpperAndLowerAntiSlippage_30Pct_To10Pct () public returns (uint256 originAmount_) {

        s.deposit(
            address(dai), 58e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 40e18
        );

        originAmount_ = s.targetSwap(
            address(dai),
            address(susd),
            2.349e18
        );

    }

    function megaLowerToUpperUpperToLower_30PctWeight () public returns (uint256 originAmount_) {

        s.deposit(
            address(dai), 55e18,
            address(usdc), 90e6,
            address(usdt), 125e6,
            address(susd), 30e18
        );

        originAmount_ = s.targetSwap(
            address(dai),
            address(usdt),
            70e6
        );

    }

    function megaLowerToUpper_10PctWeight_to_30PctWeight () public returns (uint256 originAmount_) {

        s.deposit(
            address(dai), 90e18,
            address(usdc), 90e6,
            address(usdt), 100e6,
            address(susd), 20e18
        );

        originAmount_ = s.targetSwap(
            address(susd),
            address(usdt),
            20e6
        );

    }

    function megaUpperToLower_30PctWeight_to_10PctWeight () public returns (uint256 originAmount_) {

        s.deposit(
            address(dai), 80e18,
            address(usdc), 100e6,
            address(usdt), 80e6,
            address(susd), 40e18
        );

        originAmount_ = s.targetSwap(
            address(dai),
            address(susd),
            20e18
        );

    }

    function upperHaltCheck_30PctWeight () public returns (bool success_) {

        s.deposit(
            address(dai), 90e18,
            address(usdc), 135e6,
            address(usdt), 90e6,
            address(susd), 30e18
        );

        ( success_, ) = address(s).call(abi.encodeWithSignature(
            "targetSwap(address,address,uint256,uint256,uint256)",
            address(usdc),
            address(usdt),
            31e6,
            30e6,
            1e50
        ));

    }

    function lowerHaltCheck_30PctWeight () public returns (bool success_) {

        s.deposit(
            address(dai), 60e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 30e18
        );

        ( success_, ) = address(s).call(abi.encodeWithSignature(
            "targetSwap(address,address,uint256,uint256,uint256)",
            address(usdc),
            address(dai),
            31e18,
            30e18,
            1e50
        ));

    }

    function upperHaltCheck_10PctWeight () public returns (bool success_) {

        s.proportionalDeposit(300e18, 1e50);


        ( success_, ) = address(s).call(abi.encodeWithSignature(
            "targetSwap(address,address,uint256,uint256,uint256)",
            address(susd),
            address(usdt),
            21e18,
            20e18,
            1e50
        ));

    }

    function lowerhaltCheck_10PctWeight () public returns (bool success_) {

        s.proportionalDeposit(300e18, 1e50);

        ( success_, ) = address(s).call(abi.encodeWithSignature(
            "targetSwap(address,address,uint256,uint256,uint256)",
            address(dai),
            address(susd),
            21e18,
            20e18,
            1e50
        ));

    }

    function noSlippage_partiallyUnbalanced_10PctTarget () public returns (uint256 originAmount_) {

        s.deposit(
            address(dai), 80e18,
            address(usdc), 100e6,
            address(usdt), 85e6,
            address(susd), 35e18
        );

        originAmount_ = s.targetSwap(
            address(dai),
            address(susd),
            3e18
        );

    }

    function targetGreaterThanBalance_30Pct () public {

        s.deposit(
            address(dai), 46e18,
            address(usdc), 134e6,
            address(usdt), 75e6,
            address(susd), 45e18
        );

        s.targetSwap(
            address(usdt),
            address(dai),
            50e18
        );

    }

    function targetGreaterThanBalance_10Pct () public {

        s.proportionalDeposit(300e18, 1e50);

        s.targetSwap(
            address(usdc),
            address(susd),
            31e18
        );

    }

    function smartHalt_upper_outOfBounds_to_outOfBounds () public returns (bool success_) {

        s.proportionalDeposit(300e18, 1e50);

        uint256 _rawCUsdc = cusdcAssimilator.viewRawAmount(uint256(110e18).divu(1e18));

        cusdc.transfer(address(s), _rawCUsdc);
        usdc.transfer(address(s), 110e6);

        success_ = s.targetSwapSuccess(
            address(dai),
            address(usdc),
            10e6
        );

    }

    function smartHalt_upper_outOfBounds_to_inBounds () public returns (bool success_) {

        s.proportionalDeposit(300e18, 1e50);

        uint256 _rawCUsdc = cusdcAssimilator.viewRawAmount(uint256(110e18).divu(1e18));

        cusdc.transfer(address(s), _rawCUsdc);
        usdc.transfer(address(s), 110e6);

        success_ = s.targetSwapSuccess(
            address(dai),
            address(usdc),
            30e6
        );

    }

    function smartHalt_upper_unrelated () public returns (bool success_) {

        s.proportionalDeposit(300e18, 1e50);

        uint256 _rawCUsdc = cusdcAssimilator.viewRawAmount(uint256(110e18).divu(1e18));

        cusdc.transfer(address(s), _rawCUsdc);
        usdc.transfer(address(s), 110e6);

        success_ = s.targetSwapSuccess(
            address(usdt),
            address(susd),
            1e6
        );

    }

    function smartHalt_lower () public returns (bool success_) {

        s.proportionalDeposit(67e18, 1e50);

        uint256 _rawCDai = cdaiAssimilator.viewRawAmount(uint256(70e18).divu(1e18));

        cdai.transfer(address(s), _rawCDai);
        dai.transfer(address(s), 70e18);

        usdt.transfer(address(s), 70e6);
        ausdt.transfer(address(s), 70e6);

        susd.transfer(address(s), 23e18);
        asusd.transfer(address(s), 23e18);

        success_ = s.targetSwapSuccess(
            address(dai),
            address(usdc),
            1e6
        );

    }

    function smartHalt_lower_unrelated () public returns (bool success_) {

        s.proportionalDeposit(67e18, 1e50);

        uint256 _rawCDai = cdaiAssimilator.viewRawAmount(uint256(70e18).divu(1e18));

        cdai.transfer(address(s), _rawCDai);
        dai.transfer(address(s), 70e18);

        usdt.transfer(address(s), 70e6);
        ausdt.transfer(address(s), 70e6);

        susd.transfer(address(s), 23e18);
        asusd.transfer(address(s), 23e18);

        success_ = s.targetSwapSuccess(
            address(usdt),
            address(susd),
            1e6
        );

    }
    
    function monotonicity_mutuallyInBounds_to_mutuallyOutOfBounds_noHalts () public returns (uint256 originAmount_) {

        s.deposit(
            address(dai), 2000e18,
            address(usdc), 5000e6,
            address(usdt), 5000e6,
            address(susd), 800e18
        );

        //l.TEST_setTestHalts(false);

        originAmount_ = s.targetSwap(
            address(usdc),
            address(usdt),
            4900e6
        );

    }

    function monotonicity_mutuallyInBounds_to_mutuallyOutOfBounds_halts () public returns (uint256 originAmount_) {

        s.deposit(
            address(dai), 2000e18,
            address(usdc), 5000e6,
            address(usdt), 5000e6,
            address(susd), 800e18
        );

        originAmount_ = s.targetSwap(
            address(usdc),
            address(usdt),
            4900e6
        );

    }

    function monotonicity_outOfBand_mutuallyOutOfBounds_to_mutuallyOutOfBounds_noHalts_omegaUpdate () public returns (uint256 originAmount_) {

        s.proportionalDeposit(300e18, 1e50);

        usdt.transfer(address(s), 4910e6);
        ausdt.transfer(address(s), 4910e6);

        

        //l.TEST_setTestHalts(false);

        originAmount_ = s.targetSwap(
            address(usdt),
            address(dai),
            1e18
        );

    }

    function monotonicity_outOfBand_mutuallyOutOfBounds_to_mutuallyOutOfBounds_noHalts_noOmegaUpdate () public returns (uint256 originAmount_) {

        s.proportionalDeposit(300e18, 1e50);

        usdt.transfer(address(s), 4910e6);
        ausdt.transfer(address(s), 4910e6);

        //l.TEST_setTestHalts(false);

        originAmount_ = s.targetSwap(
            address(usdt),
            address(dai),
            1e18
        );

    }

    function monotonicity_outOfBand_mutuallyOutOfBounds_to_mutuallyInBounds_noHalts_updateOmega () public returns (uint256 originAmount_) {

        s.proportionalDeposit(300e18, 1e50);

        uint256 _rawCUsdc = cusdcAssimilator.viewRawAmount(uint256(4910e18).divu(1e18));

        usdc.transfer(address(s), 4910e6);
        cusdc.transfer(address(s), _rawCUsdc);

        usdt.transfer(address(s), 9910e6);
        ausdt.transfer(address(s), 9910e6);

        susd.transfer(address(s), 1970e18);
        asusd.transfer(address(s), 1970e18);

        //l.TEST_setTestHalts(false);

        

        originAmount_ = s.targetSwap(
            address(dai),
            address(usdt),
            5000e6
        );

    }

    function monotonicity_outOfBand_mutuallyOutOfBounds_to_mutuallyInBounds_noHalts_noUpdateOmega () public returns (uint256 originAmount_) {

        s.proportionalDeposit(300e18, 1e50);

        uint256 _rawCUsdc = cusdcAssimilator.viewRawAmount(uint256(4910e18).divu(1e18));

        usdc.transfer(address(s), 4910e6);
        cusdc.transfer(address(s), _rawCUsdc);

        usdt.transfer(address(s), 9910e6);
        ausdt.transfer(address(s), 9910e6);

        susd.transfer(address(s), 1970e18);
        asusd.transfer(address(s), 1970e18);

        //l.TEST_setTestHalts(false);

        originAmount_ = s.targetSwap(
            address(dai),
            address(usdt),
            5000e6
        );

    }

    function monotonicity_outOfBand_mutuallyOutOfBound_towards_mutuallyInBound_noHalts_omegaUpdate () public returns (uint256 originAmount_) {

        s.proportionalDeposit(300e18, 1e50);

        susd.transfer(address(s), 4970e18);
        asusd.transfer(address(s), 4970e18);

        

        //l.TEST_setTestHalts(false);

        originAmount_ = s.targetSwap(
            address(usdt),
            address(susd),
            1e18
        );

    }

    function monotonicity_outOfBand_mutuallyOutOfBound_zero_noHalts_omegaUpdate () public returns (uint256 originAmount_) {

        s.proportionalDeposit(300e18, 1e50);

        susd.transfer(address(s), 4970e18);
        asusd.transfer(address(s), 4970e18);

        

        //l.TEST_setTestHalts(false);

        originAmount_ = s.targetSwap(
            address(usdt),
            address(susd),
            0
        );

    }

}