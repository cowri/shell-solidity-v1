
pragma solidity ^0.5.0;

import "ds-test/test.sol";
import "ds-math/math.sol";

import "./setup/setup.sol";

import "./setup/methods.sol";

import "../interfaces/IAssimilator.sol";
// import "../interfaces/IERC20.sol";
// import "../interfaces/IERC20NoBool.sol";
// import "../interfaces/IAToken.sol";
// import "../interfaces/ICToken.sol";
// import "../interfaces/IChai.sol";
// import "../interfaces/IPot.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

import "../ShellStorage.sol";

contract AssimilatorBouncer is ShellStorage {

    using ABDKMath64x64 for uint256;
    using ABDKMath64x64 for int128;

    using AssimilatorMethods for address;

    event log_addr(bytes32, address);
    event log(bytes32);

    constructor () public ShellStorage () { 

    }

    function safeApprove (address _token, address _spender, uint256 _value) public {
        ( bool success, bytes memory returndata ) = _token.call(abi.encodeWithSignature("approve(address,uint256)", _spender, _value));
        require(success, "SafeERC20: low-level call failed");
    }

    function depositRaw (address _assim, uint256 _amt) public returns (int256 amt_, int256 bal_) {

        ( int128 _amt64x64, int128 _bal64x64 ) = AssimilatorMethods.intakeRaw(_assim, _amt);

        amt_ = _amt64x64.muli(1e18);

        bal_ = _bal64x64.muli(1e18);

    }

    function depositNumeraire (address _assim, uint256 _amt) public returns (uint256 amt_) {

        int128 _amt64x64 = _amt.divu(1e18);

        amt_ = AssimilatorMethods.intakeNumeraire(_assim, _amt64x64);

    }

    function withdrawRaw (address _assim, uint256 _amt) public returns (int256 amt_, int256 bal_) {

        ( int128 _amt64x64, int128 _bal64x64 ) = AssimilatorMethods.outputRaw(_assim, msg.sender, _amt);

        amt_ = _amt64x64.muli(1e18);

        bal_ = _bal64x64.muli(1e18);

    }

    function withdrawNumeraire (address _assim, uint256 _amt) public returns (uint256 amt_) {

        int128 _amt64x64 = _amt.divu(1e18);

        amt_ = AssimilatorMethods.outputNumeraire(_assim, msg.sender, _amt64x64);

    }

}

