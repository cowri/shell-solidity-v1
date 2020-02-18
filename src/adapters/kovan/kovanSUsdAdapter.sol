pragma solidity ^0.5.12;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../aaveResources/ILendingPool.sol";
import "../aaveResources/ILendingPoolAddressesProvider.sol";
import "../../IAToken.sol";

contract KovanSUsdAdapter {

    constructor () public { }

    ILendingPoolAddressesProvider constant lpProvider = ILendingPoolAddressesProvider(0x506B0B2CF20FAA8f38a4E2B524EE43e1f4458Cc5);
    IERC20 constant susd = IERC20(0xD868790F57B39C9B2B51b12de046975f986675f9);
    IAToken constant asusd = IAToken(0xb9c1434aB6d5811D1D0E92E8266A37Ae8328e901);

    event log_uint(bytes32, uint256);
    // transfers susd in
    function intakeRaw (uint256 amount) public returns (uint256) {

        emit log_uint("raw", amount);
        uint256 balBefore = susd.balanceOf(address(this));
        susd.transferFrom(msg.sender, address(this), amount);
        uint256 balAfter = susd.balanceOf(address(this));
        emit log_uint("before", balBefore);
        emit log_uint("balAfter", balAfter);

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());

        address poolCore = lpProvider.getLendingPoolCore();
        susd.approve(address(poolCore), amount * 2);

        pool.deposit(address(susd), amount, 0);

        return amount;
    }

    // transfers susd in
    function intakeNumeraire (uint256 amount) public returns (uint256) {
        amount /= 1000000000000;
        safeTransferFrom(susd, msg.sender, address(this), amount);

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());

        address poolCore = lpProvider.getLendingPoolCore();
        susd.approve(address(poolCore), amount * 2);

        pool.deposit(address(susd), amount, 0);
        return amount;
    }

    // transfers susd out of our balance
    function outputRaw (address dst, uint256 amount) public returns (uint256) {
        asusd.redeem(amount);
        safeTransfer(susd, dst, amount);
        return amount;
    }

    // transfers susd to destination
    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {
        amount /= 1000000000000;
        asusd.redeem(amount);
        safeTransfer(susd, dst, amount);
        return amount;
    }

    function viewRawAmount (uint256 amount) public pure returns (uint256) {
        return amount / 1000000000000;
    }

    function viewNumeraireAmount (uint256 amount) public pure returns (uint256) {
        return amount * 1000000000000;
    }

    function viewNumeraireBalance (address addr) public view returns (uint256) {
        return asusd.balanceOf(addr) * 1000000000000;
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
        return asusd.balanceOf(address(this)) * 1000000000000;
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