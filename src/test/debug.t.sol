
pragma solidity ^0.5.0;

import "ds-test/test.sol";
import "ds-math/math.sol";

import "./setup/setup.sol";

import "./setup/methods.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

import "../Assimilators.sol";


contract DebugTest is Setup, DSMath, DSTest {

    using ABDKMath64x64 for uint;
    using ABDKMath64x64 for int128;
    

    AssimilatorBouncer bouncer;


    event log_bytes(bytes32, bytes4);
    event log_uints(bytes32, uint256[]);

    function setUp() public {

        setupStablecoinsKovan();
        setupAssimilatorsSetOneKovan();
        
        bouncer = new AssimilatorBouncer();

        approveStablecoins(address(bouncer));

    }

    function testDebug () public {
        
        bouncer.depositRaw(address(cdaiAssimilator), 300e8);
        
    }
    
    function testMath () public {

        uint256 a = 1;

        int128 a64 = a.fromUInt();

    }

}


contract AssimilatorBouncer {

    using ABDKMath64x64 for uint256;
    using ABDKMath64x64 for int128;

    constructor () public { 

    }

    function safeApprove (address _token, address _spender, uint256 _value) public {
        ( bool success, bytes memory returndata ) = _token.call(abi.encodeWithSignature("approve(address,uint256)", _spender, _value));
        require(success, "SafeERC20: low-level call failed");
    }

    function depositRaw (address _assim, uint256 _amt) public returns (int256 amt_, int256 bal_) {

        ( int128 _amt64x64, int128 _bal64x64 ) = Assimilators.intakeRawAndGetBalance(_assim, _amt);

        amt_ = _amt64x64.muli(1e18);

        bal_ = _bal64x64.muli(1e18);

    }

    function depositNumeraire (address _assim, uint256 _amt) public returns (uint256 amt_) {

        int128 _amt64x64 = _amt.divu(1e18);

        amt_ = Assimilators.intakeNumeraire(_assim, _amt64x64);

    }

    function withdrawRaw (address _assim, uint256 _amt) public returns (int256 amt_, int256 bal_) {

        ( int128 _amt64x64, int128 _bal64x64 ) = Assimilators.outputRawAndGetBalance(_assim, msg.sender, _amt);

        amt_ = _amt64x64.muli(1e18);

        bal_ = _bal64x64.muli(1e18);

    }

    function withdrawNumeraire (address _assim, uint256 _amt) public returns (uint256 amt_) {

        int128 _amt64x64 = _amt.divu(1e18);

        amt_ = Assimilators.outputNumeraire(_assim, msg.sender, _amt64x64);

    }

}
