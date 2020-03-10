pragma solidity ^0.5.6;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20Detailed.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "ds-math/math.sol";

contract CUsdcMock is ERC20, ERC20Detailed, ERC20Mintable, DSMath {
    ERC20 underlying;

    uint256 constant rate = 209788521634924;

    constructor(address _underlying, string memory _name, string memory _symbols, uint8 _decimals, uint256 _amount)
    ERC20Detailed(_name, _symbols, _decimals) public {
        _mint(msg.sender, _amount);
        underlying = ERC20(_underlying);
    }

    event log_uint(bytes32, uint256);

    function mint (uint256 amount) public returns (uint) {
        uint256 balance = balanceOf(msg.sender);
        uint256 cusdcAmount = wdiv(amount, rate);
        emit log_uint("amount", amount);
        emit log_uint("mul", cusdcAmount);
        emit log_uint("div", wdiv(amount, rate));
        _mint(msg.sender, cusdcAmount);
        underlying.transferFrom(msg.sender, address(this), amount);
        return cusdcAmount;
    }

    function redeem (uint256 amount) public returns (uint) {
        _burn(msg.sender, amount);
        underlying.transfer(msg.sender, wmul(amount, rate));
        return wmul(amount, rate);
    }

    function redeemUnderlying (uint256 amount) public returns (uint) {
        _burn(msg.sender, wdiv(amount, rate));
        underlying.transfer(msg.sender, amount);
        return amount;
    }

    function exchangeRateStored () public returns (uint256){
        return rate;
    }

    function exchangeRateCurrent () public returns (uint256) {
        return rate;
    }

    function balanceOfUnderlying (address account) public returns (uint256) {
        uint256 balance = balanceOf(account);
        if (balance == 0) return 0;
        else return wmul(balance, rate);
    }

    event log_addr(bytes32, address);

    uint constant WAD = 10 ** 18;
    
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "ds-math-add-overflow");
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x);
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
    }

    function wmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), WAD) / WAD;
    }

    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, WAD), y / 2) / y;
    }

    function wdivup(uint x, uint y) internal pure returns (uint z) {
        // always rounds up
        z = add(mul(x, WAD), sub(y, 1)) / y;
    }


}