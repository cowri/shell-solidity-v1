
pragma solidity ^0.5.0;

import "ds-test/test.sol";

import "./originSwapViewsTemplate.sol";

contract OriginSwapiViewsSuiteOneTest is OriginSwapViewsTemplate, DSTest {

    function setUp() public {

        s = getShellSuiteOne();

    }

    function test_s1_originSwapViews_noSlippage_balanced_10DAI_to_USDC_300Proportional () public {

        uint256 targetAmount = super.noSlippage_balanced_10DAI_to_USDC_300Proportional();

        assertEq(targetAmount, 9997499);

    }

    function test_s1_originSwapViews_noSlippage_lightlyUnbalanced_10USDC_to_USDT_with_80DAI_100USDC_85USDT_35SUSD () public {

        uint256 targetAmount = super.noSlippage_lightlyUnbalanced_10USDC_to_USDT_with_80DAI_100USDC_85USDT_35SUSD();

        assertEq(targetAmount, 9997499);

    }

    function test_s1_originSwapViews_noSlippage_balanced_10PctWeight_to_30PctWeight () public {

        uint256 targetAmount = super.noSlippage_balanced_10PctWeight_to_30PctWeight();

        assertEq(targetAmount, 3998999);

    }

    function test_s1_originSwapViews_partialUpperAndLowerSlippage_unbalanced_10PctWeight_to_30PctWeight () public {

        uint256 targetAmount = super.partialUpperAndLowerSlippage_unbalanced_10PctWeight_to_30PctWeight();

        assertEq(targetAmount, 7922386282489836276);

    }

    function test_s1_originSwapViews_noSlippage_balanced_30PctWeight_to_30PctWeight () public {

        uint256 targetAmount = super.noSlippage_balanced_30PctWeight_to_30PctWeight();

        assertEq(targetAmount, 9997499);

    }

    function test_s1_originSwapViews_noSlippage_lightlyUnbalanced_30PctWeight_to_10PctWeight () public {

        uint256 targetAmount = super.noSlippage_lightlyUnbalanced_30PctWeight_to_10PctWeight();

        assertEq(targetAmount, 2999249999999999997);

    }

    function test_s1_originSwapViews_partialUpperAndLowerSlippage_balanced_40USDC_to_DAI () public {

        uint256 targetAmount = super.partialUpperAndLowerSlippage_balanced_40USDC_to_DAI();

        assertEq(targetAmount, 39339756348795716299);

    }

    function test_s1_originSwapViews_partialUpperAndLowerSlippage_balanced_30PctWeight_to_10PctWeight () public {

        uint256 targetAmount = super.partialUpperAndLowerSlippage_balanced_30PctWeight_to_10PctWeight();

        assertEq(targetAmount, 14817098101815228528);

    }

    function test_s1_originSwapViews_fullUpperAndLowerSlippage_unbalanced_30PctWeight__ () public {

        uint256 targetAmount = super.fullUpperAndLowerSlippage_unbalanced_30PctWeight();

        assertEq(targetAmount, 4667368);

    }

    function test_s1_originSwapViews_fullUpperAndLowerSlippage_unbalanced_30PctWeight_to_10PctWeight () public {

        uint256 targetAmount = super.fullUpperAndLowerSlippage_unbalanced_30PctWeight_to_10PctWeight();

        assertEq(targetAmount, 2877116893342516205);

    }

    function test_s1_originSwapViews_fullUpperAndLowerSlippage_unbalanced_10PctWeight_to_30PctWeight () public {

        uint256 targetAmount = super.fullUpperAndLowerSlippage_unbalanced_10PctWeight_to_30PctWeight();

        assertEq(targetAmount, 2697035);

    }

    function test_s1_originSwapViews_partialUpperAndLowerAntiSlippage_unbalanced_30PctWeight__ () public {

        uint256 targetAmount = super.partialUpperAndLowerAntiSlippage_unbalanced_30PctWeight();

        assertEq(targetAmount, 30077776294642857112);

    }

    function test_s1_originSwapViews_partialUpperAndLowerAntiSlippage_unbalanced_30PctWeight_to_10PctWeight () public {

        uint256 targetAmount = super.partialUpperAndLowerAntiSlippage_unbalanced_30PctWeight_to_10PctWeight();

        assertEq(targetAmount, 10022287566546762578);

    }

    function test_s1_originSwapViews_fullUpperAndLowerAntiSlippage_unbalanced_30PctWeight () public {

        uint256 targetAmount = super.fullUpperAndLowerAntiSlippage_unbalanced_30PctWeight();

        assertEq(targetAmount, 5047059);

    }

    function test_s1_originSwapViews_fullUpperAndLowerAntiSlippage_10PctWeight_to30PctWeight () public {

        uint256 targetAmount = super.fullUpperAndLowerAntiSlippage_10PctWeight_to30PctWeight();

        assertEq(targetAmount, 3661067);

    }

    function test_s1_originSwapViews_fullUpperAndLowerAntiSlippage_30pctWeight_to_10Pct () public {

        uint256 targetAmount = super.fullUpperAndLowerAntiSlippage_30pctWeight_to_10Pct();

        assertEq(targetAmount, 2366053853162344119);

    }

    function test_s1_originSwapViews_upperHaltCheck_30PctWeight () public {

        bool success = super.upperHaltCheck_30PctWeight();

        assertTrue(!success);

    }

    function test_s1_originSwapViews_lowerHaltCheck_30PctWeight () public {

        bool success = super.lowerHaltCheck_30PctWeight();

        assertTrue(!success);

    }

    function test_s1_originSwapViews_upperHaltCheck_10PctWeight () public {

        bool success = super.upperHaltCheck_10PctWeight();

        assertTrue(!success);

    }

    function test_s1_originSwapViews_lowerhaltCheck_10PctWeight () public {


        bool success = super.lowerhaltCheck_10PctWeight();

        assertTrue(!success);

    }

    function test_s1_originSwapViews_megaLowerToUpperUpperToLower_30PctWeight () public {

        uint256 targetAmount = super.megaLowerToUpperUpperToLower_30PctWeight();

        assertEq(targetAmount, 69982499);

    }

    function test_s1_originSwapViews_megaLowerToUpper_10PctWeight_to_30PctWeight () public {

        uint256 targetAmount = super.megaLowerToUpper_10PctWeight_to_30PctWeight();

        assertEq(targetAmount, 19994999);

    }

    function test_s1_originSwapViews_megaUpperToLower_30PctWeight_to_10PctWeight () public {

        uint256 targetAmount = super.megaUpperToLower_30PctWeight_to_10PctWeight();

        assertEq(targetAmount, 19994999999999999972);

    }

    function testFailOriginSwap_greaterThanBalance_30Pct () public {

        super.greaterThanBalance_30Pct();

    }

    function testFailOriginSwap_greaterThanBalance_10Pct () public {

        super.greaterThanBalance_10Pct();

    }

    function test_s1_originSwapViews_smartHalt_upper () public {

        bool success = super.smartHalt_upper();

        assertTrue(!success);

    }

    function test_s1_originSwapViews_smartHalt_upper_unrelated () public {

        bool success = super.smartHalt_upper_unrelated();

        assertTrue(success);

    }

    function test_s1_originSwapViews_smartHalt_lower_outOfBounds_to_outOfBounds () public returns (bool success_) {

        bool success = super.smartHalt_lower_outOfBounds_to_outOfBounds();

        assertTrue(success);

    }

    function test_s1_originSwapViews_smartHalt_lower_outOfBounds_to_inBounds () public returns (bool success_) {

        bool success = super.smartHalt_lower_outOfBounds_to_inBounds();

        assertTrue(success);

    }

    function test_s1_originSwapViews_smartHalt_lower_unrelated () public {

        bool success = super.smartHalt_upper_unrelated();

        assertTrue(success);

    }

}