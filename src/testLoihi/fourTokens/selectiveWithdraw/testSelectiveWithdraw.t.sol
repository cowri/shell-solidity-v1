// pragma solidity ^0.5.6;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../../loihiSetup.sol";
// import "../../../interfaces/IAdapter.sol";

// contract SelectiveWithdrawTest is LoihiSetup, DSMath, DSTest {

//     function setUp() public {

//         setupLoihi();
//         setupFlavors();
//         setupAdapters();
//         approveFlavors();
//         executeApprovals();
//         includeAdapters(0);

//     }

//     function viewWithdraw (address waddr, uint256 wamount, address xaddr, uint256 xamount, address yaddr, uint256 yamount, address zaddr, uint256 zamount) public returns (uint256) {
//         address[] memory addrs = new address[](4);
//         uint256[] memory amounts = new uint256[](4);

//         addrs[0] = waddr; amounts[0] = wamount;
//         addrs[1] = xaddr; amounts[1] = xamount;
//         addrs[2] = yaddr; amounts[2] = yamount;
//         addrs[3] = zaddr; amounts[3] = zamount;

//         return l1.viewSelectiveWithdraw(addrs, amounts);
//     }

//     function withdraw (address waddr, uint256 wamount, address xaddr, uint256 xamount, address yaddr, uint256 yamount, address zaddr, uint256 zamount) public returns (uint256) {
//         address[] memory addrs = new address[](4);
//         uint256[] memory amounts = new uint256[](4);

//         addrs[0] = waddr; amounts[0] = wamount;
//         addrs[1] = xaddr; amounts[1] = xamount;
//         addrs[2] = yaddr; amounts[2] = yamount;
//         addrs[3] = zaddr; amounts[3] = zamount;

//         return l1.selectiveWithdraw(addrs, amounts, 50000*WAD, now + 500);
//     }

//     function deposit (address waddr, uint256 wamount, address xaddr, uint256 xamount, address yaddr, uint256 yamount, address zaddr, uint256 zamount) public returns (uint256) {
//         address[] memory addrs = new address[](4);
//         uint256[] memory amounts = new uint256[](4);

//         addrs[0] = waddr; amounts[0] = wamount;
//         addrs[1] = xaddr; amounts[1] = xamount;
//         addrs[2] = yaddr; amounts[2] = yamount;
//         addrs[3] = zaddr; amounts[3] = zamount;

//         return l1.selectiveDeposit(addrs, amounts, 0, now + 500);
//     }

//     function testBalancedWithdraw10Dai10Usdc10Usdt2Point5SusdFrom300Proportional () public {
//         uint256 startingShells = l1.proportionalDeposit(300*WAD);
//         uint256 viewBurned = viewWithdraw(dai, 10*WAD, usdc, 10*(10**6), usdt, 10*(10**6), susd, 2500000000000000000);
//         uint256 shellsBurned = withdraw(dai, 10*WAD, usdc, 10*(10**6), usdt, 10*(10**6), susd, 2500000000000000000);
//         assertEq(shellsBurned, 32499997860423756789);
//         assertEq(shellsBurned, viewBurned);
//     }

//     function testModeratelyUnbalancedWithdraw5Dai1Usdc3Usdt1SusdFrom80Dai100Usdc85Usdt35Susd () public {
//         deposit(dai, 80*WAD, usdc, 100*(10**6), usdt, 85*(10**6), susd, 35*WAD);
//         uint256 shellsBurned = withdraw(dai, 5*WAD, usdc, 10**6, usdt, 3*(10**6), susd, WAD);
//         assertEq(shellsBurned, 9999999341669357397);
//     }

//     function testPartialLowerSlippage5Dai5Usdc47Usdt16SusdFromProportional300 () public {
//         l1.proportionalDeposit(300*WAD);
//         uint256 shellsBurned = withdraw(dai, 5*WAD, usdc, 5*(10**6), usdt, 47*(10**6), susd, 16*WAD);
//         assertEq(shellsBurned, 73136056131754670221);
//     }

//     function testPartialLowerSlippage3Dai60Usdc30Usdt1SusdFrom80Dai100Usdc100Usdt23Susd () public {
//         uint256 startingShells = deposit(dai, 80*WAD, usdc, 100*(10**6), usdt, 100*(10**6), susd, 23*WAD);
//         uint256 viewBurned = viewWithdraw(dai, 3*WAD, usdc, 60*(10**6), usdt, 30*(10**6), susd, 1*WAD);
//         uint256 shellsBurned = withdraw(dai, 3*WAD, usdc, 60*(10**6), usdt, 30*(10**6), susd, 1*WAD);
//         assertEq(shellsBurned, 94078702922653052517);
//         assertEq(shellsBurned, viewBurned);
//         emit log_named_uint("startingShells", startingShells);
//     }

