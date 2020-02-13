// pragma solidity ^0.5.6;

// import "ds-test/test.sol";
// import "ds-math/math.sol";


// import "../LoihiLiquidity.sol";
// import "../LoihiExchange.sol";
// import "../LoihiERC20.sol";

// contract Delegation {
//     address firstDelegate;
//     address secondDelegate;
//     constructor (address first, address second) public {
//         firstDelegate = first;
//         secondDelegate = second;
//     }

//     function delegate () public returns (uint256) {
//         (bool success, bytes memory result) = firstDelegate.delegatecall(abi.encodeWithSelector(0x9fa6dd35, 55));
//         uint256 num = abi.decode(result, (uint256));
//         return num;

//     }

//     function skipFirst () public returns (uint256) {
//         (bool success, bytes memory result) = secondDelegate.delegatecall(abi.encodeWithSelector(0x18e44a49, 88));
//         return 99;
//     }

// }

// contract FirstDelegator {
//     address firstDelegate;
//     address secondDelegate;

//     constructor () public { }

//     function delegate (uint256 number) public returns (uint256) {

//         (bool success, bytes memory result) = secondDelegate.delegatecall(abi.encodeWithSelector(0x18e44a49, number));
//         return 5;
//     }

// }

// contract SecondDelegate {

//     constructor () public {  }

//     event log_uint(bytes32, uint256);
//     function delegated (uint256 number) public {
//         emit log_uint("number", number);
//     }
// }

// contract TestProportionalWithdraw is DSTest {
//     Delegation delegation;

//     event log_uints(bytes32, uint256[]);
//     event log_bytes4(bytes32, bytes4);

//     function setUp() public {


//         // // setupFlavors();
//         // // setupAdapters();
//         // // l = new Loihi(chai, cdai, dai, pot, cusdc, usdc, usdt);
//         // // approveFlavors(address(l));
        
//         // setupFlavors();
//         // setupAdapters();
//         // l = new Loihi(address(0), address(0), address(0), address(0), address(0), address(0), address(0));
//         // approveFlavors(address(l));

//         // uint256 weight = WAD / 3;

//         // l.includeNumeraireAndReserve(dai, cdaiAdapter);
//         // l.includeNumeraireAndReserve(usdc, cusdcAdapter);
//         // l.includeNumeraireAndReserve(usdt, usdtAdapter);

//         // l.includeAdapter(chai, chaiAdapter, cdaiAdapter, weight);
//         // l.includeAdapter(dai, daiAdapter, cdaiAdapter, weight);
//         // l.includeAdapter(cdai, cdaiAdapter, cdaiAdapter, weight);
//         // l.includeAdapter(cusdc, cusdcAdapter, cusdcAdapter, weight);
//         // l.includeAdapter(usdc, usdcAdapter, cusdcAdapter, weight);
//         // l.includeAdapter(usdt, usdtAdapter, usdtAdapter, weight);

//         // l.proportionalDeposit(300 * (10 ** 18));

//         address second = address(new SecondDelegate());
//         emit log_named_address("second!", second);
//         address first = address(new FirstDelegator());
//         delegation = new Delegation(first, second);

        

//     }

//     function testDelegates () public {


//         LoihiLiquidity LL;
//         LoihiExchange LE;
//         LoihiERC20 LERC20;
        
//         emit log_bytes4("execute origin trade", LE.executeOriginTrade.selector);
//         emit log_bytes4("execute target trade", LE.executeTargetTrade.selector);
//         emit log_bytes4("view target trade", LE.viewTargetTrade.selector);
//         emit log_bytes4("view origin trade", LE.viewOriginTrade.selector);
//         emit log_bytes4("selective deposit", LL.selectiveDeposit.selector);
//         emit log_bytes4("selective withdraw", LL.selectiveWithdraw.selector);
//         emit log_bytes4("proportional deposit", LL.proportionalDeposit.selector);
//         emit log_bytes4("proportional withdraw", LL.proportionalWithdraw.selector);

//         emit log_bytes4("transfer ", LERC20.transfer.selector);
//         emit log_bytes4("transfer from", LERC20.transferFrom.selector);
//         emit log_bytes4("approve ", LERC20.approve.selector);
//         // emit log_bytes4("", LL.proportionalWithdraw.selector);

//         // FirstDelegator first;
//         // SecondDelegate second;

//         // // emit log_bytes4("first", first.delegate.selector);
//         // // emit log_bytes4("second", second.delegated.selector);

//         // uint256 result = delegation.skipFirst();
//         // emit log_named_uint("result", result);

//         // uint256 result1 = delegation.delegate();
//         // emit log_named_uint("result1", result1);

//     }


// }