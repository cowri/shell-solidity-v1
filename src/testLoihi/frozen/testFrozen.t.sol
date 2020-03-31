// pragma solidity ^0.5.15;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../loihiSetup.sol";

// contract LoihiTest is LoihiSetup, DSMath, DSTest {

//     function setUp() public {

//         setupLoihi();
//         setupFlavors();
//         setupAdapters();
//         approveFlavors();
//         executeApprovals();
//         includeAdapters(0);

//     }

//     function testFailFrozen () public {

//         l1.freeze(true);
//         uint256 mintedShells = l1.proportionalDeposit(100 * (10 ** 18));

//     }

//     function testUnfreeze () public {

//         l1.freeze(true);
//         l1.freeze(false);
//         uint256 mintedShells = l1.proportionalDeposit(100 * (10 ** 18));

//     }

// }