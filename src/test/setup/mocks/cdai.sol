pragma solidity ^0.5.0;

import "./erc20.sol";

contract CDaiMock is ERC20Mock {

    ERC20Mock underlying;

    uint constant rate = 202853120189954603721819673;

    constructor(
        address _underlying,
        string memory _name,
        string memory _symbols,
        uint8 _decimals,
        uint256 _amount
    ) ERC20Mock (_name, _symbols, _decimals, _amount) public {

        underlying = ERC20Mock(_underlying);

    }

    function mint (uint256 amount) public returns (uint cdaiAmount_) {

        uint256 balance = balanceOf(msg.sender);

        cdaiAmount_ = ( amount * 1e18 ) / rate;

        _mint(msg.sender, cdaiAmount_);

        underlying.transferFrom(msg.sender, address(this), amount);

    }

    function redeem (uint256 amount) public returns (uint underlyingAmount_) {

        _burn(msg.sender, amount);

        underlyingAmount_ = ( amount * rate ) / 1e18;

        underlying.transfer(msg.sender, underlyingAmount_);

    }

    function redeemUnderlying (uint256 amount) public returns (uint) {

        uint256 _cdaiAmount = ( amount * 1e18 ) / rate;

        _burn(msg.sender, _cdaiAmount);

        underlying.transfer(msg.sender, amount);

        return amount;

    }

    function exchangeRateStored () public returns (uint256){

        return rate;

    }

    function exchangeRateCurrent () public returns (uint256) {

        return rate;

    }

    function balanceOfUnderlying (address _account) public returns (uint256 underlyingBalance_) {

        uint256 _balance = balanceOf(_account);

        if (_balance == 0) return 0;

        underlyingBalance_ = ( _balance * rate ) / 1e18;

    }

}