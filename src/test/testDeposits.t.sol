pragma solidity ^0.5.0;

import "ds-test/test.sol";
import "ds-math/math.sol";

import "./setup/setup.sol";

import "./setup/methods.sol";

import "../interfaces/IAssimilator.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

contract SelectiveDepositTest is Setup, DSMath, DSTest {

    using ABDKMath64x64 for uint;
    using ABDKMath64x64 for int128;

    using LoihiMethods for Loihi;

    Loihi l;

    function setUp() public {

        start();

        l = getLoihiSuiteOne();

    }

    event log_named_uints(bytes32, uint256[]);

    function testSelectiveDeposit_noSlippage_balanced_10DAI_10USDC_10USDT_2p5SUSD () public {

        uint256 startingShells = l.proportionalDeposit(300e18);

        ( uint256 startingReserves, ) = l.totalReserves();

        uint256 newShells = l.deposit(
            address(dai), 10e18,
            address(usdc), 10e6,
            address(usdt), 10e6,
            address(susd), 2.5e18
        );

        emit log_named_uint("starting reserves", startingReserves);
        emit log_named_uint("starting shells", startingShells);

        assertEq(newShells, 32483751922977906373);

    }

    function testSelectiveDeposit_balanced_5DAI_1USDC3_USDT_1SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 80e18,
            address(usdc), 100e6,
            address(usdt), 85e6,
            address(susd), 35e18
        );

        ( uint256 startingReserves, ) = l.totalReserves();

        uint256 newShells = l.deposit(
            address(dai), 5e18,
            address(usdc), 1e6,
            address(usdt), 3e6,
            address(susd), 1e18
        );

        emit log_named_uint("starting reserves", startingReserves);
        emit log_named_uint("starting shells", startingShells);

        assertEq(newShells, 9995000591686018553);

    }

    function testSelectiveDeposit_partialUpperSlippage_145DAI_90USDC_90USDT_50SUSD () public {

        uint256 newShells = l.deposit(
            address(dai), 145e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );

        assertEq(newShells, 374863205208333333331);

    }

    function testSelectiveDeposit_partialLowerSlippage_95DAI_55USDC_95USDT_15SUSD () public {

        uint256 newShells = l.deposit(
            address(dai), 95e18,
            address(usdc), 55e6,
            address(usdt), 95e6,
            address(susd), 15e18
        );

        assertEq(newShells, 259841433653846153849);

    }

    function testSelectiveDeposit_partialUpperSlippage_5DAI_5USDC_70USDT_28SUSD_300Proportional () public {

        uint256 startingShells = l.proportionalDeposit(300e18);

        ( uint256 startingReserves, ) = l.totalReserves();


        uint256 newShells = l.deposit(
            address(dai), 5e18,
            address(usdc), 5e6,
            address(usdt), 70e6,
            address(susd), 28e18
        );

        emit log_named_uint("starting reserves", startingReserves);
        emit log_named_uint("starting shells", startingShells);

        assertEq(newShells, 107785955736099867653);

    }

    function testSelectiveDeposit_partialLowerSlippage_moderatelyUnbalanced_1DAI_51USDC_51USDT_1SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 80e18,
            address(usdc), 100e6,
            address(usdt), 100e6,
            address(susd), 23e18
        );

        ( uint256 startingReserves, ) = l.totalReserves();

        uint256 newShells = l.deposit(
            address(dai), 1e18,
            address(usdc), 51e6,
            address(usdt), 51e6,
            address(susd), 1e18
        );

        emit log_named_uint("starting reserves", startingReserves);
        emit log_named_uint("staring shells", startingShells);

        assertEq(newShells, 103751906449728113092);

    }

    function testSelectiveDeposit_partialLowerSlippage_balanced_0p001DAI_90USDC_90USDT () logs_gas public {

        uint256 startingShells = l.proportionalDeposit(300e18);

        ( uint256 startingReserves, ) = l.totalReserves();

        uint256 newShells = l.deposit(
            address(dai), .001e18,
            address(usdc), 90e6,
            address(usdt), 90e6
        );

        emit log_named_uint("starting reserves", startingReserves);
        emit log_named_uint("starting shells", startingShells);

        assertEq(newShells, 179611178241247451581);

    }

    function testSelectiveDeposit_partialUpperAntiSlippage_46USDC_53USDT_into_145DAI_90USDC_90USDT_50SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 145e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );

        ( uint256 startingReserves, ) = l.totalReserves();

        uint256 newShells = l.deposit(
            address(usdc), 46e6,
            address(usdt), 53e6
        );

        emit log_named_uint("starting reserves", startingReserves);
        emit log_named_uint("startingShells", startingShells);

        assertEq(newShells, 98959112727321870543);

    }

    function testSelectiveDeposit_partialUpperAntiSlippage_unbalanced_1DAI_46USDC_53USDT_1SUSD_into_145DAI_90USDC_90USDT_50SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 145e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );

        ( uint256 startingReserves, ) = l.totalReserves();

        uint256 newShells = l.deposit(
            address(dai), 1e18,
            address(usdc), 46e6,
            address(usdt), 53e6,
            address(susd), 1e18
        );

        emit log_named_uint("starting reserves", startingReserves);
        emit log_named_uint("starting shells", startingShells);

        assertEq(newShells, 100958112846963763183);

    }

    function testSelectiveDeposit_noSlippage_36CHAI_into_300Proportional () public {

        uint256 startingShells = l.proportionalDeposit(300e18);

        ( uint256 startingReserves, ) = l.totalReserves();

        uint256 _chaiOf36Numeraire = chaiAssimilator.viewRawAmount(uint(36e18).divu(1e18));

        uint256 shellsMinted = l.deposit(address(chai), _chaiOf36Numeraire);

        emit log_named_uint("starting reserves", startingReserves);
        emit log_named_uint("starting shells", startingShells);

        assertEq(shellsMinted, 35991000233367100000);

    }

    function testSelectiveDeposit_partialLowerAntiSlippage_36CUSDC_18ASUSD_into_95DAI_55USDC_95USDT_15SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 95e18,
            address(usdc), 55e6,
            address(usdt), 95e6,
            address(susd), 15e18
        );

        ( uint256 startingReserves, ) = l.totalReserves();

        uint256 cusdcOf36Numeraire = cusdcAssimilator.viewRawAmount(uint(36e18).divu(1e18));
        uint256 asusdOf18Numeraire = asusdAssimilator.viewRawAmount(uint(18e18).divu(1e18));

        uint256 newShells = l.deposit(
            address(cusdc), cusdcOf36Numeraire,
            address(asusd), asusdOf18Numeraire
        );

        emit log_named_uint("starting reserves", startingReserves);
        emit log_named_uint("starting shells", startingShells);

        assertEq(newShells,  53991711756245652892);

    }

    function testSelectiveDeposit_partialLowerAntiSlippage_36USDC_18SUSD_into_95DAI_55USDC_95USDT_15SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 95e18,
            address(usdc), 55e6,
            address(usdt), 95e6,
            address(susd), 15e18
        );
        
        ( uint256 startingReserves, ) = l.totalReserves();

        uint256 newShells = l.deposit(
            address(usdc), 36e6,
            address(susd), 18e18
        );

        emit log_named_uint("starting reserves", startingReserves);
        emit log_named_uint("starting shells", startingShells);

        assertEq(newShells, 53991711756245652893);

    }

    function testSelectiveDeposit_fullUpperSlippage_5USDC_3SUSD_into_90DAI_145USDC_90USDT_50SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 90e18,
            address(usdc), 145e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );

        ( uint256 startingReserves, ) = l.totalReserves();

        uint256 newShells = l.deposit(
            address(usdc), 5e6,
            address(susd), 3e18
        );

        emit log_named_uint("starting reserves", startingReserves);
        emit log_named_uint("starting shells", startingShells);

        assertEq(newShells, 7935137412354349862);

    }

    function testSelectiveDeposit_fullLowerSlippage_12DAI_12USDC_1USDT_1SUSD_into_95DAI_95USDC_55USDT_15SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 95e18,
            address(usdc), 95e6,
            address(usdt), 55e6,
            address(susd), 15e18
        );

        ( uint256 startingReserves, ) = l.totalReserves();

        uint256 newShells = l.deposit(
            address(dai), 12e18,
            address(usdc), 12e6,
            address(usdt), 1e6,
            address(susd), 1e18
        );

        emit log_named_uint("starting reserves", startingReserves);
        emit log_named_uint("starting shells", startingShells);

        assertEq(newShells, 25895520576151595834);

    }

    function testSelectiveDeposit_fullLowerSlippage_9DAI_9USDC_into_95DAI_95USDC_55USDT_15SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 95e18,
            address(usdc), 95e6,
            address(usdt), 55e6,
            address(susd), 15e18
        );

        ( uint256 startingReserves, ) = l.totalReserves();

        uint256 newShells = l.deposit(
            address(dai), 9e18,
            address(usdc), 9e6
        );

        emit log_named_uint("starting reserves", startingReserves);
        emit log_named_uint("starting shells", startingShells);

        assertEq(newShells, 17893188953689663008);

    }

    function testSelectiveDeposit_fullUpperAntiSlippage_5CHAI_5USDC_into_90DAI_90USDC_145USDT_50SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 90e18,
            address(usdc), 90e6,
            address(usdt), 145e6,
            address(susd), 50e18
        );
        
        ( uint256 startingReserves, ) = l.totalReserves();


        uint256 chaiOf5Numeraire = chaiAssimilator.viewRawAmount(uint(5e18).divu(1e18));
        uint256 cusdcOf5Numeraire = cusdcAssimilator.viewRawAmount(uint(5e18).divu(1e18));

        uint256 newShells = l.deposit(
            address(chai), chaiOf5Numeraire,
            address(cusdc), cusdcOf5Numeraire
        );

        emit log_named_uint("starting reserves", startingReserves);
        emit log_named_uint("starting shells", startingShells);

        assertEq(newShells, 10001714411049177790);

    }

    function testSelectiveDeposit_fullUpperAntiSlippage_5DAI_5USDC_into_90DAI_90USDC_145USDT_50SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 90e18,
            address(usdc), 90e6,
            address(usdt), 145e6,
            address(susd), 50e18
        );

        ( uint256 startingReserves, ) = l.totalReserves();

        uint256 newShells = l.deposit(
            address(dai), 5e18,
            address(usdc), 5e6
        );

        emit log_named_uint("starting reserves", startingReserves);
        emit log_named_uint("starting shells", startingShells);

        assertEq(newShells, 10001714411049177791);

    }

    function testSelectiveDeposit_fullUpperAntiSlippage_8DAI_12USDC_10USDT_2SUSD_into_145DAI_90USDC_90USDT_50SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 145e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );
        
        ( uint256 startingReserves, ) = l.totalReserves();

        uint256 newShells = l.deposit(
            address(dai), 8e18,
            address(usdc), 12e6,
            address(usdt), 10e6,
            address(susd), 2e18
        );

        emit log_named_uint("starting reserves", startingReserves);
        emit log_named_uint("starting shells", startingShells);

        assertEq(newShells, 31991964078802255779);

    }

    function testSelectiveDeposit_fullLowerAntiSlippage_5DAI_5USDC_5USDT_2SUSD_into_55DAI_95USDC_95USDT_15SUSD  () public {

        uint256 startingShells = l.deposit(
            address(dai), 55e18,
            address(usdc), 95e6,
            address(usdt), 95e6,
            address(susd), 15e18
        );
        
        ( uint256 startingReserves, ) = l.totalReserves();


        uint256 newShells = l.deposit(
            address(dai), 5e18,
            address(usdc), 5e6,
            address(usdt), 5e6,
            address(susd), 2e18
        );

        emit log_named_uint("starting reserves", startingReserves);
        emit log_named_uint("starting shells", startingShells);

        assertEq(newShells, 16998625195108995468);

    }

    function testSelectiveDeposit_noSlippage_36CDAI_into_300Proportional () public {

        uint256 startingShells = l.proportionalDeposit(300e18);

        ( uint256 startingReserves, ) = l.totalReserves();

        uint256 cdaiOf36Numeraire = cdaiAssimilator.viewRawAmount(uint(36e18).divu(1e18));

        uint256 shellsMinted = l.deposit(address(cdai), cdaiOf36Numeraire);

        emit log_named_uint("starting reserves", startingReserves);
        emit log_named_uint("starting shells", startingShells);

        assertEq(shellsMinted, 35991000239800010000);

    }

    function testSelectiveDeposit_noSlippage_36DAI_from_300Proportional () public {

        uint256 startingShells = l.proportionalDeposit(300e18);

        ( uint256 startingReserves, ) = l.totalReserves();

        uint256 shellsMinted = l.deposit(address(dai), 36e18);

        emit log_named_uint("starting reserves", startingReserves);
        emit log_named_uint("starting shells", startingShells);

        assertEq(shellsMinted, 35982002130067834752);

    }

    function testSelectiveDeposit_upperSlippage_36Point001Dai_into_300Proportional () public {

        uint256 startingShells = l.proportionalDeposit(300e18);

        ( uint256 startingReserves, ) = l.totalReserves();

        uint256 shellsMinted = l.deposit(address(dai), 36.001e18);

        emit log_named_uint("starting reserves", startingReserves);
        emit log_named_uint("starting shells", startingShells);

        assertEq(shellsMinted, 35982102080069924643);

    }

    function testSelectiveDeposit_megaDepositDirectLowerToUpper_105DAI_37SUSD_from_55DAI_95USDC_95USDT_15SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 55e18,
            address(usdc), 95e6,
            address(usdt), 95e6,
            address(susd), 15e18
        );

        ( uint256 startingReserves, ) = l.totalReserves();

        uint256 newShells = l.deposit(
            address(dai), 105e18,
            address(susd), 37e18
        );

        emit log_named_uint("starting reserves", startingReserves);
        emit log_named_uint("starting shells", startingShells);

        assertEq(newShells, 141932012220330711758);

    }

    function testSelectiveDeposit_megaDepositIndirectUpperToLower_165DAI_165USDT_into_90DAI_145USDC_90USDT_50SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 90e18,
            address(usdc), 145e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );

        ( uint256 startingReserves, ) = l.totalReserves();

        uint256 newShells = l.deposit(
            address(dai), 165e18,
            address(usdt), 165e6
        );

        emit log_named_uint("starting reserves", startingReserves);
        emit log_named_uint("starting shells", startingShells);

        assertEq(newShells, 329778606762192660838);

    }

    function testSelectiveDeposit_megaDepositIndirectUpperLower_165CDAI_0p0001CUSDC_165USDT_0p5SUSD_into_90DAI_145USDC_90USDT_50SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 90e18,
            address(usdc), 145e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );

        ( uint256 startingReserves, ) = l.totalReserves();

        uint256 cdaiOf165Numeraire = cdaiAssimilator.viewRawAmount(uint(165e18).divu(1e18));
        uint256 cusdcOf0Point0001Numeraire = cusdcAssimilator.viewRawAmount(uint(0.0001e6).divu(1e6));

        uint256 newShells = l.deposit(
            address(cdai), cdaiOf165Numeraire,
            address(cusdc), cusdcOf0Point0001Numeraire,
            address(usdt), 165e6,
            address(susd), 5e18
        );

        emit log_named_uint("starting reserves", startingReserves);
        emit log_named_uint("starting shells", startingShells);

        assertEq(newShells, 33028053905716828894);

    }

    function testSelectiveDeposit_megaDepositIndirectUpperToLower_165DAI_0p0001USDC_165USDT_0p5SUSD_from_90DAI_145USDC_90USDT_50SUSD () public {

        uint256 startingShells = l.deposit(
            address(dai), 90e18,
            address(usdc), 145e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );

        
        ( uint256 startingReserves, ) = l.totalReserves();

        uint256 newShells = l.deposit(
            address(dai), 165e18,
            address(usdc), 0.0001e6,
            address(usdt), 165e6,
            address(susd), .5e18
        );

        emit log_named_uint("starting reserves", startingReserves);
        emit log_named_uint("starting shells", startingShells);

        assertEq(newShells, 330280539057168288940);

    }

    function testFailSelectiveDepositUpperHaltCheck30Pct () public {

        l.proportionalDeposit(300e18);

        l.deposit(address(dai), 100e18);

    }

    function testFailSelectiveDepositLowerHaltCheck30Pct () public {

        l.proportionalDeposit(300e18);

        l.deposit(
            address(dai), 300e18,
            address(usdt), 300e6,
            address(susd), 100e18
        );

    }

    function testFailSelectiveDepositDepostUpperHaltCheck10Pct () public {

        l.proportionalDeposit(300e18);

        l.deposit(address(susd), 500e18);

    }

    function testFailSelectiveDepositLowerHaltCheck10Pct () public {

        l.proportionalDeposit(300e18);

        l.deposit(
            address(dai), 200e18,
            address(usdc), 200e6,
            address(usdt), 200e6
        );

    }

    // function testExecuteProportionalDepositIntoAnUnbalancedShell () public {

    //     uint256 startingShells = l.deposit(
    //         address(dai), 90e18,
    //         address(usdc), 90e6,
    //         address(usdt), 140e6,
    //         address(susd), 50e18
    //     );

    //     uint256 daiBalBefore = daiAssimilator.viewNumeraireBalance(address(l));
    //     uint256 usdcBalBefore = usdcAssimilator.viewNumeraireBalance(address(l));
    //     uint256 usdtBalBefore = usdtAssimilator.viewNumeraireBalance(address(l));
    //     uint256 susdBalBefore = susdAssimilator.viewNumeraireBalance(address(l));

    //     uint256 newShells = l.proportionalDeposit(90e18);

    //     uint256 daiBalAfter = daiAssimilator.viewNumeraireBalance(address(l));
    //     uint256 usdcBalAfter = usdcAssimilator.viewNumeraireBalance(address(l));
    //     uint256 usdtBalAfter = usdtAssimilator.viewNumeraireBalance(address(l));
    //     uint256 susdBalAfter = susdAssimilator.viewNumeraireBalance(address(l));

    //     assertEq(daiBalAfter - daiBalBefore, 21891891950913103706);
    //     assertEq(usdcBalAfter - usdcBalBefore, 21891891000000000000);
    //     assertEq(usdtBalAfter - usdtBalBefore, 34054054000000000000);
    //     assertEq(susdBalAfter - susdBalBefore, 12162162195035371650);
    //     assertEq(newShells, 89945423371167329200);

    //     emit log_named_uint("starting shells", startingShells);

    // }

    // function testExecuteProportionalDepositIntoSlightlyUnbalancedShell () public {

    //     uint256 startingShells = l.deposit(
    //         address(dai), 100e18,
    //         address(usdc), 90e6,
    //         address(usdt), 80e6,
    //         address(susd), 30e18
    //     );

    //     uint256 daiBalBefore = daiAssimilator.viewNumeraireBalance(address(l));
    //     uint256 usdcBalBefore = usdcAssimilator.viewNumeraireBalance(address(l));
    //     uint256 usdtBalBefore = usdtAssimilator.viewNumeraireBalance(address(l));
    //     uint256 susdBalBefore = susdAssimilator.viewNumeraireBalance(address(l));

    //     uint256 shellsMinted = l.proportionalDeposit(90*WAD);

    //     uint256 daiBalAfter = daiAssimilator.viewNumeraireBalance(address(l));
    //     uint256 usdcBalAfter = usdcAssimilator.viewNumeraireBalance(address(l));
    //     uint256 usdtBalAfter = usdtAssimilator.viewNumeraireBalance(address(l));
    //     uint256 susdBalAfter = susdAssimilator.viewNumeraireBalance(address(l));

    //     assertEq(daiBalAfter - daiBalBefore, 29999999900039235636);
    //     assertEq(usdcBalAfter - usdcBalBefore, 27000000000000000000);
    //     assertEq(usdtBalAfter - usdtBalBefore, 23999999000000000000);
    //     assertEq(susdBalAfter - susdBalBefore, 8999999970001503300);
    //     assertEq(shellsMinted, 89955005924860299279);

    //     emit log_named_uint("starting shells", startingShells);

    // }

    // function testExecuteProportionalDepositIntoWidelyUnbalancedShell () public {

    //     uint256 startingShells = l.deposit(
    //         address(dai), 90e18,
    //         address(usdc), 125e6,
    //         address(usdt), 55e6,
    //         address(susd), 30e18
    //     );

    //     uint256 daiBalBefore = daiAssimilator.viewNumeraireBalance(address(l));
    //     uint256 usdcBalBefore = usdcAssimilator.viewNumeraireBalance(address(l));
    //     uint256 usdtBalBefore = usdtAssimilator.viewNumeraireBalance(address(l));
    //     uint256 susdBalBefore = susdAssimilator.viewNumeraireBalance(address(l));

    //     uint256 shellsMinted = l.proportionalDeposit(90*WAD);

    //     uint256 daiBalAfter = daiAssimilator.viewNumeraireBalance(address(l));
    //     uint256 usdcBalAfter = usdcAssimilator.viewNumeraireBalance(address(l));
    //     uint256 usdtBalAfter = usdtAssimilator.viewNumeraireBalance(address(l));
    //     uint256 susdBalAfter = susdAssimilator.viewNumeraireBalance(address(l));

    //     assertEq(daiBalAfter - daiBalBefore, 27000000089910320148);
    //     assertEq(usdcBalAfter - usdcBalBefore, 37499999000000000000);
    //     assertEq(usdtBalAfter - usdtBalBefore, 16500000000000000000);
    //     assertEq(susdBalAfter - susdBalBefore, 9000000030002282550);
    //     assertEq(shellsMinted, 89850891334682007814);

    //     emit log_named_uint("starting shells", startingShells);

    // }
}