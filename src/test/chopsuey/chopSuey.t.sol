pragma solidity ^0.5.0;

import "abdk-libraries-solidity/ABDKMath64x64.sol";

import "../../interfaces/IAssimilator.sol";

import "../setup/setup.sol";

import "../setup/methods.sol";

import "ds-test/test.sol";

contract ChopSueyTests is Setup, DSTest {

    using ABDKMath64x64 for uint;
    using ABDKMath64x64 for int128;

    using LoihiMethods for Loihi;

    Loihi l;
    Loihi l2;

    function setUp () public {

      l = getLoihiSuiteOne();
      
      l.setParams(.5e18, .25e18, .05e18, 3.5e14, .5e18);
      
    }
    
    function chopSueyOne () public {
      
      l.deposit(
        address(dai), 3000000000e18,
        address(usdc), 3000000000e6, 
        address(usdt), 3000000000e6,
        address(susd), 1000000000e18
      );
      
      uint bigOne = l.originSwap(
        address(dai),
        address(usdc),
        800000000e18
      );
      
      uint bigTwo = l.originSwap(
        address(usdc),
        address(usdt),
        800000000e6
      );
      
      uint smallOne = l.originSwap(
        address(usdc),
        address(dai),
        10000e6
      );
      
      uint smallTwo = l.originSwap(
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