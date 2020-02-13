pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../loihiSetup.sol";
import "../../adapters/kovan/kovanUsdtAdapter.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract CUsdtAdapterTest is LoihiSetup, DSMath, DSTest {

    KovanUsdtAdapter usdtAdptr;

    function setUp() public {
        setupFlavors();
        usdtAdptr = new KovanUsdtAdapter();
    }

    function testGetRawAndNumeraireAmount () public {
        uint256 usdtBalance = IERC20(usdt).balanceOf(address(this));
        uint256 adptrNumeraireAmt = usdtAdptr.getNumeraireAmount(usdtBalance);
        uint256 adptrRawAmt = usdtAdptr.getRawAmount(adptrNumeraireAmt);
        assertEq(adptrNumeraireAmt, usdtBalance * (10**12));
        assertEq(adptrRawAmt, usdtBalance);
    }

    function testViewRawAndNumeraireAmount () public {
        uint256 usdtBalance = IERC20(usdt).balanceOf(address(this));
        uint256 adptrNumeraireAmt = usdtAdptr.viewNumeraireAmount(usdtBalance);
        uint256 adptrRawAmt = usdtAdptr.viewRawAmount(adptrNumeraireAmt);
        assertEq(adptrNumeraireAmt, usdtBalance * (10**12));
        assertEq(adptrRawAmt, usdtBalance);
    }

}