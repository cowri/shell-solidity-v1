pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../loihiSetup.sol";
import "../../adapters/kovan/kovanDaiAdapter.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract CUsdcAdapterTest is LoihiSetup, DSMath, DSTest {

    KovanDaiAdapter daiAdptr;

    function setUp() public {
        setupFlavors();
        daiAdptr = new KovanDaiAdapter();
    }

    function testGetRawAndNumeraireAmount () public {
        uint256 daiBalance = IERC20(dai).balanceOf(address(this));
        uint256 adptrNumeraireAmt = daiAdptr.getNumeraireAmount(daiBalance);
        uint256 adptrRawAmt = daiAdptr.getRawAmount(adptrNumeraireAmt);
        assertEq(adptrNumeraireAmt, daiBalance);
        assertEq(adptrRawAmt, daiBalance);
    }
    function testViewRawAndNumeraireAmount () public {
        uint256 daiBalance = IERC20(dai).balanceOf(address(this));
        uint256 adptrNumeraireAmt = daiAdptr.viewNumeraireAmount(daiBalance);
        uint256 adptrRawAmt = daiAdptr.viewRawAmount(adptrNumeraireAmt);
        assertEq(adptrNumeraireAmt, daiBalance);
        assertEq(adptrRawAmt, daiBalance);
    }

}