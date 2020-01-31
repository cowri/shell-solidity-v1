pragma solidity ^0.5.6;

import "../adaptations/chai.sol";
import "../adaptations/cdai.sol";
import "../adaptations/dai.sol";
import "../adaptations/cusdc.sol";
import "../adaptations/usdc.sol";
import "../adaptations/usdt.sol";

contract AdapterSetup {
    ChaiAdaptation chaiAdapt;
    cDaiAdaptation cdaiAdapt;
    cUsdcAdaptation cusdcAdapt;
    DaiAdaptation daiAdapt;
    UsdcAdaptation usdcAdapt;
    UsdtAdaptation usdtAdapt;

    function setUpAdapters() public {
        l = new Loihi();
        chaiAdapt = new ChaiAdaptation();
        cdaiAdapt = new cDaiAdaptation();
        cusdcAdapt = new cUsdcAdaptation();
        daiAdapt = new DaiAdaptation();
        usdcAdapt = new UsdcAdaptation();
        usdtAdapt = new UsdtAdaptation();
    }



}