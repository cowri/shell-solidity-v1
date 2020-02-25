// pragma solidity ^0.5.6;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../loihiSetup.sol";
// import "../../interfaces/IIntefaces/IAdapter.sol";

// contract CUsdcAdapterTest is LoihiSetup, DSMath, DSTest {

//     function setUp() public {
//         setupAdapters();
//         setupFlavors();
//     }

//     function testGetRawAndNumeraireAmount () public {
//         uint256 cusdcBalance = ICToken(cusdc).balanceOf(address(this));
//         uint256 usdcBalance = ICToken(cusdc).balanceOfUnderlying(address(this));

//         uint256 adptrUsdcAmt = IAdapter(cusdcAdapter).getNumeraireAmount(cusdcBalance);
//         uint256 adptrCUsdcAmt = IAdapter(cusdcAdapter).getRawAmount(adptrUsdcAmt);

//         assertEq(usdcBalance / 10, adptrUsdcAmt / (10 ** 13));
//         assertEq(adptrCUsdcAmt / 10000, cusdcBalance / 10000);
//     }

//     function testViewRawAndNumeraireAmount () public {
//         uint256 cusdcBalance = ICToken(cusdc).balanceOf(address(this));
//         uint256 usdcBalance = ICToken(cusdc).balanceOfUnderlying(address(this));

//         uint256 adptrUsdcAmt = IAdapter(cusdcAdapter).viewNumeraireAmount(cusdcBalance);
//         uint256 adptrCUsdcAmt = IAdapter(cusdcAdapter).viewRawAmount(adptrUsdcAmt);

//         assertEq(usdcBalance / 10, adptrUsdcAmt / (10 ** 13));
//         assertEq(adptrCUsdcAmt / 10000, cusdcBalance / 10000);
//     }

// }