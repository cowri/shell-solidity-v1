// pragma solidity ^0.5.15;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../loihiSetup.sol";
// import "../flavorsSetup.sol";
// import "../../interfaces/Intefaces/IAdapter.sol";
// import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

// contract LoihiTest is LoihiSetup, DSMath, DSTest {

//     function setUp() public {

//         setupFlavors();
//         setupAdapters();
//         setupLoihi();
//         executeApprovals(address(l));

//     }

//     function testExecuteApprovals () public {

//         // address[] memory targets = new address[](5);
//         // address[] memory spenders = new address[](5);

//         // targets[0] = dai;
//         // spenders[0] = chai;

//         // targets[1] = dai;
//         // spenders[1] = cdai;

//         // targets[2] = susd;
//         // spenders[2] = 0x3dfd23A6c5E8BbcFc9581d2E864a68feb6a076d3;

//         // targets[3] = usdc;
//         // spenders[3] = cusdc;

//         // targets[4] = usdt;
//         // spenders[4] = 0x3dfd23A6c5E8BbcFc9581d2E864a68feb6a076d3;

//         // l.executeApprovals(targets, spenders);

//         uint256 chaiAllowance = IERC20(dai).allowance(address(l), chai);

//         uint256 cdaiAllowance = IERC20(dai).allowance(address(l), cdai);

//         uint256 susdAllowance = IERC20(susd).allowance(address(l), aaveLpCore);

//         uint256 cusdcAllowance = IERC20(usdc).allowance(address(l), cusdc);

//         uint256 usdtAllowance = IERC20(usdt).allowance(address(l), aaveLpCore);

//         assertEq(chaiAllowance, uint256(-1));
//         assertEq(cdaiAllowance, uint256(-1));
//         assertEq(susdAllowance, uint256(-1));
//         assertEq(cusdcAllowance, uint256(-1));
//         assertEq(usdtAllowance, uint256(-1));

//     }

// }