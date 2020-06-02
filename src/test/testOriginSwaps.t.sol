
pragma solidity ^0.5.0;

import "ds-test/test.sol";
import "ds-math/math.sol";

import "./setup/setup.sol";

import "./setup/methods.sol";

import "../interfaces/IAssimilator.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

contract OriginSwapTest is Setup, DSMath, DSTest {

    using ABDKMath64x64 for uint;
    using ABDKMath64x64 for int128;

    using LoihiMethods for Loihi;

    Loihi l;

    function setUp() public {

        start();

        l = getALoihi();

    }

    function testOriginSwap_noSlippage_balanced_10DAI_to_USDC_300Proportional () public {

        l.proportionalDeposit(300e18);

        uint256 targetAmount = l.originSwap(
            address(dai),
            address(usdc),
            10e18
        );

        assertEq(targetAmount, 9995000);

    }

    function testOriginSwap_noSlippage_lightlyUnbalanced_10USDC_to_USDT_with_80DAI_100USDC_85USDT_35SUSD () public {

        l.deposit(
            address(dai), 80e18,
            address(usdc), 100e6,
            address(usdt), 85e6,
            address(susd), 35e18
        );

        uint256 targetAmount = l.originSwap(
            address(usdc),
            address(usdt),
            10e6
        );

        assertEq(targetAmount, 9995000);

    }

    function testOriginSwap_noSlippage_balanced_10PctWeight_to_30PctWeight () public {

        l.proportionalDeposit(300e18);

        uint256 targetAmount = l.originSwap(
            address(susd),
            address(usdt),
            4e18
        );

        assertEq(targetAmount, 3998000);

    }

    function testOriginSwap_partialUpperAndLowerSlippage_unbalanced_10PctWeight_to_30PctWeight () public {

        l.deposit(
            address(dai), 65e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 30e18
        );

        uint256 targetAmount = l.originSwap(
            address(susd),
            address(dai),
            8e18
        );

        assertEq(targetAmount, 7920411672881948283);

    }

    function testOriginSwap_noSlippage_balanced_30PctWeight_to_30PctWeight () public {

        l.proportionalDeposit(300e18);

        uint256 targetAmount = l.originSwap(
            address(dai),
            address(usdc),
            10e18
        );

        assertEq(targetAmount, 9995000);

    }

    function testOriginSwap_noSlippage_lightlyUnbalanced_30PctWeight_to_10PctWeight () public {

        l.deposit(
            address(dai), 80e18,
            address(usdc), 80e6,
            address(usdt), 85e6,
            address(susd), 35e18
        );

        uint256 targetAmount = l.originSwap(
            address(usdc),
            address(susd),
            3e6
        );

        assertEq(targetAmount, 2998500187500000000);

    }

    function testOriginSwap_partialUpperAndLowerSlippage_balanced_40USDC_to_DAI () public {

        l.proportionalDeposit(300e18);

        uint256 targetAmount = l.originSwap(
            address(usdc),
            address(dai),
            40e6
        );

        assertEq(targetAmount, 39330195827959985796);

    }

    function testOriginSwap_partialUpperAndLowerSlippage_balanced_30PctWeight_CUSDC_to_CDAI () public {

        l.proportionalDeposit(300e18);

        uint256 cusdcOf40Numeraire = IAssimilator(cusdcAssimilator).viewRawAmount(40e18);

        uint256 targetAmount = l.originSwap(
            address(cusdc),
            address(cdai),
            cusdcOf40Numeraire
        );

        uint256 numeraireOfTargetAmount = IAssimilator(cdaiAssimilator).viewNumeraireAmount(targetAmount).mulu(1e18);

        assertEq(numeraireOfTargetAmount, 39330195827959985796);

    }

    function testOriginSwap_partialUpperAndLowerSlippage_balanced_30PctWeight_to_10PctWeight () public {

        l.proportionalDeposit(300e18);

        uint256 targetAmount = l.originSwap(
            address(dai),
            address(susd),
            15e18
        );

        assertEq(targetAmount, 14813513177462324025);

    }

    function testOriginSwap_fullUpperAndLowerSlippage_unbalanced_30PctWeight () public {

        l.deposit(
            address(dai), 135e18,
            address(usdc), 90e6,
            address(usdt), 60e6,
            address(susd), 30e18
        );

        uint256 targetAmount = l.originSwap(
            address(dai),
            address(usdt),
            5e18
        );

        assertEq(targetAmount, 4666173);

    }

    function testOriginSwap_fullUpperAndLowerSlippage_unbalanced_30PctWeight_to_10PctWeight () public {

        l.deposit(
            address(dai), 135e18,
            address(usdc), 90e6,
            address(usdt), 65e6,
            address(susd), 25e18
        );

        uint256 targetAmount = l.originSwap(
            address(dai),
            address(susd),
            3e18
        );

        assertEq(targetAmount, 2876384124908864750);

    }

    function testOriginSwap_fullUpperAndLowerSlippage_unbalanced_10PctWeight_to_30PctWeight_ASUSD_CUSDC () public {

        l.deposit(
            address(dai), 90e18,
            address(usdc), 55e6,
            address(usdt), 90e6,
            address(susd), 35e18
        );

        uint256 asusdOf2Point8Numeraire = IAssimilator(asusdAssimilator).viewRawAmount(2.8e18);

        uint256 targetAmount = l.originSwap(
            address(asusd),
            address(cusdc),
            asusdOf2Point8Numeraire
        );

        uint256 cusdcNumeraireTargetAmount = IAssimilator(cusdcAssimilator).viewNumeraireAmount(targetAmount).mulu(1e18);

        assertEq(cusdcNumeraireTargetAmount, 2696349000000000000);

    }

    function testOriginSwap_fullUpperAndLowerSlippage_unbalanced_10PctWeight_to_30PctWeight () public {

        l.deposit(
            address(dai), 90e18,
            address(usdc), 55e6,
            address(usdt), 90e6,
            address(susd), 35e18
        );

        uint256 targetAmount = l.originSwap(
            address(susd),
            address(usdc),
            2.8e18
        );

        assertEq(targetAmount, 2696349);

    }

    function testOriginSwap_partialUpperAndLowerAntiSlippage_unbalanced_30PctWeight () public {

        l.deposit(
            address(dai), 135e18,
            address(usdc), 60e6,
            address(usdt), 90e6,
            address(susd), 30e18
        );

        uint256 targetAmount = l.originSwap(
            address(usdc),
            address(dai),
            30e6
        );

        assertEq(targetAmount, 30070278169642344458);

    }

    function testOriginSwap_partialUpperAndLowerAntiSlippage_unbalanced_10PctWeight_to_30PctWeight () public {

        l.deposit(
            address(dai), 135e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 25e18
        );

        uint256 targetAmount = l.originSwap(
            address(susd),
            address(dai),
            10e18
        );

        assertEq(targetAmount, 10006174300378984359);

    }

    function testOriginSwap_partialUpperAndLowerAntiSlippage_unbalanced_30PctWeight_to_10PctWeight () public {

        l.deposit(
            address(dai), 90e18,
            address(usdc), 90e6,
            address(usdt), 58e6,
            address(susd), 40e18
        );

        uint256 targetAmount = l.originSwap(
            address(usdt),
            address(susd),
            100e6
        );

        assertEq(targetAmount, 10019788191004510065);

    }

    function testOriginSwap_fullUpperAndLowerAntiSlippage_unbalanced_30PctWeight () public {

        l.deposit(
            address(dai), 90e18,
            address(usdc), 135e6,
            address(usdt), 60e6,
            address(susd), 30e18
        );

        uint256 targetAmount = l.originSwap(
            address(usdt),
            address(usdc),
            5e6
        );

        assertEq(targetAmount, 5045804);

    }

    function testOriginSwap_fullUpperAndLowerAntiSlippage_10PctWeight_to30PctWeight () public {

        l.deposit(
            address(dai), 90e18,
            address(usdc), 90e6,
            address(usdt), 135e6,
            address(susd), 25e18
        );

        uint256 targetAmount = l.originSwap(
            address(susd),
            address(usdt),
            3.6537e18
        );

        assertEq(targetAmount, 3660153);

    }

    function testOriginSwap_fullUpperAndLowerAntiSlippage_30pctWeight_to_10Pct () public {

        l.deposit(
            address(dai), 58e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 40e18
        );

        uint256 targetAmount = l.originSwap(
            address(dai),
            address(susd),
            2.349e18
        );

        assertEq(targetAmount, 2365464484251272960);

    }

    function testOriginSwap_CHAI_fullUpperAndLowerAntiSlippage_30pctWeight_to_10Pct () public {

        l.deposit(
            address(dai), 58e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 40e18
        );

        uint256 chaiOf2p349Numeraire = IAssimilator(chaiAssimilator).viewRawAmount(2.349e18);

        uint256 targetAmount = l.originSwap(
            address(chai),
            address(susd),
            chaiOf2p349Numeraire
        );

        assertEq(targetAmount, 2365464484251272960);
    }

    function testOriginSwap_upperHaltCheck_30PctWeight () public {

        l.deposit(
            address(dai), 90e18,
            address(usdc), 135e6,
            address(usdt), 90e6,
            address(susd), 30e18
        );


        ( bool success, ) = address(l).call(abi.encodeWithSelector(
            l.swapByOrigin.selector,
            address(usdc),
            address(usdt),
            30e6,
            0,
            1e50
        ));

        assertTrue(!success);

    }

    function testOriginSwap_lowerHaltCheck_30PctWeight () public {

        l.deposit(
            address(dai), 60e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 30e18
        );

        (bool success, ) = address(l).call(abi.encodeWithSelector(
            l.swapByOrigin.selector,
            address(usdc),
            address(dai),
            30e6,
            0,
            1e50
        ));

        assertTrue(!success);

    }

    function testOriginSwap_upperHaltCheck_10PctWeight () public {

        l.proportionalDeposit(300e18);

        ( bool success, ) = address(l).call(abi.encodeWithSelector(
            l.swapByOrigin.selector,
            address(susd),
            address(usdt),
            20e18,
            0,
            1e50
        ));

        assertTrue(!success);

    }

    function testOriginSwap_lowerhaltCheck_10PctWeight () public {

        l.proportionalDeposit(300e18);

        ( bool success, ) = address(l).call(abi.encodeWithSelector(
            l.swapByOrigin.selector,
            address(dai),
            address(susd),
            20e18,
            0,
            1e50
        ));

        assertTrue(!success);

    }

    function testOriginSwap_megaLowerToUpperUpperToLower_30PctWeight () logs_gas public {

        l.deposit(
            address(dai), 55e18,
            address(usdc), 90e6,
            address(usdt), 125e6,
            address(susd), 30e18
        );

        uint256 targetAmount = l.originSwap(
            address(dai),
            address(usdt),
            70e18
        );

        assertEq(targetAmount, 69965119);

    }

    function testOriginSwap_megaLowerToUpperUpperToLower_CDAI_30PctWeight () public {

        l.deposit(
            address(dai), 55e18,
            address(usdc), 90e6,
            address(usdt), 125e6,
            address(susd), 30e18
        );

        uint256 cdaiOf70Numeraire = IAssimilator(cdaiAssimilator).viewRawAmount(uint(70e18).divu(1e18));

        uint256 targetAmount = l.originSwap(
            address(cdai),
            address(usdt),
            cdaiOf70Numeraire
        );

        assertEq(targetAmount, 17491279);

    }

    function testOriginSwap_megaLowerToUpper_10PctWeight_to_30PctWeight () public {

        l.deposit(
            address(dai), 90e18,
            address(usdc), 90e6,
            address(usdt), 100e6,
            address(susd), 20e18
        );

        uint256 targetAmount = l.originSwap(
            address(susd),
            address(usdt),
            20e18
        );

        assertEq(targetAmount, 19990003);

    }

    function testOriginSwap_megaUpperToLower_30PctWeight_to_10PctWeight () public {

        l.deposit(
            address(dai), 80e18,
            address(usdc), 100e6,
            address(usdt), 80e6,
            address(susd), 40e18
        );

        uint256 targetAmount = l.originSwap(
            address(dai),
            address(susd),
            20e18
        );

        assertEq(targetAmount, 19990016481618381864);

    }

    function testFailOriginSwap_greaterThanBalance_30Pct () public {

        l.deposit(
            address(dai), 46e18,
            address(usdc), 134e6,
            address(usdt), 75e6,
            address(susd), 45e18
        );

        uint256 originAmount = l.originSwap(
            address(usdt),
            address(dai),
            50e6
        );

    }

    function testFailOriginSwap_greaterThanBalance_10Pct () public {

        l.proportionalDeposit(300e18);

        uint256 originAmount = l.originSwap(
            address(usdc),
            address(susd),
            31e6
        );

    }

}