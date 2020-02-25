// pragma solidity ^0.5.6;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../loihiSetup.sol";
// import "../../interfaces/IChai.sol";
// import "../../interfaces/IAdapter.sol";

// contract ChaiAdapterTest is LoihiSetup, DSMath, DSTest {

//     function setUp() public {
//         setupAdapters();
//         setupFlavors();
//     }

//     function testGetRawAndNumeraireAmount () public {
//         uint256 chaiBalance = IChai(chai).balanceOf(address(this));
//         uint256 daiBalance = IChai(chai).dai(address(this));
//         uint256 adptrDaiAmt = IAdapter(chaiAdapter).getNumeraireAmount(chaiBalance);
//         uint256 adptrChaiAmt = IAdapter(chaiAdapter).getRawAmount(adptrDaiAmt);
//         assertEq(chaiBalance, adptrChaiAmt);
//         assertEq(daiBalance, adptrDaiAmt);
//     }

//     function testViewRawAndNumeraireAmount () public {
//         uint256 chaiBalance = IChai(chai).balanceOf(address(this));
//         uint256 daiBalance = IChai(chai).dai(address(this));
//         uint256 adptrDaiAmt = IAdapter(chaiAdapter).viewNumeraireAmount(chaiBalance);
//         uint256 adptrChaiAmt = IAdapter(chaiAdapter).viewRawAmount(adptrDaiAmt);
//         assertEq(chaiBalance, adptrChaiAmt);
//         assertEq(daiBalance, adptrDaiAmt);
//     }

// }