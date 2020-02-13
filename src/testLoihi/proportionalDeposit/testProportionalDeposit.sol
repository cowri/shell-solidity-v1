pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../loihiSetup.sol";
import "../../adapters/kovan/kovanCUsdcAdapter.sol";
import "../../adapters/kovan/kovanCDaiAdapter.sol";
import "../../adapters/kovan/kovanUsdtAdapter.sol";

contract LoihiTest is LoihiSetup, DSMath, DSTest {

    function setUp() public {

        setupFlavors();
        setupAdapters();
        setupLoihi();
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

    }

    function testproportionalDeposit () public {

        uint256 mintedShells = l.proportionalDeposit(100 * (10 ** 18));
        assertEq(mintedShells, 100 * (10 ** 18));

        uint256 cusdcBal = IERC20(cusdc).balanceOf(address(l)); // 165557372275ish
        uint256 cdaiBal = IERC20(cdai).balanceOf(address(l)); // 163925889326ish
        uint256 usdtBal = IERC20(usdt).balanceOf(address(l)); // 33333333333333333300

        uint256 usdtNumeraireAmount = new KovanUsdtAdapter().getNumeraireAmount(usdtBal);
        uint256 cusdcNumeraireAmount = new KovanCUsdcAdapter().getNumeraireAmount(cusdcBal);
        uint256 cdaiNumeraireAmount = new KovanCDaiAdapter().getNumeraireAmount(cdaiBal);
        
        // uint256 usdtNumeraireAmount = new LocalUsdtAdapter().getNumeraireAmount(usdtBal);
        // uint256 cusdcNumeraireAmount = new LocalCUsdcAdapter().getNumeraireAmount(cusdcBal);
        // uint256 cdaiNumeraireAmount = new LocalCDaiAdapter().getNumeraireAmount(cdaiBal);

        assertEq(usdtNumeraireAmount / (10 ** 10), 3333333300);
        assertEq(cusdcNumeraireAmount / (10 ** 10), 3333333300);
        assertEq(cdaiNumeraireAmount / (10 ** 10), 3333333333);

    }

}