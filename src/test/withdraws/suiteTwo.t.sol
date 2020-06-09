pragma solidity ^0.5.0;

import "ds-test/test.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

import "./withdrawTemplate.sol";

contract SelectiveWithdrawSuiteOne is SelectiveWithdrawTemplate, DSTest {

    function setUp() public {

        l = getLoihiSuiteOne();

    }

    function test_s2_selectiveWithdraw_balanced_10DAI_10USDC_10USDT_2p5SUSD_from_300Proportional () public {

        uint256 shellsBurned = super.balanced_10DAI_10USDC_10USDT_2p5SUSD_from_300Proportional();

        assertEq(shellsBurned, 32508125216729574694);

    }

    function test_s2_selectiveWithdraw_lightlyUnbalanced_5DAI_1USDC_3USDT_1SUSD_from_80DAI_100USDC_85USDT_35SUSD () public {

        uint256 shellsBurned = super.lightlyUnbalanced_5DAI_1USDC_3USDT_1SUSD_from_80DAI_100USDC_85USDT_35SUSD();

        assertEq(shellsBurned, 10002499999733097916);

    }

    function test_s2_selectiveWithdraw_partialLowerSlippage_balanced_5DAI_5USDC_47USDT_16SUSD_from_300Proportional () public {

        uint256 shellsBurned = super.partialLowerSlippage_balanced_5DAI_5USDC_47USDT_16SUSD_from_300Proportional();

        assertEq(shellsBurned, 73154345690075849040);

    }

    function test_s2_selectiveWithdraw_partialLowerSlippage_3DAI_60USDC_30USDT_1SUSD_from_80DAI_100USDC_100USDT_23SUSD () public {

        uint256 shellsBurned = super.partialLowerSlippage_3DAI_60USDC_30USDT_1SUSD_from_80DAI_100USDC_100USDT_23SUSD();

        assertEq(shellsBurned, 94102228495008790366);

    }

    function test_s2_selectiveWithdraw_partialUpperSlippage_balanced_0p001DAI_40USDC_40USDT_10SUSD_from_300Proportional () public {

        uint256 shellsBurned = super.partialUpperSlippage_balanced_0p001DAI_40USDC_40USDT_10SUSD_from_300Proportional();

        assertEq(shellsBurned, 90224422906045360592);

    }

    function test_s2_selectiveWithdraw_partialLowerIndirectAntiSlippage_40DAI_40USDT_from_95DAI_55USDC_95USDT_15SUSD () public {

        uint256 shellsBurned = super.partialLowerIndirectAntiSlippage_40DAI_40USDT_from_95DAI_55USDC_95USDT_15SUSD();

        assertEq(shellsBurned, 80001277060135043666);

    }

    function test_s2_selectiveWithdraw_partialLowerAntiSlippage_0p0001DAI_41USDC_41USDT_1SUSD_from_55DAI_95USDC_95USDT_15SUSD () public {

        uint256 shellsBurned = super.partialLowerAntiSlippage_0p0001DAI_41USDC_41USDT_1SUSD_from_55DAI_95USDC_95USDT_15SUSD();

        assertEq(shellsBurned, 83002127076568926436);

    }

    function test_s2_selectiveWithdraw_partialUpperAntiSlippage_50USDC_18SUSD_from_90DAI_145USDC_90USDT_50SUSD () public {

        uint256 shellsBurned = super.partialUpperAntiSlippage_50USDC_18SUSD_from_90DAI_145USDC_90USDT_50SUSD();

        assertEq(shellsBurned, 68008386735015754177);

    }

    function test_s2_selectiveWithdraw_partialUpperAntiSlippage_50CUSDC_18SUSD_from_90DAI_145USDC_90USDT_50SUSD () public {

        uint256 shellsBurned = super.partialUpperAntiSlippage_50CUSDC_18SUSD_from_90DAI_145USDC_90USDT_50SUSD();

        assertEq(shellsBurned, 67991384639438932784);

    }

    function test_s2_selectiveWithdraw_fullIndirectUpperSlippage_5DAI_5USDT_from90DAI_145USDC_90USDT_50SUSD () public {

        uint256 shellsBurned = super.fullIndirectUpperSlippage_5DAI_5USDT_from90DAI_145USDC_90USDT_50SUSD();

        assertEq(shellsBurned, 10072190169539376480);

    }

    function test_s2_selectiveWithdraw_fullUpperSlippage_8DAI_2USDC_8USDT_2SUSD_from_90DAI_145USDC_90USDT_50SUSD () public {

        uint256 shellsBurned = super.fullUpperSlippage_8DAI_2USDC_8USDT_2SUSD_from_90DAI_145USDC_90USDT_50SUSD();

        assertEq(shellsBurned, 20090545586275051778);

    }

    function test_s2_selectiveWithdraw_fullLowerSlippage_1USDC_7USDT_2SUSD_from_95DAI_95USDC_55USDT_15SUSD () public {

        uint256 shellsBurned = super.fullLowerSlippage_1USDC_7USDT_2SUSD_from_95DAI_95USDC_55USDT_15SUSD();

        assertEq(shellsBurned, 10134109814565570448);

    }

    function test_s2_selectiveWithdraw_fullIndirectLowerAntiSlippage_5CHAI_5CUSDC_from_95DAI_95USDC_55USDT_15SUSD () public {

        uint256 shellsBurned = super.fullIndirectLowerAntiSlippage_5CHAI_5CUSDC_from_95DAI_95USDC_55USDT_15SUSD();

        assertEq(shellsBurned, 9992948093387737702);

    }

    function test_s2_selectiveWithdraw_fullIndirectLowerAntiSlippage_5DAI_5USDC_from_95DAI_95USDC_55USDT_15SUSD () public {

        uint256 shellsBurned = super.fullIndirectLowerAntiSlippage_5DAI_5USDC_from_95DAI_95USDC_55USDT_15SUSD();

        assertEq(shellsBurned, 9995446955063918311);

    }

    function test_s2_selectiveWithdraw_fullLowerAntiSlippageWithdraw_5DAI_5USDC_0p5USDT_0p2SUSD_from_95DAI_95USDC_55USDT_15SUSD () public {

        uint256 shellsBurned = super.fullLowerAntiSlippageWithdraw_5DAI_5USDC_0p5USDT_0p2SUSD_from_95DAI_95USDC_55USDT_15SUSD();

        assertEq(shellsBurned, 10696820295674489134);

    }

    function test_s2_selectiveWithdraw_fullUpperAntiSlippage_5CDAI_2ASUSD_from_145DAI_90USDC_90USDT_50SUSD () public {

        uint256 shellsBurned = super.fullUpperAntiSlippage_5CDAI_2ASUSD_from_145DAI_90USDC_90USDT_50SUSD();

        assertEq(shellsBurned, 6994286984194756641);

    }

    function test_s2_selectiveWithdraw_fullUpperAntiSlippage_5DAI_2SUSD_from_145DAI_90USDC_90USDT_50SUSD () public {

        uint256 shellsBurned = super.fullUpperAntiSlippage_5DAI_2SUSD_from_145DAI_90USDC_90USDT_50SUSD();

        assertEq(shellsBurned, 6996035991529215020);

    }

    function test_s2_selectiveWithdraw_megaUpperToLower_95USDT_35SUSD_from_90DAI_90USDC_145USDT_50SUSD () public {

        uint256 shellsBurned = super.megaUpperToLower_95USDT_35SUSD_from_90DAI_90USDC_145USDT_50SUSD();

        assertEq(shellsBurned, 130071681773528500889);

    }

    function test_s2_selectiveWithdraw_megaIndirectLowerToUpper_11DAI_74USDC_74USDT_from_55DAI_95USDC_95USDT_15SUSD () public {

        uint256 shellsMinted = super.megaIndirectLowerToUpper_11DAI_74USDC_74USDT_from_55DAI_95USDC_95USDT_15SUSD();

        assertEq(shellsMinted, 159145489520065366756);

    }

    function test_s2_selectiveWithdraw_megaIndirectWithdrawLowerToUpper_11DAI_74USDC_74USDT_0p0001SDUSD_from_55DAI_95USDC_95USDT_15SUSD () public {

        uint256 shellsBurned = super.megaIndirectWithdrawLowerToUpper_11DAI_74USDC_74USDT_0p0001SDUSD_from_55DAI_95USDC_95USDT_15SUSD();

        assertEq(shellsBurned, 159145586630360938967);

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

    //     uint256 startingShells = l.deposit(
    //         address(dai), 80e18,
    //         address(usdc), 100e6,
    //         address(usdt), 85e6,
    //         address(susd), 35e18
    //     );

    //     l.proportionalWithdraw(150e18);

    //     ( uint256 totalReserves, uint256[] memory reserves ) = l.totalReserves();

    //     uint256 endingShells = l.balanceOf(address(this));

    //     assertEq(reserves[0], 39999999999959671960);
    //     assertEq(reserves[1], 50000000);
    //     assertEq(reserves[2], 42500000);
    //     assertEq(reserves[3], 17500000000000000000);
    //     assertEq(startingShells - endingShells, 150e18);

    // }

    // function testProportionalWithdraw_unbalanced () public {

    //     uint256 startingShells = l.deposit(
    //         address(dai), 55e18,
    //         address(usdc), 90e6,
    //         address(usdt), 125e6,
    //         address(susd), 30e18
    //     );

    //     l.proportionalWithdraw(150*WAD);

    //     ( uint256 totalReserves, uint256[] memory reserves ) = l.totalReserves();

    //     uint256 endingShells = l.balanceOf(address(this));

    //     assertEq(reserves[0], 27531865585159300387);
    //     assertEq(reserves[1], 45052144);
    //     assertEq(reserves[2], 62572421);
    //     assertEq(reserves[3], 15017381228273464650);

    //     assertEq(startingShells - endingShells, 150e18);

    // }

    function test_s2_selectiveWithdraw_smartHalt_outOfBounds_to_outOfBounds () public {

        bool success = super.smartHalt_upper_outOfBounds_to_outOfBounds();
        assertTrue(success);

    }

    function test_s2_selectiveWithdraw_smartHalt_outOfBounds_to_inBounds () public {

        bool success = super.smartHalt_upper_outOfBounds_to_inBounds();
        assertTrue(success);

    }
    
    function test_s2_selectiveWithdraw_smartHalt_lower_outOfBounds_to_outOfBounds () public {

        bool success = super.smartHalt_lower_outOfBounds_to_outOfBounds();

        assertTrue(success);

    }

    function test_s2_selectiveWithdraw_smartHalt_lower_outOfBounds_to_inBounds () public {

        bool success = super.smartHalt_lower_outOfBounds_to_inBounds();

        assertTrue(success);

    }

}