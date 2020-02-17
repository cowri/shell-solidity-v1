pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../loihiSetup.sol";
import "../../IAdapter.sol";

contract CDaiAdapterTest is LoihiSetup, DSMath, DSTest {

    function setUp() public {
        setupFlavors();
    }

    function testViewRawAndNumeraireAmount () public {
        uint256 cdaiBalance = ICToken(cdai).balanceOf(address(this));
        uint256 daiBalance = ICToken(cdai).balanceOfUnderlying(address(this));
        uint256 adptrDaiAmt = IAdapter(cdaiAdapter).viewNumeraireAmount(cdaiBalance);
        uint256 adptrCDaiAmt = IAdapter(cdaiAdapter).viewRawAmount(adptrDaiAmt);

        assertEq(adptrCDaiAmt / 100, cdaiBalance / 100);
        assertEq(adptrDaiAmt / 100, daiBalance / 100);
    }

    function testGetRawAndNumeraireAmount () public {
        uint256 cdaiBalance = ICToken(cdai).balanceOf(address(this));
        uint256 daiBalance = ICToken(cdai).balanceOfUnderlying(address(this));
        uint256 adptrDaiAmt = IAdapter(cdaiAdapter).getNumeraireAmount(cdaiBalance);
        uint256 adptrCDaiAmt = IAdapter(cdaiAdapter).getRawAmount(adptrDaiAmt);

        assertEq(adptrCDaiAmt / 100, cdaiBalance / 100);
        assertEq(adptrDaiAmt / 100, daiBalance / 100);
    }
}