pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "./sandbox.sol";

contract DappTest is DSMath, DSTest {
    Sandbox sandbox;

    function setUp() public {
        sandbox = new Sandbox();
    }


    function testPow () public {
        // uint powed2 = pow(10,2);
        // uint powed3 = pow(2,3);
        // uint powed4 = pow(2,4);
        // uint powed5 = pow(2,5);
        // uint powed6 = pow(2,6);
        // uint powed7 = pow(2,7);
        // assertEq(powed2,100);
        // assertEq(powed3,8);
        // assertEq(powed4,16);
        // assertEq(powed5,32);
        // assertEq(powed6,64);
        // assertEq(powed7,128);
    }

    function testThing () public {

        // uint256 result = wdiv(
        //     wmul(100000000000000000000, 500000000000000000000),
        //     1000000000000000000000
        // );
        // assertEq(result, 50000000000000000000);

    }

    function pow(uint x, uint n) internal pure returns (uint z) {
        z = n % 2 != 0 ? x : 1;

        for (n /= 2; n != 0; n /= 2) {
            x = mul(x, x);

            if (n % 2 != 0) {
                z = mul(z, x);
            }
        }
    }

}
