
pragma solidity ^0.5.12;

import "ds-math/math.sol";
import "../ERC20I.sol";
import "openzeppelin-contracts/contracts/token/ERC20/SafeERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract UsdtAdapter is DSMath {
    IERC20 usdt;

    constructor (address _usdt) public {
        usdt = IERC20(_usdt);
    }

    // transfers usdt into our balance
    function intakeRaw (uint256 amount) public returns (uint256) {
        SafeERC20.safeTransferFrom(usdt, msg.sender, address(this), amount);
        return amount;
    }

    function intakeNumeraire (uint256 amount) public {
        SafeERC20.safeTransferFrom(usdt, msg.sender, address(this), amount);
    }

    // transfers usdt out of our balance
    function outputRaw (address dst, uint256 amount) public returns (uint256) {
        SafeERC20.safeTransfer(usdt, dst, amount);
        return amount;
    }

    // transfers usdt to destination
    function outputNumeraire (address dst, uint256 amount) public  {
        SafeERC20.safeTransfer(usdt, dst, amount);
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