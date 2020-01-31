pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../Loihi.sol";
import "../adaptations/chai.sol";
import "../adaptations/cdai.sol";
import "../adaptations/dai.sol";
import "../adaptations/cusdc.sol";
import "../adaptations/cusdc.sol";
import "../adaptations/cusdc.sol";
import "../adaptations/cusdc.sol";

contract LoihiTest is DSMath, DSTest {
    Loihi l;

    function setUp() public {
        l = new Loihi();
    }

}