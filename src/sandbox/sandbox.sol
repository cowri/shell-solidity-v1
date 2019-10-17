pragma solidity ^0.5.6;

contract Sandbox {

    constructor () public {

    }

    modifier doesFindArgument( uint256 num ) {
        emit log_int("num", num);
        _;
    }

    event log_int(bytes32 key, uint256 val);

    function giveArguments (uint256 otherNum, uint256 num) public doesFindArgument(otherNum) {
        emit log_int("otherNum", otherNum);
    }

    function rollsOver () public pure returns (uint256 z) {
        for (uint8 i = 0; i < 5; i++ ){
            z++;
        }
    }

}