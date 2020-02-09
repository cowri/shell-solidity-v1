
pragma solidity ^0.5.12;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../../ICToken.sol";

contract KovanUsdcAdapter {

    constructor () public { }

    // transfers usdc in
    // wraps it in csudc
    function intakeRaw (uint256 amount) public {
        amount = amount / 1000000000000;
        IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF).transferFrom(msg.sender, address(this), amount);
        IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF).approve(address(0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35), amount);
        ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c).mint(amount);
    }

    // transfers usdc in
    // wraps it in csudc
    function intakeNumeraire (uint256 amount) public returns (uint256) {
        uint256 usdcDecimalAmount = amount / 1000000000000;
        IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF).transferFrom(msg.sender, address(this), usdcDecimalAmount);
        IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF).approve(address(0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35), usdcDecimalAmount);
        ICToken(0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35).mint(usdcDecimalAmount);
        return amount;
    }
    event log_uint(bytes32, uint256);

    // redeems numeraire amount from cusdc
    // transfers it to destination
    function outputNumeraire (address dst, uint256 amount) public {
        
        ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c).redeemUnderlying(amount);
        IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF).transfer(dst, amount);

    }

    function outputRaw (address dst, uint256 amount) public returns (uint256) {
        amount = amount / 1000000000000;
        uint256 bal = IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF).balanceOf(address(this));
        ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c).redeemUnderlying(amount);
        bal = IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF).balanceOf(address(this)) - bal;
        IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF).transfer(dst, amount);
        return bal;
    }

    // is already numeraire amount
    function getNumeraireAmount (uint256 amount) public pure returns (uint256) {
        return amount;
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