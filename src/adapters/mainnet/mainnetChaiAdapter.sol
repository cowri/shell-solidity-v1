
pragma solidity ^0.5.12;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../../ICToken.sol";
import "../../IChai.sol";
import "../../IPot.sol";

contract MainnetChaiAdapter {

    uint256 internal constant WAD = 10**18;
    uint256 internal constant RAY = 10**27;
    IChai constant chai = IChai(0x06AF07097C9Eeb7fD685c692751D5C66dB49c215);
    IERC20 constant dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    ICToken constant cdai = ICToken(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);
    IPot constant pot = IPot(0x197E90f9FAD81970bA7976f33CbD77088E5D7cf7);

    constructor () public { }

    // takes raw chai amount
    // transfers it into our balance
    function intakeRaw (uint256 amount) public {

        uint256 daiAmt = dai.balanceOf(address(this));
        chai.exit(msg.sender, amount);
        daiAmt = dai.balanceOf(address(this)) - daiAmt;
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
        uint256 chaiBal = chai.balanceOf(dst);
        chai.join(dst, amount);
        return chai.balanceOf(dst) - chaiBal;

    }

    // transfers corresponding chai to destination address
    function outputRaw (address dst, uint256 amount) public returns (uint256) {

        uint256 daiAmt = rmul(amount, pot.chi());
        cdai.redeemUnderlying(daiAmt);
        uint256 chaiAmt = chai.balanceOf(dst);
        chai.join(dst, daiAmt);
        return chai.balanceOf(dst) - chaiAmt;

    }
    
    // pass it a numeraire and get the raw amount
    function viewRawAmount (uint256 amount) public view returns (uint256) {

        return rdivup(amount, pot.chi());

    }

    // pass it a raw amount and get the numeraire amount
    function viewNumeraireAmount (uint256 amount) public view returns (uint256) {

        return rmul(amount, pot.chi());

    }

    function viewNumeraireBalance (address addr) public view returns (uint256) {

        uint256 rate = cdai.exchangeRateStored();
        uint256 balance = cdai.balanceOf(addr);
        return wmul(balance, rate);

    }

    // takes chai amount
    // tells corresponding numeraire value
    function getNumeraireAmount (uint256 amount) public returns (uint256) {

        uint chi = (now > pot.rho()) ? pot.drip() : pot.chi();
        return rmul(amount, chi);

    }

    function getRawAmount (uint256 amount) public returns (uint256) {

        uint chi = (now > pot.rho())
          ? pot.drip()
          : pot.chi();
        return rdivup(amount, chi);

    }

    // tells numeraire balance
    function getNumeraireBalance () public returns (uint256) {

        return cdai.balanceOfUnderlying(address(this));

    }
    
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "ds-math-add-overflow");
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x);
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

    function rmul(uint x, uint y) internal pure returns (uint z) {
        // always rounds down
        z = mul(x, y) / RAY;
    }
    function rdiv(uint x, uint y) internal pure returns (uint z) {
        // always rounds down
        z = mul(x, RAY) / y;
    }
    function rdivup(uint x, uint y) internal pure returns (uint z) {
        // always rounds up
        z = add(mul(x, RAY), sub(y, 1)) / y;
    }

}