// pragma solidity ^0.5.15;

// import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../../loihiSetup.sol";

// contract TestProportionalWithdraw is LoihiSetup, DSMath, DSTest {

//     event log_uints(bytes32, uint256[]);

//     function setUp() public {
        
//         setupFlavors();
//         setupAdapters();
//         setupLoihi();
//         approveFlavors(address(l));
//         executeLoihiApprovals(address(l));
//         includeAdapters(address(l), 1);


//     }

//     // function testBalancedProportionalWithdraw300 () public {

//     //     l.proportionalDeposit(300 * (10 ** 18));

//     //     uint256[] memory withdrawals = l.proportionalWithdraw(300 * WAD);
//     //     assertEq(l.totalSupply(), 0);
//     //     assertEq(withdrawals[0] / 10000000000, 9994999999);
//     //     assertEq(withdrawals[1], 99949998);
//     //     assertEq(withdrawals[2], 99949999);

//     // }

//     // function testBalancedProportionalWithdraw150 () public {

//     //     l.proportionalDeposit(300 * (10 ** 18));

//     //     uint256[] memory withdrawals = l.proportionalWithdraw(150 * WAD);
//     //     assertEq(l.totalSupply(), 150000000000000000000);
//     //     assertEq(withdrawals[0] / 10000000000, 4997499999);
//     //     assertEq(withdrawals[1], 49974999);
//     //     assertEq(withdrawals[2], 49974999);

//     // }

//     // function testUnbalancedProportionalWithdraw29Point99 () public {
//     //     uint256[] memory amts = new uint256[](3);
//     //     address[] memory addrs = new address[](3);

//     //     addrs[0] = dai; amts[0] = 70*WAD;
//     //     addrs[1] = usdc; amts[1] = 100*(10**6);
//     //     addrs[2] = usdt; amts[2] = 130*(10**6);

//     //     l.selectiveDeposit(addrs, amts, 0, now+50);

//     //     uint256[] memory withdrawals = l.proportionalWithdraw(29997500000000000000);

//     //     assertEq(withdrawals[0], 6996499999984715388);
//     //     assertEq(withdrawals[1], 9994999);
//     //     assertEq(withdrawals[2], 12993500);
    

//     // }

//     // function testUnbalancedProportionalWithdraw239Point98 () public {
//     //     uint256[] memory amts = new uint256[](3);
//     //     address[] memory addrs = new address[](3);

//     //     addrs[0] = dai; amts[0] = 70*WAD;
//     //     addrs[1] = usdc; amts[1] = 100*(10**6);
//     //     addrs[2] = usdt; amts[2] = 130*(10**6);

//     //     l.selectiveDeposit(addrs, amts, 0, now+50);

//     //     uint256[] memory withdrawals = l.proportionalWithdraw(239980000000000000000);

//     //     assertEq(withdrawals[0], 55971999999969544962);
//     //     assertEq(withdrawals[1], 79959999);
//     //     assertEq(withdrawals[2], 103948000);
    

//     // }

//     function testUnbalancedProportionalWithdraw239Point98 () public {
//         uint256[] memory amts = new uint256[](3);
//         address[] memory addrs = new address[](3);

//         addrs[0] = dai; amts[0] = 70*WAD;
//         addrs[1] = usdc; amts[1] = 100*(10**6);
//         addrs[2] = usdt; amts[2] = 130*(10**6);

//         uint256 shellsMinted = l.selectiveDeposit(addrs, amts, 0, now+50);

//         uint256[] memory withdrawals = l.proportionalWithdraw(shellsMinted);

//         assertEq(withdrawals[0] / (10**10), 6996499999);
//         assertEq(withdrawals[1], 99949999);
//         assertEq(withdrawals[2], 129935000);
//         emit log_named_uint("shellsMinted", shellsMinted);

//         (uint256 totalReserves, uint256[] memory reserves) = l.totalReserves();
//         emit log_named_uint("dai", reserves[0]);
//         emit log_named_uint("usdc", reserves[1]);
//         emit log_named_uint("usdt", reserves[2]);
    

//     }


// }