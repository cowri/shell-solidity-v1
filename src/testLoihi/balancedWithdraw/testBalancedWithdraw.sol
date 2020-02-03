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

        l.includeNumeraireAndReserve(dai, chaiAdapter);
        l.includeNumeraireAndReserve(usdc, cusdcAdapter);
        l.includeNumeraireAndReserve(usdt, usdtAdapter);

        l.includeAdapter(chai, chaiAdapter, weight);
        l.includeAdapter(dai, daiAdapter, weight);
        l.includeAdapter(cdai, cdaiAdapter, weight);
        l.includeAdapter(cusdc, cusdcAdapter, weight);
        l.includeAdapter(usdc, usdcAdapter, weight);
        l.includeAdapter(usdt, usdtAdapter, weight);


        l.balancedDeposit(100 * (10 ** 18));

    }

    event log_uint_arr(bytes32, uint256[]);

    function testBalancedWithdraw () public {

        uint256[] memory withdrawnTokens = l.balancedWithdraw(90 * (10 ** 18));
        uint256 balance = l.balanceOf(address(this));
        emit log_uint_arr("minted shells", withdrawnTokens);
        emit log_named_uint("balance", balance);

        // uint256 mintedShells2 = l.balancedDeposit(50 * (10 ** 18));
        // uint256 balance2 = l.balanceOf(address(this));
        // emit log_named_uint("mintedShells2", mintedShells2);
        // emit log_named_uint("balance2", balance2);

        // uint256 mintedShells3 = l.balancedDeposit(70 * (10 ** 18));
        // uint256 balance3 = l.balanceOf(address(this));
        // emit log_named_uint("mintedShells2", mintedShells3);
        // emit log_named_uint("balance2", balance3);
        // assertTrue(false);

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