/**
 *Submitted for verification at Etherscan.io on 2017-11-28
*/

pragma solidity ^0.5.12;

contract IUsdt {
    function transfer(address _to, uint _value) external;
    function transferFrom(address _from, address _to, uint _value) external;
    function balanceOf(address who) external view returns (uint);
    function approve(address _spender, uint _value) external;
    function allowance(address _owner, address _spender) external view returns (uint remaining);
    function deprecate(address _upgradedAddress) external;
    function totalSupply() external view returns (uint);
    function issue(uint amount) external;
    function redeem(uint amount) external;
    function setParams(uint newBasisPoints, uint newMaxFee) external;
    event Issue(uint amount);
    event Redeem(uint amount);
    event Deprecate(address newAddress);
    event Params(uint feeBasisPoints, uint maxFee);
}