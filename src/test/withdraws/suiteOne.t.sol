pragma solidity ^0.5.0;

import "ds-test/test.sol";

import "./withdrawTemplate.sol";

contract SelectiveWithdrawSuiteOne is SelectiveWithdrawTemplate, DSTest {

    function setUp() public {

        s = getShellSuiteOne();

    }

    function test_s1_selectiveWithdraw_balanced_10DAI_10USDC_10USDT_2p5SUSD_from_300Proportional () public {

        uint256 shellsBurned = super.balanced_10DAI_10USDC_10USDT_2p5SUSD_from_300Proportional();

        assertEq(shellsBurned, 32508125000000000018);

    }

    function test_s1_selectiveWithdraw_lightlyUnbalanced_5DAI_1USDC_3USDT_1SUSD_from_80DAI_100USDC_85USDT_35SUSD () public {

        uint256 shellsBurned = super.lightlyUnbalanced_5DAI_1USDC_3USDT_1SUSD_from_80DAI_100USDC_85USDT_35SUSD();

        assertEq(shellsBurned, 10002500000000000000);

    }

    function test_s1_selectiveWithdraw_partialLowerSlippage_balanced_5DAI_5USDC_47USDT_16SUSD_from_300Proportional () public {

        uint256 shellsBurned = super.partialLowerSlippage_balanced_5DAI_5USDC_47USDT_16SUSD_from_300Proportional();

        assertEq(shellsBurned, 73154344955029368640);

    }

    function test_s1_selectiveWithdraw_partialLowerSlippage_3DAI_60USDC_30USDT_1SUSD_from_80DAI_100USDC_100USDT_23SUSD () public {

        uint256 shellsBurned = super.partialLowerSlippage_3DAI_60USDC_30USDT_1SUSD_from_80DAI_100USDC_100USDT_23SUSD();

        assertEq(shellsBurned, 94102228808064194663);

    }

    function test_s1_selectiveWithdraw_partialUpperSlippage_balanced_0p001DAI_40USDC_40USDT_10SUSD_from_300Proportional () public {

        uint256 shellsBurned = super.partialUpperSlippage_balanced_0p001DAI_40USDC_40USDT_10SUSD_from_300Proportional();

        assertEq(shellsBurned, 90224421960738460186);

    }

    function test_s1_selectiveWithdraw_partialLowerIndirectAntiSlippage_40DAI_40USDT_from_95DAI_55USDC_95USDT_15SUSD () public {

        uint256 shellsBurned = super.partialLowerIndirectAntiSlippage_40DAI_40USDT_from_95DAI_55USDC_95USDT_15SUSD();

        assertEq(shellsBurned, 80001277371794871867);

    }

    function test_s1_selectiveWithdraw_partialLowerAntiSlippage_0p0001DAI_41USDC_41USDT_1SUSD_from_55DAI_95USDC_95USDT_15SUSD () public {

        uint256 shellsBurned = super.partialLowerAntiSlippage_0p0001DAI_41USDC_41USDT_1SUSD_from_55DAI_95USDC_95USDT_15SUSD();

        assertEq(shellsBurned, 83002127396794871860);

    }

    function test_s1_selectiveWithdraw_partialUpperAntiSlippage_50USDC_18SUSD_from_90DAI_145USDC_90USDT_50SUSD () public {

        uint256 shellsBurned = super.partialUpperAntiSlippage_50USDC_18SUSD_from_90DAI_145USDC_90USDT_50SUSD();

        assertEq(shellsBurned, 68008386736111111158);

    }

    function test_s1_selectiveWithdraw_fullIndirectUpperSlippage_5DAI_5USDT_from90DAI_145USDC_90USDT_50SUSD () public {

        uint256 shellsBurned = super.fullIndirectUpperSlippage_5DAI_5USDT_from90DAI_145USDC_90USDT_50SUSD();

        assertEq(shellsBurned, 10072190173135464226);

    }

    function test_s1_selectiveWithdraw_fullUpperSlippage_8DAI_2USDC_8USDT_2SUSD_from_90DAI_145USDC_90USDT_50SUSD () public {

        uint256 shellsBurned = super.fullUpperSlippage_8DAI_2USDC_8USDT_2SUSD_from_90DAI_145USDC_90USDT_50SUSD();

        assertEq(shellsBurned, 20090545637715179967);

    }

    function test_s1_selectiveWithdraw_fullLowerSlippage_1USDC_7USDT_2SUSD_from_95DAI_95USDC_55USDT_15SUSD () public {

        uint256 shellsBurned = super.fullLowerSlippage_1USDC_7USDT_2SUSD_from_95DAI_95USDC_55USDT_15SUSD();

        assertEq(shellsBurned, 10134109817307692313);

    }

    function test_s1_selectiveWithdraw_fullIndirectLowerAntiSlippage_5DAI_5USDC_from_95DAI_95USDC_55USDT_15SUSD () public {

        uint256 shellsBurned = super.fullIndirectLowerAntiSlippage_5DAI_5USDC_from_95DAI_95USDC_55USDT_15SUSD();

        assertEq(shellsBurned, 9995446955128205126);

    }

    function test_s1_selectiveWithdraw_fullLowerAntiSlippageWithdraw_5DAI_5USDC_0p5USDT_0p2SUSD_from_95DAI_95USDC_55USDT_15SUSD () public {

        uint256 shellsBurned = super.fullLowerAntiSlippageWithdraw_5DAI_5USDC_0p5USDT_0p2SUSD_from_95DAI_95USDC_55USDT_15SUSD();

        assertEq(shellsBurned, 10696820295820476818);

    }

    function test_s1_selectiveWithdraw_fullUpperAntiSlippage_5DAI_2SUSD_from_145DAI_90USDC_90USDT_50SUSD () public {

        uint256 shellsBurned = super.fullUpperAntiSlippage_5DAI_2SUSD_from_145DAI_90USDC_90USDT_50SUSD();

        assertEq(shellsBurned, 6996036011473429940);

    }

    function test_s1_selectiveWithdraw_megaUpperToLower_95USDT_35SUSD_from_90DAI_90USDC_145USDT_50SUSD () public {

        uint256 shellsBurned = super.megaUpperToLower_95USDT_35SUSD_from_90DAI_90USDC_145USDT_50SUSD();

        assertEq(shellsBurned, 130071682128684807393);

    }

    function test_s1_selectiveWithdraw_megaIndirectLowerToUpper_11DAI_74USDC_74USDT_from_55DAI_95USDC_95USDT_15SUSD () public {

        uint256 shellsMinted = super.megaIndirectLowerToUpper_11DAI_74USDC_74USDT_from_55DAI_95USDC_95USDT_15SUSD();

        assertEq(shellsMinted, 159145489489956207277);

    }

    function test_s1_selectiveWithdraw_megaIndirectWithdrawLowerToUpper_11DAI_74USDC_74USDT_0p0001SDUSD_from_55DAI_95USDC_95USDT_15SUSD () public {

        uint256 shellsBurned = super.megaIndirectWithdrawLowerToUpper_11DAI_74USDC_74USDT_0p0001SDUSD_from_55DAI_95USDC_95USDT_15SUSD();

        assertEq(shellsBurned, 159145586600251986918);

    }

    function testFailSelectiveWithdraw_upperHaltCheck30Pct () public {

        super.upperHaltCheck30Pct();

    }

    function testFailSelectiveWithdraw_lowerHaltCheck30Pct () public {

        super.lowerHaltCheck30Pct();

    }

    function testFailSelectiveWithdraw_upperHaltCheck10Pct () public {

        super.upperHaltCheck10Pct();

    }

    function testFailSelectiveWithdraw_lowerHaltCheck10Pct () public {

        super.lowerHaltCheck10Pct();

    }

    // function testProportionalWithdraw_mediumUnbalance () public {

    //     uint256 startingShells = s.deposit(
    //         address(dai), 80e18,
    //         address(usdc), 100e6,
    //         address(usdt), 85e6,
    //         address(susd), 35e18
    //     );

    //     s.proportionalWithdraw(150e18);

    //     ( uint256 totalReserves, uint256[] memory reserves ) = s.liquidity();

    //     uint256 endingShells = s.balanceOf(address(this));

    //     assertEq(reserves[0], 39999999999959671960);
    //     assertEq(reserves[1], 50000000);
    //     assertEq(reserves[2], 42500000);
    //     assertEq(reserves[3], 17500000000000000000);
    //     assertEq(startingShells - endingShells, 150e18);

    // }

    // function testProportionalWithdraw_unbalanced () public {

    //     uint256 startingShells = s.deposit(
    //         address(dai), 55e18,
    //         address(usdc), 90e6,
    //         address(usdt), 125e6,
    //         address(susd), 30e18
    //     );

    //     s.proportionalWithdraw(150*WAD);

    //     ( uint256 totalReserves, uint256[] memory reserves ) = s.liquidity();

    //     uint256 endingShells = s.balanceOf(address(this));

    //     assertEq(reserves[0], 27531865585159300387);
    //     assertEq(reserves[1], 45052144);
    //     assertEq(reserves[2], 62572421);
    //     assertEq(reserves[3], 15017381228273464650);

    //     assertEq(startingShells - endingShells, 150e18);

    // }

    function test_s1_selectiveWithdraw_smartHalt_upper_outOfBounds_to_outOfBounds () public {

        bool success = super.smartHalt_upper_outOfBounds_to_outOfBounds();

        assertTrue(success);

    }

    function test_s1_selectiveWithdraw_smartHalt_upper_outOfBounds_to_inBounds () public {

        bool success = super.smartHalt_upper_outOfBounds_to_inBounds();

        assertTrue(success);

    }

    function test_s1_selectiveWithdraw_smartHalt_upper_unrelated () public {

        bool success = super.smartHalt_upper_unrelated();

        assertTrue(!success);

    }

    function test_s1_selectiveWithdraw_smartHalt_lower_outOfBounds_to_outOfBounds () public {

        bool success = super.smartHalt_lower_outOfBounds_to_outOfBounds();

        assertTrue(success);

    }

    function test_s1_selectiveWithdraw_smartHalt_lower_outOfBounds_to_inBounds () public {

        bool success = super.smartHalt_lower_outOfBounds_to_inBounds();

        assertTrue(success);

    }

    function test_s1_selectiveWithdraw_smartHalt_lower_outOfBounds_exacerbated () public {

        bool success = super.smartHalt_lower_outOfBounds_exacerbated();

        assertTrue(!success);

    }

}