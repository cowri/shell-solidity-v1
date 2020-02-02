pragma solidity ^0.5.6;
import "openzeppelin-contracts/contracts/math/SafeMath.sol";
import "./delegate.sol";

contract Sandbox {

    using SafeMath for uint;
    Delegate delegate;
    address delegateAddr;

    constructor () public {
        delegate = new Delegate();
        delegateAddr = address(delegate);
    }

    event log_bool(bytes32, bool);
    event log_named_uint(bytes32, uint256);

}