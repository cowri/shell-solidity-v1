pragma solidity ^0.5.0;

import "../ERC20I.sol";

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library YieldWrapperLibrary {

    function transfer (address erc20, address destination, uint256 amount) internal returns (bool) {
        return ERC20I(erc20).transfer(destination, amount);
    }

    function transferFrom (address erc20, address source, address destination, uint256 amount) internal returns (bool) {
        return ERC20I(erc20).transferFrom(source, destination, amount);
    }

    function mint (address erc20, address minter, uint256 amount) internal returns (bool) {
        return ERC20I(erc20).mint(minter, amount);
    }

    function burn (address erc20, uint256 amount) internal {
        ERC20I(erc20).burn(amount);
    }

    function burnFrom (address erc20, address account, uint256 amount) internal {
        ERC20I(erc20).burnFrom(account, amount);
    }

}
