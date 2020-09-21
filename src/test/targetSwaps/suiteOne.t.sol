
pragma solidity ^0.5.0;

import "ds-test/test.sol";

import "./targetSwapTemplate.sol";

contract TargetSwapSuiteOneTests is TargetSwapTemplate, DSTest {

    function setUp() public {

        s = getShellSuiteOne();

    }

    function test_s1_targetSwap_noSlippage_balanced_DAI_to_10USDC_300Proportional () public {

        uint256 originAmount = super.noSlippage_balanced_DAI_to_10USDC_300Proportional();

        assertEq(originAmount, 10002500000000000000);

    }

    function test_s1_targetSwap_noSlippage_unbalanced_USDC_to_3SUSD_with_80DAI_100USDC_85USDT_35SUSD () public {

        uint256 originAmount = super.noSlippage_unbalanced_USDC_to_3SUSD_with_80DAI_100USDC_85USDT_35SUSD();

        assertEq(originAmount, 3000750);

    }

    function test_s1_targetSwap_noSlippage_balanced_10PctWeight_to_30PctWeight () public {

        uint256 originAmount = super.noSlippage_balanced_10PctWeight_to_30PctWeight();

        assertEq(originAmount, 4001000000000000000);

    }

    function test_s1_targetSwap_partialUpperAndLowerSlippage_balanced_30PctWeight_to30PctWeight () public {

        uint256 originAmount = super.partialUpperAndLowerSlippage_balanced_30PctWeight_to30PctWeight();

        assertEq(originAmount, 40712545);

    }

    function test_s1_targetSwap_partialUpperAndLowerSlippage_balanced_30PctWeight_to_10PctWeight () public {

        uint256 originAmount = super.partialUpperAndLowerSlippage_balanced_30PctWeight_to_10PctWeight();

        assertEq(originAmount, 12070653);

    }

    function test_s1_targetSwap_partialUpperAndLowerSlippage_unbalanced_10PctWeight_to_30PctWeight () public {

        uint256 originAmount = super.partialUpperAndLowerSlippage_unbalanced_10PctWeight_to_30PctWeight();

        assertEq(originAmount, 8080628052824050000);

    }

    function test_s1_targetSwap_noSlippage_lightlyUnbalanced_30PctWeight_to_10PctWeight () public {

        uint256 originAmount = super.noSlippage_lightlyUnbalanced_30PctWeight_to_10PctWeight();

        assertEq(originAmount, 3000750);

    }

    function test_s1_targetSwap_fullUpperAndLowerSlippage_unbalanced_30PctWeight () public {

        uint256 originAmount = super.fullUpperAndLowerSlippage_unbalanced_30PctWeight();

        assertEq(originAmount, 5291271507550375000);

    }

    function test_s1_targetSwap_fullUpperAndLowerSlippage_unbalanced_30PctWeight_to_10PctWeight () public {

        uint256 originAmount = super.fullUpperAndLowerSlippage_unbalanced_30PctWeight_to_10PctWeight();

        assertEq(originAmount, 3129492603917005000);

    }

    function test_s1_targetSwap_fullUpperAndLowerSlippage_unbalanced_10PctWeight_to_30PctWeight () public {

        uint256 originAmount = super.fullUpperAndLowerSlippage_unbalanced_10PctWeight_to_30PctWeight();

        assertEq(originAmount, 2908432935382939000);

    }

    function test_s1_targetSwap_partialUpperAndLowerAntiSlippage_unbalanced_30PctWeight_to_30PctWeight () public {

        uint256 originAmount = super.partialUpperAndLowerAntiSlippage_unbalanced_30PctWeight_to_30PctWeight();

        assertEq(originAmount, 29922181);

    }

    function test_s1_targetSwap_partialUpperAndLowerAntiSlippage_unbalanced_10PctWeight_to_30PctWeight () public {

        uint256 originAmount = super.partialUpperAndLowerAntiSlippage_unbalanced_10PctWeight_to_30PctWeight();

        assertEq(originAmount, 9991320735294117000);

    }

    function test_s1_targetSwap_partialUpperAndLowerAntiSlippage_unbalanced_30PctWeight_to_10PctWeight () public {

        uint256 originAmount = super.partialUpperAndLowerAntiSlippage_unbalanced_30PctWeight_to_10PctWeight();

        assertEq(originAmount, 9977700);

    }

    function test_s1_targetSwap_fullUpperAndLowerAntiSlippage_unbalanced_30PctWeight () public {

        uint256 originAmount = super.fullUpperAndLowerAntiSlippage_unbalanced_30PctWeight();

        assertEq(originAmount, 4953278);

    }

    function test_s1_targetSwap_fullUpperAndLowerAntiSlippage_10PctOrigin_to_30PctTarget () public {

        uint256 originAmount = super.fullUpperAndLowerAntiSlippage_10PctOrigin_to_30PctTarget();

        assertEq(originAmount, 3646340426509550000);

    }

    function test_s1_targetSwap_fullUpperAndLowerAntiSlippage_30Pct_To10Pct () public {

        uint256 originAmount = super.fullUpperAndLowerAntiSlippage_30Pct_To10Pct();

        assertEq(originAmount, 2332029381118264000);

    }

    function test_s1_targetSwap_megaLowerToUpperUpperToLower_30PctWeight () public {

        uint256 originAmount = super.megaLowerToUpperUpperToLower_30PctWeight();

        assertEq(originAmount, 70017500000000000000);

    }

    function test_s1_targetSwap_megaLowerToUpper_10PctWeight_to_30PctWeight () public {

        uint256 originAmount = super.megaLowerToUpper_10PctWeight_to_30PctWeight();

        assertEq(originAmount, 20005000000000000000);

    }

    function test_s1_targetSwap_megaUpperToLower_30PctWeight_to_10PctWeight () public {

        uint256 originAmount = super.megaUpperToLower_30PctWeight_to_10PctWeight();

        assertEq(originAmount, 20005000000000000000);

    }

    function test_s1_targetSwap_upperHaltCheck_30PctWeight () public {

        bool success = super.upperHaltCheck_30PctWeight();

        assertTrue(!success);

    }

    function test_s1_targetSwap_lowerHaltCheck_30PctWeight () public {

        bool success = super.lowerHaltCheck_30PctWeight();

        assertTrue(!success);

    }

    function test_s1_targetSwap_upperHaltCheck_10PctWeight () public {

        bool success = super.upperHaltCheck_10PctWeight();

        assertTrue(!success);

    }

    function test_s1_targetSwap_lowerhaltCheck_10PctWeight () public {

        bool success = super.lowerhaltCheck_10PctWeight();

        assertTrue(!success);

    }

    function test_s1_targetSwap_noSlippage_partiallyUnbalanced_10PctTarget () public {

        uint256 originAmount = super.noSlippage_partiallyUnbalanced_10PctTarget();

        assertEq(originAmount, 3000750000000000000);

    }

    function testFailTargetSwap_targetGreaterThanBalance_30Pct () public {

        super.targetGreaterThanBalance_30Pct();

    }

    function testFailTargetSwap_targetGreaterThanBalance_10Pct () public {

        super.targetGreaterThanBalance_10Pct();

    }

    function test_s1_targetSwap_smartHalt_upper_unrelated () public {

        bool success = super.smartHalt_upper_unrelated();

        assertTrue(success);

    }

    function test_s1_targetSwap_smartHalt_upper_outOfBounds_to_outOfBounds () public {

        bool success = super.smartHalt_upper_outOfBounds_to_outOfBounds();

        assertTrue(success);

    }

    function test_s1_targetSwap_smartHalt_upper_outOfBounds_to_inBounds () public {

        bool success = super.smartHalt_upper_outOfBounds_to_inBounds();

        assertTrue(success);

    }

    function test_s1_targetSwap_smartHalt_lower () public {

        bool success = super.smartHalt_lower();

        assertTrue(!success);

    }

    function test_s1_targetSwap_smartHalt_lower_unrelated () public {

        bool success = super.smartHalt_lower_unrelated();

        assertTrue(!success);

    }

}