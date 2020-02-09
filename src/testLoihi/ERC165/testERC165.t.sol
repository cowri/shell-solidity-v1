pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../flavorsSetup.sol";
import "../adaptersSetup.sol";
import "../../Loihi.sol";

contract LoihiERC165Test is AdaptersSetup, DSMath, DSTest {
    Loihi l;

    function setUp() public {
        setupFlavors();
        setupAdapters();

        address pot = address(new PotMock());
        l = new Loihi(
            chai, cdai, dai, pot,
            cusdc, usdc,
            usdt
        );

    }

    function testSupportsERC165 () public {
        assert(l.supportsInterface(bytes4(0x36372b07)));
    }

    function testSupportsERC20 () public {
        assert(l.supportsInterface(bytes4(0x01ffc9a7)));
    }

}