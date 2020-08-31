pragma solidity ^0.5.0;

import "./storage.sol";

/* Assimilator set one - staking to dai, usdc, usdt and susd */
import "../../assimilators/kovan/daiReserves/kovanDaiToDaiAssimilator.sol";
import "../../assimilators/kovan/usdcReserves/kovanUsdcToUsdcAssimilator.sol";
import "../../assimilators/kovan/usdtReserves/kovanUsdtToUsdtAssimilator.sol";
import "../../assimilators/kovan/susdReserves/kovanSUsdToSUsdAssimilator.sol";

contract AssimilatorSetup is StorageSetup {

    function setupAssimilatorsSetOneKovan () public {

        daiAssimilator = IAssimilator(address(new KovanDaiToDaiAssimilator()));
        usdcAssimilator = IAssimilator(address(new KovanUsdcToUsdcAssimilator()));
        usdtAssimilator = IAssimilator(address(new KovanUsdtToUsdtAssimilator()));
        susdAssimilator = IAssimilator(address(new KovanSUsdToSUsdAssimilator()));

    }

}
