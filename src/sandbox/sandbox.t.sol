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

contract SandboxTest is DSMath, DSTest {
    Sandbox sandbox;

    function setUp() public { sandbox = new Sandbox(); }

    // function testERC () public {

    //     KovanUsdtAdapter a = new UsdtAdapter();

    //     uint256 balance = a.getNumeraireBalance(0xA600AdF7CB8C750482a828712849ee026446aA66);

    // }

}