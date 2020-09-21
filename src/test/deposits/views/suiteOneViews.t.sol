pragma solidity ^0.5.0;

import "ds-test/test.sol";

import "./depositsViewsTemplate.sol";

contract SelectiveDepositSuiteOneViews is SelectiveDepositViewsTemplate, DSTest {

    function setUp() public {

        s = getShellSuiteOne();

    }

    function test_s1_selectiveDepositViews_balanced_5DAI_1USDC_3USDT_1SUSD () public {

        uint256 newShells = super.balanced_5DAI_1USDC_3USDT_1SUSD();

        assertEq(newShells, 9999999999999999991);

    }

    function test_s1_selectiveDepositViews_partialUpperSlippage_145DAI_90USDC_90USDT_50SUSD () public {

        uint256 newShells = super.partialUpperSlippage_145DAI_90USDC_90USDT_50SUSD();

        assertEq(newShells, 374956944444444444455);

    }

    function test_s1_selectiveDepositViews_partialLowerSlippage_95DAI_55USDC_95USDT_15SUSD () public {

        uint256 newShells = super.partialLowerSlippage_95DAI_55USDC_95USDT_15SUSD();

        assertEq(newShells, 259906410256410256403);

    }

    function test_s1_selectiveDepositViews_partialUpperSlippage_5DAI_5USDC_70USDT_28SUSD_300Proportional () public {

        uint256 newShells = super.partialUpperSlippage_5DAI_5USDC_70USDT_28SUSD_300Proportional();

        assertEq(newShells, 107839869281045751654);

    }

    function test_s1_selectiveDepositViews_partialLowerSlippage_moderatelyUnbalanced_1DAI_51USDC_51USDT_1SUSD () public {

        uint256 newShells = super.partialLowerSlippage_moderatelyUnbalanced_1DAI_51USDC_51USDT_1SUSD();

        assertEq(newShells, 103803802211302211279);

    }

    function test_s1_selectiveDepositViews_partialLowerSlippage_balanced_0p001DAI_90USDC_90USDT () public {

        uint256 newShells = super.partialLowerSlippage_balanced_0p001DAI_90USDC_90USDT();

        assertEq(newShells, 179701018124533421095);

    }

    function test_s1_selectiveDepositViews_partialUpperAntiSlippage_46USDC_53USDT_into_145DAI_90USDC_90USDT_50SUSD () public {

        uint256 newShells = super.partialUpperAntiSlippage_46USDC_53USDT_into_145DAI_90USDC_90USDT_50SUSD();

        assertEq(newShells, 99008611111111111104);

    }

    function test_s1_selectiveDepositViews_partialUpperAntiSlippage_unbalanced_1DAI_46USDC_53USDT_1SUSD_into_145DAI_90USDC_90USDT_50SUSD () public {

        uint256 newShells = super.partialUpperAntiSlippage_unbalanced_1DAI_46USDC_53USDT_1SUSD_into_145DAI_90USDC_90USDT_50SUSD();

        assertEq(newShells, 101008611111111111102);

    }

    function test_s1_selectiveDepositViews_partialLowerAntiSlippage_36USDC_18SUSD_into_95DAI_55USDC_95USDT_15SUSD () public {

        uint256 newShells = super.partialLowerAntiSlippage_36USDC_18SUSD_into_95DAI_55USDC_95USDT_15SUSD();

        assertEq(newShells, 54018717948717948711);

    }

    function test_s1_selectiveDepositViews_fullUpperSlippage_5USDC_3SUSD_into_90DAI_145USDC_90USDT_50SUSD () public {

        uint256 newShells = super.fullUpperSlippage_5USDC_3SUSD_into_90DAI_145USDC_90USDT_50SUSD();

        assertEq(newShells, 7939106469393675653);

    }

    function test_s1_selectiveDepositViews_fullLowerSlippage_12DAI_12USDC_1USDT_1SUSD_into_95DAI_95USDC_55USDT_15SUSD () public {

        uint256 newShells = super.fullLowerSlippage_12DAI_12USDC_1USDT_1SUSD_into_95DAI_95USDC_55USDT_15SUSD();

        assertEq(newShells, 25908473193473193467);

    }

    function test_s1_selectiveDepositViews_fullLowerSlippage_9DAI_9USDC_into_95DAI_95USDC_55USDT_15SUSD () public {

        uint256 newShells = super.fullLowerSlippage_9DAI_9USDC_into_95DAI_95USDC_55USDT_15SUSD();

        assertEq(newShells, 17902138904261206411);

    }

    function test_s1_selectiveDepositViews_fullUpperAntiSlippage_8DAI_12USDC_10USDT_2SUSD_into_145DAI_90USDC_90USDT_50SUSD () public {

        uint256 newShells = super.fullUpperAntiSlippage_8DAI_12USDC_10USDT_2SUSD_into_145DAI_90USDC_90USDT_50SUSD();

        assertEq(newShells, 32007966147966147958);

    }

    function test_s1_selectiveDepositViews_fullLowerAntiSlippage_5DAI_5USDC_5USDT_2SUSD_into_55DAI_95USDC_95USDT_15SUSD  () public {

        uint256 newShells = super.fullLowerAntiSlippage_5DAI_5USDC_5USDT_2SUSD_into_55DAI_95USDC_95USDT_15SUSD();

        assertEq(newShells, 17007127696010367489);

    }

    function test_s1_selectiveDepositViews_noSlippage_36DAI_from_300Proportional () public {

        uint256 shellsMinted = super.noSlippage_36DAI_from_300Proportional();

        assertEq(shellsMinted, 35999999999999999985);

    }

    function test_s1_selectiveDepositViews_upperSlippage_36Point001Dai_into_300Proportional () public {

        uint256 shellsMinted = super.upperSlippage_36Point001Dai_into_300Proportional();

        assertEq(shellsMinted, 36000999999612476342);

    }

    function test_s1_selectiveDepositViews_megaDepositDirectLowerToUpper_105DAI_37SUSD_from_55DAI_95USDC_95USDT_15SUSD () public {

        uint256 newShells = super.megaDepositDirectLowerToUpper_105DAI_37SUSD_from_55DAI_95USDC_95USDT_15SUSD();

        assertEq(newShells, 142003004847557086355);

    }

    function test_s1_selectiveDepositViews_megaDepositIndirectUpperToLower_165DAI_165USDT_into_90DAI_145USDC_90USDT_50SUSD () public {

        uint256 newShells = super.megaDepositIndirectUpperToLower_165DAI_165USDT_into_90DAI_145USDC_90USDT_50SUSD();

        assertEq(newShells, 329943557919621749370);

    }

    function test_s1_selectiveDepositViews_megaDepositIndirectUpperToLower_165DAI_0p0001USDC_165USDT_0p5SUSD_from_90DAI_145USDC_90USDT_50SUSD () public {

        uint256 newShells = super.megaDepositIndirectUpperToLower_165DAI_0p0001USDC_165USDT_0p5SUSD_from_90DAI_145USDC_90USDT_50SUSD();

        assertEq(newShells, 330445741274888467979);

    }

    function testFailSelectiveDepositUpperHaltCheck30Pct () public {

        s.proportionalDeposit(300e18, 1e50);

        s.deposit(address(dai), 100e18);

    }

    function testFailSelectiveDepositLowerHaltCheck30Pct () public {

        s.proportionalDeposit(300e18, 1e50);

        s.deposit(
            address(dai), 300e18,
            address(usdt), 300e6,
            address(susd), 100e18
        );

    }

    function testFailSelectiveDepositDepostUpperHaltCheck10Pct () public {

        s.proportionalDeposit(300e18, 1e50);

        s.deposit(address(susd), 500e18);

    }

    function testFailSelectiveDepositLowerHaltCheck10Pct () public {

        s.proportionalDeposit(300e18, 1e50);

        s.deposit(
            address(dai), 200e18,
            address(usdc), 200e6,
            address(usdt), 200e6
        );

    }

    function testExecuteProportionalDepositIntoAnUnbalancedShell () public {

        uint256[] memory deposits = super.proportionalDeposit_unbalancedShell();

        assertEq(deposits[0], 21891891950913103706);
        assertEq(deposits[1], 21891891000000000000);
        assertEq(deposits[2], 34054054000000000000);
        assertEq(deposits[3], 12162162195035371650);

    }

    function testExecuteProportionalDepositIntoSlightlyUnbalancedShell () public {

        uint256[] memory deposits = super.proportionalDeposit_slightlyUnbalancedShell();

        assertEq(deposits[0], 29999999900039235636);
        assertEq(deposits[1], 27000000000000000000);
        assertEq(deposits[2], 23999999000000000000);
        assertEq(deposits[3], 8999999970001503300);

    }

    function testExecuteProportionalDepositIntoWidelyUnbalancedShell () public {

        uint256[] memory deposits = super.proportionalDeposit_heavilyUnbalancedShell();

        assertEq(deposits[0], 27000000089910320148);
        assertEq(deposits[1], 37499999000000000000);
        assertEq(deposits[2], 16500000000000000000);
        assertEq(deposits[3], 9000000030002282550);

    }

    function test_s1_selectiveDepositViews_smartHalt_upper_outOfBounds_to_outOfBounds () public {

        bool success = super.smartHalt_upper_outOfBounds_to_outOfBounds();

        assertTrue(success);

    }

    function test_s1_selectiveDepositViews_smartHalt_upper_outOfBounds_to_inBounds () public {

        bool success = super.smartHalt_upper_outOfBounds_to_inBounds();

        assertTrue(success);

    }
    function test_s1_selectiveDepositViews_smartHalt_upper_outOfBounds_exacerbated () public {

        bool success = super.smartHalt_upper_outOfBounds_exacerbated();

        assertTrue(!success);

    }

    function test_s1_selectiveDepositViews_smartHalt_lower_outOfBounds_to_outOfBounds () public {

        bool success = super.smartHalt_lower_outOfBounds_to_outOfBounds();

        assertTrue(success);

    }

    function test_s1_selectiveDepositViews_smartHalt_lower_outOfBounds_to_inBounds () public {

        bool success = super.smartHalt_lower_outOfBounds_to_inBounds();

        assertTrue(success);

    }

    function test_s1_selectiveDepositViews_smartHalt_lower_unrelated () public {

        bool success = super.smartHalt_lower_unrelated();

        assertTrue(!success);

    }

}