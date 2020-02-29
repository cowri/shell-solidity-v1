pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../../loihiSetup.sol";
import "../../../interfaces/IAdapter.sol";

contract SelectiveDepositTest is LoihiSetup, DSMath, DSTest {

    function setUp() public {

        setupFlavors();
        setupAdapters();
        setupLoihi();
        approveFlavors(address(l));
        executeLoihiApprovals(address(l));
        includeAdapters(address(l), 0);

    }

    function setReserveState (address waddr, uint256 wamount, address xaddr, uint256 xamount, address yaddr, uint256 yamount, address zaddr, uint256 zamount) public returns (uint256) {
        address[] memory addrs = new address[](4);
        uint256[] memory amounts = new uint256[](4);

        addrs[0] = waddr; amounts[0] = wamount;
        addrs[1] = xaddr; amounts[1] = xamount;
        addrs[2] = yaddr; amounts[2] = yamount;
        addrs[3] = zaddr; amounts[3] = zamount;

        return l.selectiveDeposit(addrs, amounts, 0, now + 500);
    }


    // function testNoFee10Dai10Usdc10Usdt2Point5Susd () public {

    //     uint256 initialShells = l.proportionalDeposit(300 * (10 ** 18));

    //     uint256[] memory amounts = new uint256[](4);
    //     address[] memory tokens = new address[](4);

    //     tokens[0] = dai; amounts[0] = 10 * WAD;
    //     tokens[1] = usdc; amounts[1] = 10 * (10**6);
    //     tokens[2] = usdt; amounts[2] = 10 * (10**6);
    //     tokens[3] = susd; amounts[3] = 2500000000000000000;

    //     uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);
    //     newShells /= 10000000000;
    //     assertEq(newShells, 32500000);

    // }

    // function testPartialFee75Dai0x0y20Susd () public {

    //     uint256 initialShells = l.proportionalDeposit(300*WAD);

    //     uint256[] memory amounts = new uint256[](2);
    //     address[] memory tokens = new address[](2);

    //     tokens[0] = dai; amounts[0] = 75 * WAD;
    //     tokens[1] = susd; amounts[1] = 20 * WAD;

    //     uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);

    //     assertEq(newShells / (10**12), 94758702);

    // }

    // function testFullFee0w0x3Usdt1Susd () public {

    //     uint256 initialShells = setReserveState(dai, 90*WAD, usdc, 90*(10**6), usdt, 145*(10**6), susd, 50*WAD);

    //     uint256[] memory amounts = new uint256[](2);
    //     address[] memory tokens = new address[](2);

    //     tokens[0] = usdt; amounts[0] = 3 * (10**6);
    //     tokens[1] = susd; amounts[1] = WAD;

    //     uint256 newShells = l.selectiveDeposit(tokens, amounts, 0, now + 500);

    //     assertEq(newShells / (10**10), 397447766);

    //     emit log_named_uint("initial shells", initialShells);

    // }

    event log_uints(bytes32, uint256[]);


    // function testHaltCheckThirty0w9Usdc0y17Point7z () public {
    //     uint256[] memory amounts = new uint256[](1);
    //     address[] memory tokens = new address[](1);

    //     tokens[0] = susd; amounts[0] = 17700000000000000000;

    //     (bool success, bytes memory result) = address(l).call(
    //         abi.encodeWithSelector(l.selectiveDeposit.selector, tokens, amounts, 0, now + 500)
    //     );

    //     assertTrue(!success);
    // }

    // function testHaltCheckThirty0w83Usdc0y0z () public {
    //     uint256[] memory amounts = new uint256[](1);
    //     address[] memory tokens = new address[](1);

    //     tokens[0] = usdc; amounts[0] = 83 * (10**6);

    //     (bool success, bytes memory result) = address(l).call(
    //         abi.encodeWithSelector(l.selectiveDeposit.selector, tokens, amounts, 0, now + 500)
    //     );

    //     assertTrue(!success);
    // }

}