//     function testPartialUpperSlippage0Point001Dai40Usdc40Usdt10SusdFromProportional300 () public {
//         l1.proportionalDeposit(300*WAD);
//         uint256 shellsBurned = withdraw(dai, WAD/1000, usdc, 40*(10**6), usdt, 40*(10**6), susd, 10*WAD);
//         assertEq(shellsBurned, 90201865540244940833);
//     }

//     function testPartialLowerAntiSlippageNoWithdraw40Dai0Usdc40Usdt0SusdFrom95Dai55Usdc95Usdt15Susd () public {
//         uint256 startingShells = deposit(dai, 95*WAD, usdc, 55*(10**6), usdt, 95*(10**6), susd, 15*WAD);
//         uint256 shellsBurned = withdraw(dai, 40*WAD, usdc, 0, usdt, 40*(10**6), susd, 0);
//         assertEq(shellsBurned, 79981276744199058590);
//         emit log_named_uint("startingShells", startingShells);
//     }

//     function testPartialLowerAntiSlippageWithWithdraw0Point0001Dai41Usdc41Usdt1SusdFrom55Dai95Usdc95Usdt15Susd () public {
//         uint256 startingShells = deposit(dai, 55*WAD, usdc, 95*(10**6), usdt, 95*(10**6), susd, 15*WAD);
//         uint256 shellsBurned = withdraw(dai, WAD/10000, usdc, 41*(10**6), usdt, 41*(10**6), susd, WAD);
//         assertEq(shellsBurned, 82981376864951243388);
//         emit log_named_uint("startingShells", startingShells);
//     }

//     function testPartialUpperAntiSlippage0Dai50Usdc0Usdt18SusdFrom90Dai145Usdc90Usdt50Susd () public {
//         uint256 startingShells = deposit(dai, 90*WAD, usdc, 145*(10**6), usdt, 90*(10**6), susd, 50*WAD);
//         uint256 shellsBurned = withdraw(dai, 0, usdc, 50*(10**6), usdt, 0, susd, 18*WAD);
//         assertEq(shellsBurned, 67991384639438932785);
//         emit log_named_uint("startingShells", startingShells);
//     }

//     function testPartialUpperAntiSlippage0Dai50Usdc0Usdt18SusdFrom90Dai145Usdc90Usdt50SusdWITHCUSDC () public {
//         uint256 startingShells = deposit(dai, 45*WAD, usdc, (145*(10**6))/2, usdt, (90*(10**6))/2, susd, 25*WAD);
//         uint256 cusdcOf50Numeraires = IAdapter(cusdcAdapter).viewRawAmount(25*WAD);
//         uint256 shellsBurned = withdraw(dai, 0, cusdc, cusdcOf50Numeraires, usdt, 0, susd, 9*WAD);
//         assertEq(shellsBurned, 33995692319719466392);
//         emit log_named_uint("startingShells", startingShells);
//     }

//     function testFullUpperSlippageNoWithdraw5Dai0Usdc5Usdt0SusdFrom90Dai145Usdc90Usdt50Susd () public {
//         uint256 startingShells = deposit(dai, 90*WAD, usdc, 145*(10**6), usdt, 90*(10**6), susd, 50*WAD);
//         uint256 shellsBurned = withdraw(dai, 5*WAD, usdc, 0, usdt, 5*(10**6), susd, 0);
//         assertEq(shellsBurned, 10069672125594190772);
//         emit log_named_uint("starting shells", startingShells);
//     }

//     function testFullUpperSlippage8Dai2Usdc8Usdt2SusdFrom90Dai145Usdc90Usdt50Susd () public {
//         uint256 startingShells = deposit(dai, 90*WAD, usdc, 145*(10**6), usdt, 90*(10**6), susd, 50*WAD);
//         uint256 viewBurned = viewWithdraw(dai, 8*WAD, usdc, 2*(10**6), usdt, 8*(10**6), susd, 2*WAD);
//         uint256 shellsBurned = withdraw(dai, 8*WAD, usdc, 2*(10**6), usdt, 8*(10**6), susd, 2*WAD);
//         assertEq(shellsBurned, 20085523001309582294);
//         assertEq(shellsBurned, viewBurned);
//         emit log_named_uint("starting shells", startingShells);
//     }

