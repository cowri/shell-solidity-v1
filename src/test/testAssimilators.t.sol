
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

contract AssimilatorSetOneTests is Setup, DSTest {

    using ABDKMath64x64 for uint;
    using ABDKMath64x64 for int128;

    using AssimilatorMethods for address;

    AssimilatorBouncer assimBouncer;

    event log_bytes(bytes32, bytes4);

    function setUp() public {

        setupStablecoinsLocal();
        setupAssimilatorsSetOneLocal();

        assimBouncer = new AssimilatorBouncer();

        approveStablecoins(address(assimBouncer));
        interApproveStablecoinsLocal(address(assimBouncer));

    }

    function testAssimilator_DAI_to_CDAI () public {

    }

    function testAssimilator_CDAI_to_CDAI () public {

    }

    function testAssimilator_CHAI_to_CDAI () public {

    }

    function testAssimilator_USDC_to_CUSDC () public {

        uint256 _5Numeraire = uint256(5e18);

        int128 _5Numeraire64x64 = _5Numeraire.divu(1e18);

        uint256 _cusdcOf5Numeraire = cusdcAssimilator.viewRawAmount(_5Numeraire64x64);

        emit log_named_uint("cusdc Amount", _cusdcOf5Numeraire);

        int128 _5NumeraireFromRaw64x64 = cusdcAssimilator.viewNumeraireAmount(_cusdcOf5Numeraire);

        uint256 _5NumeraireFromRaw = _5NumeraireFromRaw64x64.mulu(1e18);

        emit log_named_uint("numeraire from raw", _5NumeraireFromRaw);

    }

    function testAssimilator_CUSDC_to_CUSDC () public {

    }

    function testAssimilator_USDT_to_AUSDT () public {

    }

    function testAssimilator_AUSDT_to_AUSDT () public {

    }

    function testAssimilator_SUSD_to_ASUSD () public {

    }

    function testAssimilator_ASUSD_to_ASUSD () public {

    }

}

contract AssimilatorSetTwoTests is Setup, DSTest {

    using ABDKMath64x64 for uint;
    using ABDKMath64x64 for int128;

    using AssimilatorMethods for address;

    AssimilatorBouncer assimBouncer;

    event log_bytes(bytes32, bytes4);

    function setUp() public {

        setupAssimilatorsSetTwoLocal();
        setupStablecoinsLocal();
        assimBouncer = new AssimilatorBouncer();
        approveStablecoins(address(assimBouncer));
        interApproveStablecoinsLocal(address(assimBouncer));

    }

    function testAssimilator_DAI_to_DAI () public {

    }

    function testAssimilator_CDAI_to_DAI () public {

    }

    function testAssimilator_CHAI_to_DAI () public {

    }

    function testAssimilator_USDC_to_USDC () public {

    }

    function testAssimilator_CUSDC_to_USDC () public {

    }

    function testAssimilator_USDT_to_USDT () public {

    }

    function testAssimilator_AUSDT_to_USDT () public {

    }

    function testAssimilator_SUSD_to_SUSD () public {

    }

    function testAssimilator_ASUSD_to_SUSD () public {

    }

}
