pragma solidity ^0.5.0;

import "abdk-libraries-solidity/ABDKMath64x64.sol";

import "../../interfaces/IAssimilator.sol";

import "../setup/setup.sol";

import "../setup/methods.sol";

contract BTCSelectiveDepositTemplate is Setup {

    using ABDKMath64x64 for uint;
    using ABDKMath64x64 for int128;

    using ShellMethods for Shell;

    Shell s;
    Shell s2;

    function noSlippage_balanced_15mWBTC_12mRenBTC_3mSBTC () public returns (uint256 shellsMinted_) {

        uint256 gas = gasleft();

        shellsMinted_ = s.deposit(
            address(wBTC), .015e8,
            address(renBTC), .012e8,
            address(sBTC), .003e18
        );

        emit log_uint("gas for deposit", gas - gasleft());

    }

}