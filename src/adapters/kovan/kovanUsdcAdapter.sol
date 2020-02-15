
pragma solidity ^0.5.12;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../../ICToken.sol";

contract KovanUsdcAdapter {

    constructor () public { }

    // transfers usdc in
    // wraps it in csudc
    function intakeRaw (uint256 amount) public {
        IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF).transferFrom(msg.sender, address(this), amount);
        IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF).approve(address(0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35), amount);
        ICToken(0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35).mint(amount);
    }

    // transfers usdc in
    // wraps it in csudc
    function intakeNumeraire (uint256 amount) public returns (uint256) {
        amount /= 1000000000000;
        IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF).transferFrom(msg.sender, address(this), amount);
        IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF).approve(address(0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35), amount);
        ICToken(0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35).mint(amount);
        return amount;
    }

    function outputRaw (address dst, uint256 amount) public returns (uint256) {
        ICToken(0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35).redeemUnderlying(amount);
        IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF).transfer(dst, amount);
        return amount;
    }

    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {
        amount /= 1000000000000;
        ICToken(0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35).redeemUnderlying(amount);
        IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF).transfer(dst, amount);
        return amount;
    }

    function viewRawAmount (uint256 amount) public view returns (uint256) {
        return amount / 1000000000000;
    }

    function viewNumeraireAmount (uint256 amount) public pure returns (uint256) {
        return amount * 1000000000000;
    }

    function viewNumeraireBalance (address addr) public view returns (uint256) {
        uint256 rate = ICToken(0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35).exchangeRateStored();
        uint256 balance = ICToken(0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35).balanceOf(addr);
        return wmul(balance, rate) * 1000000000000;
    }

    function getRawAmount (uint256 amount) public pure returns (uint256) {
        return amount / 1000000000000;
    }

    // is already numeraire amount
    function getNumeraireAmount (uint256 amount) public pure returns (uint256) {
        return amount * 1000000000000;
    }

    // returns numeraire balance
    function getNumeraireBalance () public returns (uint256) {
        uint256 bal = ICToken(0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35).balanceOfUnderlying(address(this));
        return bal * 1000000000000;
    }

    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "ds-math-add-overflow");
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
    }

    function wmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), 1000000000000000000 / 2) / 1000000000000000000;
    }

    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, 1000000000000000000), y / 2) / y;
    }
}