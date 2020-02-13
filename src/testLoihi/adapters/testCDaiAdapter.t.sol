// pragma solidity ^0.5.6;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../loihiSetup.sol";
// import "../../adapters/kovan/kovanCDaiAdapter.sol";
// import "../../IChai.sol";
// import "../../IPot.sol";

// contract CDaiAdapterTest is LoihiSetup, DSMath, DSTest {

//     KovanCDaiAdapter cdaiAdptr;

//     function setUp() public {
//         setupFlavors();
//         cdaiAdptr = new KovanCDaiAdapter();
//     }

//     function testViewRawAndNumeraireAmount () public {
//         uint256 cdaiBalance = ICToken(cdai).balanceOf(address(this));
//         uint256 daiBalance = ICToken(cdai).balanceOfUnderlying(address(this));
//         uint256 adptrDaiAmt = cdaiAdptr.viewNumeraireAmount(cdaiBalance);
//         uint256 adptrCDaiAmt = cdaiAdptr.viewRawAmount(adptrDaiAmt);

//         emit log_named_uint("daiBalance", daiBalance);
//         emit log_named_uint("adptrDaiAmt", adptrDaiAmt);

//         emit log_named_uint("cdaiBalance", cdaiBalance);
//         emit log_named_uint("adptrCDaiAmt", adptrCDaiAmt);

//         assertEq(adptrCDaiAmt / 100, cdaiBalance / 100);
//         assertEq(adptrDaiAmt / 100, daiBalance / 100);
//     }

//     function testGetRawAndNumeraireAmount () public {
//         uint256 cdaiBalance = ICToken(cdai).balanceOf(address(this));
//         uint256 daiBalance = ICToken(cdai).balanceOfUnderlying(address(this));
//         uint256 adptrDaiAmt = cdaiAdptr.getNumeraireAmount(cdaiBalance);
//         uint256 adptrCDaiAmt = cdaiAdptr.getRawAmount(adptrDaiAmt);

//         emit log_named_uint("daiBalance", daiBalance);
//         emit log_named_uint("adptrDaiAmt", adptrDaiAmt);

//         emit log_named_uint("cdaiBalance", cdaiBalance);
//         emit log_named_uint("adptrCDaiAmt", adptrCDaiAmt);

//         assertEq(adptrCDaiAmt / 100, cdaiBalance / 100);
//         assertEq(adptrDaiAmt / 100, daiBalance / 100);
//     }
// }