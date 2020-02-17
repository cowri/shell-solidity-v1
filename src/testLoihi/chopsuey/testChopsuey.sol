pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../loihiSetup.sol";
import "../../IAdapter.sol";


contract LoihiChopSueyTest is LoihiSetup, DSMath, DSTest {

    uint256 ChaiNM10;

    function setUp() public {

        setupFlavors();
        setupAdapters();
        setupLoihi();
        approveFlavors(address(l));
        includeAdapters(address(l), 0);

        ChaiNM10 = IAdapter(chaiAdapter).viewRawAmount(10*WAD);

    }

    event log_addrs(bytes32, address[]);

    // function testproportionalDeposit () public {

    //     address[] memory coins = new address[](4);
    //     coins[0] = dai;
    //     coins[1] = usdc;
    //     coins[2] = usdt;
    //     coins[3] = asusd;

    //     uint256[] memory amounts = new uint256[](4);
    //     amounts[0] = 100 * WAD;
    //     amounts[1] = 100 * (10**6);
    //     amounts[2] = 100 * (10**6);
    //     amounts[3] = 50 * (10**6);

    //     uint256 mintedShells = l.selectiveDeposit(coins, amounts, 0, now+50);
    //     emit log_named_uint("mintedShells", mintedShells);
    //     assertEq(mintedShells, 349888392857142857144);


    //     uint256 daiBal = IERC20(cdai).balanceOf(address(l));
    //     uint256 cusdcBal = IERC20(cusdc).balanceOf(address(l));
    //     uint256 usdtBal = IERC20(usdt).balanceOf(address(l));
    //     uint256 asusdBal = IERC20(asusd).balanceOf(address(l));

    //     emit log_named_uint("daiBal", daiBal);
    //     emit log_named_uint("cusdcBal", cusdcBal);
    //     emit log_named_uint("usdtBal", usdtBal);
    //     emit log_named_uint("asusdBal", asusdBal);

        // amounts[0] = 50 * WAD;
        // amounts[1] = 25 * (10 ** 6);
        // amounts[2] = 0;
        // amounts[3] = 15 * (10 ** 6);
        // mintedShells = l.selectiveDeposit(coins, amounts, 0, now + 50);
        // emit log_named_uint("mintedShells", mintedShells);
        // assertEq(mintedShells, 89744101015533405357);

        // uint256 shellsBurned = l.balanceOf(address(this));
        // uint256[] memory withdrawals = l.proportionalWithdraw(50*WAD);
        // shellsBurned -= l.balanceOf(address(this));

        // assertEq(withdrawals[0], 17051173660885777205);
        // assertEq(withdrawals[1], 14209311);
        // assertEq(withdrawals[2], 11367449);
        // assertEq(withdrawals[3], 7388841);

        // uint256 targetAmount = l.swapByOrigin(usdc, usdt, 20 * (10**6), 0, now + 500);
        // assertEq(targetAmount, 19677892);

        // uint256 originAmount = l.swapByTarget(asusd, dai, 500 * WAD, WAD / 2, now + 500);
        // assertEq(originAmount, 512199);

        // amounts[0] = 25 * WAD;
        // amounts[1] = 0;
        // amounts[2] = 10 * (10**6);
        // amounts[3] = 10 * (10**6);
        // shellsBurned = l.selectiveWithdraw(coins, amounts, 500 * WAD, now + 500);
        // assertEq(shellsBurned, 45124168354146908133);


        // mintedShells = l.proportionalDeposit(100*WAD);
        // emit log_named_uint("minted", mintedShells);
        // assertEq(mintedShells, 99765663267213421115);

        // originAmount = l.swapByTarget(dai, usdc, 500 * WAD, 69000000, now + 500);

    // }

    event log_uints(bytes32, uint256[]);
    event log_bytes4(bytes32, bytes4);

    function testProportionalDepositIntoSubOnePool () public {

        uint256 mintedShells = l.proportionalDeposit(100 * (10 ** 18));
        assertEq(mintedShells, 100 * (10 ** 18));

        uint256 daiBal = IERC20(cdai).balanceOf(address(l));
        uint256 cusdcBal = IERC20(cusdc).balanceOf(address(l));
        uint256 usdtBal = IERC20(usdt).balanceOf(address(l));
        uint256 asusdBal = IERC20(asusd).balanceOf(address(l));

        emit log_named_uint("daiBal", daiBal);
        emit log_named_uint("cusdcBal", cusdcBal);
        emit log_named_uint("usdtBal", usdtBal);
        emit log_named_uint("asusdBal", asusdBal);

    }

}