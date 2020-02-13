pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../loihiSetup.sol";
import "../../adapters/kovan/kovanUsdcAdapter.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract CUsdcAdapterTest is LoihiSetup, DSMath, DSTest {

    KovanUsdcAdapter usdcAdptr;

    function setUp() public {
        setupFlavors();
        usdcAdptr = new KovanUsdcAdapter();
    }

    function testGetRawAndNumeraireAmount () public {
        uint256 usdcBalance = IERC20(usdc).balanceOf(address(this));
        uint256 adptrNumeraireAmt = usdcAdptr.getNumeraireAmount(usdcBalance);
        uint256 adptrRawAmt = usdcAdptr.getRawAmount(adptrNumeraireAmt);
        assertEq(adptrNumeraireAmt, usdcBalance * (10**12));
        assertEq(adptrRawAmt, usdcBalance);
    }

    function testViewRawAndNumeraireAmount () public {
        uint256 usdcBalance = IERC20(usdc).balanceOf(address(this));
        uint256 adptrNumeraireAmt = usdcAdptr.viewNumeraireAmount(usdcBalance);
        uint256 adptrRawAmt = usdcAdptr.viewRawAmount(adptrNumeraireAmt);
        assertEq(adptrNumeraireAmt, usdcBalance * (10**12));
        assertEq(adptrRawAmt, usdcBalance);
    }

}