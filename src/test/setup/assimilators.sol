pragma solidity ^0.5.0;

import "./storage.sol";

/* Assimilator set one - staking to dai, usdc, usdt and susd */
import "../../assimilators/local/daiReserves/localDaiToDaiAssimilator.sol";
import "../../assimilators/local/usdcReserves/localUsdcToUsdcAssimilator.sol";
import "../../assimilators/local/usdtReserves/localUsdtToUsdtAssimilator.sol";
import "../../assimilators/local/susdReserves/localSUsdToSUsdAssimilator.sol";

contract AssimilatorSetup is StorageSetup {

    event log_bytes(bytes32, bytes4);

    function setupAssimilatorsSetOneLocal () public {

        daiAssimilator = IAssimilator(address(new LocalDaiToDaiAssimilator(address(dai))));
        usdcAssimilator = IAssimilator(address(new LocalUsdcToUsdcAssimilator(address(usdc))));
        usdtAssimilator = IAssimilator(address(new LocalUsdtToUsdtAssimilator(address(usdt))));
        susdAssimilator = IAssimilator(address(new LocalSUsdToSUsdAssimilator(address(susd))));

    }

}