//     function testFullLowerSlippage0Dai1Usdc7Usdt2SusdFrom95Dai95Usdc55Usdt15Susd () public {
//         uint256 startingShells = deposit(dai, 95*WAD, usdc, 95*(10**6), usdt, 55*(10**6), susd, 15*WAD);
//         uint256 shellsBurned = withdraw(dai, 0, usdc, 10**6, usdt, 7*(10**6), susd, 2*WAD);
//         assertEq(shellsBurned, 10131576289851891571);
//     }

//     function testFullLowerAntiSlippageNoWithdraw5Dai5Usdc0Usdt0SusdFrom95Dai95Usdc55Usdt15SusdWITHCHAICUSDC () public {
//         uint256 startingShells = deposit(dai, 95*WAD, usdc, 95*(10**6), usdt, 55*(10**6), susd, 15*WAD);
//         uint256 chaiOf5Numeraire = IAdapter(chaiAdapter).viewRawAmount(5*WAD);
//         uint256 cusdcOf5Numeraire = IAdapter(cusdcAdapter).viewRawAmount(5*WAD);
//         uint256 shellsBurned = withdraw(chai, chaiOf5Numeraire, cusdc, cusdcOf5Numeraire, usdt, 0, susd, 0);
//         assertEq(shellsBurned, 9992948093387737702);
//         emit log_named_uint("startingShells", startingShells);
//     }

//     function testFullLowerAntiSlippageNoWithdraw5Dai5Usdc0Usdt0SusdFrom95Dai95Usdc55Usdt15Susd () public {
//         uint256 startingShells = deposit(dai, 95*WAD, usdc, 95*(10**6), usdt, 55*(10**6), susd, 15*WAD);
//         uint256 shellsBurned = withdraw(dai, 5*WAD, usdc, 5*(10**6), usdt, 0, susd, 0);
//         assertEq(shellsBurned, 9992948093387737702);
//         emit log_named_uint("startingShells", startingShells);
//     }

//     function testFullLowerAntiSlippageWithdraw5Dai5Usdc0Point5Usdt0Point2SusdFrom95Dai95Usdc55Usdt15Susd () public {
//         uint256 startingShells = deposit(dai, 95*WAD, usdc, 95*(10**6), usdt, 55*(10**6), susd, 15*WAD);
//         uint256 shellsBurned = withdraw(dai, 5*WAD, usdc, 5*(10**6), usdt, (10**6)/2, susd, WAD/5);
//         assertEq(shellsBurned, 10694146090744721415);
//         emit log_named_uint("startingShells", startingShells);
//     }

//     function testFullUpperAntiSlippage5Dai2SusdFrom145Dai90Usdc90Usdt50SusdWITHCDAI () public {
//         uint256 startingShells = deposit(dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
//         uint256 cdaiOf5Numeraires = IAdapter(cdaiAdapter).viewRawAmount(5*WAD);
//         uint256 shellsBurned = withdraw(cdai, cdaiOf5Numeraires, usdc, 0, usdt, 0, asusd, 2*WAD);
//         assertEq(shellsBurned, 6994286984194756641);
//         emit log_named_uint("starting shells", startingShells);
//     }

//     function testFullUpperAntiSlippage5Dai2SusdFrom145Dai90Usdc90Usdt50Susd () public {
//         uint256 startingShells = deposit(dai, 145*WAD, usdc, 90*(10**6), usdt, 90*(10**6), susd, 50*WAD);
//         uint256 viewBurned = viewWithdraw(dai, 5*WAD, usdc, 0, usdt, 0, susd, 2*WAD);
//         uint256 shellsBurned = withdraw(dai, 5*WAD, usdc, 0, usdt, 0, susd, 2*WAD);
//         assertEq(shellsBurned, 6994286984194756641);
//         assertEq(shellsBurned, viewBurned);
//         emit log_named_uint("starting shells", startingShells);
//     }

