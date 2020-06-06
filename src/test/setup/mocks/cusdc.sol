pragma solidity ^0.5.0;

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

    function mint (uint256 _amount) public returns (uint cusdcAmount_) {

        cusdcAmount_ = ( _amount * 1e18 ) / rate;

        _mint(msg.sender, cusdcAmount_);

        underlying.transferFrom(msg.sender, address(this), _amount);

    }

    function redeem (uint256 _amount) public returns (uint underlyingAmt_) {

        _burn(msg.sender, _amount);

        underlyingAmt_ = ( _amount * rate ) / 1e18;

        underlying.transfer(msg.sender, underlyingAmt_);

    }

    function redeemUnderlying (uint256 amount) public returns (uint) {

        uint256 _cUsdcAmount = ( amount * 1e18 ) / rate;

        _burn(msg.sender, _cUsdcAmount);

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

        else return ( balance * rate ) / 1e18;

    }

}