contract AssimilatorSetOneTests is Setup, DSTest {

    using ABDKMath64x64 for uint;
    using ABDKMath64x64 for int128;

    using AssimilatorMethods for address;

    AssimilatorBouncer assimBouncer;

    event log_bytes(bytes32, bytes4);

    function setUp() public {

        // setupStablecoinsLocal();
        // setupAssimilatorsSetOneLocal();

        assimBouncer = new AssimilatorBouncer();

        // assimBouncer.TEST_includeAssimilatorState(
        //     IERC20(dai),
        //     ICToken(cdai),
        //     IChai(chai),
        //     IPot(pot),
        //     IERC20(usdc),
        //     ICToken(cusdc),
        //     IERC20NoBool(usdt),
        //     IAToken(ausdt),
        //     IERC20(susd),
        //     IAToken(asusd)
        // );

        approveStablecoins(address(assimBouncer));
        // interApproveStablecoinsLocal(address(assimBouncer));

    }

    function testAssimilator_DAI_to_CDAI_views () public {

        uint256 daiOf5Numeraire = daiAssimilator.viewRawAmount(
            uint256(5e18).divu(1e18)
        );

        uint256 fiveNumeraireOfDai = daiAssimilator.viewNumeraireAmount(
            daiOf5Numeraire
        ).mulu(1e18);

        assertTrue(daiOf5Numeraire == fiveNumeraireOfDai);

    }

    function testAssimilator_DAI_to_CDAI_raws () public {

        ( int256 _depositAmt, int256 _depositBal ) = assimBouncer.depositRaw(
            address(daiAssimilator),
            5e18
        );

        ( int256 _withdrawAmt, int256 _withdrawBal ) = assimBouncer.withdrawRaw(
            address(daiAssimilator),
            5e18
        );

        emit log_named_int("_depositAmt", _depositAmt);
        emit log_named_int("_depositBal", _depositBal);

        emit log_named_int("_withdrawAmt", _withdrawAmt);
        emit log_named_int("_withdrawBal", _withdrawBal);

        assertEq(_depositAmt + _withdrawAmt, 0);
        assertEq(_depositBal - _withdrawBal, _depositAmt);
        assertEq(_withdrawBal - _depositBal, _withdrawAmt);

    }

    function testAssimilator_DAI_to_CDAI_numeraires () public {

        uint256 _depositAmt = assimBouncer.depositNumeraire(
            address(daiAssimilator),
            5e18
        );

        uint256 _withdrawAmt = assimBouncer.withdrawNumeraire(
            address(daiAssimilator),
            5e18
        );

        assertEq(_depositAmt, _withdrawAmt);

    }

    function testAssimilator_CDAI_to_CDAI_views () public {

        uint256 cdaiOf5Numeraire = cdaiAssimilator.viewRawAmount(
            uint256(5e18).divu(1e18)
        );

        uint256 fiveNumeraireOfCDai = cdaiAssimilator.viewNumeraireAmount(
            cdaiOf5Numeraire
        ).mulu(1e10);

        assertTrue(
            fiveNumeraireOfCDai == 5e10 ||
            fiveNumeraireOfCDai == 5e10 - 1 ||
            fiveNumeraireOfCDai == 5e10 - 2
        );

    }

    function testAssimilator_CDAI_to_CDAI_raws () public {

        uint256 cdaiOf5Numeraire = cdaiAssimilator.viewRawAmount(
            uint256(5e18).divu(1e18)
        );

        ( int256 _depositAmt, int256 _depositBal ) = assimBouncer.depositRaw(
            address(cdaiAssimilator),
            cdaiOf5Numeraire
        );

        ( int256 _withdrawAmt, int256 _withdrawBal ) = assimBouncer.withdrawRaw(
            address(cdaiAssimilator),
            cdaiOf5Numeraire
        );

        assertEq(_depositAmt + _withdrawAmt, 0);
        assertEq(_depositBal - _withdrawBal, _depositAmt);
        assertEq(_withdrawBal - _depositBal, _withdrawAmt);

    }

    function testAssimilator_CDAI_to_CDAI_numeraires () public {

        uint256 _depositAmt = assimBouncer.depositNumeraire(
            address(cdaiAssimilator),
            5e18
        );

        uint256 _withdrawAmt = assimBouncer.withdrawNumeraire(
            address(cdaiAssimilator),
            5e18
        );

        assertEq(_depositAmt, _withdrawAmt);

    }

    function testAssimilator_CHAI_to_CDAI_views () public {

        uint256 chaiOf5Numeraire = chaiAssimilator.viewRawAmount(
            uint256(5e18).divu(1e18)
        );

        uint256 fiveNumeraireOfChai = chaiAssimilator.viewNumeraireAmount(
            chaiOf5Numeraire
        ).mulu(1e18);

        assertTrue(
            fiveNumeraireOfChai == 5e18 ||
            fiveNumeraireOfChai == 5e18 - 1 ||
            fiveNumeraireOfChai == 5e18 - 2
        );

    }

    function testAssimilator_CHAI_to_CDAI_raws () public {

        uint256 chaiOf5Numeraire = cdaiAssimilator.viewRawAmount(
            uint256(5e18).divu(1e18)
        );

        ( int256 _depositAmt, int256 _depositBal ) = assimBouncer.depositRaw(
            address(cdaiAssimilator),
            chaiOf5Numeraire
        );

        ( int256 _withdrawAmt, int256 _withdrawBal ) = assimBouncer.withdrawRaw(
            address(cdaiAssimilator),
            chaiOf5Numeraire
        );

        assertEq(_depositAmt + _withdrawAmt, 0);
        assertEq(_depositBal - _withdrawBal, _depositAmt);
        assertEq(_withdrawBal - _depositBal, _withdrawAmt);

    }

    function testAssimilator_CHAI_to_CDAI_numeraires () public {

        uint256 _depositAmt = assimBouncer.depositNumeraire(
            address(chaiAssimilator),
            5e18
        );

        uint256 _withdrawAmt = assimBouncer.withdrawNumeraire(
            address(chaiAssimilator),
            5e18
        );

        assertEq(_depositAmt, _withdrawAmt);

    }

    function testAssimilator_USDC_to_CUSDC_views () public {

        uint256 usdcOf5Numeraire = usdcAssimilator.viewRawAmount(
            uint256(5e18).divu(1e18)
        );

        uint256 fiveNumeraireOfUsdc = usdcAssimilator.viewNumeraireAmount(
            usdcOf5Numeraire
        ).mulu(1e6);

        assertTrue(
            fiveNumeraireOfUsdc == 5e6 ||
            fiveNumeraireOfUsdc == 5e6 - 1 ||
            fiveNumeraireOfUsdc == 5e6 - 2
        );

    }

    function testAssimilator_USDC_to_CUSDC_raws () public {

        uint256 usdcOf5Numeraire = usdcAssimilator.viewRawAmount(
            uint256(5e18).divu(1e18)
        );

        ( int256 _depositAmt, int256 _depositBal ) = assimBouncer.depositRaw(
            address(usdcAssimilator),
            usdcOf5Numeraire
        );

        ( int256 _withdrawAmt, int256 _withdrawBal ) = assimBouncer.withdrawRaw(
            address(usdcAssimilator),
            usdcOf5Numeraire
        );

        emit log_named_uint("usdcOf5Numeraire", usdcOf5Numeraire);

        emit log_named_int("_depositAmt", _depositAmt);
        emit log_named_int("_depositBal", _depositBal);

        emit log_named_int("_withdrawAmt", _withdrawAmt);
        emit log_named_int("_withdrawBal", _withdrawBal);

        assertEq(_depositAmt + _withdrawAmt, 0);
        assertEq(_depositBal - _withdrawBal, _depositAmt);
        assertEq(_withdrawBal - _depositBal, _withdrawAmt);

    }

    function testAssimilator_USDC_to_CUSDC_numeraires () public {

    }

    function testAssimilator_CUSDC_to_CUSDC_views () public {

        uint256 cusdcOf5Numeraire = cusdcAssimilator.viewRawAmount(
            uint256(5e18).divu(1e18)
        );

        uint256 fiveNumeraireOfCUsdc = cusdcAssimilator.viewNumeraireAmount(
            cusdcOf5Numeraire
        ).mulu(1e6);

        assertTrue(
            fiveNumeraireOfCUsdc == 5e6 ||
            fiveNumeraireOfCUsdc == 5e6 - 1 ||
            fiveNumeraireOfCUsdc == 5e6 - 2
        );

    }

    function testAssimilator_CUSDC_to_CUSDC_raws () public {

        uint256 cusdcOf5Numeraire = cusdcAssimilator.viewRawAmount( uint256(5e18).divu(1e18) );

        ( int256 _depositAmt, int256 _depositBal ) = assimBouncer.depositRaw(
            address(cusdcAssimilator),
            cusdcOf5Numeraire
        );

        ( int256 _withdrawAmt, int256 _withdrawBal ) = assimBouncer.withdrawRaw(
            address(cusdcAssimilator),
            cusdcOf5Numeraire
        );

        assertEq(_depositAmt + _withdrawAmt, 0);
        assertEq(_depositBal - _withdrawBal, _depositAmt);
        assertEq(_withdrawBal - _depositBal, _withdrawAmt);

    }

    function testAssimilator_CUSDC_to_CUSDC_numeraires () public {

        uint256 _depositAmt = assimBouncer.depositNumeraire(
            address(cusdcAssimilator),
            5e18
        );

        uint256 _withdrawAmt = assimBouncer.withdrawNumeraire(
            address(cusdcAssimilator),
            5e18
        );

        assertEq(_depositAmt, _withdrawAmt);

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

        // setupAssimilatorsSetTwoLocal();
        // setupStablecoinsLocal();
        assimBouncer = new AssimilatorBouncer();
        approveStablecoins(address(assimBouncer));
        // interApproveStablecoinsLocal(address(assimBouncer));

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
