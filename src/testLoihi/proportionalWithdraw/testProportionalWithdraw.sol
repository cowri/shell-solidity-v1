pragma solidity ^0.5.6;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "ds-test/test.sol";
import "ds-math/math.sol";
import "../flavorsSetup.sol";
import "../adaptersSetup.sol";
import "../../Loihi.sol";

contract TestProportionalWithdraw is AdaptersSetup, DSMath, DSTest {
    Loihi l;

    event log_uints(bytes32, uint256[]);

    function setUp() public {

        // setupFlavors();
        // setupAdapters();
        // l = new Loihi(chai, cdai, dai, pot, cusdc, usdc, usdt);
        // approveFlavors(address(l));
        
        setupFlavors();
        setupAdapters();
        l = new Loihi(address(0), address(0), address(0), address(0), address(0), address(0), address(0));
        approveFlavors(address(l));

        uint256 weight = WAD / 3;

        l.includeNumeraireAndReserve(dai, cdaiAdapter);
        l.includeNumeraireAndReserve(usdc, cusdcAdapter);
        l.includeNumeraireAndReserve(usdt, usdtAdapter);

        l.includeAdapter(chai, chaiAdapter, cdaiAdapter, weight);
        l.includeAdapter(dai, daiAdapter, cdaiAdapter, weight);
        l.includeAdapter(cdai, cdaiAdapter, cdaiAdapter, weight);
        l.includeAdapter(cusdc, cusdcAdapter, cusdcAdapter, weight);
        l.includeAdapter(usdc, usdcAdapter, cusdcAdapter, weight);
        l.includeAdapter(usdt, usdtAdapter, usdtAdapter, weight);

        l.proportionalDeposit(300 * (10 ** 18));

    }

    function testproportionalWithdraw300 () public {

        uint256[] memory withdrawals = l.proportionalWithdraw(300 * WAD);
        assertEq(l.totalSupply(), 0);
        assertEq(withdrawals[0] / 10000000000, 9994999999);
        assertEq(withdrawals[1], 99949998);
        assertEq(withdrawals[2], 99949998);

    }

    function testProportionalWithdraw150 () public {

        uint256[] memory withdrawals = l.proportionalWithdraw(150 * WAD);
        assertEq(l.totalSupply(), 150000000000000000000);
        assertEq(withdrawals[0] / 10000000000, 4997499999);
        assertEq(withdrawals[1], 49974999);
        assertEq(withdrawals[2], 49974999);

    }

}