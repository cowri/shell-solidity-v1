
pragma solidity ^0.5.6;
import "openzeppelin-contracts/contracts/math/SafeMath.sol";

contract Delegate {
    using SafeMath for uint;


    constructor () public {
    }

    function testDelegate (uint256 num) public returns (uint256) {
        return num;
    }

}