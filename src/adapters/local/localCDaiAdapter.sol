
pragma solidity ^0.5.12;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../../IChai.sol";
import "../../ICToken.sol";
import "../../IPot.sol";
import "../../LoihiRoot.sol";

contract LocalCDaiAdapter is LoihiRoot {

    IChai chai;
    ICToken cdai;
    IERC20 dai;
    IPot pot;
    ICToken cusdc;
    IERC20 usdc;
    IERC20 usdt;

    constructor () public { }

    // takes raw cdai amount
    // unwraps it into dai
    // deposits dai amount in chai
    function intakeRaw (uint256 amount) public {
        cdai.transferFrom(msg.sender, address(this), amount);
    }

    function intakeNumeraire (uint256 amount) public returns (uint256) {
        uint256 rate = cdai.exchangeRateCurrent();
        uint256 cdaiAmount = wmul(rate, amount);
        cdai.transferFrom(msg.sender, address(this), cdaiAmount);
        return cdaiAmount;
    }

    // unwraps numeraire amount of dai from chai
    // wraps it into cdai amount
    // sends that to destination
    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {
        uint rate = cdai.exchangeRateCurrent();
        uint cdaiAmount = wmul(amount, rate);
        cdai.transfer(dst, cdaiAmount);
        return cdaiAmount;
    }

    // takes raw amount and gives numeraire amount
    function getNumeraireAmount (uint256 amount) public returns (uint256) {
        uint256 rate = cdai.exchangeRateCurrent();
        return wdiv(amount, rate);
    }

    event log_address(bytes32, address);

    function getNumeraireBalance () public returns (uint256) {
        emit log_address("cdai", address(cdai));
        return cdai.balanceOfUnderlying(address(this));
    }

}