
pragma solidity ^0.5.12;

import "ds-math/math.sol";
import "../ERC20I.sol";
import "../ChaiI.sol";
import "../BadERC20I.sol";
import "../CTokenI.sol";
import "../PotI.sol";
import "../LoihiRoot.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract cDaiAdapter is LoihiRoot {

    ChaiI chai;
    CTokenI cdai;
    ERC20I dai;
    PotI pot;
    CTokenI cusdc;
    ERC20I usdc;
    IERC20 usdt;

    // ChaiI constant public chai = ChaiI(0xB641957b6c29310926110848dB2d464C8C3c3f38);
    // CTokenI constant public cdai = CTokenI(0xe7bc397DBd069fC7d0109C0636d06888bb50668c);
    // IERC20 constant public dai = IERC20(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa);
    // PotI constant public pot = PotI(0xEA190DBDC7adF265260ec4dA6e9675Fd4f5A78bb);
    // CTokenI constant public cusdc = CTokenI(0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35);
    // IERC20 constant public usdc = IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF);
    // IERC20 constant public usdt = IERC20(0x20F7963EF38AC716A85ed18fb683f064db944648);

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