
pragma solidity ^0.5.0;

import "ds-test/test.sol";

import "./targetSwapTemplate.sol";

contract TargetSwapSuiteTwoTests is TargetSwapTemplate, DSTest {

    function setUp() public {

        l = getLoihiSuiteTwo();

    }

    function test_s2_targetSwap_noSlippage_balanced_DAI_to_10USDC_300Proportional () public {

        uint256 originAmount = super.noSlippage_balanced_DAI_to_10USDC_300Proportional();

        assertEq(originAmount, 10005000625000000000);

    }

    function test_s2_targetSwap_noSlippage_unbalanced_USDC_to_3SUSD_with_80DAI_100USDC_85USDT_35SUSD () public {

        uint256 originAmount = super.noSlippage_unbalanced_USDC_to_3SUSD_with_80DAI_100USDC_85USDT_35SUSD();

        assertEq(originAmount, 3001500);

    }

    function test_s2_targetSwap_noSlippage_balanced_10PctWeight_to_30PctWeight () public {

        uint256 originAmount = super.noSlippage_balanced_10PctWeight_to_30PctWeight();

        assertEq(originAmount, 4002000250000000000);

    }

    function test_s2_targetSwap_noSlippage_Balanced_10PctWeight_to_30PctWeight_AUSDT () public {

        uint256 originAmount = super.noSlippage_Balanced_10PctWeight_to_30PctWeight_AUSDT();

        assertEq(originAmount, 4002000250000000000);

    }

    function test_s2_targetSwap_partialUpperAndLowerSlippage_balanced_30PctWeight_to30PctWeight () public {

        uint256 originAmount = super.partialUpperAndLowerSlippage_balanced_30PctWeight_to30PctWeight();

        assertEq(originAmount, 40722871);

    }

    function test_s2_targetSwap_partialUpperAndLowerSlippage_balanced_30PctWeight_to_10PctWeight () public {

        uint256 originAmount = super.partialUpperAndLowerSlippage_balanced_30PctWeight_to_10PctWeight();

        assertEq(originAmount, 12073660);

    }

    function test_s2_targetSwap_partialUpperAndLowerSLippage_balanced_30PctWeight_to_10PctWeight_ASUSD () public {

        uint256 originAmount = super.partialUpperAndLowerSLippage_balanced_30PctWeight_to_10PctWeight_ASUSD();

        assertEq(originAmount, 12073660);

    }

    function test_s2_targetSwap_partialUpperAndLowerSlippage_unbalanced_10PctWeight_to_30PctWeight () public {

        uint256 originAmount = super.partialUpperAndLowerSlippage_unbalanced_10PctWeight_to_30PctWeight();

        assertEq(originAmount, 8082681715960427072);

    }

    function test_s2_targetSwap_noSlippage_lightlyUnbalanced_30PctWeight_to_10PctWeight () public {

        uint256 originAmount = super.noSlippage_lightlyUnbalanced_30PctWeight_to_10PctWeight();

        assertEq(originAmount, 3001500);

    }

    function test_s2_targetSwap_noSlippage_lightlyUnbalanced_30PctWeight_to_10PctWeight_CUSDC () public {

        uint256 originAmount = super.noSlippage_lightlyUnbalanced_30PctWeight_to_10PctWeight_CUSDC();

        assertEq(originAmount, 3001500000000000000);

    }

    function test_s2_targetSwap_fullUpperAndLowerSlippage_unbalanced_30PctWeight () public {

        uint256 originAmount = super.fullUpperAndLowerSlippage_unbalanced_30PctWeight();

        assertEq(originAmount, 5361455914007417759);

    }

    function test_s2_targetSwap_fullUpperAndLowerSlippage_unbalanced_30PctWeight_to_10PctWeight () public {

        uint256 originAmount = super.fullUpperAndLowerSlippage_unbalanced_30PctWeight_to_10PctWeight();

        assertEq(originAmount, 3130264791663764854);

    }

    function test_s2_targetSwap_fullUpperAndLowerSlippage_unbalanced_10PctWeight_to_30PctWeight () public {

        uint256 originAmount = super.fullUpperAndLowerSlippage_unbalanced_10PctWeight_to_30PctWeight();

        assertEq(originAmount, 2909155536050677534);

    }

    function test_s2_targetSwap_partialUpperAndLowerAntiSlippage_unbalanced_30PctWeight_to_30PctWeight () public {

        uint256 originAmount = super.partialUpperAndLowerAntiSlippage_unbalanced_30PctWeight_to_30PctWeight();

        assertEq(originAmount, 29929682);

    }

    function test_s2_targetSwap_partialUpperAndLowerAntiSlippage_unbalanced_CHAI_10PctWeight_to_30PctWeight () public {

        uint256 originAmount = super.partialUpperAndLowerAntiSlippage_unbalanced_CHAI_10PctWeight_to_30PctWeight();

        assertEq(originAmount, 9993821361386267461);

    }

    function test_s2_targetSwap_partialUpperAndLowerAntiSlippage_unbalanced_10PctWeight_to_30PctWeight () public {

        uint256 originAmount = super.partialUpperAndLowerAntiSlippage_unbalanced_10PctWeight_to_30PctWeight();

        assertEq(originAmount, 9993821361386267461);

    }

    function test_s2_targetSwap_partialUpperAndLowerAntiSlippage_unbalanced_30PctWeight_to_10PctWeight () public {

        uint256 originAmount = super.partialUpperAndLowerAntiSlippage_unbalanced_30PctWeight_to_10PctWeight();

        assertEq(originAmount, 9980200);

    }

    function test_s2_targetSwap_fullUpperAndLowerAntiSlippage_unbalanced_30PctWeight () public {

        uint256 originAmount = super.fullUpperAndLowerAntiSlippage_unbalanced_30PctWeight();

        assertEq(originAmount, 4954524);

    }

    function test_s2_targetSwap_fullUpperAndLowerAntiSlippage_10PctOrigin_to_30PctTarget () public {

        uint256 originAmount = super.fullUpperAndLowerAntiSlippage_10PctOrigin_to_30PctTarget();

        assertEq(originAmount, 3647253554589698680);

    }

    function test_s2_targetSwap_fullUpperAndLowerAntiSlippage_CDAI_30pct_to_10Pct () public {

        uint256 originAmount = super.fullUpperAndLowerAntiSlippage_CDAI_30pct_to_10Pct();

        assertEq(originAmount, 2332615973198180868);

    }

    function test_s2_targetSwap_fullUpperAndLowerAntiSlippage_30Pct_To10Pct () public {

        uint256 originAmount = super.fullUpperAndLowerAntiSlippage_30Pct_To10Pct();

        assertEq(originAmount, 2332615973232859927);

    }

    function test_s2_targetSwap_megaLowerToUpperUpperToLower_30PctWeight () public {

        uint256 originAmount = super.megaLowerToUpperUpperToLower_30PctWeight();

        assertEq(originAmount, 70035406577130885767);

    }

    function test_s2_targetSwap_megaLowerToUpper_10PctWeight_to_30PctWeight () public {

        uint256 originAmount = super.megaLowerToUpper_10PctWeight_to_30PctWeight();

        assertEq(originAmount, 20010074968656541264);

    }

    function test_s2_targetSwap_megaUpperToLower_30PctWeight_to_10PctWeight () public {

        uint256 originAmount = super.megaUpperToLower_30PctWeight_to_10PctWeight();

        assertEq(originAmount, 20010007164941759473);

    }

    function test_s2_targetSwap_upperHaltCheck_30PctWeight () public {

        bool success = super.upperHaltCheck_30PctWeight();

        assertTrue(!success);

    }

    function test_s2_targetSwap_lowerHaltCheck_30PctWeight () public {

        bool success = super.lowerHaltCheck_30PctWeight();

        assertTrue(!success);

    }

    function test_s2_targetSwap_upperHaltCheck_10PctWeight () public {

        bool success = super.upperHaltCheck_10PctWeight();

        assertTrue(!success);

    }

    function test_s2_targetSwap_lowerhaltCheck_10PctWeight () public {

        bool success = super.lowerhaltCheck_10PctWeight();

        assertTrue(!success);

    }

    function test_s2_targetSwap_noSlippage_partiallyUnbalanced_10PctTarget () public {

        uint256 originAmount = super.noSlippage_partiallyUnbalanced_10PctTarget();

        assertEq(originAmount, 3001500187500000000);

    }

    function testFailTargetSwap_targetGreaterThanBalance_30Pct () public {

        super.targetGreaterThanBalance_30Pct();

    }

    function testFailTargetSwap_targetGreaterThanBalance_10Pct () public {

        super.targetGreaterThanBalance_10Pct();

    }

}