
pragma solidity ^0.5.12;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../../IChai.sol";
import "../../ICToken.sol";
import "../../IPot.sol";
import "../../LoihiRoot.sol";

contract LocalUsdtAdapter is LoihiRoot {

    IChai chai;
    ICToken cdai;
    IERC20 dai;
    IPot pot;
    ICToken cusdc;
    IERC20 usdc;
    IERC20 usdt;

    constructor () public { }

    // transfers usdt in
    function intakeRaw (uint256 amount) public returns (uint256) {
        safeTransferFrom(usdt, msg.sender, address(this), amount);
        return amount;
    }

    // transfers usdt in
    function intakeNumeraire (uint256 amount) public returns (uint256) {
        safeTransferFrom(usdt, msg.sender, address(this), amount);
        return amount;
    }

    // transfers usdt out of our balance
    function outputRaw (address dst, uint256 amount) public returns (uint256) {
        safeTransfer(usdt, dst, amount);
        return amount;
    }

    // transfers usdt to destination
    function outputNumeraire (address dst, uint256 amount) public  {
        safeTransfer(usdt, dst, amount);
    }

    // returns amount, is already numeraire amount
    function getNumeraireAmount (uint256 amount) public returns (uint256) {
        return amount;
    }

    // returns balance
    function getNumeraireBalance () public returns (uint256) {
        return usdt.balanceOf(address(this));
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