// pragma solidity ^0.5.6;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../loihiSetup.sol";
// import "../../adapters/kovan/kovanCUsdcAdapter.sol";
// import "../../IChai.sol";
// import "../../IPot.sol";

// contract CUsdcAdapterTest is LoihiSetup, DSMath, DSTest {

//     KovanCUsdcAdapter cusdcAdptr;

//     function setUp() public {
//         setupFlavors();
//         cusdcAdptr = new KovanCUsdcAdapter();
//     }

//     function testGetRawAndNumeraireAmount () public {
//         uint256 cusdcBalance = ICToken(cusdc).balanceOf(address(this));
//         uint256 usdcBalance = ICToken(cusdc).balanceOfUnderlying(address(this));

//         uint256 adptrUsdcAmt = cusdcAdptr.getNumeraireAmount(cusdcBalance);
//         uint256 adptrCUsdcAmt = cusdcAdptr.getRawAmount(adptrUsdcAmt);

//         assertEq(usdcBalance / 10, adptrUsdcAmt / (10 ** 13));
//         assertEq(adptrCUsdcAmt / 10000, cusdcBalance / 10000);
//     }

//     function testViewRawAndNumeraireAmount () public {
//         uint256 cusdcBalance = ICToken(cusdc).balanceOf(address(this));
//         uint256 usdcBalance = ICToken(cusdc).balanceOfUnderlying(address(this));

//         uint256 adptrUsdcAmt = cusdcAdptr.viewNumeraireAmount(cusdcBalance);
//         uint256 adptrCUsdcAmt = cusdcAdptr.viewRawAmount(adptrUsdcAmt);

//         assertEq(usdcBalance / 10, adptrUsdcAmt / (10 ** 13));
//         assertEq(adptrCUsdcAmt / 10000, cusdcBalance / 10000);
//     }

// }