
pragma solidity ^0.5.12;

import "ds-math/math.sol";
import "../ERC20I.sol";
import "../ChaiI.sol";
import "../BadERC20I.sol";
import "../CTokenI.sol";
import "openzeppelin-contracts/contracts/token/ERC20/SafeERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../PotI.sol";
import "../LoihiRoot.sol";

contract UsdtAdapter is LoihiRoot {

    ChaiI chai;
    CTokenI cdai;
    ERC20I dai;
    PotI pot;
    CTokenI cusdc;
    ERC20I usdc;
    IERC20 usdt;

    constructor () public { }

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
    function getNumeraireBalance () public returns (uint256) {
        return usdt.balanceOf(address(this));
    }

}