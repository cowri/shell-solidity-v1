
pragma solidity ^0.5.0;

import "ds-test/test.sol";
import "ds-math/math.sol";

import "../interfaces/IAssimilator.sol";

import "./setup/setup.sol";

import "./setup/methods.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

contract TargetSwapTest is Setup, DSMath, DSTest {

    using ABDKMath64x64 for uint;
    using ABDKMath64x64 for int128;

    using LoihiMethods for Loihi;

    Loihi l;

    function setUp() public {

        start();

        l = getLoihiSuiteTwo();

    }

    function testTargetSwap_noSlippage_balanced_DAI_to_10USDC_300Proportional () public {

        l.proportionalDeposit(300e18);

        uint256 originAmount = l.targetSwap(
            address(dai),
            address(usdc),
            10e6
        );

        assertEq(originAmount, 10005000625000000000);

    }

    function testTargetSwap_noSlippage_unbalanced_USDC_to_3SUSD_with_80DAI_100USDC_85USDT_35SUSD () public {

        l.deposit(
            address(dai), 80e18,
            address(usdc), 100e6,
            address(usdt), 85e6,
            address(susd), 35e18
        );

        uint256 originAmount = l.targetSwap(
            address(usdc),
            address(susd),
            3e18
        );

        assertEq(originAmount, 3001500);

    }

    function testTargetSwap_noSlippage_balanced_10PctWeight_to_30PctWeight () public {

        l.proportionalDeposit(300e18);

        uint256 originAmount = l.targetSwap(
            address(susd),
            address(usdt),
            4e6
        );

        assertEq(originAmount, 4002000250000000000);

    }

    function testTargetSwap_noSlippage_Balanced_10PctWeight_to_30PctWeight_AUSDT () public {

        l.proportionalDeposit(300e18);

        uint256 originAmount = l.targetSwap(
            address(susd),
            address(ausdt),
            4e18
        );

        assertEq(originAmount, 4002000250000000000);

    }

    function testTargetSwap_partialUpperAndLowerSlippage_balanced_30PctWeight_to30PctWeight () public {

        l.proportionalDeposit(300e18);

        uint256 originAmount = l.targetSwap(
            address(usdc),
            address(dai),
            40e18
        );

        assertEq(originAmount, 40722871);

    }

    function testTargetSwap_partialUpperAndLowerSlippage_balanced_30PctWeight_to_10PctWeight () public {

        l.proportionalDeposit(300e18);

        uint256 originAmount = l.targetSwap(
            address(usdc),
            address(susd),
            12e18
        );

        assertEq(originAmount, 12073660);

    }

    function testTargetSwap_partialUpperAndLowerSLippage_balanced_30PctWeight_to_10PctWeight_ASUSD () public {

        l.proportionalDeposit(300e18);

        uint256 originAmount = l.targetSwap(
            address(usdc),
            address(asusd),
            12e18
        );

        assertEq(originAmount, 12073660);

    }

    function testTargetSwap_partialUpperAndLowerSlippage_unbalanced_10PctWeight_to_30PctWeight () public {

        l.deposit(
            address(dai), 65e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 30e18
        );

        uint256 originAmount = l.targetSwap(
            address(susd),
            address(dai),
            8e18
        );

        assertEq(originAmount, 8082681715960427072);

    }

    function testTargetSwap_noSlippage_lightlyUnbalanced_30PctWeight_to_10PctWeight () public {

        l.deposit(
            address(dai), 80e18,
            address(usdc), 100e6,
            address(usdt), 85e6,
            address(susd), 35e18
        );

        uint256 originAmount = l.targetSwap(
            address(usdc),
            address(susd),
            3e18
        );

        assertEq(originAmount, 3001500);

    }

    function testTargetSwap_noSlippage_lightlyUnbalanced_30PctWeight_to_10PctWeight_CUSDC () public {

        l.deposit(
            address(dai), 80e18,
            address(usdc), 100e6,
            address(usdt), 85e6,
            address(susd), 35e18
        );

        uint256 originAmount = l.targetSwap(
            address(cusdc),
            address(susd),
            3e18
        );

        uint256 numeraireOfTargetCusdc = IAssimilator(cusdcAssimilator).viewNumeraireAmount(originAmount).mulu(1e18);

        assertEq(numeraireOfTargetCusdc, 3001500000000000000);

    }

    function testTargetSwap_fullUpperAndLowerSlippage_unbalanced_30PctWeight () public {

        l.deposit(
            address(dai), 135e18,
            address(usdc), 90e6,
            address(usdt), 60e6,
            address(susd), 30e18
        );

        uint256 originAmount = l.targetSwap(
            address(dai),
            address(usdt),
            5e6
        );

        assertEq(originAmount, 5361455914007417759);

    }

    function testTargetSwap_fullUpperAndLowerSlippage_unbalanced_30PctWeight_to_10PctWeight () public {

        l.deposit(
            address(dai), 135e18,
            address(usdc), 90e6,
            address(usdt), 65e6,
            address(susd), 25e18
        );

        uint256 originAmount = l.targetSwap(
            address(dai),
            address(susd),
            3e18
        );

        assertEq(originAmount, 3130264791663764854);

    }

    function testTargetSwap_fullUpperAndLowerSlippage_unbalanced_10PctWeight_to_30PctWeight () public {

        l.deposit(
            address(dai), 90e18,
            address(usdc), 55e6,
            address(usdt), 90e6,
            address(susd), 35e18
        );

        uint256 originAmount = l.targetSwap(
            address(susd),
            address(usdc),
            2.8e6
        );

        assertEq(originAmount, 2909155536050677534);

    }

    function testTargetSwap_partialUpperAndLowerAntiSlippage_unbalanced_30PctWeight_to_30PctWeight () public {

        l.deposit(
            address(dai), 135e18,
            address(usdc), 60e6,
            address(usdt), 90e6,
            address(susd), 30e18
        );

        uint256 originAmount = l.targetSwap(
            address(usdc),
            address(dai),
            30e18
        );

        assertEq(originAmount, 29929682);

    }

    function testTargetSwap_partialUpperAndLowerAntiSlippage_unbalanced_CHAI_10PctWeight_to_30PctWeight () public {

        l.deposit(
            address(dai), 135e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 25e18
        );

        uint256 chaiOf10Numeraire = IAssimilator(chaiAssimilator).viewRawAmount(uint(10e18).divu(1e18));

        uint256 originAmount = l.targetSwap(
            address(susd),
            address(chai),
            chaiOf10Numeraire
        );

        assertEq(originAmount, 9993821361386267461);

    }

    function testTargetSwap_partialUpperAndLowerAntiSlippage_unbalanced_10PctWeight_to_30PctWeight () public {

        l.deposit(
            address(dai), 135e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 25e18
        );

        uint256 originAmount = l.targetSwap(
            address(susd),
            address(dai),
            10e18
        );

        assertEq(originAmount, 9993821361386267461);

    }

    function testTargetSwap_partialUpperAndLowerAntiSlippage_unbalanced_30PctWeight_to_10PctWeight () public {

        l.deposit(
            address(dai), 90e18,
            address(usdc), 90e6,
            address(usdt), 58e6,
            address(susd), 40e18
        );

        uint256 originAmount = l.targetSwap(
            address(usdt),
            address(susd),
            10e18
        );

        assertEq(originAmount, 9980200);

    }

    function testTargetSwap_fullUpperAndLowerAntiSlippage_unbalanced_30PctWeight () public {

        l.deposit(
            address(dai), 90e18,
            address(usdc), 135e6,
            address(usdt), 60e6,
            address(susd), 30e18
        );

        uint256 originAmount = l.targetSwap(
            address(usdt),
            address(usdc),
            5e6
        );

        assertEq(originAmount, 4954524);

    }

    function testTargetSwap_fullUpperAndLowerAntiSlippage_10PctOrigin_to_30PctTarget () public {

        l. deposit(
            address(dai), 90e18,
            address(usdc), 90e6,
            address(usdt), 135e6,
            address(susd), 25e18
        );

        uint256 originAmount = l.targetSwap(
            address(susd),
            address(usdt),
            3.6537e6
        );

        assertEq(originAmount, 3647253554589698680);

    }

    function testTargetSwap_fullUpperAndLowerAntiSlippage_CDAI_30pct_to_10Pct () public {

        l.deposit(
            address(dai), 58e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 40e18
        );

        uint256 originAmount = l.targetSwap(
            address(cdai),
            address(susd),
            2.349e18
        );

        uint256 numeraireOfTargetCdai = IAssimilator(cdaiAssimilator).viewNumeraireAmount(originAmount).mulu(1e18);

        assertEq(numeraireOfTargetCdai, 2332615973198180868);

    }

    function testTargetSwap_fullUpperAndLowerAntiSlippage_30Pct_To10Pct () public {

        l.deposit(
            address(dai), 58e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 40e18
        );

        uint256 originAmount = l.targetSwap(
            address(dai),
            address(susd),
            2.349e18
        );

        assertEq(originAmount, 2332615973232859927);

    }

    function testTargetSwap_megaLowerToUpperUpperToLower_30PctWeight () public {

        l.deposit(
            address(dai), 55e18,
            address(usdc), 90e6,
            address(usdt), 125e6,
            address(susd), 30e18
        );

        uint256 originAmount = l.targetSwap(
            address(dai),
            address(usdt),
            70e6
        );

        assertEq(originAmount, 70035406577130885767);

    }

    function testTargetSwap_megaLowerToUpper_10PctWeight_to_30PctWeight () public {

        l.deposit(
            address(dai), 90e18,
            address(usdc), 90e6,
            address(usdt), 100e6,
            address(susd), 20e18
        );

        uint256 originAmount = l.targetSwap(
            address(susd),
            address(usdt),
            20e6
        );

        assertEq(originAmount, 20010074968656541264);

    }

    function testTargetSwap_megaUpperToLower_30PctWeight_to_10PctWeight () public {

        l.deposit(
            address(dai), 80e18,
            address(usdc), 100e6,
            address(usdt), 80e6,
            address(susd), 40e18
        );

        uint256 originAmount = l.targetSwap(
            address(dai),
            address(susd),
            20e18
        );

        assertEq(originAmount, 20010007164941759473);

    }

    function testTargetSwap_upperHaltCheck_30PctWeight () public {

        l.deposit(
            address(dai), 90e18,
            address(usdc), 135e6,
            address(usdt), 90e6,
            address(susd), 30e18
        );

        ( bool success, ) = address(l).call(abi.encodeWithSelector(
            l.swapByTarget.selector,
            address(usdc),
            address(usdt),
            31e6,
            30e6,
            1e50
        ));

        assertTrue(!success);

    }

    function testTargetSwap_lowerHaltCheck_30PctWeight () public {

        l.deposit(
            address(dai), 60e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 30e18
        );

        (bool success, bytes memory result) = address(l).call(abi.encodeWithSelector(
            l.swapByTarget.selector,
            address(usdc),
            address(dai),
            31e18,
            30e18,
            1e50
        ));

        assertTrue(!success);

    }

    function testTargetSwap_upperHaltCheck_10PctWeight () public {

        l.proportionalDeposit(300e18);

        (bool success, bytes memory result) = address(l).call(abi.encodeWithSelector(
            l.swapByTarget.selector,
            address(susd),
            address(usdt),
            21e18,
            20e18,
            1e50
        ));

        assertTrue(!success);

    }

    function testTargetSwap_lowerhaltCheck_10PctWeight () public {

        l.proportionalDeposit(300e18);

        (bool success, bytes memory result) = address(l).call(abi.encodeWithSelector(
            l.swapByTarget.selector,
            address(dai),
            address(susd),
            21e18,
            20e18,
            1e50
        ));

        assertTrue(!success);

    }

    function testTargetSwap_noSlippage_partiallyUnbalanced_10PctTarget () public {

        l.deposit(
            address(dai), 80e18,
            address(usdc), 100e6,
            address(usdt), 85e6,
            address(susd), 35e18
        );

        uint256 originAmount = l.targetSwap(
            address(dai),
            address(susd),
            3e18
        );

        assertEq(originAmount, 3001500187500000000);

    }

    function testFailTargetSwap_targetGreaterThanBalance_30Pct () public {

        l.deposit(
            address(dai), 46e18,
            address(usdc), 134e6,
            address(usdt), 75e6,
            address(susd), 45e18
        );

        uint256 originAmount = l.targetSwap(
            address(usdt),
            address(dai),
            50e18
        );

    }

    function testFailTargetSwap_targetGreaterThanBalance_10Pct () public {

        l.proportionalDeposit(300e18);

        uint256 originAmount = l.targetSwap(
            address(usdc),
            address(susd),
            31e18
        );

    }

}