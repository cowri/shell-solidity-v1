pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../../loihiSetup.sol";
import "../../../interfaces/IAdapter.sol";

contract SelectiveWithdrawTest is LoihiSetup, DSMath, DSTest {

    function setUp() public {

        setupFlavors();
        setupAdapters();
        setupLoihi();
        approveFlavors(address(l));
        executeLoihiApprovals(address(l));
        includeAdapters(address(l), 0);


    }

    function setReserveState (address waddr, uint256 wamount, address xaddr, uint256 xamount, address yaddr, uint256 yamount, address zaddr, uint256 zamount) public returns(uint256) {
        address[] memory addrs = new address[](4);
        uint256[] memory amounts = new uint256[](4);

        addrs[0] = waddr; amounts[0] = wamount;
        addrs[1] = xaddr; amounts[1] = xamount;
        addrs[2] = yaddr; amounts[2] = yamount;
        addrs[3] = zaddr; amounts[3] = zamount;

        return l.selectiveDeposit(addrs, amounts, 0, now + 500);
    }

    // function testNoFee10Dai10Usdc10Usdt2Point5Susd () public {

    //     l.proportionalDeposit(300 * (10 ** 18));

    //     uint256[] memory amounts = new uint256[](4);
    //     address[] memory tokens = new address[](4);

    //     tokens[0] = dai; amounts[0] = 10 * WAD;
    //     tokens[1] = usdc; amounts[1] = 10 * (10**6);
    //     tokens[2] = usdt; amounts[2] = 10 * (10**6);
    //     tokens[3] = susd; amounts[3] = 2500000000000000000;

    //     uint256 newShells = l.selectiveWithdraw(tokens, amounts, 500 * WAD, now + 500);
    //     newShells /= 1000000000000;
    //     assertEq(newShells, 32516250);

    // }

    // function testNoFee10Chai10CUsdc10Usdt2Point5Susd () public {

    //     l.proportionalDeposit(300 * (10 ** 18));

    //     uint256[] memory amounts = new uint256[](4);
    //     address[] memory tokens = new address[](4);

    //     uint256 chaiOfTenNumeraire = IAdapter(chaiAdapter).viewRawAmount(10*WAD);
    //     uint256 cusdcOfTenNumeraire = IAdapter(cusdcAdapter).viewRawAmount(10*WAD);

    //     tokens[0] = chai; amounts[0] = chaiOfTenNumeraire;
    //     tokens[1] = cusdc; amounts[1] = cusdcOfTenNumeraire;
    //     tokens[2] = usdt; amounts[2] = 10 * (10**6);
    //     tokens[3] = susd; amounts[3] = 2500000000000000000;

    //     uint256 newShells = l.selectiveWithdraw(tokens, amounts, 500 * WAD, now + 500);
    //     newShells /= 1000000000000;
    //     assertEq(newShells, 32516250);

    // }

    // function testNoFee10Cdai10CUsdc10Usdt2Point5Susd () public {

        // l.proportionalDeposit(300 * (10 ** 18));

        // uint256[] memory amounts = new uint256[](4);
        // address[] memory tokens = new address[](4);

        // uint256 cdaiOfTenNumeraire = IAdapter(cdaiAdapter).viewRawAmount(10*WAD);
        // uint256 cusdcOfTenNumeraire = IAdapter(cusdcAdapter).viewRawAmount(10*WAD);

        // tokens[0] = cdai; amounts[0] = cdaiOfTenNumeraire;
        // tokens[1] = cusdc; amounts[1] = cusdcOfTenNumeraire;
        // tokens[2] = usdt; amounts[2] = 10 * (10**6);
        // tokens[3] = susd; amounts[3] = 2500000000000000000;

        // uint256 newShells = l.selectiveWithdraw(tokens, amounts, 500 * WAD, now + 500);
        // newShells /= 1000000000000;
        // assertEq(newShells, 32516250);

    // }

    // function testPartialFee50Dai0x0y15Susd () public {

    //     l.proportionalDeposit(300 * (10 ** 18));

    //     uint256[] memory amounts = new uint256[](2);
    //     address[] memory tokens = new address[](2);

    //     tokens[0] = dai; amounts[0] = 50 * WAD;
    //     tokens[1] = susd; amounts[1] = 15 * WAD;

    //     uint256 burntShells = l.selectiveWithdraw(tokens, amounts, 500 * WAD, now + 500);
    //     burntShells /= 100000000000;
    //     assertEq(burntShells, 652970827);

    // }

    // function testTotalFee50Dai0x0y15Susd () public {

    //     setReserveState(dai, 95*WAD, usdc, 95*(10**6), usdt, 55*(10**6), susd, 15*WAD);

        // uint256[] memory amounts = new uint256[](2);
        // address[] memory tokens = new address[](2);

        // tokens[0] = usdt; amounts[0] = 3 * (10**6);
        // tokens[1] = susd; amounts[1] = WAD;

        // uint256 burntShells = l.selectiveWithdraw(tokens, amounts, 500 * WAD, now + 500);
        // burntShells /= 100000000000;

        // assertEq(burntShells, 40442086);

    // }


    // function testHaltCheckTen0w0x0y15Point85z () public {

    //     l.proportionalDeposit(300 * (10 ** 18));

    //     uint256[] memory amounts = new uint256[](1);
    //     address[] memory tokens = new address[](1);

    //     tokens[0] = susd; amounts[0] = 15850000000000000000;

    //     (bool success, bytes memory result) = address(l).call(
    //         abi.encodeWithSelector(l.selectiveDeposit.selector, tokens, amounts, 500 * WAD, now + 500)
    //     );

    //     assertTrue(!success);
    // }

    function testTotalFeeSelectiveWithdraw () public {

        l.proportionalDeposit(10*WAD);
        l.proportionalWithdraw(10*WAD);
        uint256 initialShells = setReserveState(dai, 95*WAD, usdc, 95*(10**6), usdt, 55*(10**6), susd, 15*WAD);

        uint256[] memory amts = new uint256[](2);
        address[] memory addrs = new address[](2);

        addrs[0] = usdt; amts[0] = 3 * (10**6);
        addrs[1] = susd; amts[1] = WAD;

        uint256 shellsBurned = l.selectiveWithdraw(addrs, amts, 500 * WAD, now + 50);

        assertEq(shellsBurned, 5);

    }

    // function testHaltCheckThirty0w53Usdc0y0z () public {

    //     setReserveState(dai, 100*WAD, usdc, 80*(10**6), usdt, 90*(10**6), susd, 30*WAD);

    //     uint256[] memory amounts = new uint256[](1);
    //     address[] memory tokens = new address[](1);

    //     tokens[0] = usdc; amounts[0] = 53 * (10**6);

    //     (bool success, bytes memory result) = address(l).call(
    //         abi.encodeWithSelector(l.selectiveWithdraw.selector, tokens, amounts, 500*WAD, now + 500)
    //     );

    //     assertTrue(!success);
    // }

}