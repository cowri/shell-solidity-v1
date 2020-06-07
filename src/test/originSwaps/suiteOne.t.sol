
pragma solidity ^0.5.0;

import "ds-test/test.sol";

import "./originSwapTemplate.sol";

contract OriginSwapSuiteOneTest is OriginSwapTemplate, DSTest {

    function setUp() public {

        l = getLoihiSuiteOne();

    }

    function testOriginSwap_noSlippage_balanced_10DAI_to_USDC_300Proportional () public {

        uint256 targetAmount = super.noSlippage_balanced_10DAI_to_USDC_300Proportional();

        assertEq(targetAmount, 9995000);

    }

    function testOriginSwap_noSlippage_lightlyUnbalanced_10USDC_to_USDT_with_80DAI_100USDC_85USDT_35SUSD () public {

        uint256 targetAmount = super.noSlippage_lightlyUnbalanced_10USDC_to_USDT_with_80DAI_100USDC_85USDT_35SUSD();

        assertEq(targetAmount, 9995000);

    }

    function testOriginSwap_noSlippage_balanced_10PctWeight_to_30PctWeight () public {

        uint256 targetAmount = super.noSlippage_balanced_10PctWeight_to_30PctWeight();

        assertEq(targetAmount, 3998000);

    }

    function testOriginSwap_partialUpperAndLowerSlippage_unbalanced_10PctWeight_to_30PctWeight () public {

        uint256 targetAmount = super.partialUpperAndLowerSlippage_unbalanced_10PctWeight_to_30PctWeight();

        assertEq(targetAmount, 7920411672881948283);

    }

    function testOriginSwap_noSlippage_balanced_30PctWeight_to_30PctWeight () public {

        uint256 targetAmount = super.noSlippage_balanced_30PctWeight_to_30PctWeight();

        assertEq(targetAmount, 9995000);

    }

    function testOriginSwap_noSlippage_lightlyUnbalanced_30PctWeight_to_10PctWeight () public {

        uint256 targetAmount = super.noSlippage_lightlyUnbalanced_30PctWeight_to_10PctWeight();

        assertEq(targetAmount, 2998500187500000000);

    }

    function testOriginSwap_partialUpperAndLowerSlippage_balanced_40USDC_to_DAI () public {

        uint256 targetAmount = super.partialUpperAndLowerSlippage_balanced_40USDC_to_DAI();

        assertEq(targetAmount, 39330195827959985796);

    }

    function testOriginSwap_partialUpperAndLowerSlippage_balanced_30PctWeight_CUSDC_to_CDAI () public {

        uint256 targetAmount = super.partialUpperAndLowerSlippage_balanced_30PctWeight_CUSDC_to_CDAI();

        assertEq(targetAmount, 39330195827959985796);

    }

    function testOriginSwap_partialUpperAndLowerSlippage_balanced_30PctWeight_to_10PctWeight () public {

        uint256 targetAmount = super.partialUpperAndLowerSlippage_balanced_30PctWeight_to_10PctWeight();

        assertEq(targetAmount, 14813513177462324025);

    }

    function testOriginSwap_fullUpperAndLowerSlippage_unbalanced_30PctWeight () public {

        uint256 targetAmount = super.fullUpperAndLowerSlippage_unbalanced_30PctWeight();

        assertEq(targetAmount, 4666173);

    }

    function testOriginSwap_fullUpperAndLowerSlippage_unbalanced_30PctWeight_to_10PctWeight () public {

        uint256 targetAmount = super.fullUpperAndLowerSlippage_unbalanced_30PctWeight_to_10PctWeight();

        assertEq(targetAmount, 2876384124908864750);

    }

    function testOriginSwap_fullUpperAndLowerSlippage_CUSDC_ASUSD_unbalanced_10PctWeight_to_30PctWeight_ASUSD_CUSDC () public {

        uint256 targetAmount = super.fullUpperAndLowerSlippage_CUSDC_ASUSD_unbalanced_10PctWeight_to_30PctWeight_ASUSD_CUSDC();

        assertEq(targetAmount, 2696349000000000000);

    }

    function testOriginSwap_fullUpperAndLowerSlippage_unbalanced_10PctWeight_to_30PctWeight () public {

        uint256 targetAmount = super.fullUpperAndLowerSlippage_unbalanced_10PctWeight_to_30PctWeight();

        assertEq(targetAmount, 2696349);

    }

    function testOriginSwap_partialUpperAndLowerAntiSlippage_unbalanced_30PctWeight__ () public {

        uint256 targetAmount = super.partialUpperAndLowerAntiSlippage_unbalanced_30PctWeight();

        assertEq(targetAmount, 30070278169642344458);

    }

    function testOriginSwap_partialUpperAndLowerAntiSlippage_unbalanced_10PctWeight_to_30PctWeight () public {

        uint256 targetAmount = super.partialUpperAndLowerAntiSlippage_unbalanced_10PctWeight_to_30PctWeight();

        assertEq(targetAmount, 10006174300378984359);

    }

    function testOriginSwap_partialUpperAndLowerAntiSlippage_unbalanced_30PctWeight_to_10PctWeight () public {

        uint256 targetAmount = super.partialUpperAndLowerAntiSlippage_unbalanced_30PctWeight_to_10PctWeight();

        assertEq(targetAmount, 10019788191004510065);

    }

    function testOriginSwap_fullUpperAndLowerAntiSlippage_unbalanced_30PctWeight () public {

        uint256 targetAmount = super.fullUpperAndLowerAntiSlippage_unbalanced_30PctWeight();

        assertEq(targetAmount, 5045804);

    }

    function testOriginSwap_fullUpperAndLowerAntiSlippage_10PctWeight_to30PctWeight () public {

        uint256 targetAmount = super.fullUpperAndLowerAntiSlippage_10PctWeight_to30PctWeight();

        assertEq(targetAmount, 3660153);

    }

    function testOriginSwap_fullUpperAndLowerAntiSlippage_30pctWeight_to_10Pct () public {

        uint256 targetAmount = super.fullUpperAndLowerAntiSlippage_30pctWeight_to_10Pct();

        assertEq(targetAmount, 2365464484251272960);

    }

    function testOriginSwap_CHAI_fullUpperAndLowerAntiSlippage_30pctWeight_to_10Pct () public {

        uint256 targetAmount = super.CHAI_fullUpperAndLowerAntiSlippage_30pctWeight_to_10Pct();

        assertEq(targetAmount, 2365464484251272960);

    }

    function testOriginSwap_upperHaltCheck_30PctWeight () public {

        bool success = super.upperHaltCheck_30PctWeight();

        assertTrue(!success);

    }

    function testOriginSwap_lowerHaltCheck_30PctWeight () public {

        bool success = super.lowerHaltCheck_30PctWeight();

        assertTrue(!success);

    }

    function testOriginSwap_upperHaltCheck_10PctWeight () public {

        bool success = super.upperHaltCheck_10PctWeight();

        assertTrue(!success);

    }

    function testOriginSwap_lowerhaltCheck_10PctWeight () public {


        bool success = super.lowerhaltCheck_10PctWeight();

        assertTrue(!success);

    }

    function testOriginSwap_megaLowerToUpperUpperToLower_30PctWeight () public {

        uint256 targetAmount = super.megaLowerToUpperUpperToLower_30PctWeight();

        assertEq(targetAmount, 69965119);

    }

    function testOriginSwap_megaLowerToUpperUpperToLower_CDAI_30PctWeight () public {

        uint256 targetAmount = super.megaLowerToUpperUpperToLower_CDAI_30PctWeight();

        assertEq(targetAmount, 17491279);

    }

    function testOriginSwap_megaLowerToUpper_10PctWeight_to_30PctWeight () public {

        uint256 targetAmount = super.megaLowerToUpper_10PctWeight_to_30PctWeight();

        assertEq(targetAmount, 19990003);

    }

    function testOriginSwap_megaUpperToLower_30PctWeight_to_10PctWeight () public {

        uint256 targetAmount = super.megaUpperToLower_30PctWeight_to_10PctWeight();

        assertEq(targetAmount, 19990016481618381864);

    }

    function testFailOriginSwap_greaterThanBalance_30Pct () public {

        super.greaterThanBalance_30Pct();

    }

    function testFailOriginSwap_greaterThanBalance_10Pct () public {

        super.greaterThanBalance_10Pct();

    }

}