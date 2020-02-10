pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "./sandbox.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../adapters/kovan/kovanUsdtAdapter.sol";
import "../adapters/kovan/kovanUsdcAdapter.sol";
import "../adapters/kovan/kovanCUsdcAdapter.sol";
import "../adapters/kovan/kovanCDaiAdapter.sol";
import "../adapters/kovan/kovanChaiAdapter.sol";

interface I {
    function outputRaw (address addr, uint256 amt) external;
}


contract SandboxTest is DSMath, DSTest {
    Sandbox sandbox;
    event log_bytes(bytes32, bytes4);

    function setUp() public { sandbox = new Sandbox(); }

    function testERC () public {
        I i;

        emit log_bytes("output raw", i.outputRaw.selector);


    }

}