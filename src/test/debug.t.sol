
pragma solidity ^0.5.0;

import "ds-test/test.sol";
import "ds-math/math.sol";

import "./setup/setup.sol";

import "./setup/methods.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

contract DebugTest is Setup, DSMath, DSTest {

    using ABDKMath64x64 for uint;
    using ABDKMath64x64 for int128;

    using LoihiMethods for Loihi;

    Loihi l;

    event log_bytes(bytes32, bytes4);

    function setUp() public {

        start();
        l = getLoihiSuiteOne();

    }

    function testDebug () public {

        uint256 b = 4.567e18;
        uint256 a = 6.543e18;

        int128 a64 = a.divu(1e18);
        int128 b64 = b.divu(1e18);

        emit log_named_int("a64.sub(b64)", (a64.sub(b64)).muli(1e18));

        emit log_named_int("a64 - b64", (a64 - b64).muli(1e18));

        // ( int128 _amt, int128 _bal)  = assimBouncer.deposit(address(usdcAssimilator), 1e6);
        // ( int128 _amt, int128 _bal)  = assimBouncer.withdraw(address(daiAssimilator), 5e18);

        // emit log_named_int("amount", _amt.muli(1e18));
        // emit log_named_int("bal", _bal.muli(1e18));

        // ( _amt, _bal )  = assimBouncer.withdraw(address(usdcAssimilator), 1e6);

        // emit log_named_int("amount", _amt.muli(1e18));
        // emit log_named_int("bal", _bal.muli(1e18));

        // int128 xr = uint256(202853120189954603721819673).divu(1e18);
        // int128 xr1 = 0xC174B0030A0DD6AB5B914FD;

        // uint256 daiAmt = 95e18;

        // int128 dai64 = daiAmt.divu(1e18);

        // emit log_named_uint("dai", dai64.toUInt());

        // int128 cdaiAmt64 = uint256(95e18).divu(1e18).div(xr1);

        // int128 daiAmt64 = cdaiAmt64.mul(xr1);

        // uint256 daiAmtBack = daiAmt64.mulu(1e18);

        // emit log_named_uint("daiAmtBack", daiAmtBack);

        // uint256 startingShells = l.proportionalDeposit(300e18);


        // uint256 startingShells = l.deposit(
        //     address(dai), 58e18,
        //     address(usdc), 90e6,
        //     address(usdt), 90e6,
        //     address(susd), 40e18
        // );
        // uint256 startingShells = l.deposit(
        //     address(dai), 135e18,
        //     address(usdc), 90e6,
        //     address(usdt), 60e6,
        //     address(susd), 30e18
        // );

        // ( uint256 totalReserves, uint256[] memory reserves ) = l.totalReserves();

        // emit log_uint("total reserves", totalReserves);

        // emit log_uint("dai", reserves[0]);
        // emit log_uint("usdc", reserves[1]);
        // emit log_uint("usdt", reserves[2]);
        // emit log_uint("susd", reserves[3]);

        // uint256 targetAmount = l.originSwap(
        //     address(dai),
        //     address(usdt),
        //     // address(susd),
        //     5e18
        //     // 3e18
        // );

        // uint256 originAmount = l.targetSwap(
        //     address(dai),
        //     address(susd),
        //     2.349e18
        // );

//         deposit(dai, 58*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 40*WAD);
//         uint256 targetAmount = l1.swapByTarget(cdai, susd, 10*WAD, 2349000000000000000, now+50);
//         uint256 numeraireOfTargetCdai = IAdapter(cdaiAdapter).viewNumeraireAmount(targetAmount);
//         assertEq(numeraireOfTargetCdai, 2332615973198180868);


        // uint256 targetAmount = l.originSwap(
        //     address(dai),
        //     address(usdc),
        //     10e18
        // );

        // uint256 startingShells = l.deposit(
        //     address(dai), 95e18,
        //     address(usdc), 55e6,
        //     address(usdt), 95e6,
        //     address(susd), 15e18
        // );

        // uint256 startingShells = l.deposit(
        //     address(dai), 90e18,
        //     address(usdc), 145e6,
        //     address(usdt), 90e6,
        //     address(susd), 50e18
        // );

    //     uint256 startingShells = deposit(1, dai, 90*WAD, usdc, 145*(10**6), usdt, 90*(10**6), susd, 50*WAD);

        // uint256 _newShells = l.deposit(
        //     address(usdc), 36e6,
        //     address(susd), 18e18
        // );

        // uint256 startingShells = l.deposit(
        //     address(dai), 90e18,
        //     address(usdc), 145e6,
        //     address(usdt), 90e6,
        //     address(susd), 50e18
        // );

        // uint256 newShells = l.deposit(
        //     address(usdc), 5e6,
        //     address(susd), 3e18
        // );

        // uint256 newShells = l.deposit(
        //     address(dai), 12e18,
        //     address(usdc), 12e6,
        //     address(usdt), 10e6,
        //     address(susd), 1e18
        // );

        // uint256 startingShells = l.deposit(
        //     address(dai), 90e18,
        //     address(usdc), 145e6,
        //     address(usdt), 90e6,
        //     address(susd), 50e18
        // );
        

        // uint256 shellsBurned = l.withdraw(
        //     address(usdc), 50e6,
        //     address(susd), 18e18
        // );

        // uint256 shellsBurned = l.withdraw(
        //     address(dai), 5e18,
        //     address(usdt), 5e6
        // );

        // uint256 burnedShells = l.withdraw(
        //     address(dai), 10e18,
        //     address(usdc), 10e6,
        //     address(usdt), 10e6,
        //     address(susd), 2.5e18
        // );

        // assertEq(burnedShells, 32499997860423756789);

        // emit log_named_uint("newShells", _newShells);

    }

//     function testExecuteSelectiveWithdrawPartialUpperAntiSlippage0Dai50Usdc0Usdt18SusdFrom90Dai145Usdc90Usdt50SusdWITHCUSDC () public {
//         uint256 startingShells = deposit(dai, 45*WAD, usdc, (145*(10**6))/2, usdt, (90*(10**6))/2, susd, 25*WAD);
//         uint256 cusdcOf50Numeraires = IAdapter(cusdcAdapter).viewRawAmount(25*WAD);
//         uint256 shellsBurned = withdraw(dai, 0, cusdc, cusdcOf50Numeraires, usdt, 0, susd, 9*WAD);
//         assertEq(shellsBurned, 33995692319719466392);
//         emit log_named_uint("startingShells", startingShells);
//     }

//     function testExecuteSelectiveWithdrawFullUpperSlippageNoWithdraw5Dai0Usdc5Usdt0SusdFrom90Dai145Usdc90Usdt50Susd () public {
//         uint256 startingShells = deposit(dai, 90*WAD, usdc, 145*(10**6), usdt, 90*(10**6), susd, 50*WAD);
//         uint256 shellsBurned = withdraw(dai, 5*WAD, usdc, 0, usdt, 5*(10**6), susd, 0);
//         assertEq(shellsBurned, 10069672125594190772);
//         emit log_named_uint("starting shells", startingShells);
//     }


    // function testExecuteSelectiveDepositUnbalancedFullUpperSlippageFeeLessThanDeposit0Dai5Usdc0Usdt3SusdInto90Dai145Usdc90Usdt50Susd () public {

    //     uint256 startingShells = deposit(1, dai, 90*WAD, usdc, 145*(10**6), usdt, 90*(10**6), susd, 50*WAD);
    //     uint256 newShells = deposit(1, dai, 0, usdc, 5*(10**6), usdt, 0, susd, 3*WAD);
    //     assertEq(newShells, 7935137412354349862);
    //     emit log_named_uint("startingShells", startingShells);

    // }

    // function testExecuteSelectiveDepositUnbalancedFullLowerSlippageFeeLessThanDeposit12Dai12Usdc1Usdt1SusdInto95Dai95Usdc55Usdt15Susd () public {

    //     uint256 startingShells = deposit(1, dai, 95*WAD, usdc, 95*(10**6), usdt, 55*(10**6), susd, 15*WAD);
    //     uint256 newShells = deposit(1, dai, 12*WAD, usdc, 12*(10**6), usdt, 10**6, susd, WAD);
    //     assertEq(newShells, 25895520576151595834);
    //     emit log_named_uint("startingShells", startingShells);

    // }
    
    function testMath () public {

        uint256 a = 1;

        int128 a64 = a.fromUInt();

    }

}