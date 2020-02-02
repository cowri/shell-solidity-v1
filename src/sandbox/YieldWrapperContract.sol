pragma solidity ^0.5.0;

import "../ERC20I.sol";

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
contract YieldWrapperContract {
    ERC20I erc20;

    constructor (address addr) public {
        erc20 = ERC20I(addr);
    }

    function transfer (address destination, uint256 amount) public returns (bool) {
        return erc20.transfer(destination, amount);
    }

    function transferFrom (address source, address destination, uint256 amount) public returns (bool) {
        return erc20.transferFrom(source, destination, amount);
    }

    function mint (address minter, uint256 amount) public returns (bool) {
        return erc20.mint(minter, amount);
    }

    function burn (uint256 amount) public {
        erc20.burn(amount);
    }

    function burnFrom (address account, uint256 amount) public {
        erc20.burnFrom(account, amount);
    }

}
