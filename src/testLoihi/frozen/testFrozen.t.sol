// pragma solidity ^0.5.15;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../loihiSetup.sol";
// import "../flavorsSetup.sol";
// import "../../interfaces/Intefaces/IAdapter.sol";

// contract LoihiTest is LoihiSetup, DSMath, DSTest {

//     function setUp() public {

//         setupFlavors();
//         setupAdapters();
//         setupLoihi();
//         approveFlavors(address(l));
//         includeAdapters(address(l), 1);

//     }

//     function testFailFrozen () public {

//         l.freeze(true);
//         uint256 mintedShells = l.proportionalDeposit(100 * (10 ** 18));

//     }

// }