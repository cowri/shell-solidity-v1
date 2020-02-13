// pragma solidity ^0.5.6;

// import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
// import "openzeppelin-contracts/contracts/token/ERC20/SafeERC20.sol";
// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "../adapters/kovan/kovanUsdtAdapter.sol";
// import "../adapters/kovan/kovanUsdcAdapter.sol";
// import "../adapters/kovan/kovanCUsdcAdapter.sol";
// import "../adapters/kovan/kovanCDaiAdapter.sol";
// import "../adapters/kovan/kovanDaiAdapter.sol";
// import "../adapters/kovan/kovanChaiAdapter.sol";
// import "./FlavorBrain.sol";

// contract FlavorBrainTest is DSMath, DSTest {
//     FlavorBrain fb;

//     function setUp() public {
//         fb = new FlavorBrain();
//         IERC20(0xe7bc397DBd069fC7d0109C0636d06888bb50668c).transfer(address(fb), 50*(10**8));
//         IERC20(0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35).transfer(address(fb), 50*(10**8));
//         IERC20(0x1886b2763b26C45c8DE3e4ccc2bbD02578f9e62D).transfer(address(fb), 50*(10**8));
//         address kusdc = address(new KovanUsdcAdapter());
//         address kusdt = address(new KovanUsdtAdapter());
//         address kdai = address(new KovanDaiAdapter());
//         address kcdai = address(new KovanCDaiAdapter());
//         address kchai = address(new KovanChaiAdapter());
//         address kcusdc = address(new KovanCUsdcAdapter());
        
//         uint256 weight = WAD / 3;
//         // cdai
//         fb.includeFlavor(0xe7bc397DBd069fC7d0109C0636d06888bb50668c, kcdai, kcdai, weight);
//         // chai
//         fb.includeFlavor(0xB641957b6c29310926110848dB2d464C8C3c3f38, kchai, kcdai, weight);
//         // dai
//         fb.includeFlavor(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa, kdai, kcdai, weight);
//         // cusdc
//         fb.includeFlavor(0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35, kcusdc, kcusdc, weight);
//         // usdc
//         fb.includeFlavor(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF, kusdc, kcusdc, weight);
//         // usdt 
//         fb.includeFlavor(0x1886b2763b26C45c8DE3e4ccc2bbD02578f9e62D, kusdt, kusdt, weight);


//     }

//     function testNest () public {
//         uint256 bal = fb.viewBalNest(0xe7bc397DBd069fC7d0109C0636d06888bb50668c);
//     }

//     function testBrainCDai () public {
//         uint256 bal = fb.viewBalance(0xe7bc397DBd069fC7d0109C0636d06888bb50668c);
//         emit log_named_address("FB", address(fb));
//         emit log_named_address("me from test", address(this));
//         emit log_named_uint("cdai", bal);
//         assertTrue(false);
//     }

//     function testBrainChai () public {
//         uint256 bal = fb.viewBalance(0xB641957b6c29310926110848dB2d464C8C3c3f38);
//         emit log_named_uint("chai", bal);
//         assertTrue(false);
//     }

//     function testBrainCUsdc () public {
//         uint256 bal = fb.viewBalance(0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35);
//         emit log_named_uint("cusdc bal", bal);
//         assertTrue(false);
//     }

//     function testBrainDai () public {
//         uint256 bal = fb.viewBalance(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa);
//         emit log_named_uint("dai bal", bal);
//         assertTrue(false);
//     }

//     function testBrainUsdc () public {
//         uint256 bal = fb.viewBalance(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF);
//         emit log_named_uint("usdc bal", bal);
//         assertTrue(false);
//     }

//     function testBrainUsdt () public {
//         uint256 bal = fb.viewBalance(0x1886b2763b26C45c8DE3e4ccc2bbD02578f9e62D);
//         emit log_named_uint("usdt bal", bal);
//         assertTrue(false);
//     }

// }