//     function testMegaWithdrawDirectUpperToLower95Usdt35SusdFrom90Dai90Usdc145Usdt50Susd () public {
//         uint256 startingShells = deposit(dai, 90*WAD, usdc, 90*(10**6), usdt, 145*(10**6), susd, 50*WAD);
//         uint256 g1 = gasleft();
//         uint256 shellsBurned = withdraw(dai, 0, usdc, 0, usdt, 95*(10**6), susd, 35*WAD);
//         uint256 g2 = gasleft();
//         assertEq(shellsBurned, 130039163869573249706);
//         emit log_named_uint("starting shells", startingShells);
//         emit log_named_uint("withdraw gas", g1-g2);
//     }

//     function testMegaWithdrawIndirectLowerToUpperNoWithdraw11Dai74Usdc74UsdtFrom55Dai95Usdc95Usdt15Susd () public {
//         deposit(dai, 55*WAD, usdc, 95*(10**6), usdt, 95*(10**6), susd, 15*WAD);
//         uint256 shellsMinted = withdraw(dai, 11*WAD, usdc, 74*(10**6), usdt, 74*(10**6), susd, 0);
//         assertEq(shellsMinted, 159105703117593955184);
//     }

//     function testMegaWithdrawIndirectLowerToUpper11Dai74Usdc74Usdt0Point0001From55Dai95Usdc95Usdt15Susd () public {
//         uint256 startingShells = deposit(dai, 55*WAD, usdc, 95*(10**6), usdt, 95*(10**6), susd, 15*WAD);
//         uint256 viewBurned = viewWithdraw(dai, 11*WAD, usdc, 74*(10**6), usdt, 74*(10**6), susd, WAD/10000);
//         uint256 shellsBurned = withdraw(dai, 11*WAD, usdc, 74*(10**6), usdt, 74*(10**6), susd, WAD/10000);
//         assertEq(shellsBurned, 159105800203612160910);
//         assertEq(shellsBurned, viewBurned);
//         emit log_named_uint("startingShells", startingShells);
//     }

//     function testFailDepositUpperHaltCheck30Pct () public {
//         deposit(dai, 100*WAD, usdc, 90*(10**6), usdt, 80*(10**6), susd, 30*WAD);
//         withdraw(dai, 95*WAD, usdc, 0, usdt, 75*(10**6), susd, 27*WAD);
//     }

//     function testFailDepositLowerHaltCheck30Pct () public {
//         deposit(dai, 90*WAD, usdc, 90*(10**6), usdt, 65*(10**6), susd, 30*WAD);
//         withdraw(dai, 0, usdc, 0, usdt, 50*(10**6), susd, 0);
//     }

//     function testFailDepostUpperHaltCheck10Pct () public {
//         deposit(dai, 80*WAD, usdc, 110*(10**6), usdt, 80*(10**6), susd, 30*WAD);
//         withdraw(dai, 75*WAD, usdc, 105*(10**6), usdt, 75*(10**6), susd, 0);
//     }

//     function testFailDepositLowerHaltCheck10Pct () public {
//         deposit(dai, 90*WAD, usdc, 90*(10**6), usdt, 80*(10**6), susd, 40*WAD);
//         withdraw(dai, 0, usdc, 0, usdt, 0, susd, 30*WAD);
//     }

//     function testProportionalWithdrawFromModeratelyUnbalancedShell () public {
//         deposit(dai, 80*WAD, usdc, 100*(10**6), usdt, 85*(10**6), susd, 35*WAD);
//         uint256 startingShells = l1.balanceOf(address(this));
//         uint256[] memory withdrawals = l1.proportionalWithdraw(150*WAD);
//         uint256 endingShells = l1.balanceOf(address(this));
//         assertEq(withdrawals[0], 39999999999959671960);
//         assertEq(withdrawals[1], 50000000);
//         assertEq(withdrawals[2], 42500000);
//         assertEq(withdrawals[3], 17500000000000000000);
//         assertEq(startingShells - endingShells, 150*WAD);
//     }
    
//     function testProportionalWithdrawFromUnbalancedShell () public {
//         deposit(dai, 55*WAD, usdc, 90*(10**6), usdt, 125*(10**6), susd, 30*WAD);
//         uint256 startingShells = l1.balanceOf(address(this));
//         uint256[] memory withdrawals = l1.proportionalWithdraw(150*WAD);
//         uint256 endingShells = l1.balanceOf(address(this));
//         assertEq(withdrawals[0], 27531865585159300387);
//         assertEq(withdrawals[1], 45052144);
//         assertEq(withdrawals[2], 62572421);
//         assertEq(withdrawals[3], 15017381228273464650);
//         assertEq(startingShells - endingShells, 150*WAD);
//     }

// }