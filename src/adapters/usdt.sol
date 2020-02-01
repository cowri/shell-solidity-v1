
pragma solidity ^0.5.12;

import "ds-math/math.sol";
import "../ERC20I.sol";
import "openzeppelin-contracts/contracts/token/ERC20/SafeERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract UsdtAdaptation is SafeERC20, DSMath {
    IERC20 usdt;

    constructor (address _usdt) public {
        usdt = IERC20(_usdt);
    }

    // transfers usdt into our balance
    function intake (uint256 amount) public returns (uint256) {
        safeTransferFrom(usdt, msg.sender, address(this));
    }

    // transfers usdt out of our balance
    function output (address dst, uint256 amount) public returns (uint256) {
        safeTransfer(dst, amount);
        return amount;
    }

    // returns amount, is already numeraire amount
    function getNumeraireAmount (uint256 amount) public returns (uint256) {
        return amount;
    }

    // returns balance
    function getNumeraireBalance (uint256 amount) public returns (uint256) {
        return usdt.balanceOf(address(this));
    }

}