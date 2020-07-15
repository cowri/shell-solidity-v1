pragma solidity ^0.5.0;

import "./erc20.sol";

contract CUsdcMock is ERC20Mock {

    ERC20Mock underlying;

    uint256 constant rate = 209788521634924;

    constructor(
        address _underlying,
        string memory _name,
        string memory _symbols,
        uint8 _decimals,
        uint256 _amount
    ) ERC20Mock (_name, _symbols, _decimals, _amount) public {

        underlying = ERC20Mock(_underlying);

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