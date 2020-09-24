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

  function test_s7_fuzz (uint num) public { 

    s.deposit(
      address(dai), 190e18,
      address(usdc), 190e6,
      address(usdt), 190e6,
      address(susd), 60e18
    );

    if (num < 20e18) {

      while (num < 20e18) num *= 2;

    } else if (num > 40e18) {

      while (num > 40e18) num /= 2;

    }

    s.targetSwap(
      address(susd),
      address(dai),
      num
    );

    s.originSwap(
      address(dai),
      address(susd),
      num
    );

    s.deposit(
      address(dai), ( num * 100 / 85 ),
      address(usdc), ( num * 100 / 110 ) / 1e12,
      address(usdt), ( num * 100 / 115 ) / 1e12,
      address(susd), num / 3
    );

    s.proportionalWithdraw(num, 1e50);

    s.proportionalDeposit(num, 1e50);
    
    s.withdraw(
      address(dai), ( num * 100 / 85 ),
      address(usdc), ( num * 100 / 120 ) / 1e12,
      address(usdt), ( num * 100 / 111 ) / 1e12,
      address(susd), num / 3
    );

  }

}