pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../Loihi.sol";
import "./flavorsSetup.sol";
import "./adaptersSetup.sol";

contract LoihiTest is AdaptersSetup, DSMath, DSTest {
    Loihi l;

    function setUp() public {
        setupFlavors();
        setupAdapters();
        l = new Loihi();

        uint256 weight = WAD / 3;

        l.includeAdaptation(chai, chaiAdapter, weight);
        l.includeAdaptation(dai, daiAdapter, weight);
        l.includeAdaptation(cdai, cdaiAdapter, weight);
        l.includeAdaptation(cusdc, cusdcAdapter, weight);
        l.includeAdaptation(usdc, usdcAdapter, weight);
        l.includeAdaptation(usdt, usdtAdapter, weight);
    }

    function testDepositLiquidity () public {

        uint256[] memory deposits = new uint256[](3);
        deposits[0] = 500;
        deposits[1] = 500;
        deposits[2] = 500;

        address[] memory flavors = new address[](3);
        flavors[0] = chai;
        flavors[1] = cusdc;
        flavors[2] = usdt;

        l.selectiveDeposit(flavors, deposits);

    }

}