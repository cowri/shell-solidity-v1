
pragma solidity ^0.5.0;

import "ds-test/test.sol";

import "./originSwapTemplate.sol";

contract OriginSwapSuiteOneTest is OriginSwapTemplate, DSTest {

    function setUp() public {

        s = getShellSuiteOne();

    }

    function test_s7_originSwap_noSlippage_balanced_10DAI_to_USDC_300Proportional () public {

        uint256 targetAmount = super.noSlippage_balanced_10DAI_to_USDC_300Proportional();

        assertEq(targetAmount, 9995000);

    }

    function test_s7_originSwap_noSlippage_lightlyUnbalanced_10USDC_to_USDT_with_80DAI_100USDC_85USDT_35SUSD () public {

        uint256 targetAmount = super.noSlippage_lightlyUnbalanced_10USDC_to_USDT_with_80DAI_100USDC_85USDT_35SUSD();

        assertEq(targetAmount, 9995000);

    }

    function test_s7_originSwap_noSlippage_balanced_10PctWeight_to_30PctWeight () public {

        uint256 targetAmount = super.noSlippage_balanced_10PctWeight_to_30PctWeight();

        assertEq(targetAmount, 3998000);

    }

    function test_s7_originSwap_partialUpperAndLowerSlippage_unbalanced_10PctWeight_to_30PctWeight () public {

        uint256 targetAmount = super.partialUpperAndLowerSlippage_unbalanced_10PctWeight_to_30PctWeight();

        assertEq(targetAmount, 7920411672881948283);

    }

    function test_s7_originSwap_noSlippage_balanced_30PctWeight_to_30PctWeight () public {

        uint256 targetAmount = super.noSlippage_balanced_30PctWeight_to_30PctWeight();

        assertEq(targetAmount, 9995000);

    }

    function test_s7_originSwap_noSlippage_lightlyUnbalanced_30PctWeight_to_10PctWeight () public {

        uint256 targetAmount = super.noSlippage_lightlyUnbalanced_30PctWeight_to_10PctWeight();

        assertEq(targetAmount, 2998500187500000000);

    }

    function test_s7_originSwap_partialUpperAndLowerSlippage_balanced_40USDC_to_DAI () public {

        uint256 targetAmount = super.partialUpperAndLowerSlippage_balanced_40USDC_to_DAI();

        assertEq(targetAmount, 39330195827959985796);

    }

    function test_s7_originSwap_partialUpperAndLowerSlippage_balanced_30PctWeight_CUSDC_to_CDAI () public {

        uint256 targetAmount = super.partialUpperAndLowerSlippage_balanced_30PctWeight_CUSDC_to_CDAI();

        assertEq(targetAmount, 39330195827959985796);

    }

    function test_s7_originSwap_partialUpperAndLowerSlippage_balanced_30PctWeight_to_10PctWeight () public {

        uint256 targetAmount = super.partialUpperAndLowerSlippage_balanced_30PctWeight_to_10PctWeight();

        assertEq(targetAmount, 14813513177462324025);

    }

    function test_s7_originSwap_fullUpperAndLowerSlippage_unbalanced_30PctWeight () public {

        uint256 targetAmount = super.fullUpperAndLowerSlippage_unbalanced_30PctWeight();

        assertEq(targetAmount, 4666173);

    }

    function test_s7_originSwap_fullUpperAndLowerSlippage_unbalanced_30PctWeight_to_10PctWeight () public {

        uint256 targetAmount = super.fullUpperAndLowerSlippage_unbalanced_30PctWeight_to_10PctWeight();

        assertEq(targetAmount, 2876384124908864750);

    }

    function test_s7_originSwap_fullUpperAndLowerSlippage_CUSDC_ASUSD_unbalanced_10PctWeight_to_30PctWeight_ASUSD_CUSDC () public {

        uint256 targetAmount = super.fullUpperAndLowerSlippage_CUSDC_ASUSD_unbalanced_10PctWeight_to_30PctWeight_ASUSD_CUSDC();

        assertEq(targetAmount, 2696349000000000000);

    }

    function test_s7_originSwap_fullUpperAndLowerSlippage_unbalanced_10PctWeight_to_30PctWeight () public {

        uint256 targetAmount = super.fullUpperAndLowerSlippage_unbalanced_10PctWeight_to_30PctWeight();

        assertEq(targetAmount, 2696349);

    }

    function test_s7_originSwap_partialUpperAndLowerAntiSlippage_unbalanced_30PctWeight__ () public {

        uint256 targetAmount = super.partialUpperAndLowerAntiSlippage_unbalanced_30PctWeight();

        assertEq(targetAmount, 30070278169642344458);

    }

    function test_s7_originSwap_partialUpperAndLowerAntiSlippage_unbalanced_10PctWeight_to_30PctWeight () public {

        uint256 targetAmount = super.partialUpperAndLowerAntiSlippage_unbalanced_10PctWeight_to_30PctWeight();

        assertEq(targetAmount, 10006174300378984359);

    }

    function test_s7_originSwap_partialUpperAndLowerAntiSlippage_unbalanced_30PctWeight_to_10PctWeight () public {

        uint256 targetAmount = super.partialUpperAndLowerAntiSlippage_unbalanced_30PctWeight_to_10PctWeight();

        assertEq(targetAmount, 10019788191004510065);

    }

    function test_s7_originSwap_fullUpperAndLowerAntiSlippage_unbalanced_30PctWeight () public {

        uint256 targetAmount = super.fullUpperAndLowerAntiSlippage_unbalanced_30PctWeight();

        assertEq(targetAmount, 5045804);

    }

    function test_s7_originSwap_fullUpperAndLowerAntiSlippage_10PctWeight_to30PctWeight () public {

        uint256 targetAmount = super.fullUpperAndLowerAntiSlippage_10PctWeight_to30PctWeight();

        assertEq(targetAmount, 3660153);

    }

    function test_s7_originSwap_fullUpperAndLowerAntiSlippage_30pctWeight_to_10Pct () public {

        uint256 targetAmount = super.fullUpperAndLowerAntiSlippage_30pctWeight_to_10Pct();

        assertEq(targetAmount, 2365464484251272960);

    }

    function test_s7_originSwap_CHAI_fullUpperAndLowerAntiSlippage_30pctWeight_to_10Pct () public {

        uint256 targetAmount = super.CHAI_fullUpperAndLowerAntiSlippage_30pctWeight_to_10Pct();

        assertEq(targetAmount, 2365464484251272960);

    }

    function test_s7_originSwap_upperHaltCheck_30PctWeight () public {

        bool success = super.upperHaltCheck_30PctWeight();

        assertTrue(!success);

    }

    function test_s7_originSwap_lowerHaltCheck_30PctWeight () public {

        bool success = super.lowerHaltCheck_30PctWeight();

        assertTrue(!success);

    }

    function test_s7_originSwap_upperHaltCheck_10PctWeight () public {

        bool success = super.upperHaltCheck_10PctWeight();

        assertTrue(!success);

    }

    function test_s7_originSwap_lowerhaltCheck_10PctWeight () public {


        bool success = super.lowerhaltCheck_10PctWeight();

        assertTrue(!success);

    }

    function test_s7_originSwap_megaLowerToUpperUpperToLower_30PctWeight () public {

        uint256 targetAmount = super.megaLowerToUpperUpperToLower_30PctWeight();

        assertEq(targetAmount, 69965119);

    }

    function test_s7_originSwap_megaLowerToUpperUpperToLower_CDAI_30PctWeight () public {

        uint256 targetAmount = super.megaLowerToUpperUpperToLower_CDAI_30PctWeight();

        assertEq(targetAmount, 17491279);

    }

    function test_s7_originSwap_megaLowerToUpper_10PctWeight_to_30PctWeight () public {

        uint256 targetAmount = super.megaLowerToUpper_10PctWeight_to_30PctWeight();

        assertEq(targetAmount, 19990003);

    }

    function test_s7_originSwap_megaUpperToLower_30PctWeight_to_10PctWeight () public {

        uint256 targetAmount = super.megaUpperToLower_30PctWeight_to_10PctWeight();

        assertEq(targetAmount, 19990016481618381864);

    }

    function testFailOriginSwap_greaterThanBalance_30Pct () public {

        super.greaterThanBalance_30Pct();

    }

    function testFailOriginSwap_greaterThanBalance_10Pct () public {

        super.greaterThanBalance_10Pct();

    }

    function test_s7_originSwap_smartHalt_upper () public {

        bool success = super.smartHalt_upper();

        assertTrue(!success);

    }

    function test_s7_originSwap_smartHalt_upper_unrelated () public {

        bool success = super.smartHalt_upper_unrelated();

        assertTrue(success);

    }

    function test_s7_originSwap_smartHalt_lower_outOfBounds_to_outOfBounds () public returns (bool success_) {

        bool success = super.smartHalt_lower_outOfBounds_to_outOfBounds();

        assertTrue(success);

    }

    function test_s7_originSwap_smartHalt_lower_outOfBounds_to_inBounds () public returns (bool success_) {

        bool success = super.smartHalt_lower_outOfBounds_to_inBounds();

        assertTrue(success);

    }

    function test_s7_originSwap_smartHalt_lower_unrelated () public {

        bool success = super.smartHalt_upper_unrelated();

        assertTrue(success);

    }

}