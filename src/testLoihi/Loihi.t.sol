pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "../Loihi.sol";
import "./flavorsSetup.sol";
import "./adaptationsSetup.sol";
import "./reservesSetup.sol";

contract LoihiTest is FlavorsSetup, ReservesSetup, AdaptationsSetup, DSMath, DSTest {
    Loihi l;

    function setUp() public {
        setupFlavors();
        setupAdaptations();
        setupReserves();
        l = new Loihi();

        uint256 weight = WAD / 3;

        l.includeReserve(chaiReserve);
        l.includeReserve(cusdcReserve);
        l.includeReserve(usdtReserve);

        l.includeAdaptation(chai, chaiAdapt, chaiReserve, weight);
        l.includeAdaptation(dai, daiAdapt, chaiReserve, weight);
        l.includeAdaptation(cdai, cdaiAdapt, chaiReserve, weight);
        l.includeAdaptation(cusdc, cusdcAdapt, cusdcReserve, weight);
        l.includeAdaptation(usdc, usdcAdapt, cusdcReserve, weight);
        l.includeAdaptation(usdt, usdtAdapt, usdtReserve, weight);
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