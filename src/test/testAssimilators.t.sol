
pragma solidity ^0.5.0;

import "ds-test/test.sol";
import "ds-math/math.sol";

import "./setup/setup.sol";

import "./setup/methods.sol";

import "../interfaces/IAssimilator.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

contract AssimilatorBouncer is Setup {

    using ABDKMath64x64 for uint;
    using ABDKMath64x64 for int128;

    using AssimilatorMethods for address;

    event log_addr(bytes32, address);
    event log(bytes32);

    constructor () public {

        emit log_addr("bouncer", address(this));

    }
    function safeApprove (address _token, address _spender, uint256 _value) public {
        ( bool success, bytes memory returndata ) = _token.call(abi.encodeWithSignature("approve(address,uint256)", _spender, _value));
        require(success, "SafeERC20: low-level call failed");
    }

    function deposit (address _assim, uint256 _amt) public returns (int128 amt_, int128 bal_) {

        ( amt_, bal_ ) = _assim.intakeRaw(_amt);

    }

    function withdraw (address _assim, uint256 _amt) public returns (int128 amt_, int128 bal_) {

        ( amt_, bal_ ) = _assim.outputRaw(msg.sender, _amt);

    }

}

contract AssimilatorTests is Setup, DSMath, DSTest {

    using ABDKMath64x64 for uint;
    using ABDKMath64x64 for int128;

    using AssimilatorMethods for address;

    AssimilatorBouncer assimBouncer;

    event log_bytes(bytes32, bytes4);

    function setUp() public {

        setupAssimilatorsSetOneMainnet();
        setupStablecoinsMainnet();
        assimBouncer = new AssimilatorBouncer();
        approveStablecoins(address(assimBouncer));
        interApproveStablecoinsRPC(address(assimBouncer));

    }

    function testAssimilator () public {


    }

}