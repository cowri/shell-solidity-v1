pragma solidity ^0.5.12;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract KovanUsdtAdapter {

    constructor () public { }

    // transfers usdt in
    function intakeRaw (uint256 amount) public returns (uint256) {
        safeTransferFrom(IERC20(0x20F7963EF38AC716A85ed18fb683f064db944648), msg.sender, address(this), amount);
        return amount;
    }

    // transfers usdt in
    function intakeNumeraire (uint256 amount) public returns (uint256) {
        safeTransferFrom(IERC20(0x20F7963EF38AC716A85ed18fb683f064db944648), msg.sender, address(this), amount);
        return amount;
    }

    // transfers usdt out of our balance
    function outputRaw (address dst, uint256 amount) public returns (uint256) {
        safeTransfer(IERC20(0x20F7963EF38AC716A85ed18fb683f064db944648), dst, amount);
        return amount;
    }

    // transfers usdt to destination
    function outputNumeraire (address dst, uint256 amount) public  {
        safeTransfer(IERC20(0x20F7963EF38AC716A85ed18fb683f064db944648), dst, amount);
    }

    // returns amount, is already numeraire amount
    function getNumeraireAmount (uint256 amount) public returns (uint256) {
        return amount;
    }

    // returns balance
    function getNumeraireBalance () public returns (uint256) {
        return IERC20(0x20F7963EF38AC716A85ed18fb683f064db944648).balanceOf(address(this));
    }
    
    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        callOptionalReturn(address(token), abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(address(token), abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function callOptionalReturn(address token, bytes memory data) private {

        (bool success, bytes memory returndata) = token.call(data);
        require(success, "SafeERC20: low-level call failed");

    }
}