
pragma solidity ^0.5.12;

import "ds-math/math.sol";
import "../ERC20I.sol";
import "../ChaiI.sol";
import "../BadERC20I.sol";
import "../CTokenI.sol";
import "../PotI.sol";
import "../LoihiRoot.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract ChaiAdapter is LoihiRoot {

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

    // takes raw chai amount
    // transfers it into our balance
    function intakeRaw (uint256 amount) public {
        uint256 daiAmt = dai.balanceOf(address(this));
        chai.exit(msg.sender, amount);
        daiAmt = dai.balanceOf(address(this)) - daiAmt;
        dai.approve(address(cdai), daiAmt);
        cdai.mint(daiAmt);
    }


    // takes numeraire amount
    // transfers corresponding chai into our balance;
    function intakeNumeraire (uint256 amount) public returns (uint256) {
        chai.draw(msg.sender, amount);
        cdai.mint(amount);
        return amount;
    }

    // takes numeraire amount
    // transfers corresponding chai to destination address
    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {
        cdai.redeemUnderlying(amount);
        uint256 chaiBal = chai.balanceOf(address(this));
        dai.approve(address(this), amount);
        chai.join(dst, amount);
        chaiBal = chaiBal - chai.balanceOf(address(this));
        return chaiBal;
    }

    // transfers corresponding chai to destination address
    function outputRaw (address dst, uint256 amount) public returns (uint256) {
        return amount;
    }

    // takes chai amount
    // tells corresponding numeraire value
    function getNumeraireAmount (uint256 amount) public returns (uint256) {
        uint chi = (now > pot.rho()) ? pot.drip() : pot.chi();
        return wmul(amount, chi);
    }

    // tells numeraire balance
    function getNumeraireBalance () public returns (uint256) {
        return cdai.balanceOfUnderlying(address(this));
    }

}