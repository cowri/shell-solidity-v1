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

        setupFlavors();
        setupAdapters();
        l = new Loihi(chai, cdai, dai, pot, cusdc, usdc, usdt);
        approveFlavors(address(l));
        
        // setupFlavors();
        // setupAdapters();
        // l = new Loihi(address(0), address(0), address(0), address(0), address(0), address(0), address(0));
        // approveFlavors(address(l));


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

        IERC20(cdai).transfer(address(l), 35 * WAD);
        IERC20(cusdc).transfer(address(l), 50 * WAD);
        SafeERC20.safeTransfer(IERC20(usdt), address(l), 130 * WAD);

        l.fakeMint(WAD * 300);

    }

    function testSelectiveDeposit0x10y20z () public {
        uint256[] memory amounts = new uint256[](3);
        address[] memory tokens = new address[](3);

        tokens[0] = dai; amounts[0] = 0;
        tokens[1] = usdc; amounts[1] = WAD * 10;
        tokens[2] = usdt; amounts[2] = WAD * 20;

        uint256 newShells = l.selectiveDeposit(tokens, amounts);
        assertEq(newShells, 29857954545454545448);
    }

    function testSelectiveDeposit10x15y0z () public {
        uint256[] memory amounts = new uint256[](3);
        address[] memory tokens = new address[](3);

        tokens[0] = dai; amounts[0] = WAD * 10;
        tokens[1] = usdc; amounts[1] = WAD * 15;
        tokens[2] = usdt; amounts[2] = 0;

        uint256 newShells = l.selectiveDeposit(tokens, amounts);
        assertEq(newShells, 25000000000000000000);
    }

    function testSelectiveDeposit10x15y25z () public {
        uint256[] memory amounts = new uint256[](3);
        address[] memory tokens = new address[](3);

        tokens[0] = dai; amounts[0] = WAD * 10;
        tokens[1] = usdc; amounts[1] = WAD * 15;
        tokens[2] = usdt; amounts[2] = WAD * 25;

        uint256 newShells = l.selectiveDeposit(tokens, amounts);
        assertEq(newShells, 49927976190476190476);
    }

    function testFailSelectiveDeposit0x0y100z () public {
        uint256[] memory amounts = new uint256[](3);
        address[] memory tokens = new address[](3);

        tokens[0] = dai; amounts[0] = 0;
        tokens[1] = usdc; amounts[1] = 0;
        tokens[2] = usdt; amounts[2] = WAD * 100;

        uint256 newShells = l.selectiveDeposit(tokens, amounts);
    }



}