
pragma solidity ^0.5.0;

import "abdk-libraries-solidity/ABDKMath64x64.sol";

import "../../../interfaces/IAssimilator.sol";

import "../../setup/setup.sol";

import "../../setup/methods.sol";

contract OriginSwapViewsTemplate is Setup {

    using ABDKMath64x64 for uint;
    using ABDKMath64x64 for int128;

    using ShellMethods for Shell;

    Shell s;
    Shell s2;

    event log_int(bytes32, int);

    function noSlippage_balanced_10DAI_to_USDC_300Proportional () public returns (uint256 targetAmount_) {

        s.proportionalDeposit(300e18, 1e50);

        uint256 gas = gasleft();

        targetAmount_ = s.viewOriginSwap(
            address(dai),
            address(usdc),
            10e18
        );

        emit log_uint("gas used for swap", gas - gasleft());

    }

    function noSlippage_lightlyUnbalanced_10USDC_to_USDT_with_80DAI_100USDC_85USDT_35SUSD () public returns (uint256 targetAmount_) {

        s.deposit(
            address(dai), 80e18,
            address(usdc), 100e6,
            address(usdt), 85e6,
            address(susd), 35e18
        );

        targetAmount_ = s.viewOriginSwap(
            address(usdc),
            address(usdt),
            10e6
        );

    }

    function noSlippage_balanced_10PctWeight_to_30PctWeight () public returns (uint256 targetAmount_) {

        s.proportionalDeposit(300e18, 1e50);

        targetAmount_ = s.viewOriginSwap(
            address(susd),
            address(usdt),
            4e18
        );

    }

    function partialUpperAndLowerSlippage_unbalanced_10PctWeight_to_30PctWeight () public returns (uint256 targetAmount_) {

        s.deposit(
            address(dai), 65e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 30e18
        );

        uint256 gas = gasleft();

        targetAmount_ = s.viewOriginSwap(
            address(susd),
            address(dai),
            8e18
        );

        emit log_uint("gas used for swap", gas - gasleft());

    }

    function noSlippage_balanced_30PctWeight_to_30PctWeight () public returns (uint256 targetAmount_) {

        s.proportionalDeposit(300e18, 1e50);

        targetAmount_ = s.viewOriginSwap(
            address(dai),
            address(usdc),
            10e18
        );

    }

    function noSlippage_lightlyUnbalanced_30PctWeight_to_10PctWeight () public returns (uint256 targetAmount_) {

        s.deposit(
            address(dai), 80e18,
            address(usdc), 80e6,
            address(usdt), 85e6,
            address(susd), 35e18
        );

        targetAmount_ = s.viewOriginSwap(
            address(usdc),
            address(susd),
            3e6
        );

    }

    function partialUpperAndLowerSlippage_balanced_40USDC_to_DAI () public returns (uint256 targetAmount_) {

        s.proportionalDeposit(300e18, 1e50);

        targetAmount_ = s.viewOriginSwap(
            address(usdc),
            address(dai),
            40e6
        );

    }

    function partialUpperAndLowerSlippage_balanced_30PctWeight_CUSDC_to_CDAI () public returns (uint256 targetAmount_) {

        s.proportionalDeposit(300e18, 1e50);

        uint256 cusdcOf40Numeraire = IAssimilator(cusdcAssimilator).viewRawAmount(40e18);

        uint256 targetAmount = s.viewOriginSwap(
            address(cusdc),
            address(cdai),
            cusdcOf40Numeraire
        );

        targetAmount_ = cdaiAssimilator.viewNumeraireAmount(targetAmount).mulu(1e18);

    }

    function partialUpperAndLowerSlippage_balanced_30PctWeight_to_10PctWeight () public returns (uint256 targetAmount_) {

        s.proportionalDeposit(300e18, 1e50);

        targetAmount_ = s.viewOriginSwap(
            address(dai),
            address(susd),
            15e18
        );

    }
    
    function fullUpperAndLowerSlippage_unbalanced_30PctWeight () public returns (uint256 targetAmount_) {

        s.deposit(
            address(dai), 135e18,
            address(usdc), 90e6,
            address(usdt), 60e6,
            address(susd), 30e18
        );

        uint256 gas = gasleft();

        targetAmount_ = s.viewOriginSwap(
            address(dai),
            address(usdt),
            5e18
        );

        emit log_uint("gas for swap", gas - gasleft());

    }

    function fullUpperAndLowerSlippage_unbalanced_30PctWeight_to_10PctWeight () public returns (uint256 targetAmount_) {

        s.deposit(
            address(dai), 135e18,
            address(usdc), 90e6,
            address(usdt), 65e6,
            address(susd), 25e18
        );

        uint256 gas = gasleft();

        targetAmount_ = s.viewOriginSwap(
            address(dai),
            address(susd),
            3e18
        );

        emit log_uint("gas used for swap", gas - gasleft());

    }

    function fullUpperAndLowerSlippage_CUSDC_ASUSD_unbalanced_10PctWeight_to_30PctWeight_ASUSD_CUSDC () public returns (uint256 targetAmount_) {

        s.deposit(
            address(dai), 90e18,
            address(usdc), 55e6,
            address(usdt), 90e6,
            address(susd), 35e18
        );

        uint256 asusdOf2Point8Numeraire = IAssimilator(asusdAssimilator).viewRawAmount(2.8e18);

        uint256 targetAmount = s.viewOriginSwap(
            address(asusd),
            address(cusdc),
            asusdOf2Point8Numeraire
        );

        targetAmount_ = IAssimilator(cusdcAssimilator).viewNumeraireAmount(targetAmount).mulu(1e18);

    }

    function fullUpperAndLowerSlippage_unbalanced_10PctWeight_to_30PctWeight () public returns (uint256 targetAmount_) {

        s.deposit(
            address(dai), 90e18,
            address(usdc), 55e6,
            address(usdt), 90e6,
            address(susd), 35e18
        );

        uint gas = gasleft();

        targetAmount_ = s.viewOriginSwap(
            address(susd),
            address(usdc),
            2.8e18
        );

        emit log_uint("gas used", gas - gasleft());

    }

    function partialUpperAndLowerAntiSlippage_unbalanced_30PctWeight () public returns (uint256 targetAmount_) {

        s.deposit(
            address(dai), 135e18,
            address(usdc), 60e6,
            address(usdt), 90e6,
            address(susd), 30e18
        );

        targetAmount_ = s.viewOriginSwap(
            address(usdc),
            address(dai),
            30e6
        );

    }

    function partialUpperAndLowerAntiSlippage_unbalanced_10PctWeight_to_30PctWeight () public returns (uint256 targetAmount_) {

        s.deposit(
            address(dai), 135e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 25e18
        );

        targetAmount_ = s.viewOriginSwap(
            address(susd),
            address(dai),
            10e18
        );

    }

    function partialUpperAndLowerAntiSlippage_unbalanced_30PctWeight_to_10PctWeight () public returns (uint256 targetAmount_) {

        s.deposit(
            address(dai), 90e18,
            address(usdc), 90e6,
            address(usdt), 58e6,
            address(susd), 40e18
        );

        targetAmount_ = s.viewOriginSwap(
            address(usdt),
            address(susd),
            10e6
        );

    }

    function fullUpperAndLowerAntiSlippage_unbalanced_30PctWeight () public returns (uint256 targetAmount_) {

        s.deposit(
            address(dai), 90e18,
            address(usdc), 135e6,
            address(usdt), 60e6,
            address(susd), 30e18
        );

        uint256 gas = gasleft();

        targetAmount_ = s.viewOriginSwap(
            address(usdt),
            address(usdc),
            5e6
        );

        emit log_uint("gas used", gas - gasleft());

    }

    function fullUpperAndLowerAntiSlippage_10PctWeight_to30PctWeight () public returns (uint256 targetAmount_) {

        s.deposit(
            address(dai), 90e18,
            address(usdc), 90e6,
            address(usdt), 135e6,
            address(susd), 25e18
        );

        uint256 gas = gasleft();

        targetAmount_ = s.viewOriginSwap(
            address(susd),
            address(usdt),
            3.6537e18
        );

        emit log_uint("gas used for swap", gas - gasleft());

    }

    function fullUpperAndLowerAntiSlippage_30pctWeight_to_10Pct () public returns (uint256 targetAmount_) {

        s.deposit(
            address(dai), 58e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 40e18
        );

        targetAmount_ = s.viewOriginSwap(
            address(dai),
            address(susd),
            2.349e18
        );

    }

    function CHAI_fullUpperAndLowerAntiSlippage_30pctWeight_to_10Pct () public returns (uint256 targetAmount_) {

        s.deposit(
            address(dai), 58e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 40e18
        );

        uint256 chaiOf2p349Numeraire = IAssimilator(chaiAssimilator).viewRawAmount(2.349e18);

        targetAmount_ = s.viewOriginSwap(
            address(chai),
            address(susd),
            chaiOf2p349Numeraire
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
            "viewOriginSwap(address,address,uint256)",
            address(usdc),
            address(usdt),
            30e6,
            0,
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
            "viewOriginSwap(address,address,uint256)",
            address(usdc),
            address(dai),
            30e6,
            0,
            1e50
        ));

    }

    function upperHaltCheck_10PctWeight () public returns (bool success_) {

        s.proportionalDeposit(300e18, 1e50);

        ( success_, ) = address(s).call(abi.encodeWithSignature(
            "viewOriginSwap(address,address,uint256)",
            address(susd),
            address(usdt),
            20e18,
            0,
            1e50
        ));

    }

    function lowerhaltCheck_10PctWeight () public returns (bool success_) {

        s.proportionalDeposit(300e18, 1e50);

        ( success_, ) = address(s).call(abi.encodeWithSignature(
            "viewOriginSwap(address,address,uint256)",
            address(dai),
            address(susd),
            20e18,
            0,
            1e50
        ));

    }

    function megaLowerToUpperUpperToLower_30PctWeight () public returns (uint256 targetAmount_) {

        s.deposit(
            address(dai), 55e18,
            address(usdc), 90e6,
            address(usdt), 125e6,
            address(susd), 30e18
        );

        targetAmount_ = s.viewOriginSwap(
            address(dai),
            address(usdt),
            70e18
        );

    }

    function megaLowerToUpperUpperToLower_CDAI_30PctWeight () public returns (uint256 targetAmount_) {

        s.deposit(
            address(dai), 55e18,
            address(usdc), 90e6,
            address(usdt), 125e6,
            address(susd), 30e18
        );

        uint256 cdaiOf70Numeraire = IAssimilator(cdaiAssimilator).viewRawAmount(uint(70e18).divu(1e18));

        targetAmount_ = s.viewOriginSwap(
            address(cdai),
            address(usdt),
            cdaiOf70Numeraire
        );

    }

    function megaLowerToUpper_10PctWeight_to_30PctWeight () public returns (uint256 targetAmount_) {

        s.deposit(
            address(dai), 90e18,
            address(usdc), 90e6,
            address(usdt), 100e6,
            address(susd), 20e18
        );

        targetAmount_ = s.viewOriginSwap(
            address(susd),
            address(usdt),
            20e18
        );

    }

    function megaUpperToLower_30PctWeight_to_10PctWeight () public returns (uint256 targetAmount_) {

        s.deposit(
            address(dai), 80e18,
            address(usdc), 100e6,
            address(usdt), 80e6,
            address(susd), 40e18
        );

        targetAmount_ = s.viewOriginSwap(
            address(dai),
            address(susd),
            20e18
        );

    }

    function greaterThanBalance_30Pct () public {

        s.deposit(
            address(dai), 46e18,
            address(usdc), 134e6,
            address(usdt), 75e6,
            address(susd), 45e18
        );

        s.viewOriginSwap(
            address(usdt),
            address(dai),
            50e6
        );

    }

    function greaterThanBalance_10Pct () public {

        s.proportionalDeposit(300e18, 1e50);

        s.viewOriginSwap(
            address(usdc),
            address(susd),
            31e6
        );

    }

    function smartHalt_upper () public returns (bool success_) {

        s.proportionalDeposit(300e18, 1e50);

        uint256 _rawCUsdc = cusdcAssimilator.viewRawAmount(uint256(110e18).divu(1e18));

        cusdc.transfer(address(s), _rawCUsdc);
        usdc.transfer(address(s), 110e6);

        success_ = s.originSwapSuccess(
            address(usdc),
            address(dai),
            1e6
        );

    }

    function smartHalt_upper_unrelated () public returns (bool success_) {

        s.proportionalDeposit(300e18, 1e50);

        uint256 _rawCUsdc = cusdcAssimilator.viewRawAmount(uint256(110e18).divu(1e18));

        cusdc.transfer(address(s), _rawCUsdc);
        usdc.transfer(address(s), 110e6);

        success_ = s.originSwapSuccess(
            address(usdt),
            address(susd),
            1e6
        );

    }

    function smartHalt_lower_outOfBounds_to_outOfBounds () public returns (bool success_) {

        s.proportionalDeposit(67e18, 1e50);

        uint256 _rawCDai = cdaiAssimilator.viewRawAmount(uint256(70e18).divu(1e18));

        cdai.transfer(address(s), _rawCDai);
        dai.transfer(address(s), 70e18);

        usdt.transfer(address(s), 70e6);
        ausdt.transfer(address(s), 70e6);

        susd.transfer(address(s), 23e18);
        asusd.transfer(address(s), 23e18);

        success_ = s.originSwapSuccess(
            address(usdc),
            address(dai),
            1e6
        );

    }

    function smartHalt_lower_outOfBounds_to_inBounds () public returns (bool success_) {

        s.proportionalDeposit(67e18, 1e50);

        uint256 _rawCDai = cdaiAssimilator.viewRawAmount(uint256(70e18).divu(1e18));

        cdai.transfer(address(s), _rawCDai);
        dai.transfer(address(s), 70e18);

        usdt.transfer(address(s), 70e6);
        ausdt.transfer(address(s), 70e6);

        susd.transfer(address(s), 23e18);
        asusd.transfer(address(s), 23e18);

        success_ = s.originSwapSuccess(
            address(usdc),
            address(dai),
            40e6
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

        success_ = s.originSwapSuccess(
            address(usdt),
            address(susd),
            1e6
        );

    }


    function monotonicity_mutuallyInBounds_to_mutuallyOutOfBounds_noHalts () public returns (uint256 targetAmount_) {

        s.deposit(
            address(dai), 2000e18 / 100,
            address(usdc), 5000e6 / 100,
            address(usdt), 5000e6 / 100,
            address(susd), 800e18 / 100
        );

        //l.TEST_setTestHalts(false);

        targetAmount_ = s.viewOriginSwap(
            address(usdc),
            address(usdt),
            4900e6 / 100
        );

    }

    function monotonicity_mutuallyInBounds_to_mutuallyOutOfBounds_halts () public returns (uint256 targetAmount_) {

        s.deposit(
            address(dai), 2000e18,
            address(usdc), 5000e6,
            address(usdt), 5000e6,
            address(susd), 800e18
        );

        targetAmount_ = s.viewOriginSwap(
            address(usdc),
            address(usdt),
            4900e6
        );

    }

    function monotonicity_outOfBand_mutuallyOutOfBounds_to_mutuallyOutOfBounds_noHalts_omegaUpdate () public returns (uint256 targetAmount_) {

        s.proportionalDeposit(300e18, 1e50);

        usdt.transfer(address(s), 4910e6);
        ausdt.transfer(address(s), 4910e6);

        

        //l.TEST_setTestHalts(false);

        targetAmount_ = s.viewOriginSwap(
            address(usdt),
            address(dai),
            1e6
        );

    }

    function monotonicity_outOfBand_mutuallyOutOfBounds_to_mutuallyOutOfBounds_noHalts_noOmegaUpdate () public returns (uint256 targetAmount_) {

        s.proportionalDeposit(300e18, 1e50);

        usdt.transfer(address(s), 4910e6);
        ausdt.transfer(address(s), 4910e6);

        //l.TEST_setTestHalts(false);

        targetAmount_ = s.viewOriginSwap(
            address(usdt),
            address(dai),
            1e6
        );

    }

    function monotonicity_outOfBand_mutuallyOutOfBounds_to_mutuallyInBounds_noHalts_updateOmega () public returns (uint256 targetAmount_) {

        s.proportionalDeposit(300e18, 1e50);

        uint256 _rawCUsdc = cusdcAssimilator.viewRawAmount(uint256(4910e18).divu(1e18));

        usdc.transfer(address(s), 4910e6);
        cusdc.transfer(address(s), _rawCUsdc);

        usdt.transfer(address(s), 9910e6);
        ausdt.transfer(address(s), 9910e6);

        susd.transfer(address(s), 1970e18);
        asusd.transfer(address(s), 1970e18);

        //l.TEST_setTestHalts(false);

        

        targetAmount_ = s.viewOriginSwap(
            address(dai),
            address(usdt),
            5000e18
        );

    }

    function monotonicity_outOfBand_mutuallyOutOfBounds_to_mutuallyInBounds_noHalts_noUpdateOmega () public returns (uint256 targetAmount_) {

        s.proportionalDeposit(300e18, 1e50);

        uint256 _rawCUsdc = cusdcAssimilator.viewRawAmount(uint256(4910e18).divu(1e18));

        usdc.transfer(address(s), 4910e6);
        cusdc.transfer(address(s), _rawCUsdc);

        usdt.transfer(address(s), 9910e6);
        ausdt.transfer(address(s), 9910e6);

        susd.transfer(address(s), 1970e18);
        asusd.transfer(address(s), 1970e18);

        //l.TEST_setTestHalts(false);

        targetAmount_ = s.viewOriginSwap(
            address(dai),
            address(usdt),
            5000e18
        );

    }

    function monotonicity_outOfBand_mutuallyOutOfBound_towards_mutuallyInBound_noHalts_omegaUpdate () public returns (uint256 targetAmount_) {

        s.proportionalDeposit(300e18, 1e50);

        susd.transfer(address(s), 4970e18);
        asusd.transfer(address(s), 4970e18);

        

        //l.TEST_setTestHalts(false);

        targetAmount_ = s.viewOriginSwap(
            address(usdt),
            address(susd),
            1e6
        );

    }

    function monotonicity_outOfBand_mutuallyOutOfBound_zero_noHalts_omegaUpdate () public returns (uint256 targetAmount_) {

        s.proportionalDeposit(300e18, 1e50);

        susd.transfer(address(s), 4970e18);
        asusd.transfer(address(s), 4970e18);

        

        //l.TEST_setTestHalts(false);

        targetAmount_ = s.viewOriginSwap(
            address(usdt),
            address(susd),
            0
        );

    }

}