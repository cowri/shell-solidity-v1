pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../Loihi.sol";
import "../ERC20I.sol";
import "./flavorsSetup.sol";
import "./adaptersSetup.sol";
import "../ChaiI.sol";

contract PotMock {
    constructor () public { }
    function rho () public returns (uint256) { return now - 500; }
    function drip () public returns (uint256) { return (10 ** 18) * 2; }
    function chi () public returns (uint256) { return (10 ** 18) * 2; }
}

contract LoihiTest is AdaptersSetup, DSMath, DSTest {
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

        l.includeReserve(chaiAdapter);
        l.includeReserve(cusdcAdapter);
        l.includeReserve(usdtAdapter);

        l.includeAdapter(chai, chaiAdapter, weight);
        l.includeAdapter(dai, daiAdapter, weight);
        l.includeAdapter(cdai, cdaiAdapter, weight);
        l.includeAdapter(cusdc, cusdcAdapter, weight);
        l.includeAdapter(usdc, usdcAdapter, weight);
        l.includeAdapter(usdt, usdtAdapter, weight);

        emit log_named_uint("allowance to l for chai", ERC20I(chai).allowance(address(this), address(l)));
        emit log_named_uint("dai", ChaiI(chai).dai(address(this)));
        emit log_named_address("chai", address(chai));
        emit log_named_address("chai adapter", chaiAdapter);
        emit log_named_address("cusdc adapter", cusdcAdapter);
        emit log_named_address("usdt adapter", usdtAdapter);

    }

    function testDepositLiquidity () public {

        uint256[] memory deposits = new uint256[](3);
        deposits[0] = 250;
        deposits[1] = 250;
        deposits[2] = 500;

        address[] memory flavors = new address[](3);
        flavors[0] = chai;
        flavors[1] = cusdc;
        flavors[2] = usdt;

        l.selectiveDeposit(flavors, deposits);

    }

}