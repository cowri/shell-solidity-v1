// pragma solidity ^0.5.6;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../loihiSetup.sol";
// import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
// import "../../interfaces/IAdapter.sol";

// contract CUsdcAdapterTest is LoihiSetup, DSMath, DSTest {

//     function setUp() public {
//         setupAdapters();
//         setupFlavors();
//     }

//     function testGetRawAndNumeraireAmount () public {
//         uint256 daiBalance = IERC20(dai).balanceOf(address(this));
//         uint256 adptrNumeraireAmt = IAdapter(daiAdapter).getNumeraireAmount(daiBalance);
//         uint256 adptrRawAmt = IAdapter(daiAdapter).getRawAmount(adptrNumeraireAmt);
//         assertEq(adptrNumeraireAmt, daiBalance);
//         assertEq(adptrRawAmt, daiBalance);
//     }

//     function testViewRawAndNumeraireAmount () public {
//         uint256 daiBalance = IERC20(dai).balanceOf(address(this));
//         uint256 adptrNumeraireAmt = IAdapter(daiAdapter).viewNumeraireAmount(daiBalance);
//         uint256 adptrRawAmt = IAdapter(daiAdapter).viewRawAmount(adptrNumeraireAmt);
//         assertEq(adptrNumeraireAmt, daiBalance);
//         assertEq(adptrRawAmt, daiBalance);
//     }

// }