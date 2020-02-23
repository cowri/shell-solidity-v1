
pragma solidity ^0.5.12;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../../ICToken.sol";

contract MainnetDaiAdapter {

    constructor () public { }

    ICToken constant cdai = ICToken(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);
    IERC20 constant dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    uint256 constant WAD = 10 ** 18;

    // transfers dai in
    // wraps it in chai
    function intakeRaw (uint256 amount) public {
        
        dai.transferFrom(msg.sender, address(this), amount);
        cdai.mint(amount);
        
    }

    // transfers dai in
    // wraps it in cdai
    function intakeNumeraire (uint256 amount) public returns (uint256) {
        
        dai.transferFrom(msg.sender, address(this), amount);
        cdai.mint(amount);
        return amount;
        
    }

    // unwraps chai
    // transfers out dai
    function outputRaw (address dst, uint256 amount) public {
        
        cdai.redeemUnderlying(amount);
        dai.transfer(dst, amount);
        
    }

    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {
        
        cdai.redeemUnderlying(amount);
        dai.transfer(dst, amount);
        return amount;
        
    }

    function viewRawAmount (uint256 amount) public pure returns (uint256) {
        return amount;
    }

    function viewNumeraireAmount (uint256 amount) public pure returns (uint256) {
        return amount;
    }

    function viewNumeraireBalance (address addr) public view returns (uint256) {

        uint256 rate = cdai.exchangeRateStored();
        uint256 balance = cdai.balanceOf(addr);
        return wmul(balance, rate);

    }

    function getRawAmount (uint256 amount) public pure returns (uint256) {

        return amount;

    }

    // returns amount, already in numeraire
    function getNumeraireAmount (uint256 amount) public pure returns (uint256) {

        return amount;

    }

    // returns numeraire amount of chai balance
    function getNumeraireBalance () public returns (uint256) {

        return cdai.balanceOfUnderlying(address(this));

    }

    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "ds-math-add-overflow");
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
    }

    function wmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), WAD / 2) / WAD;
    }

    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, WAD), y / 2) / y;
    }

}