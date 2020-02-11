// pragma solidity ^0.5.6;

// import "ds-test/test.sol";
// import "ds-math/math.sol";
// import "./sandbox.sol";
// import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
// import "../adapters/kovan/kovanUsdtAdapter.sol";
// import "../adapters/kovan/kovanUsdcAdapter.sol";
// import "../adapters/kovan/kovanCUsdcAdapter.sol";
// import "../adapters/kovan/kovanCDaiAdapter.sol";
// import "../adapters/kovan/kovanDaiAdapter.sol";
// import "../adapters/kovan/kovanChaiAdapter.sol";

// interface I {
//     function outputRaw (address addr, uint256 amt) external;
// }


// contract SandboxTest is DSMath, DSTest {
//     Sandbox sandbox;
//     address kusdc;
//     address kdai;
//     address kcdai;
//     address kchai;
//     address kusdt;
//     address kcusdc;

//     event log_bytes(bytes32, bytes4);
//     function setUp() public { 
//         sandbox = new Sandbox();
//         kusdc = address(new KovanUsdcAdapter());
//         kdai = address(new KovanDaiAdapter());
//         kcdai = address(new KovanCDaiAdapter());
//         kchai = address(new KovanChaiAdapter());
//         kusdt = address(new KovanUsdtAdapter());
//         kcusdc = address(new KovanCUsdcAdapter());
//     }

//     function testERC () public {
//         KovanUsdcAdapter i;

//         (bool success, bytes memory result) = kusdt.delegatecall(abi.encodeWithSelector(0x10df6430)); // encoded selector of "getNumeraireBalance()";
//         uint256 balance = abi.decode(result, (uint256));
//         emit log_named_uint("balance", balance);



//     }

// }