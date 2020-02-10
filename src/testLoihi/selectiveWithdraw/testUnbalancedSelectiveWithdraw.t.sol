pragma solidity ^0.5.6;

import "openzeppelin-contracts/contracts/token/ERC20/SafeERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "ds-test/test.sol";
import "ds-math/math.sol";
import "../flavorsSetup.sol";
import "../adaptersSetup.sol";
import "../../Loihi.sol";


contract UnbalancedSelectiveWithdrawTest is AdaptersSetup, DSMath, DSTest {
    Loihi l;

    function setUp() public {

        // setupFlavors();
        // setupAdapters();
        // l = new Loihi(chai, cdai, dai, pot, cusdc, usdc, usdt);
        // approveFlavors(address(l));
        
        setupFlavors();
        setupAdapters();
        l = new Loihi(address(0), address(0), address(0), address(0), address(0), address(0), address(0));
        approveFlavors(address(l));

        uint256 weight = WAD / 3;

        l.includeNumeraireAndReserve(dai, cdaiAdapter);
        l.includeNumeraireAndReserve(usdc, cusdcAdapter);
        l.includeNumeraireAndReserve(usdt, usdtAdapter);

        l.includeAdapter(chai, chaiAdapter, cdaiAdapter, weight);
        l.includeAdapter(dai, daiAdapter, cdaiAdapter, weight);
        l.includeAdapter(cdai, cdaiAdapter, cdaiAdapter, weight);
        l.includeAdapter(cusdc, cusdcAdapter, cusdcAdapter, weight);
        l.includeAdapter(usdc, usdcAdapter, cusdcAdapter, weight);
        l.includeAdapter(usdt, usdtAdapter, usdtAdapter, weight);

        l.setAlpha((5 * WAD) / 10);
        l.setBeta((25 * WAD) / 100);
        l.setFeeDerivative(WAD / 10);
        l.setFeeBase(500000000000000);

        emit log_named_address("me", address(this));
        l.proportionalDeposit(300 * (10 ** 18));

        address[] memory addr = new address[](1);
        uint256[] memory amt = new uint256[](1);
        addr[0] = dai;
        amt[0] = 30 * WAD;
        l.selectiveWithdraw(addr, amt);

        addr[0] = usdt;
        l.selectiveDeposit(addr, amt);

    }

    function testUnbalancedSelectiveWithdraw10x5y0z () public {
        uint256[] memory amounts = new uint256[](2);
        address[] memory tokens = new address[](2);

        tokens[0] = dai; amounts[0] = 10 * WAD;
        tokens[1] = usdc; amounts[1] = 5 * 1000000;

        uint256 shellsBurnt = l.selectiveWithdraw(tokens, amounts);
        shellsBurnt /= 10000000000;
        assertEq(shellsBurnt, 1512791323);
    }

    function testUnbalancedSelectiveWithdraw0x10y10z () public {
        uint256[] memory amounts = new uint256[](2);
        address[] memory tokens = new address[](2);

        tokens[0] = usdc; amounts[0] = 10 * 1000000;
        tokens[1] = usdt; amounts[1] = WAD * 10;

        uint256 shellsBurnt = l.selectiveWithdraw(tokens, amounts);
        shellsBurnt /= 10000000000;
        assertEq(shellsBurnt, 2001255711);
    }

    function testUnbalancedSelectiveWithdraw10x0y5z () public {
        uint256[] memory amounts = new uint256[](2);
        address[] memory tokens = new address[](2);

        tokens[0] = dai; amounts[0] = WAD * 10;
        tokens[1] = usdt; amounts[1] = WAD * 5;

        uint256 shellsBurnt = l.selectiveWithdraw(tokens, amounts);
        shellsBurnt /= 10000000000;
        assertEq(shellsBurnt, 1512791323);
    }

    function testFailUnbalancedSelectiveWithdraw0x0y100z () public {
        uint256[] memory amounts = new uint256[](1);
        address[] memory tokens = new address[](1);

        tokens[0] = usdt; amounts[0] = WAD * 100;

        l.selectiveWithdraw(tokens, amounts);
    }

}