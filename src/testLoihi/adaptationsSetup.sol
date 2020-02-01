pragma solidity ^0.5.6;

import "../adaptations/chai.sol";
import "../adaptations/cdai.sol";
import "../adaptations/dai.sol";
import "../adaptations/cusdc.sol";
import "../adaptations/usdc.sol";
import "../adaptations/usdt.sol";

contract AdaptationsSetup {
    address chaiAdapt;
    address cdaiAdapt;
    address cusdcAdapt;
    address daiAdapt;
    address usdcAdapt;
    address usdtAdapt;

    function setupAdaptations() public {
        // chaiAdapt = address(new ChaiAdaptation());
        // cdaiAdapt = address(new cDaiAdaptation());
        // cusdcAdapt = address(new cUsdcAdaptation());
        // daiAdapt = address(new DaiAdaptation());
        // usdcAdapt = address(new UsdcAdaptation());
        // usdtAdapt = address(new UsdtAdaptation());
    }



}