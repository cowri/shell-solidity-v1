// pragma solidity ^0.5.16;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../loihiSetup.sol";
// import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
// import "../../IAdapter.sol";

// contract CUsdtAdapterTest is LoihiSetup, DSMath, DSTest {

//     function setUp() public {
//         setupAdapters();
//         setupFlavors();
//     }

//     function testGetRawAndNumeraireAmount () public {
//         uint256 usdtBalance = IERC20(usdt).balanceOf(address(this));
//         uint256 adptrNumeraireAmt = IAdapter(usdtAdapter).getNumeraireAmount(usdtBalance);
//         uint256 adptrRawAmt = IAdapter(usdtAdapter).getRawAmount(adptrNumeraireAmt);
//         assertEq(adptrNumeraireAmt, usdtBalance * (10**12));
//         assertEq(adptrRawAmt, usdtBalance);
//     }

//     function testViewRawAndNumeraireAmount () public {
//         uint256 usdtBalance = IERC20(usdt).balanceOf(address(this));
//         uint256 adptrNumeraireAmt = IAdapter(usdtAdapter).viewNumeraireAmount(usdtBalance);
//         uint256 adptrRawAmt = IAdapter(usdtAdapter).viewRawAmount(adptrNumeraireAmt);
//         assertEq(adptrNumeraireAmt, usdtBalance * (10**12));
//         assertEq(adptrRawAmt, usdtBalance);
//     }

// }