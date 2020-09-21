pragma solidity ^0.5.0;

import "abdk-libraries-solidity/ABDKMath64x64.sol";

import "../../interfaces/IAssimilator.sol";

import "../setup/setup.sol";

import "../setup/methods.sol";

import "ds-test/test.sol";

contract ChopSueyTests is Setup, DSTest {

    using ABDKMath64x64 for uint;
    using ABDKMath64x64 for int128;

    using ShellMethods for Shell;

    Shell s;
    Shell s2;

    function setUp () public {

      s = getShellSuiteOne();
      
     s.setParams(.5e18, .25e18, .05e18, 3.5e14, .5e18);
      
    }
    
    function chopSueyOne () public {
      
     s.deposit(
        address(dai), 3000000000e18,
        address(usdc), 3000000000e6, 
        address(usdt), 3000000000e6,
        address(susd), 1000000000e18
      );
      
      uint bigOne = s.originSwap(
        address(dai),
        address(usdc),
        800000000e18
      );
      
      uint bigTwo = s.originSwap(
        address(usdc),
        address(usdt),
        800000000e6
      );
      
      uint smallOne = s.originSwap(
        address(usdc),
        address(dai),
        10000e6
      );
      
      uint smallTwo = s.originSwap(
        address(usdt),
        address(dai),
        10000e6
      );
      
      emit log_named_uint("big one", bigOne);
      emit log_named_uint("big two", bigTwo);
      emit log_named_uint("small one", smallOne);
      emit log_named_uint("small two", smallTwo);

    }

}