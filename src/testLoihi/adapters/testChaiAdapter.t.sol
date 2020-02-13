// pragma solidity ^0.5.6;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../loihiSetup.sol";
// import "../../adapters/kovan/kovanChaiAdapter.sol";
// import "../../IChai.sol";
// import "../../IPot.sol";

// contract ChaiAdapterTest is LoihiSetup, DSMath, DSTest {

//     KovanChaiAdapter chaiAdptr;

//     function setUp() public {
//         setupFlavors();
//         chaiAdptr = new KovanChaiAdapter();
//     }

//     function testGetRawAndNumeraireAmount () public {
//         uint256 chaiBalance = IChai(chai).balanceOf(address(this));
//         uint256 daiBalance = IChai(chai).dai(address(this));
//         uint256 adptrDaiAmt = chaiAdptr.getNumeraireAmount(chaiBalance);
//         uint256 adptrChaiAmt = chaiAdptr.getRawAmount(adptrDaiAmt);
//         assertEq(chaiBalance, adptrChaiAmt);
//         assertEq(daiBalance, adptrDaiAmt);
//     }

//     function testViewRawAndNumeraireAmount () public {
//         uint256 chaiBalance = IChai(chai).balanceOf(address(this));
//         uint256 daiBalance = IChai(chai).dai(address(this));
//         uint256 adptrDaiAmt = chaiAdptr.viewNumeraireAmount(chaiBalance);
//         uint256 adptrChaiAmt = chaiAdptr.viewRawAmount(adptrDaiAmt);
//         assertEq(chaiBalance, adptrChaiAmt);
//         assertEq(daiBalance, adptrDaiAmt);
//     }

// }