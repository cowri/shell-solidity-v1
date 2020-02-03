pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../../Loihi.sol";
import "../../ERC20I.sol";
import "../flavorsSetup.sol";
import "../adaptersSetup.sol";
import "../../ChaiI.sol";

contract PotMock {
    constructor () public { }
    function rho () public returns (uint256) { return now - 500; }
    function drip () public returns (uint256) { return (10 ** 18) * 2; }
    function chi () public returns (uint256) { return (10 ** 18) * 2; }
}

contract SelectiveDepositTest is AdaptersSetup, DSMath, DSTest {
    Loihi l;

    function setUp() public {
        setupFlavors();
        setupAdapters();

        address pot = address(new PotMock());
        l = new Loihi(
            chai, cdai, dai, pot,
            cusdc, usdc,
            usdt
        );

        ERC20I(chai).approve(address(l), 100000 * (10 ** 18));
        ERC20I(cdai).approve(address(l), 100000 * (10 ** 18));
        ERC20I(dai).approve(address(l), 100000 * (10 ** 18));
        ERC20I(cusdc).approve(address(l), 100000 * (10 ** 18));
        ERC20I(usdc).approve(address(l), 100000 * (10 ** 18));
        ERC20I(usdt).approve(address(l), 100000 * (10 ** 18));

        uint256 weight = WAD / 3;

        l.includeNumeraireAndReserve(dai, chaiAdapter);
        l.includeNumeraireAndReserve(usdc, cusdcAdapter);
        l.includeNumeraireAndReserve(usdt, usdtAdapter);

        l.includeAdapter(chai, chaiAdapter, weight);
        l.includeAdapter(dai, daiAdapter, weight);
        l.includeAdapter(cdai, cdaiAdapter, weight);
        l.includeAdapter(cusdc, cusdcAdapter, weight);
        l.includeAdapter(usdc, usdcAdapter, weight);
        l.includeAdapter(usdt, usdtAdapter, weight);

        l.setAlpha((5 * WAD) / 10);
        l.setBeta((25 * WAD) / 100);
        l.setFeeDerivative(WAD / 10);
        l.setFeeBase(500000000000000);

        l.balancedDeposit(210 * (10 ** 18));

    }

    function testSelectiveDeposit () public {

        uint256[] memory amounts = new uint256[](3);
        address[] memory tokens = new address[](3);


    }

    // function testSelectiveDeposit () public {

    //     uint256[] memory deposits = new uint256[](3);
    //     deposits[0] = 250;
    //     deposits[1] = 250;
    //     deposits[2] = 500;

    //     address[] memory flavors = new address[](3);
    //     flavors[0] = chai;
    //     flavors[1] = cusdc;
    //     flavors[2] = usdt;

    //     l.selectiveDeposit(flavors, deposits);

    // }

}