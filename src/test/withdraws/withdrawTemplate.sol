pragma solidity ^0.5.0;

import "abdk-libraries-solidity/ABDKMath64x64.sol";

import "../../interfaces/IAssimilator.sol";

import "../setup/setup.sol";

import "../setup/methods.sol";

contract SelectiveWithdrawTemplate is Setup {

    using ABDKMath64x64 for uint;
    using ABDKMath64x64 for int128;

    using LoihiMethods for Loihi;

    Loihi l;
    Loihi l2;

    event log_uint(bytes32, uint256);
    event log_uints(bytes32, uint256[]);
    event log_addr(bytes32, address);

    function balanced_10DAI_10USDC_10USDT_2p5SUSD_from_300Proportional () public returns (uint256 shellsBurned_) {

        ( uint256 _startingShells, uint[] memory _deposits ) = l.proportionalDeposit(300e18, 1e50);

        shellsBurned_ = l.withdraw(
            address(dai), 10e18,
            address(usdc), 10e6,
            address(usdt), 10e6,
            address(susd), 2.5e18
        );

    }

    function lightlyUnbalanced_5DAI_1USDC_3USDT_1SUSD_from_80DAI_100USDC_85USDT_35SUSD () public returns (uint256 shellsBurned_) {

        uint256 _startingShells = l.deposit(
            address(dai), 80e18,
            address(usdc), 100e6,
            address(usdt), 85e6,
            address(susd), 35e18
        );

        shellsBurned_ = l.withdraw(
            address(dai), 5e18,
            address(usdc), 1e6,
            address(usdt), 3e6,
            address(susd), 1e18
        );

    }

    function partialLowerSlippage_balanced_5DAI_5USDC_47USDT_16SUSD_from_300Proportional () public returns (uint256 shellsBurned_) {

        ( uint256 _startingShells, uint[] memory _deposits ) = l.proportionalDeposit(300e18, 1e50);

        shellsBurned_ = l.withdraw(
            address(dai), 5e18,
            address(usdc), 5e6,
            address(usdt), 47e6,
            address(susd), 16e18
        );

    }

    function partialLowerSlippage_3DAI_60USDC_30USDT_1SUSD_from_80DAI_100USDC_100USDT_23SUSD () public returns (uint256 shellsBurned_) {

        uint256 _startingShells = l.deposit(
            address(dai), 80e18,
            address(usdc), 100e6,
            address(usdt), 100e6,
            address(susd), 23e18
        );

        shellsBurned_ = l.withdraw(
            address(dai), 3e18,
            address(usdc), 60e6,
            address(usdt), 30e6,
            address(susd), 1e18
        );

    }

    function partialUpperSlippage_balanced_0p001DAI_40USDC_40USDT_10SUSD_from_300Proportional () public returns (uint256 shellsBurned_) {

        ( uint256 _startingShells, uint[] memory _deposits ) = l.proportionalDeposit(300e18, 1e50);

        shellsBurned_ = l.withdraw(
            address(dai), 0.001e18,
            address(usdc), 40e6,
            address(usdt), 40e6,
            address(susd), 10e18
        );

    }

    function partialLowerIndirectAntiSlippage_40DAI_40USDT_from_95DAI_55USDC_95USDT_15SUSD () public returns (uint256 shellsBurned_) {

        uint256 _startingShells = l.deposit(
            address(dai), 95e18,
            address(usdc), 55e6,
            address(usdt), 95e6,
            address(susd), 15e18
        );

        shellsBurned_ = l.withdraw(
            address(dai), 40e18,
            address(usdt), 40e6
        );

    }

    function partialLowerAntiSlippage_0p0001DAI_41USDC_41USDT_1SUSD_from_55DAI_95USDC_95USDT_15SUSD () public returns (uint256 shellsBurned_) {

        uint256 _startingShells = l.deposit(
            address(dai), 55e18,
            address(usdc), 95e6,
            address(usdt), 95e6,
            address(susd), 15e18
        );

        shellsBurned_ = l.withdraw(
            address(dai), 0.0001e18,
            address(usdc), 41e6,
            address(usdt), 41e6,
            address(susd), 1e18
        );

    }

    function partialUpperAntiSlippage_50USDC_18SUSD_from_90DAI_145USDC_90USDT_50SUSD () public returns (uint256 shellsBurned_) {

        uint256 _startingShells = l.deposit(
            address(dai), 90e18,
            address(usdc), 145e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );

        shellsBurned_ = l.withdraw(
            address(usdc), 50e6,
            address(susd), 18e18
        );

    }

    function partialUpperAntiSlippage_50CUSDC_18SUSD_from_90DAI_145USDC_90USDT_50SUSD () public returns (uint256 shellsBurned_) {

        uint256 _startingShells = l.deposit(
            address(dai), 90e18,
            address(usdc), 145e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );

        uint256 cusdcOf50Numeraires = cusdcAssimilator.viewRawAmount(uint(50e18).divu(1e18));

        shellsBurned_ = l.withdraw(
            address(cusdc), cusdcOf50Numeraires,
            address(susd), 18e18
        );

    }

    function fullIndirectUpperSlippage_5DAI_5USDT_from90DAI_145USDC_90USDT_50SUSD () public returns (uint256 shellsBurned_) {

        uint256 _startingShells = l.deposit(
            address(dai), 90e18,
            address(usdc), 145e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );

        shellsBurned_ = l.withdraw(
            address(dai), 5e18,
            address(usdt), 5e6
        );

    }

    function fullUpperSlippage_8DAI_2USDC_8USDT_2SUSD_from_90DAI_145USDC_90USDT_50SUSD () public returns (uint256 shellsBurned_) {

        uint256 _startingShells = l.deposit(
            address(dai), 90e18,
            address(usdc), 145e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );

        shellsBurned_ = l.withdraw(
            address(dai), 8e18,
            address(usdc), 2e6,
            address(usdt), 8e6,
            address(susd), 2e18
        );

    }

    function fullLowerSlippage_1USDC_7USDT_2SUSD_from_95DAI_95USDC_55USDT_15SUSD () public returns (uint256 shellsBurned_) {

        uint256 _startingShells = l.deposit(
            address(dai), 95e18,
            address(usdc), 95e6,
            address(usdt), 55e6,
            address(susd), 15e18
        );

        shellsBurned_ = l.withdraw(
            address(usdc), 1e6,
            address(usdt), 7e6,
            address(susd), 2e18
        );

    }

    function fullIndirectLowerAntiSlippage_5CHAI_5CUSDC_from_95DAI_95USDC_55USDT_15SUSD () public returns (uint256 shellsBurned_) {

        uint256 _startingShells = l.deposit(
            address(dai), 95e18,
            address(usdc), 95e6,
            address(usdt), 55e6,
            address(susd), 15e18
        );

        uint256 chaiOf5Numeraire = chaiAssimilator.viewRawAmount(uint(5e18).divu(1e18));
        uint256 cusdcOf5Numeraire = cusdcAssimilator.viewRawAmount(uint(5e18).divu(1e18));

        shellsBurned_ = l.withdraw(
            address(chai), chaiOf5Numeraire,
            address(cusdc), cusdcOf5Numeraire
        );

    }

    function fullIndirectLowerAntiSlippage_5DAI_5USDC_from_95DAI_95USDC_55USDT_15SUSD () public returns (uint256 shellsBurned_) {

        uint256 _startingShells = l.deposit(
            address(dai), 95e18,
            address(usdc), 95e6,
            address(usdt), 55e6,
            address(susd), 15e18
        );

        shellsBurned_ = l.withdraw(
            address(dai), 5e18,
            address(usdc), 5e6
        );

    }

    function fullLowerAntiSlippageWithdraw_5DAI_5USDC_0p5USDT_0p2SUSD_from_95DAI_95USDC_55USDT_15SUSD () public returns (uint256 shellsBurned_) {

        uint256 _startingShells = l.deposit(
            address(dai), 95e18,
            address(usdc), 95e6,
            address(usdt), 55e6,
            address(susd), 15e18
        );

        shellsBurned_ = l.withdraw(
            address(dai), 5e18,
            address(usdc), 5e6,
            address(usdt), 0.5e6,
            address(susd), 0.2e18
        );

    }

    function fullUpperAntiSlippage_5CDAI_2ASUSD_from_145DAI_90USDC_90USDT_50SUSD () public returns (uint256 shellsBurned_) {

        uint256 startingShells = l.deposit(
            address(dai), 145e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );

        uint256 cdaiOf5Numeraires = cdaiAssimilator.viewRawAmount(uint(5e18).divu(1e18));

        shellsBurned_ = l.withdraw(
            address(cdai), cdaiOf5Numeraires,
            address(asusd), 2e18
        );

    }

    function fullUpperAntiSlippage_5DAI_2SUSD_from_145DAI_90USDC_90USDT_50SUSD () public returns (uint256 shellsBurned_) {

        uint256 startingShells = l.deposit(
            address(dai), 145e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );

        shellsBurned_ = l.withdraw(
            address(dai), 5e18,
            address(susd), 2e18
        );

    }

    function megaUpperToLower_95USDT_35SUSD_from_90DAI_90USDC_145USDT_50SUSD () public returns (uint256 shellsBurned_) {

        uint256 startingShells = l.deposit(
            address(dai), 90e18,
            address(usdc), 90e6,
            address(usdt), 145e6,
            address(susd), 50e18
        );

        shellsBurned_ = l.withdraw(
            address(usdt), 95e6,
            address(susd), 35e18
        );

    }

    function megaIndirectLowerToUpper_11DAI_74USDC_74USDT_from_55DAI_95USDC_95USDT_15SUSD () public returns (uint256 shellsBurned_) {

        uint256 startingShells = l.deposit(
            address(dai), 55e18,
            address(usdc), 95e6,
            address(usdt), 95e6,
            address(susd), 15e18
        );

        shellsBurned_ = l.withdraw(
            address(dai), 11e18,
            address(usdc), 74e6,
            address(usdt), 74e6
        );

    }

    function megaIndirectWithdrawLowerToUpper_11DAI_74USDC_74USDT_0p0001SDUSD_from_55DAI_95USDC_95USDT_15SUSD () public returns (uint256 shellsBurned_) {

        uint256 startingShells = l.deposit(
            address(dai), 55e18,
            address(usdc), 95e6,
            address(usdt), 95e6,
            address(susd), 15e18
        );

        shellsBurned_ = l.withdraw(
            address(dai), 11e18,
            address(usdc), 74e6,
            address(usdt), 74e6,
            address(susd), 0.0001e18
        );

    }

    function upperHaltCheck30Pct () public {

        l.deposit(
            address(dai), 100e18,
            address(usdc), 90e6,
            address(usdt), 80e6,
            address(susd), 30e18
        );

        l.withdraw(
            address(dai), 95e18,
            address(usdt), 75e6,
            address(susd), 27e18
        );

    }

    function lowerHaltCheck30Pct () public {

        l.deposit(
            address(dai), 90e18,
            address(usdc), 90e6,
            address(usdt), 65e6,
            address(susd), 30e18
        );

        l.withdraw(address(usdt), 50e6);

    }

    function upperHaltCheck10Pct () public {

        l.deposit(
            address(dai), 80e18,
            address(usdc), 110e6,
            address(usdt), 80e6,
            address(susd), 30e18
        );

        l.withdraw(
            address(dai), 75e18,
            address(usdc), 105e6,
            address(usdt), 75e6
        );

    }

    function lowerHaltCheck10Pct () public {

        l.deposit(
            address(dai), 90e18,
            address(usdc), 90e6,
            address(usdt), 80e6,
            address(susd), 40e18
        );

        l.withdraw(address(susd), 30e18);

    }

    function portionalWithdraw_lightUnbalance () public returns (uint256[] memory) {

        uint256 startingShells = l.deposit(
            address(dai), 80e18,
            address(usdc), 100e6,
            address(usdt), 85e6,
            address(susd), 35e18
        );

        ( , uint256[] memory reserves ) = l.liquidity();

        return reserves;

    }

    function proportionalWithdraw_unbalanced () public returns (uint256[] memory) {

        uint256 startingShells = l.deposit(
            address(dai), 55e18,
            address(usdc), 90e6,
            address(usdt), 125e6,
            address(susd), 30e18
        );

        l.proportionalWithdraw(150e18, 1e50);

        ( , uint256[] memory reserves ) = l.liquidity();

        return reserves;

    }

    function smartHalt_upper_outOfBounds_to_outOfBounds () public returns (bool success_) {

        l.proportionalDeposit(300e18, 1e50);

        uint256 _rawCUsdc = cusdcAssimilator.viewRawAmount(uint256(110e18).divu(1e18));

        cusdc.transfer(address(l), _rawCUsdc);
        usdc.transfer(address(l), 110e6);

        success_ = l.withdrawSuccess(address(usdc), 1e6);

    }

    function smartHalt_upper_outOfBounds_to_inBounds () public returns (bool success_) {

        l.proportionalDeposit(300e18, 1e50);

        uint256 _rawCUsdc = cusdcAssimilator.viewRawAmount(uint256(110e18).divu(1e18));

        cusdc.transfer(address(l), _rawCUsdc);
        usdc.transfer(address(l), 110e6);

        success_ = l.withdrawSuccess(address(usdc), 100e6);

    }

    function smartHalt_upper_unrelated () public returns (bool success_) {

        l.proportionalDeposit(300e18, 1e50);

        uint256 _rawCUsdc = cusdcAssimilator.viewRawAmount(uint256(110e18).divu(1e18));

        cusdc.transfer(address(l), _rawCUsdc);
        usdc.transfer(address(l), 110e6);

        success_ = l.withdrawSuccess(address(usdt), 1e6);

    }

    function smartHalt_lower_outOfBounds_exacerbated () public returns (bool success_) {

        l.proportionalDeposit(67e18, 1e50);

        uint256 _rawCDai = cdaiAssimilator.viewRawAmount(uint256(70e18).divu(1e18));

        cdai.transfer(address(l), _rawCDai);
        dai.transfer(address(l), 70e18);

        usdt.transfer(address(l), 70e6);
        ausdt.transfer(address(l), 70e6);

        susd.transfer(address(l), 23e18);
        asusd.transfer(address(l), 23e18);

        success_ = l.withdrawSuccess(
            address(usdc), 1e6
        );

    }

    function smartHalt_lower_outOfBounds_to_outOfBounds () public returns (bool success_) {

        l.proportionalDeposit(67e18, 1e50);

        uint256 _rawCDai = cdaiAssimilator.viewRawAmount(uint256(70e18).divu(1e18));

        cdai.transfer(address(l), _rawCDai);
        dai.transfer(address(l), 70e18);

        usdt.transfer(address(l), 70e6);
        ausdt.transfer(address(l), 70e6);

        susd.transfer(address(l), 23e18);
        asusd.transfer(address(l), 23e18);

        success_ = l.withdrawSuccess(
            address(dai), 1e18,
            address(usdt), 1e6,
            address(susd), 1e18
        );

    }

    function smartHalt_lower_outOfBounds_to_inBounds () public returns (bool success_) {

        l.proportionalDeposit(67e18, 1e50);

        uint256 _rawCDai = cdaiAssimilator.viewRawAmount(uint256(70e18).divu(1e18));

        cdai.transfer(address(l), _rawCDai);
        dai.transfer(address(l), 70e18);

        usdt.transfer(address(l), 70e6);
        ausdt.transfer(address(l), 70e6);

        susd.transfer(address(l), 23e18);
        asusd.transfer(address(l), 23e18);

        success_ = l.withdrawSuccess(
            address(dai), 80e18,
            address(usdt), 80e6,
            address(susd), 23e18
        );

    }

    function monotonicity_upper_outOfBand_outOfBounds_to_inBounds_noHalt_omegaUpdate () public returns (uint256 shellsBurned_) {

        l.proportionalDeposit(300e18, 1e50);

        usdt.transfer(address(l), 9910e6);
        ausdt.transfer(address(l), 9910e6);

        

        //l.TEST_setTestHalts(false);

        shellsBurned_ = l.withdraw(address(usdt), 9910e6);

    }

    function monotonicity_upper_outOfBand_outOfBounds_to_inBounds_noHalt_noOmegaUpdate () public returns (uint256 shellsBurned_) {

        l.proportionalDeposit(300e18, 1e50);

        usdt.transfer(address(l), 9910e6);
        ausdt.transfer(address(l), 9910e6);

        //l.TEST_setTestHalts(false);

        shellsBurned_ = l.withdraw(address(usdt), 9910e6);

    }

    function monotonicity_upper_outOfBand_outOfBounds_to_inBounds_halt_omegaUpdate () public returns (uint256 shellsBurned_) {

        l.proportionalDeposit(300e18, 1e50);

        usdt.transfer(address(l), 9910e6);
        ausdt.transfer(address(l), 9910e6);

        

        shellsBurned_ = l.withdraw(address(usdt), 9910e6);

    }

    function monotonicity_upper_outOfBand_outOfBounds_to_inBounds_halt_noOmegaUpdate () public returns (uint256 shellsBurned_) {

        l.proportionalDeposit(300e18, 1e50);

        usdt.transfer(address(l), 9910e6);
        ausdt.transfer(address(l), 9910e6);

        shellsBurned_ = l.withdraw(address(usdt), 9910e6);

    }

    function monotonicity_upper_outOfBand_outOfBounds_to_outOfBounds_noHalt_omegaUpdate () public returns (uint256 shellsBurned_) {

        l.proportionalDeposit(300e18, 1e50);

        susd.transfer(address(l), 9970e18);
        asusd.transfer(address(l), 9970e18);

        

        //l.TEST_setTestHalts(false);

        shellsBurned_ = l.withdraw(address(susd), 1e18);

    }

    function monotonicity_upper_outOfBand_outOfBounds_to_outOfBounds_noHalt_noOmegaUpdate () public returns (uint256 shellsBurned_) {

        l.proportionalDeposit(300e18, 1e50);

        susd.transfer(address(l), 9970e18);
        asusd.transfer(address(l), 9970e18);

        //l.TEST_setTestHalts(false);

        shellsBurned_ = l.withdraw(address(susd), 1e18);

    }

    function monotonicity_upper_outOfBand_outOfBounds_to_outOfBounds_halt_omegaUpdate () public returns (uint256 shellsBurned_) {

        l.proportionalDeposit(300e18, 1e50);

        susd.transfer(address(l), 9970e18);
        asusd.transfer(address(l), 9970e18);

        

        shellsBurned_ = l.withdraw(address(susd), 1e18);

    }

    function monotonicity_upper_outOfBand_outOfBounds_to_outOfBounds_halt_noOmegaUpdate () public returns (uint256 shellsBurned_) {

        l.proportionalDeposit(300e18, 1e50);

        susd.transfer(address(l), 9970e18);
        asusd.transfer(address(l), 9970e18);

        shellsBurned_ = l.withdraw(address(susd), 1e18);

    }

    function monotonicity_lower_inBounds_to_outOfBounds_halt () public returns (uint256 shellsBurned_) {

        l.proportionalDeposit(30000e18, 1e50);

        shellsBurned_ = l.withdraw(address(dai), 8910e18);

    }

    function monotonicity_lower_inBounds_to_outOfBounds_noHalt () public returns (uint256 shellsBurned_) {

        l.proportionalDeposit(30000e18, 1e50);

        //l.TEST_setTestHalts(false);

        shellsBurned_ = l.withdraw(address(dai), 8910e18);

    }

    function monotonicity_lower_outOfBand_outOfBounds_to_outOfBounds_halt_omegaUpdate () public returns (uint256 shellsBurned_) {

        l.proportionalDeposit(300e18, 1e50);

        uint256 _rawCDai = cdaiAssimilator.viewRawAmount(uint256(8910e18).divu(1e18));

        cdai.transfer(address(l), _rawCDai);
        dai.transfer(address(l), 8910e18);

        usdt.transfer(address(l), 8910e6);
        ausdt.transfer(address(l), 8910e6);

        susd.transfer(address(l), 2970e18);
        asusd.transfer(address(l), 2970e18);

        

        shellsBurned_ = l.withdraw(address(usdc), 1e6);

    }

    function monotonicity_lower_outOfBand_outOfBounds_to_outOfBounds_halt_noOmegaUpdate () public returns (uint256 shellsBurned_) {

        l.proportionalDeposit(300e18, 1e50);

        uint256 _rawCDai = cdaiAssimilator.viewRawAmount(uint256(8910e18).divu(1e18));

        cdai.transfer(address(l), _rawCDai);
        dai.transfer(address(l), 8910e18);

        usdt.transfer(address(l), 8910e6);
        ausdt.transfer(address(l), 8910e6);

        susd.transfer(address(l), 2970e18);
        asusd.transfer(address(l), 2970e18);

        shellsBurned_ = l.withdraw(address(usdc), 1e6);

    }

    function monotonicity_lower_outOfBand_outOfBounds_to_outOfBounds_noHalt_omegaUpdate () public returns (uint256 shellsBurned_) {

        l.proportionalDeposit(300e18, 1e50);

        uint256 _rawCDai = cdaiAssimilator.viewRawAmount(uint256(8910e18).divu(1e18));

        cdai.transfer(address(l), _rawCDai);
        dai.transfer(address(l), 8910e18);

        usdt.transfer(address(l), 8910e6);
        ausdt.transfer(address(l), 8910e6);

        susd.transfer(address(l), 2970e18);
        asusd.transfer(address(l), 2970e18);

        

        //l.TEST_setTestHalts(false);

        shellsBurned_ = l.withdraw(address(usdc), 1e6);

    }

    function monotonicity_lower_outOfBand_outOfBounds_to_outOfBounds_noHalt_noOmegaUpdate () public returns (uint256 shellsBurned_) {

        l.proportionalDeposit(300e18, 1e50);

        uint256 _rawCDai = cdaiAssimilator.viewRawAmount(uint256(8910e18).divu(1e18));

        cdai.transfer(address(l), _rawCDai);
        dai.transfer(address(l), 8910e18);

        usdt.transfer(address(l), 8910e6);
        ausdt.transfer(address(l), 8910e6);

        susd.transfer(address(l), 2970e18);
        asusd.transfer(address(l), 2970e18);

        //l.TEST_setTestHalts(false);

        shellsBurned_ = l.withdraw(address(usdc), 1e6);

    }

    function monotonicity_proportional_upper_outOfBand () public returns (
        uint256 dai_,
        uint256 usdc_,
        uint256 usdt_,
        uint256 susd_
    ) {

        l.proportionalDeposit(300e18, 1e50);

        usdt.transfer(address(l), 9910e6);
        ausdt.transfer(address(l), 9910e6);

        uint256 _daiBal = dai.balanceOf(address(this));
        uint256 _usdcBal = usdc.balanceOf(address(this));
        uint256 _usdtBal = usdt.balanceOf(address(this));
        uint256 _susdBal = susd.balanceOf(address(this));

        //l.TEST_setTestHalts(false);

        l.proportionalWithdraw(1e18, 1e50);

        dai_ = dai.balanceOf(address(this)) - _daiBal;
        usdc_ = usdc.balanceOf(address(this)) - _usdcBal;
        usdt_ = usdt.balanceOf(address(this)) - _usdtBal;
        susd_ = susd.balanceOf(address(this)) - _susdBal;

    }

    event log(bytes32);

    function monotonicity_proportional_lower_outOfBand () public returns (
        uint256 dai_,
        uint256 usdc_,
        uint256 usdt_,
        uint256 susd_
    ) {

        l.proportionalDeposit(300e18, 1e50);

        uint256 _rawCDai = cdaiAssimilator.viewRawAmount(uint256(9910e18).divu(1e18));

        dai.transfer(address(l), 9910e18);
        cdai.transfer(address(l), _rawCDai);

        usdt.transfer(address(l), 9910e6);
        ausdt.transfer(address(l), 9910e6);

        susd.transfer(address(l), 2970e18);
        asusd.transfer(address(l), 2970e18);

        uint256 _daiBal = dai.balanceOf(address(this));
        uint256 _usdcBal = usdc.balanceOf(address(this));
        uint256 _usdtBal = usdt.balanceOf(address(this));
        uint256 _susdBal = susd.balanceOf(address(this));

        l.proportionalWithdraw(1e18, 1e50);

        dai_ = dai.balanceOf(address(this)) - _daiBal;
        usdc_ = usdc.balanceOf(address(this)) - _usdcBal;
        usdt_ = usdt.balanceOf(address(this)) - _usdtBal;
        susd_ = susd.balanceOf(address(this)) - _susdBal;

        emit log("its really here");

    }

}