pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";

import "../LoihiDelegators.sol";

import "../adapters/kovan/kovanAUsdtAdapter.sol";
import "../adapters/kovan/kovanUsdtAdapter.sol";
import "../adapters/kovan/kovanASUsdAdapter.sol";
import "../adapters/kovan/kovanSUsdAdapter.sol";
import "../adapters/mainnet/mainnetASusdAdapter.sol";
import "../IAToken.sol";
import "../ILoihi.sol";

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract Delegator is LoihiDelegators {

    address usdtAdptr;
    address ausdtAdptr;
    address susdAdptr;
    address asusdAdptr;

    constructor () public {
        usdtAdptr = address(new KovanUsdtAdapter());
        ausdtAdptr = address(new KovanAUsdtAdapter());
        susdAdptr = address(new KovanSUsdAdapter());
        asusdAdptr = address(new KovanASUsdAdapter());
    }

    function intakeUsdt () public {
        dIntakeNumeraire(usdtAdptr, 10 * (10**6));
    }

    function outputUsdt () public {
        dOutputNumeraire(usdtAdptr, msg.sender, 10 * (10**6));
    }

    function intakeAUsdt () public {
        dIntakeNumeraire(ausdtAdptr, 10 * (10**18));
    }

    function outputAUsdt () public {
        dOutputNumeraire(ausdtAdptr, msg.sender, 10 * (10**18));
    }

    function intakeSUsd () public {
        dIntakeRaw(susdAdptr, 10 * (10**6));
    }

    function outputSUsd () public {
        dOutputRaw(susdAdptr, msg.sender, 10 * (10**6));
    }

    function intakeASUsd () public {
        dIntakeRaw(asusdAdptr, 10 * (10**6));
    }

    function outputASUsd () public {
        dOutputRaw(asusdAdptr, msg.sender, 10 * (10**6));
    }

}

contract TestProportionalWithdraw is DSTest, LoihiDelegators {

    event log_uints(bytes32, uint256[]);
    event log_bytes4(bytes32, bytes4);

    Delegator delegator;

    function setUp() public {
        emit log_named_address("me",address(this));
        // delegator = new Delegator();
    }

    // // event log_bytes4(bytes32, bytes4);
    // function testMe () public {
    //     ILoihi l;
    //     emit log_bytes4("totalReserves", l.totalReserves.selector);
    // }

    // function testDelegates () public {

        // KovanAUsdtAdapter adptr = new KovanAUsdtAdapter();
        // adptr.getData();

        // emit log_named_address("delegator", address(delegator));
        // emit log_named_address("me", address(this));

        // KovanAUsdtAdapter ausdtAdptr = new KovanAUsdtAdapter();
        // KovanUsdtAdapter usdtAdptr = new KovanUsdtAdapter();
        // KovanSUsdAdapter susdAdptr = new KovanSUsdAdapter();
        // KovanASUsdAdapter asusdAdptr = new KovanASUsdAdapter();

        // uint256 ausdtBal = dViewNumeraireBalance(address(ausdtAdptr), address(this));
        // emit log_named_uint("ausdtBal", ausdtBal);
        // uint256 usdtBal = dViewNumeraireBalance(address(usdtAdptr), address(this));
        // emit log_named_uint("usdtBal", usdtBal);

        // IERC20(0x13512979ADE267AB5100878E2e0f485B568328a4).approve(address(delegator), 150 * (10**6)); // usdt

        // delegator.intakeUsdt();

        // ausdtBal = dViewNumeraireBalance(address(ausdtAdptr), address(delegator));
        // emit log_named_uint("ausdtBal", ausdtBal);
        // usdtBal = dViewNumeraireBalance(address(usdtAdptr), address(delegator));
        // emit log_named_uint("usdtBal", usdtBal);

        // delegator.outputUsdt();

        // usdtBal = dViewNumeraireBalance(address(usdtAdptr), address(this));
        // emit log_named_uint("usdtBal", usdtBal);

        // ausdtBal = dViewNumeraireBalance(address(ausdtAdptr), address(this));
        // emit log_named_uint("ausdtbal me", ausdtBal);

        // IERC20(0xD868790F57B39C9B2B51b12de046975f986675f9).approve(address(delegator), 150 * (10**6)); // susd
        // IERC20(0xb9c1434aB6d5811D1D0E92E8266A37Ae8328e901 ).approve(address(delegator), 150 * (10**6)); // susd

        // uint256 susdBal = susdAdptr.viewNumeraireBalance(address(this));
        // uint256 erc20bal = IERC20(0xD868790F57B39C9B2B51b12de046975f986675f9).balanceOf(address(this));

        // emit log_named_uint("susdBal", susdBal);
        // delegator.intakeSUsd();
        // uint256 susdBalAfter = susdAdptr.viewNumeraireBalance(address(delegator));
        // uint256 erc20balAfter = IERC20(0xD868790F57B39C9B2B51b12de046975f986675f9).balanceOf(address(this));

        // delegator.outputSUsd();

        // susdBalAfter = susdAdptr.viewNumeraireBalance(address(delegator));
        // uint256 erc20balAfter = IERC20(0xD868790F57B39C9B2B51b12de046975f986675f9).balanceOf(address(this));

        // emit log_named_uint("susdBalAfter", susdBalAfter);
        // emit log_named_uint("erc20bal", erc20bal);
        // emit log_named_uint("erc20balafter", erc20balAfter);

        // delegator.intakeASUsd();
        // uint256 asusdBalAfter = asusdAdptr.viewNumeraireBalance(address(delegator));
        // emit log_named_uint("asusdBalAfter", asusdBalAfter);
        // delegator.outputASUsd();
        // susdBalAfter = susdAdptr.viewNumeraireBalance(address(delegator));
        // emit log_named_uint("susdBalAfter", susdBalAfter);

    // }
}