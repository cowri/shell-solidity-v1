pragma solidity ^0.5.12;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract KovanUsdtAdapter {

    constructor () public { }

    // transfers usdt in
    function intakeRaw (uint256 amount) public returns (uint256) {
        safeTransferFrom(IERC20(0x1886b2763b26C45c8DE3e4ccc2bbD02578f9e62D), msg.sender, address(this), amount);
        return amount;
    }

    // transfers usdt in
    function intakeNumeraire (uint256 amount) public returns (uint256) {
        amount /= 1000000000000;
        safeTransferFrom(IERC20(0x1886b2763b26C45c8DE3e4ccc2bbD02578f9e62D), msg.sender, address(this), amount);
        return amount;
    }

    // transfers usdt out of our balance
    function outputRaw (address dst, uint256 amount) public returns (uint256) {
        safeTransfer(IERC20(0x1886b2763b26C45c8DE3e4ccc2bbD02578f9e62D), dst, amount);
        return amount;
    }

    // transfers usdt to destination
    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {
        amount /= 1000000000000;
        safeTransfer(IERC20(0x1886b2763b26C45c8DE3e4ccc2bbD02578f9e62D), dst, amount);
        return amount;
    }

    function viewRawAmount (uint256 amount) public pure returns (uint256) {
        return amount / 1000000000000;
    }

    function viewNumeraireAmount (uint256 amount) public pure returns (uint256) {
        return amount * 1000000000000;
    }

    function viewNumeraireBalance (address addr) public view returns (uint256) {
        return IERC20(0x1886b2763b26C45c8DE3e4ccc2bbD02578f9e62D).balanceOf(addr) * 1000000000000;
    }

    function getRawAmount (uint256 amount) public pure returns (uint256) {
        return amount / 1000000000000;
    }

    // returns amount, is already numeraire amount
    function getNumeraireAmount (uint256 amount) public returns (uint256) {
        return amount * 1000000000000;
    }

    // returns balance
    function getNumeraireBalance () public returns (uint256) {
        return IERC20(0x1886b2763b26C45c8DE3e4ccc2bbD02578f9e62D).balanceOf(address(this)) * 1000000000000;
    }
    
    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        callOptionalReturn(address(token), abi.encodeWithSelector(0xa9059cbb, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(address(token), abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function callOptionalReturn(address token, bytes memory data) private {

        (bool success, bytes memory returndata) = token.call(data);
        require(success, "SafeERC20: low-level call failed");

    }
}