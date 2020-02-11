
pragma solidity ^0.5.12;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../../ICToken.sol";

contract KovanUsdcAdapter {

    constructor () public { }

    // transfers usdc in
    // wraps it in csudc
    function intakeRaw (uint256 amount) public {
        amount /= 1000000000000;
        uint256 balance = IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF).balanceOf(msg.sender);
        emit log_uint("balance", balance);
        IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF).transferFrom(msg.sender, address(this), amount);
        IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF).approve(address(0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35), amount);
        ICToken(0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35).mint(amount);
    }

    // transfers usdc in
    // wraps it in csudc
    function intakeNumeraire (uint256 amount) public returns (uint256) {
        emit log_uint("amount", amount);
        amount /= 1000000000000;
        emit log_uint("amount", amount);
        IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF).transferFrom(msg.sender, address(this), amount);
        IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF).approve(address(0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35), amount);
        ICToken(0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35).mint(amount);
        return amount;
    }
    event log_uint(bytes32, uint256);

    // redeems numeraire amount from cusdc
    // transfers it to destination
    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {
        emit log_uint("amount1", amount);
        amount /= 1000000000000;
        emit log_uint("amount2", amount);

        uint256 underlyingBal = ICToken(0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35).balanceOfUnderlying(address(this));
        uint256 bal = ICToken(0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35).balanceOf(address(this));
        emit log_uint("underlying bal", underlyingBal);
        emit log_uint("bal", bal);
        uint256 usdcBal = IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF).balanceOf(address(this));
        ICToken(0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35).redeemUnderlying(amount);
        uint256 usdcBalAfter = IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF).balanceOf(address(this));
        emit log_uint("usdcBal", usdcBal);
        emit log_uint("usdcBalAfter", usdcBalAfter);
        IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF).transfer(dst, amount);
        return amount;
    }

    function outputRaw (address dst, uint256 amount) public returns (uint256) {
        uint256 bal = IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF).balanceOf(address(this));
        ICToken(0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35).redeemUnderlying(amount);
        bal = IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF).balanceOf(address(this)) - bal;
        IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF).transfer(dst, amount);
        emit log_uint("amount", amount);
        emit log_uint("bal", bal);
        return bal;
    }

    function viewRawAmount (uint256 amount) public view returns (uint256) {
        amount /= 1000000000000;
        uint256 rate = ICToken(0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35).exchangeRateStored();
        return wdiv(amount, rate);
    }

    function viewNumeraireAmount (uint256 amount) public pure returns (uint256) {
        return amount * 1000000000000;
    }

    function viewNumeraireBalance (address addr) public view returns (uint256) {
        uint256 rate = ICToken(0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35).exchangeRateStored();
        uint256 balance = ICToken(0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35).balanceOf(addr);
        return wmul(balance, rate) * 1000000000000;
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