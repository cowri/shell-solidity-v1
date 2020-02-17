pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";


import "../LoihiLiquidity.sol";
import "../LoihiExchange.sol";
import "../LoihiERC20.sol";


contract TestProportionalWithdraw is DSTest {

    event log_uints(bytes32, uint256[]);
    event log_bytes4(bytes32, bytes4);

    function setUp() public {
        emit log_named_address("me",address(this));
    }

    function testDelegates () public {

    }


}