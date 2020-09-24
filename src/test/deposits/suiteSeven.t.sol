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

  function test_s7_deposit (uint deposit) public { 

    s.deposit(
      address(dai), 90e18,
      address(usdc), 90e6,
      address(usdt), 90e6,
      address(susd), 30e18
    );


    if (deposit < 20e18 || 40e18 < deposit) {

      if (deposit < 20e18) {

        while (deposit < 20e18) deposit *= 10e10;

      } else {

        while (deposit > 40e18) deposit /= 10e10;

      }

    }

    if ( 20e18 < deposit || deposit < 40e18) {

      s.originSwap(
        address(usdc),
        address(susd),
        deposit
      );

      // s.withdraw(
      //   address(dai), deposit * 100 / 85,
      //   address(usdc), ( deposit * 100 / 120) / 1e12,
      //   address(usdt), ( deposit * 100 / 105) / 1e12,
      //   address(susd), deposit / 3
      // );

    }


  }

}