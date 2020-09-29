pragma solidity ^0.5.0;

interface IChai {
    function draw(address src, uint wad) external;
    function exit(address src, uint wad) external;
    function join(address dst, uint wad) external;
    function dai(address usr) external returns (uint wad);
    function permit(address holder, address spender, uint256 nonce, uint256 expiry, bool allowed, uint8 v, bytes32 r, bytes32 s) external;
    function approve(address usr, uint wad) external returns (bool);
    function move(address src, address dst, uint wad) external returns (bool);
    function transfer(address dst, uint wad) external returns (bool);
    function transferFrom(address src, address dst, uint wad) external;
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
}