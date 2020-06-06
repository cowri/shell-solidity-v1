
pragma solidity ^0.5.0;

import "ds-test/test.sol";
import "ds-math/math.sol";

import "./setup/setup.sol";

import "./setup/methods.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

contract DebugTest is Setup, DSMath, DSTest {

    using ABDKMath64x64 for uint;
    using ABDKMath64x64 for int128;

    using LoihiMethods for Loihi;

    Loihi l;

    event log_bytes(bytes32, bytes4);
    event log_uints(bytes32, uint256[]);

    function setUp() public {

        l = getLoihiSuiteOne();

    }

    function testDebug () public {

        uint256 p3 = .3e18;

        int128 p3divu = p3.divu(1e18);

        int128 onedivu = uint256(1).divu(1e18);

        int128 wad64x64 = uint256(1e18).fromUInt();

        int128 p3fromu = p3.fromUInt().div(wad64x64);

        emit log_named_int("p3divu", p3divu.muli(1e18));
        emit log_named_int("p3fromu", p3fromu.muli(1e18));

        p3divu = p3divu.add(onedivu);
        p3fromu = p3fromu.add(onedivu);

        emit log_named_int("p3divu", p3divu.muli(1e18));
        emit log_named_int("p3fromu", p3fromu.muli(1e18));

        uint256 startingShells = l.proportionalDeposit(300e18);

        ( uint256 totalReserves, uint256[] memory reserves ) = l.totalReserves();

        uint256 newShells = l.deposit(
            address(dai), 10e18,
            address(usdc), 10e6,
            address(usdt), 10e6,
            address(susd), 2.5e18
        );

        emit log_named_uint("total reserves", totalReserves);
        emit log_uints("reserves", reserves);

        assertEq(newShells, 32499999216641686631);

    }
    
    function testMath () public {

        uint256 a = 1;

        int128 a64 = a.fromUInt();

    }

}