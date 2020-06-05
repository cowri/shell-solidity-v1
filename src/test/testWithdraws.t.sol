pragma solidity ^0.5.0;

import "ds-test/test.sol";
import "ds-math/math.sol";

import "./setup/setup.sol";

import "./setup/methods.sol";

import "../interfaces/IAssimilator.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

contract SelectiveWithdrawTest is Setup, DSMath, DSTest {

    using ABDKMath64x64 for uint;
    using ABDKMath64x64 for int128;

    using LoihiMethods for Loihi;

    Loihi l;

    function setUp() public {

        l = getLoihiSuiteOne();

    }

    function testSelectiveWithdraw_balanced_10DAI_10USDC_10USDT_2p5SUSD_from_300Proportional () public {

        uint256 startingShells = l.proportionalDeposit(300e18);

        uint256 shellsBurned = l.withdraw(
            address(dai), 10e18,
            address(usdc), 10e6,
            address(usdt), 10e6,
            address(susd), 2.5e18
        );

        assertEq(shellsBurned, 32508125216729574694);

    }

    function testSelectiveWithdraw_lightlyUnbalanced_5DAI_1USDC_3USDT_1SUSD_from_80DAI_100USDC_85USDT_35SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 80e18,
            address(usdc), 100e6,
            address(usdt), 85e6,
            address(susd), 35e18
        );

        uint256 shellsBurned = l.withdraw(
            address(dai), 5e18,
            address(usdc), 1e6,
            address(usdt), 3e6,
            address(susd), 1e18
        );

        assertEq(shellsBurned, 10002499999733097916);

    }

    function testSelectiveWithdraw_partialLowerSlippage_balanced_5DAI_5USDC_47USDT_16SUSD_from_300Proportional () public {

        uint256 startingShells = l.proportionalDeposit(300e18);

        uint256 shellsBurned = l.withdraw(
            address(dai), 5e18,
            address(usdc), 5e6,
            address(usdt), 47e6,
            address(susd), 16e18
        );

        assertEq(shellsBurned, 73154345690075849040);

    }

    function testSelectiveWithdraw_partialLowerSlippage_3DAI_60USDC_30USDT_1SUSD_from_80DAI_100USDC_100USDT_23SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 80e18,
            address(usdc), 100e6,
            address(usdt), 100e6,
            address(susd), 23e18
        );

        uint256 shellsBurned = l.withdraw(
            address(dai), 3e18,
            address(usdc), 60e6,
            address(usdt), 30e6,
            address(susd), 1e18
        );

        assertEq(shellsBurned, 94102228495008790366);

    }

    function testSelectiveWithdraw_partialUpperSlippage_balanced_0p001DAI_40USDC_40USDT_10SUSD_from_300Proportional () public {

        uint256 startingShells = l.proportionalDeposit(300e18);

        uint256 shellsBurned = l.withdraw(
            address(dai), 0.001e18,
            address(usdc), 40e6,
            address(usdt), 40e6,
            address(susd), 10e18
        );

        assertEq(shellsBurned, 90224422906045360592);

    }

    function testSelectiveWithdraw_partialLowerIndirectAntiSlippage_40DAI_40USDT_from_95DAI_55USDC_95USDT_15SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 95e18,
            address(usdc), 55e6,
            address(usdt), 95e6,
            address(susd), 15e18
        );

        uint256 shellsBurned = l.withdraw(
            address(dai), 40e18,
            address(usdt), 40e6
        );

        assertEq(shellsBurned, 80001277060135043666);

    }

    function testSelectiveWithdraw_partialLowerAntiSlippage_0p0001DAI_41USDC_41USDT_1SUSD_from_55DAI_95USDC_95USDT_15SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 55e18,
            address(usdc), 95e6,
            address(usdt), 95e6,
            address(susd), 15e18
        );

        uint256 shellsBurned = l.withdraw(
            address(dai), 0.0001e18,
            address(usdc), 41e6,
            address(usdt), 41e6,
            address(susd), 1e18
        );

        assertEq(shellsBurned, 83002127076568926436);

    }

    function testSelectiveWithdraw_partialUpperAntiSlippage_50USDC_18SUSD_from_90DAI_145USDC_90USDT_50SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 90e18,
            address(usdc), 145e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );

        uint256 shellsBurned = l.withdraw(
            address(usdc), 50e6,
            address(susd), 18e18
        );

        assertEq(shellsBurned, 68008386735015754177);

    }

    function testSelectiveWithdraw_partialUpperAntiSlippage_50CUSDC_18SUSD_from_90DAI_145USDC_90USDT_50SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 90e18,
            address(usdc), 145e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );

        uint256 cusdcOf50Numeraires = IAssimilator(cusdcAssimilator).viewRawAmount(uint(50e18).divu(1e18));

        uint256 shellsBurned = l.withdraw(
            address(cusdc), cusdcOf50Numeraires,
            address(susd), 18e18
        );

        assertEq(shellsBurned, 67991384639438932784);

    }

    function testSelectiveWithdraw_fullIndirectUpperSlippage_5DAI_5USDT_from90DAI_145USDC_90USDT_50SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 90e18,
            address(usdc), 145e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );

        uint256 shellsBurned = l.withdraw(
            address(dai), 5e18,
            address(usdt), 5e6
        );

        assertEq(shellsBurned, 10072190169539376480);

    }

    function testSelectiveWithdraw_fullUpperSlippage_8DAI_2USDC_8USDT_2SUSD_from_90DAI_145USDC_90USDT_50SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 90e18,
            address(usdc), 145e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );

        uint256 shellsBurned = l.withdraw(
            address(dai), 8e18,
            address(usdc), 2e6,
            address(usdt), 8e6,
            address(susd), 2e18
        );

        assertEq(shellsBurned, 20090545586275051778);

    }

    function testSelectiveWithdraw_fullLowerSlippage_1USDC_7USDT_2SUSD_from_95DAI_95USDC_55USDT_15SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 95e18,
            address(usdc), 95e6,
            address(usdt), 55e6,
            address(susd), 15e18
        );

        uint256 shellsBurned = l.withdraw(
            address(usdc), 1e6,
            address(usdt), 7e6,
            address(susd), 2e18
        );

        assertEq(shellsBurned, 10134109814565570448);

    }

    function testSelectiveWithdraw_fullIndirectLowerAntiSlippage_5CHAI_5CUSDC_from_95DAI_95USDC_55USDT_15SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 95e18,
            address(usdc), 95e6,
            address(usdt), 55e6,
            address(susd), 15e18
        );

        uint256 chaiOf5Numeraire = IAssimilator(chaiAssimilator).viewRawAmount(uint(5e18).divu(1e18));
        uint256 cusdcOf5Numeraire = IAssimilator(cusdcAssimilator).viewRawAmount(uint(5e18).divu(1e18));

        uint256 shellsBurned = l.withdraw(
            address(chai), chaiOf5Numeraire,
            address(cusdc), cusdcOf5Numeraire
        );

        assertEq(shellsBurned, 9992948093387737702);

    }

    function testSelectiveWithdraw_fullIndirectLowerAntiSlippage_5DAI_5USDC_from_95DAI_95USDC_55USDT_15SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 95e18,
            address(usdc), 95e6,
            address(usdt), 55e6,
            address(susd), 15e18
        );

        uint256 shellsBurned = l.withdraw(
            address(dai), 5e18,
            address(usdc), 5e6
        );

        assertEq(shellsBurned, 9995446955063918311);

    }

    function testSelectiveWithdraw_fullLowerAntiSlippageWithdraw_5DAI_5USDC_0p5USDT_0p2SUSD_from_95DAI_95USDC_55USDT_15SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 95e18,
            address(usdc), 95e6,
            address(usdt), 55e6,
            address(susd), 15e18
        );

        uint256 shellsBurned = l.withdraw(
            address(dai), 5e18,
            address(usdc), 5e6,
            address(usdt), 0.5e6,
            address(susd), 0.2e18
        );

        assertEq(shellsBurned, 10696820295674489134);

    }

    function testSelectiveWithdraw_fullUpperAntiSlippage_5CDAI_2ASUSD_from_145DAI_90USDC_90USDT_50SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 145e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );

        uint256 cdaiOf5Numeraires = IAssimilator(cdaiAssimilator).viewRawAmount(uint(5e18).divu(1e18));

        uint256 shellsBurned = l.withdraw(
            address(cdai), cdaiOf5Numeraires,
            address(asusd), 2e18
        );

        assertEq(shellsBurned, 6994286984194756641);

    }

    function testSelectiveWithdraw_fullUpperAntiSlippage_5DAI_2SUSD_from_145DAI_90USDC_90USDT_50SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 145e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );

        uint256 shellsBurned = l.withdraw(
            address(dai), 5e18,
            address(susd), 2e18
        );

        assertEq(shellsBurned, 6996035991529215020);

    }

    function testSelectiveWithdraw_megaUpperToLower_95USDT_35SUSD_from_90DAI_90USDC_145USDT_50SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 90e18,
            address(usdc), 90e6,
            address(usdt), 145e6,
            address(susd), 50e18
        );

        uint256 shellsBurned = l.withdraw(
            address(usdt), 95e6,
            address(susd), 35e18
        );

        assertEq(shellsBurned, 130071681773528500889);

    }

    function testSelectiveWithdraw_megaIndirectLowerToUpper_11DAI_74USDC_74USDT_from_55DAI_95USDC_95USDT_15SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 55e18,
            address(usdc), 95e6,
            address(usdt), 95e6,
            address(susd), 15e18
        );

        uint256 shellsMinted = l.withdraw(
            address(dai), 11e18,
            address(usdc), 74e6,
            address(usdt), 74e6
        );

        assertEq(shellsMinted, 159145489520065366756);

    }

    function testSelectiveWithdraw_megaIndirectWithdrawLowerToUpper_11DAI_74USDC_74USDT_0p0001SDUSD_from_55DAI_95USDC_95USDT_15SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 55e18,
            address(usdc), 95e6,
            address(usdt), 95e6,
            address(susd), 15e18
        );

        uint256 shellsBurned = l.withdraw(
            address(dai), 11e18,
            address(usdc), 74e6,
            address(usdt), 74e6,
            address(susd), 0.0001e18
        );

        assertEq(shellsBurned, 159145586630360938967);

    }

    function testFailSelectiveWithdraw_upperHaltCheck30Pct () public {

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

    function testFailSelectiveWithdraw_lowerHaltCheck30Pct () public {

        l.deposit(
            address(dai), 90e18,
            address(usdc), 90e6,
            address(usdt), 65e6,
            address(susd), 30e18
        );

        l.withdraw(address(usdt), 50e6);

    }

    function testFailSelectiveWithdraw_upperHaltCheck10Pct () public {

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

    function testFailSelectiveWithdraw_lowerHaltCheck10Pct () public {

        l.deposit(
            address(dai), 90e18,
            address(usdc), 90e6,
            address(usdt), 80e6,
            address(susd), 40e18
        );

        l.withdraw(address(susd), 30e18);

    }

    function testProportionalWithdraw_mediumUnbalance () public {

        uint256 startingShells = l.deposit(
            address(dai), 80e18,
            address(usdc), 100e6,
            address(usdt), 85e6,
            address(susd), 35e18
        );

        l.proportionalWithdraw(150e18);

        ( uint256 totalReserves, uint256[] memory reserves ) = l.totalReserves();

        uint256 endingShells = l.balanceOf(address(this));

        assertEq(reserves[0], 39999999999959671960);
        assertEq(reserves[1], 50000000);
        assertEq(reserves[2], 42500000);
        assertEq(reserves[3], 17500000000000000000);
        assertEq(startingShells - endingShells, 150e18);

    }

    function testProportionalWithdraw_unbalanced () public {

        uint256 startingShells = l.deposit(
            address(dai), 55e18,
            address(usdc), 90e6,
            address(usdt), 125e6,
            address(susd), 30e18
        );

        l.proportionalWithdraw(150*WAD);

        ( uint256 totalReserves, uint256[] memory reserves ) = l.totalReserves();

        uint256 endingShells = l.balanceOf(address(this));

        assertEq(reserves[0], 27531865585159300387);
        assertEq(reserves[1], 45052144);
        assertEq(reserves[2], 62572421);
        assertEq(reserves[3], 15017381228273464650);

        assertEq(startingShells - endingShells, 150e18);

    }

    // function testSelectiveWithdraw_excess () public {

    //     l.proportionalDeposit(300e18);

    //     usdc.transfer(address(l), 110e6);

    //     bool success = l.withdrawSuccess(address(usdc), 1e6);

    //     assertTrue(success);

    // }

    // function testSelectiveWithdraw_excess_to_within_halt () public {

    //     l.proportionalDeposit(300e18);

    //     usdc.transfer(address(l), 110e6);

    //     bool success = l.withdrawSuccess(address(usdc), 100e6);

    //     assertTrue(success);

    // }

}