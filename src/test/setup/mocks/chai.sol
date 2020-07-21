pragma solidity ^0.5.0;

import "./erc20.sol";

contract ChaiMock is ERC20Mock {

    ERC20Mock underlying;

    uint256 constant chi = 1014865463929259205354699760;

    constructor (
        address _underlying,
        string memory _name,
        string memory _symbols,
        uint8 _decimals,
        uint256 _amount
    ) ERC20Mock (_name, _symbols, _decimals, _amount) public {

        underlying = ERC20Mock(_underlying);

    }

    event log_uint(bytes32, uint256);
    event log_addr(bytes32, address);

    function draw (address src, uint wad) public {
        _burn(src, rdivup(wad, chi));
        underlying.transfer(msg.sender, wad);
    }

    function exit (address src, uint wad) public {
        _burn(src, wad);
        underlying.transfer(msg.sender, rmul(chi, wad));
    }

    function join (address dst, uint wad) public {
        underlying.transferFrom(msg.sender, address(this), wad);
        _mint(dst, rdiv(wad, chi));
    }

    function dai (address usr) public returns (uint wad) {
        return rmul(chi, balanceOf(usr));
    }

    function move (address src, address dst, uint wad) public returns (bool) {
        return transferFrom(src, dst, rdivup(wad, chi));
    }

    uint constant RAY = 10 ** 27;

    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x);
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x);
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x);
    }

    function rmul(uint x, uint y) internal pure returns (uint z) {
        // always rounds down
        z = mul(x, y) / RAY;
    }

    function rdiv(uint x, uint y) internal pure returns (uint z) {
        // always rounds down
        z = mul(x, RAY) / y;
    }

    function rdivup(uint x, uint y) internal pure returns (uint z) {
        // always rounds up
        z = add(mul(x, RAY), sub(y, 1)) / y;
    }

}