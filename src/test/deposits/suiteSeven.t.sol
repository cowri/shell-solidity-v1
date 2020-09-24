pragma solidity ^0.5.0;

import "ds-test/test.sol";

import "./depositsTemplate.sol";

import "../setup/setup.sol";

contract SelectiveDepositSuiteSeven is Setup, DSTest {

  Shell s;

  using ShellMethods for Shell;

  function setUp() public {

    s = getShellSuiteSeven();

  }

  function test_s7_deposit () public { 

    s.deposit(
      address(dai), 90e18,
      address(usdc), 90e6,
      address(usdt), 90e6,
      address(susd), 30e18
    );

    s.proportionalDeposit(18446744073709551616, 1e50);

  }

}