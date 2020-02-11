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

//         emit log_bytes("viewNumeraireBalance", i.viewNumeraireBalance.selector);
//         emit log_bytes("viewNumeraireAmount", i.viewNumeraireAmount.selector);
//         emit log_bytes("viewRawAmount", i.viewRawAmount.selector);

//         (bool success, bytes memory result) = kcdai.delegatecall(abi.encodeWithSelector(0xac969a73, address(this)));
//         uint256 kcdaiNB = abi.decode(result, (uint256));
//         (success, result) = kcdai.delegatecall(abi.encodeWithSelector(0x049ca270, kcdaiNB));
//         uint256 kcdaiB = abi.decode(result, (uint256));
//         (success, result) = kcdai.delegatecall(abi.encodeWithSelector(0xf5e6c0ca, kcdaiB));
//         uint256 daibalance = abi.decode(result, (uint256));

//         (success, result) = kcusdc.delegatecall(abi.encodeWithSelector(0xac969a73, address(this)));
//         uint256 kcusdcNB = abi.decode(result, (uint256));
//         (success, result) = kcusdc.delegatecall(abi.encodeWithSelector(0x049ca270, kcusdcNB));
//         uint256 kcusdcB = abi.decode(result, (uint256));
//         (success, result) = kcusdc.delegatecall(abi.encodeWithSelector(0xf5e6c0ca, kcusdcB));
//         uint256 usdcbalance = abi.decode(result, (uint256));

//         (success, result) = kusdt.delegatecall(abi.encodeWithSelector(0xac969a73, address(this)));
//         uint256 kusdtNB = abi.decode(result, (uint256));
//         (success, result) = kusdt.delegatecall(abi.encodeWithSelector(0x049ca270, kusdtNB));
//         uint256 kusdtB = abi.decode(result, (uint256));
//         (success, result) = kusdt.delegatecall(abi.encodeWithSelector(0xf5e6c0ca, kusdtB));
//         uint256 usdtbalance = abi.decode(result, (uint256));

//         emit logs("----------------------------");
//         emit log_named_uint("cusdc n bal", kcusdcNB);
//         emit log_named_uint("cusdc bal  ", kcusdcB);
//         emit log_named_uint("back usdc n", usdcbalance);
//         emit logs("----------------------------");
//         emit log_named_uint("cdai n bal", kcdaiNB);
//         emit log_named_uint("cdai bal  ", kcdaiB);
//         emit log_named_uint("back cdai n", daibalance);
//         emit logs("----------------------------");
//         emit log_named_uint("usdt n bal", kusdtNB);
//         emit log_named_uint("usdt bal  ", kusdtB);
//         emit log_named_uint("back usdt n", usdtbalance);
//         emit logs("----------------------------");

//     }

// }