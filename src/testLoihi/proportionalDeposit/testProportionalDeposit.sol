pragma solidity ^0.5.6;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "ds-test/test.sol";
import "ds-math/math.sol";
import "../flavorsSetup.sol";
import "../adaptersSetup.sol";
import "../../Loihi.sol";
import "../../adapters/kovan/kovanCUsdcAdapter.sol";
import "../../adapters/kovan/kovanCDaiAdapter.sol";


contract LoihiTest is AdaptersSetup, DSMath, DSTest {
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

    }

    function testproportionalDeposit () public {

        uint256 mintedShells = l.proportionalDeposit(100 * (10 ** 18));
        emit log_named_uint("shells", mintedShells);
        assertEq(mintedShells, 100 * (10 ** 18));
        uint256 cusdcBal = IERC20(cusdc).balanceOf(address(l)); // 165557372275ish
        uint256 cdaiBal = IERC20(cdai).balanceOf(address(l)); // 163925889326ish
        uint256 usdtBal = IERC20(usdt).balanceOf(address(l)); // 33333333333333333300

        uint256 usdtNumeraireAmount = new KovanUsdtAdapter().getNumeraireAmount(usdtBal);
        uint256 cusdcNumeraireAmount = new KovanCUsdcAdapter().getNumeraireAmount(cusdcBal);
        uint256 cdaiNumeraireAmount = new KovanCDaiAdapter().getNumeraireAmount(cdaiBal);

        assertEq(usdtNumeraireAmount / (10 ** 10), 3333333300);
        assertEq(cusdcNumeraireAmount / (10 ** 10), 3333333300);
        assertEq(cdaiNumeraireAmount / (10 ** 10), 3333333333);

    }
}