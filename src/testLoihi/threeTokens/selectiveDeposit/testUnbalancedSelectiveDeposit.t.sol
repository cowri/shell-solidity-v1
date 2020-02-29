// pragma solidity ^0.5.6;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../../loihiSetup.sol";
// import "../../../interfaces/IAdapter.sol";
// import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

// contract UnbalancedSelectiveDepositTest is LoihiSetup, DSMath, DSTest {

//     function setUp() public {

//         setupFlavors();
//         setupAdapters();
//         setupLoihi();
//         approveFlavors(address(l));
//         executeLoihiApprovals(address(l));
//         includeAdapters(address(l), 1);

//         address[] memory addr = new address[](3);
//         uint256[] memory amt = new uint256[](3);
//         addr[0] = dai; amt[0] = 70*WAD;
//         addr[1] = usdc; amt[1] = 100*(10**6);
//         addr[2] = usdt; amt[2] = 130*(10**6);

//         uint256 minted = l.selectiveDeposit(addr, amt, 50*WAD, now + 500);

//     }

//     function testUnbalancedSelectiveDeposit0x10y20z () public {
//         uint256 startingShells = l.balanceOf(address(this));
//         (uint256 totalBalanceBefore, uint256[] memory balancesBefore) = l.totalReserves();

//         uint256[] memory amounts = new uint256[](2);
//         address[] memory tokens = new address[](2);

//         tokens[0] = usdc; amounts[0] = 10 * 1000000;
//         tokens[1] = usdt; amounts[1] = 20 * 1000000;

//         uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
//         newShells /= 1000000000000;
//         assertEq(newShells, 29855466);

//         uint256 endingShells = l.balanceOf(address(this));
//         (uint256 totalBalanceAfter, uint256[] memory balancesAfter) = l.totalReserves();

//         emit log_named_uint("startingShells", startingShells);
//         emit log_named_uint("totalBalanceBefore", totalBalanceBefore);
//         emit log_uints("before", balancesBefore);

//         emit log_named_uint("endingShells", endingShells);
//         emit log_named_uint("totalBalanceAfter", totalBalanceAfter);
//         emit log_uints("after", balancesAfter);

//     }
//     // event log_uints(bytes32, uint256[]);

//     function testUnbalancedSelectiveDeposit10x15y0z () public {
//         uint256 startingShells = l.balanceOf(address(this));
//         uint256[] memory amounts = new uint256[](2);
//         address[] memory tokens = new address[](2);

//         tokens[0] = dai; amounts[0] = 10 * WAD;
//         tokens[1] = usdc; amounts[1] = 15 * 1000000;

//         uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
//         newShells /= 1000000000000;
//         assertEq(newShells, 24997916);
//         emit log_named_uint("starting shells", startingShells);
//     }

//     function testUnbalancedSelectiveDeposit10cDai15cUsdc0z () public {
//         uint256 startingShells = l.balanceOf(address(this));
//         uint256[] memory amounts = new uint256[](2);
//         address[] memory tokens = new address[](2);

//         uint256 cdaiAmt = IAdapter(cdaiAdapter).viewRawAmount(10*(10**18));
//         tokens[0] = cdai; amounts[0] = cdaiAmt;

//         uint256 cusdcAmt = IAdapter(cusdcAdapter).viewRawAmount(15*(10**18));
//         tokens[1] = cusdc; amounts[1] = cusdcAmt;

//         uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);

//         newShells /= 1000000000000;
//         assertEq(newShells, 24997916);
//         emit log_named_uint("starting shells", startingShells);
//     }

//     function testUnbalancedSelectiveDeposit10x15y0zChaiCUsdc () public {
//         uint256 startingShells = l.balanceOf(address(this));
//         uint256[] memory amounts = new uint256[](2);
//         address[] memory tokens = new address[](2);

//         uint256 chaiAmt = IAdapter(chaiAdapter).viewRawAmount(10*(10**18));
//         tokens[0] = chai; amounts[0] = chaiAmt;

//         uint256 cusdcAmt = IAdapter(cusdcAdapter).viewRawAmount(15*(10**18));
//         tokens[1] = cusdc; amounts[1] = cusdcAmt;

//         uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);

//         newShells /= 1000000000000;
//         assertEq(newShells, 24997916);
//         emit log_named_uint("starting shells", startingShells);
//     }

//     function testUnbalancedSelectiveDeposit10x15y25zChaiCUsdcUsdt () public {
//         uint256 startingShells = l.balanceOf(address(this));
//         uint256[] memory amounts = new uint256[](3);
//         address[] memory tokens = new address[](3);

//         uint256 chaiAmt = IAdapter(chaiAdapter).viewRawAmount(10*(10**18));
//         tokens[0] = chai; amounts[0] = chaiAmt;

//         uint256 cusdcAmt = IAdapter(cusdcAdapter).viewRawAmount(15*(10**18));
//         tokens[1] = cusdc; amounts[1] = cusdcAmt;

//         tokens[2] = usdt; amounts[2] = 25 * 1000000;

//         uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
//         newShells /= 1000000000000;
//         assertEq(newShells, 49923815);
//         emit log_named_uint("starting shells", startingShells);
//     }

//     function testUnbalancedSelectiveDeposit10x15y25zCDaiUsdtUsdt () public {
//         uint256 startingShells = l.balanceOf(address(this));
//         uint256[] memory amounts = new uint256[](3);
//         address[] memory tokens = new address[](3);

//         uint256 cdaiAmt = IAdapter(cdaiAdapter).viewRawAmount(10*(10**18));
//         tokens[0] = cdai; amounts[0] = cdaiAmt;
//         tokens[1] = usdc; amounts[1] = 15 * 1000000;
//         tokens[2] = usdt; amounts[2] = 25 * 1000000;

//         uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
//         newShells /= 1000000000000;
//         assertEq(newShells, 49923815);
//         emit log_named_uint("starting shells", startingShells);
//     }

//     function testUnbalancedSelectiveDeposit10x15y25z () public {

//         uint256 startingShells = l.balanceOf(address(this));
//         (uint256 totalBalanceBefore, uint256[] memory balancesBefore) = l.totalReserves();

//         uint256[] memory amounts = new uint256[](3);
//         address[] memory tokens = new address[](3);

//         tokens[0] = dai; amounts[0] = 10 * WAD;
//         tokens[1] = usdc; amounts[1] = 15 * 1000000;
//         tokens[2] = usdt; amounts[2] = 25 * 1000000;

//         uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
//         newShells /= 1000000000000;
//         assertEq(newShells, 49923815);


//         uint256 endingShells = l.balanceOf(address(this));
//         (uint256 totalBalanceAfter, uint256[] memory balancesAfter) = l.totalReserves();

//         emit log_named_uint("startingShells", startingShells);
//         emit log_named_uint("totalBalanceBefore", totalBalanceBefore);
//         emit log_uints("before", balancesBefore);

//         emit log_named_uint("endingShells", endingShells);
//         emit log_named_uint("totalBalanceAfter", totalBalanceAfter);
//         emit log_uints("after", balancesAfter);
//     }

//     event log_uints(bytes32, uint256[]);

//     function testFailUnbalancedSelectiveDeposit0x0y100z () public {
//         uint256[] memory amounts = new uint256[](2);
//         address[] memory tokens = new address[](2);

//         tokens[0] = usdc; amounts[0] = 0;
//         tokens[1] = usdt; amounts[1] = 100 * (10**6);

//         uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
//     }

// }