
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

        s = getShellSuiteOne();

    }

    function testDebug () public {

        uint256 p3 = .3e18;

        int128 p3divu = p3.divu(1e18);

        int128 onedivu = uint256(.25e18).divu(1e18);

        emit log_named_int("int128", onedivu);



    }
    
    function testMath () public {

        uint256 a = 1;

        int128 a64 = a.fromUInt();

    }

}