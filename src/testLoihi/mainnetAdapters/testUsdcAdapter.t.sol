// pragma solidity ^0.5.6;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../loihiSetup.sol";
// import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
// import "../../IAdapter.sol";

// contract CUsdcAdapterTest is LoihiSetup, DSMath, DSTest {

//     function setUp() public {
//         setupAdapters();
//         setupFlavors();
//     }

//     function testGetRawAndNumeraireAmount () public {
//         uint256 usdcBalance = IERC20(usdc).balanceOf(address(this));
//         uint256 adptrNumeraireAmt = IAdapter(usdcAdapter).getNumeraireAmount(usdcBalance);
//         uint256 adptrRawAmt = IAdapter(usdcAdapter).getRawAmount(adptrNumeraireAmt);
//         assertEq(adptrNumeraireAmt, usdcBalance * (10**12));
//         assertEq(adptrRawAmt, usdcBalance);
//     }

//     function testViewRawAndNumeraireAmount () public {
//         uint256 usdcBalance = IERC20(usdc).balanceOf(address(this));
//         uint256 adptrNumeraireAmt = IAdapter(usdcAdapter).viewNumeraireAmount(usdcBalance);
//         uint256 adptrRawAmt = IAdapter(usdcAdapter).viewRawAmount(adptrNumeraireAmt);
//         assertEq(adptrNumeraireAmt, usdcBalance * (10**12));
//         assertEq(adptrRawAmt, usdcBalance);
//     }

// }