pragma solidity ^0.5.0;

import "abdk-libraries-solidity/ABDKMath64x64.sol";

import "ds-test/test.sol";

import "../setup/setup.sol";

import "../setup/methods.sol";

contract LoihiFactorySuiteOne is Setup, DSTest {

    using ABDKMath64x64 for uint;
    using ABDKMath64x64 for int128;

    using LoihiMethods for Loihi;

    LoihiFactory lf;

    function setUp() public {

        lf = getLoihiFactorySuiteOne();

    }

    function setupSuiteOneParameters (Loihi _l) public {

        _l.TEST_includeAssimilatorState(
            dai, cdai, chai, pot,
            usdc, cusdc,
            usdt, ausdt,
            susd, asusd
        );

        includeAssetsSetOne(_l);

        includeAssimilatorsSetOne(_l);

        setParamsSetOne(_l);

        approveStablecoins(address(_l));

        interApproveStablecoinsLocal(address(_l));

    }

    function newShell () public returns (Loihi loihi_) {
        
        address[] memory _assets = new address[](0);
        uint[] memory _weights = new uint[](0);
        address[] memory _derivatives = new address[](0);        
        
        loihi_ = lf.newShell(
            _assets,
            _weights,
            _derivatives
        );

    }

    function test_s1_loihiFactory () public {
        
        Loihi l1 = newShell();

        setupSuiteOneParameters(l1);

        Loihi l2 = newShell();

        setupSuiteOneParameters(l2);

        bool l1IsShell = lf.isShell(address(l1));

        bool l2IsShell = lf.isShell(address(l2));

        assertTrue(l1IsShell);

        assertTrue(l2IsShell);

    }

}