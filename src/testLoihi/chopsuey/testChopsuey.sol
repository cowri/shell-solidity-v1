pragma solidity ^0.5.15;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../loihiSetup.sol";
import "../../interfaces/IAdapter.sol";


contract LoihiChopSueyTest is LoihiSetup, DSMath, DSTest {

    uint256 ChaiNM10;

    function setUp() public {
// 
        setupFlavors();
        setupAdapters();
        setupLoihi();
        approveFlavors(address(l));
        executeLoihiApprovals(address(l));
        includeAdapters(address(l), 0);

        ChaiNM10 = IAdapter(chaiAdapter).viewRawAmount(10*WAD);

    }

    event log_addrs(bytes32, address[]);

    function testChopSuey () public {

        address[] memory coins = new address[](4);
        coins[0] = dai;
        coins[1] = usdc;
        coins[2] = usdt;
        coins[3] = susd;

        uint256[] memory amounts = new uint256[](4);
        amounts[0] = 100 * WAD;
        amounts[1] = 100 * (10**6);
        amounts[2] = 100 * (10**6);
        amounts[3] = 50 * WAD;

        uint256 mintedShells = l.selectiveDeposit(coins, amounts, 0, now+50);
        assertEq(mintedShells, 349888392857142857144);

        uint256 daiBal = IERC20(cdai).balanceOf(address(l));
        uint256 cusdcBal = IERC20(cusdc).balanceOf(address(l));
        uint256 ausdtBal = IERC20(ausdt).balanceOf(address(l));
        uint256 asusdBal = IERC20(asusd).balanceOf(address(l));

        amounts[0] = 50 * WAD;
        amounts[1] = 25 * (10 ** 6);
        amounts[2] = 0;
        amounts[3] = 15 * WAD;
        mintedShells = l.selectiveDeposit(coins, amounts, 0, now + 50);
        assertEq(mintedShells, 89744101015533405357);

        uint256 shellsBurned = l.balanceOf(address(this));
        uint256[] memory withdrawals = l.proportionalWithdraw(50*WAD);
        shellsBurned -= l.balanceOf(address(this));

        assertEq(withdrawals[0], 17051173660885777205);
        assertEq(withdrawals[1], 14209311);
        assertEq(withdrawals[2], 11367449);
        assertEq(withdrawals[3], 7388841919725202334);

        assertEq(shellsBurned, 50 * WAD);

        uint256 targetAmount = l.swapByOrigin(usdc, usdt, 20 * (10**6), 0, now + 500);
        assertEq(targetAmount, 19677892);

        uint256 originAmount = l.swapByTarget(susd, dai, 500 * WAD, WAD / 2, now + 500);
        assertEq(originAmount, 512199000000000000);

        amounts[0] = 25 * WAD;
        amounts[1] = 0;
        amounts[2] = 10 * (10**6);
        amounts[3] = 10 * (10**18);
        shellsBurned = l.selectiveWithdraw(coins, amounts, 500 * WAD, now + 500);
        assertEq(shellsBurned, 45124168354146908133);


        mintedShells = l.proportionalDeposit(100*WAD);
        assertEq(mintedShells, 99765663267213421115);

        amounts[0] = 50 * WAD;
        amounts[1] = 0;
        amounts[2] = 0;
        amounts[3] = 0;
        uint256 burnedShells1 = l.selectiveWithdraw(coins, amounts, 500*WAD, now + 500);

        assertEq(burnedShells1, 49909660804015867535);

        amounts[0] = 0;
        amounts[1] = 10 * (10 ** 6);
        uint256 mintedShells1 = l.selectiveDeposit(coins, amounts, 0, now + 500);

        assertEq(mintedShells1, 9821676958182931101);

        uint256 target1 = l.swapByOrigin(susd, usdt, WAD/4, 0, now + 500);
        assertEq(target1, 244621);

        uint256 target2 = l.swapByOrigin(usdt, usdc, 75 * (10**6), 0, now + 500);
        assertEq(target2, 74849710);

        uint256 origin1 = l.swapByTarget(usdc, dai, 50*WAD, 1300000000000000000, now + 500);
        assertEq(origin1, 1306084);

        uint256 origin2 = l.swapByTarget(dai, usdt, 500 * WAD, 75 * (10**6), now + 500);
        assertEq(origin2, 75111362681373515778);

        originAmount = l.swapByTarget(dai, susd, 500 * WAD, 38100000000000000000, now + 500);

    }

    event log_uints(bytes32, uint256[]);

    // event log_uints(bytes32, uint256[]);
    // event log_bytes4(bytes32, bytes4);

    // function testProportionalDepositIntoSubOnePool () public {

    //     uint256 mintedShells = l.proportionalDeposit(100 * (10 ** 18));
    //     assertEq(mintedShells, 100 * (10 ** 18));

    //     uint256 daiBal = IERC20(cdai).balanceOf(address(l));
    //     uint256 cusdcBal = IERC20(cusdc).balanceOf(address(l));
    //     uint256 usdtBal = IERC20(usdt).balanceOf(address(l));
    //     uint256 asusdBal = IERC20(asusd).balanceOf(address(l));

    //     emit log_named_uint("daiBal", daiBal);
    //     emit log_named_uint("cusdcBal", cusdcBal);
    //     emit log_named_uint("usdtBal", usdtBal);
    //     emit log_named_uint("asusdBal", asusdBal);

    // }

}