pragma solidity ^0.5.6;

import "openzeppelin-contracts/contracts/token/ERC20/SafeERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "ds-test/test.sol";
import "ds-math/math.sol";
import "../flavorsSetup.sol";
import "../adaptersSetup.sol";
import "../../Loihi.sol";


contract UnbalancedSelectiveDepositTest is AdaptersSetup, DSMath, DSTest {
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

        l.proportionalDeposit(300 * (10 ** 18));

        address[] memory addr = new address[](1);
        uint256[] memory amt = new uint256[](1);
        addr[0] = dai;
        amt[0] = 30 * WAD;
        uint256 burned = l.selectiveWithdraw(addr, amt);

        addr[0] = usdt;
        uint256 deposited = l.selectiveDeposit(addr, amt);

    }

    function testUnbalancedSelectiveDeposit0x10y20z () public {
        uint256[] memory amounts = new uint256[](2);
        address[] memory tokens = new address[](2);

        tokens[0] = usdc; amounts[0] = 10 * 1000000;
        tokens[1] = usdt; amounts[1] = 20 * WAD;

        uint256 newShells = l.selectiveDeposit(tokens, amounts);
        newShells /= 1000000000000;
        assertEq(newShells, 29853807);
    }

    function testUnbalancedSelectiveDeposit10x15y0z () public {
        uint256[] memory amounts = new uint256[](2);
        address[] memory tokens = new address[](2);

        tokens[0] = dai; amounts[0] = 10 * WAD;
        tokens[1] = usdc; amounts[1] = 15 * 1000000;

        uint256 newShells = l.selectiveDeposit(tokens, amounts);
        newShells /= 1000000000000;
        assertEq(newShells, 25000000);
    }

    function testUnbalancedSelectiveDeposit10x15y25z () public {
        uint256[] memory amounts = new uint256[](3);
        address[] memory tokens = new address[](3);

        tokens[0] = dai; amounts[0] = 10 * WAD;
        tokens[1] = usdc; amounts[1] = 15 * 1000000;
        tokens[2] = usdt; amounts[2] = 25 * WAD;

        uint256 newShells = l.selectiveDeposit(tokens, amounts);
        newShells /= 1000000000000;
        assertEq(newShells, 49921042);
    }

    function testFailUnbalancedSelectiveDeposit0x0y100z () public {
        uint256[] memory amounts = new uint256[](2);
        address[] memory tokens = new address[](2);

        tokens[1] = usdc; amounts[1] = 0;
        tokens[2] = usdt; amounts[2] = 100 * WAD;

        uint256 newShells = l.selectiveDeposit(tokens, amounts);
    }

}