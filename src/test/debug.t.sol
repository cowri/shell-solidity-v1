
pragma solidity ^0.5.0;

import "ds-test/test.sol";
import "ds-math/math.sol";

import "./setup/setup.sol";

import "./setup/methods.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

contract DebugTest is Setup, DSMath, DSTest {

    using ABDKMath64x64 for uint;
    using ABDKMath64x64 for int128;

    using ShellMethods for Shell;

    Shell s;

    event log_bytes(bytes32, bytes4);
    event log_uints(bytes32, uint256[]);

    function setUp() public {

        // s = getShellSuiteOne();
        setupAssimilatorsSetOneMainnet();

    }

    function testDebug () public {

        uint daiBal = daiAssimilator.viewNumeraireBalance(address(this)).mulu(1e18);

        emit log_named_uint("daibal", daiBal);

    }
    
    function testMath () public {

        uint256 a = 1;

        int128 a64 = a.fromUInt();

    }

}