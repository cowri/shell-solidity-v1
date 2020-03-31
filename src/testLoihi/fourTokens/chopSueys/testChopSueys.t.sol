
// pragma solidity ^0.5.6;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../../loihiSetup.sol";
// import "../../../interfaces/IAdapter.sol";

// contract ChopSueyTest is LoihiSetup, DSMath, DSTest {

//     function setUp() public {

//         setupLoihi();
//         setupFlavors();
//         setupAdapters();
//         approveFlavors();
//         executeApprovals();
//         includeAdapters(0);

//     }

//     function withdraw (uint256 _type, address waddr, uint256 wamount, address xaddr, uint256 xamount, address yaddr, uint256 yamount, address zaddr, uint256 zamount) public returns (uint256) {
//         address[] memory addrs = new address[](4);
//         uint256[] memory amounts = new uint256[](4);

//         addrs[0] = waddr; amounts[0] = wamount;
//         addrs[1] = xaddr; amounts[1] = xamount;
//         addrs[2] = yaddr; amounts[2] = yamount;
//         addrs[3] = zaddr; amounts[3] = zamount;

//         if (_type == 1) return l1.selectiveWithdraw(addrs, amounts, 50000*WAD, now + 500);
//         if (_type == 2) return l2.selectiveWithdraw(addrs, amounts, 50000*WAD, now + 500);
//     }

//     function deposit (uint256 _type, address waddr, uint256 wamount, address xaddr, uint256 xamount, address yaddr, uint256 yamount, address zaddr, uint256 zamount) public returns (uint256) {
//         address[] memory addrs = new address[](4);
//         uint256[] memory amounts = new uint256[](4);

//         addrs[0] = waddr; amounts[0] = wamount;
//         addrs[1] = xaddr; amounts[1] = xamount;
//         addrs[2] = yaddr; amounts[2] = yamount;
//         addrs[3] = zaddr; amounts[3] = zamount;

//         if (_type == 1) return l1.selectiveDeposit(addrs, amounts, 0, now + 500);
//         if (_type == 2) return l2.selectiveDeposit(addrs, amounts, 0, now + 500);
//     }

//     uint256 constant DOT = 10**6;

//     function testChopSuey1 () public {

//         uint256 shells1 = deposit(1, dai, (55*WAD)/2, usdc, 45*DOT, usdt, (125*DOT)/2, susd, 15*WAD);
//         uint256[] memory withdraw1 = l1.proportionalWithdraw(shells1);
//         uint256 shells2 = l1.proportionalDeposit(300*WAD);
//         // uint256[] memory withdraw2 = l1.proportionalWithdraw(shells2);
//         // uint256 shells3 = deposit(1, dai, 30*WAD, usdc, 60*DOT, usdt, 60*DOT, susd, 15*WAD);
//         // uint256 shells4 = withdraw(1, dai, 10*WAD, usdc, 20*DOT, usdt, 20*DOT, susd, 5*WAD);
//         // uint256 shells5 = deposit(1, dai, 5*WAD, usdc, 5*DOT, usdt, 0, susd, 0);
//         // uint256 target1 = l1.swapByOrigin(usdc, dai, 5*DOT, 0, now + 50);
//         // uint256 origin1 = l1.swapByTarget(dai, usdc, 50*WAD, 20*DOT, now + 50);
//         // uint256 target2 = l1.swapByOrigin(usdt, susd, (5*DOT)/2, 0, now + 50);
//         // uint256 shells6 = withdraw(1, dai, 0, usdc, 0, usdt, (45*DOT)/2, susd, 0);
//         // uint256 shells7 = l1.proportionalDeposit((39*WAD)/2);
//         // uint256[] memory preLastWithdraw = new uint256[](4);
//         // preLastWithdraw[0] = IAdapter(daiAdapter).viewNumeraireBalance(address(l1));
//         // preLastWithdraw[1] = IAdapter(usdcAdapter).viewNumeraireBalance(address(l1));
//         // preLastWithdraw[2] = IAdapter(usdtAdapter).viewNumeraireBalance(address(l1));
//         // preLastWithdraw[3] = IAdapter(susdAdapter).viewNumeraireBalance(address(l1));
//         // uint256[] memory withdraw3 = l1.proportionalWithdraw(l1.balanceOf(address(this)));

//         emit log_named_uint("shells1", shells1);
//         emit log_named_uint("withdraw1[0]", withdraw1[0]);
//         emit log_named_uint("withdraw1[1]", withdraw1[1]);
//         emit log_named_uint("withdraw1[2]", withdraw1[2]);
//         emit log_named_uint("withdraw1[3]", withdraw1[3]);
//         emit log_named_uint("shells2", shells2);
//         // emit log_named_uint("withdraw2[0]", withdraw2[0]);
//         // emit log_named_uint("withdraw2[1]", withdraw2[1]);
//         // emit log_named_uint("withdraw2[2]", withdraw2[2]);
//         // emit log_named_uint("withdraw2[3]", withdraw2[3]);
//         // emit log_named_uint("shells3", shells3);
//         // emit log_named_uint("shells4", shells4);
//         // emit log_named_uint("shells5", shells5);
//         // emit log_named_uint("target1", target1);
//         // emit log_named_uint("origin1", origin1);
//         // emit log_named_uint("target2", target2);
//         // emit log_named_uint("shells6", shells6);
//         // emit log_named_uint("shells7", shells7);
//         // emit log_named_uint("preLastWithdraw[0]", preLastWithdraw[0]);
//         // emit log_named_uint("preLastWithdraw[1]", preLastWithdraw[1]);
//         // emit log_named_uint("preLastWithdraw[2]", preLastWithdraw[2]);
//         // emit log_named_uint("preLastWithdraw[3]", preLastWithdraw[3]);
//         // emit log_named_uint("withdraw3[0]", withdraw3[0]);
//         // emit log_named_uint("withdraw3[1]", withdraw3[1]);
//         // emit log_named_uint("withdraw3[2]", withdraw3[2]);
//         // emit log_named_uint("withdraw3[3]", withdraw3[3]);


//     }

// }