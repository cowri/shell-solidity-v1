pragma solidity ^0.5.0;

import "./storage.sol";

/* Assimilator set one - staking to dai, usdc, usdt and susd */
import "../../assimilators/local/daiReserves/localDaiToDaiAssimilator.sol";
import "../../assimilators/local/usdcReserves/localUsdcToUsdcAssimilator.sol";
import "../../assimilators/local/usdtReserves/localUsdtToUsdtAssimilator.sol";
import "../../assimilators/local/susdReserves/localSUsdToSUsdAssimilator.sol";

/* Assimilator set one - staking to dai, usdc, usdt and susd */
import "../../assimilators/kovan/daiReserves/kovanDaiToDaiAssimilator.sol";
import "../../assimilators/kovan/usdcReserves/kovanUsdcToUsdcAssimilator.sol";
import "../../assimilators/kovan/usdtReserves/kovanUsdtToUsdtAssimilator.sol";
import "../../assimilators/kovan/susdReserves/kovanSUsdToSUsdAssimilator.sol";

// /* Assimilator set one - staking to dai, usdc, usdt and susd */
// import "../../assimilators/mainnet/daiReserves/mainnetDaiToDaiAssimilator.sol";
// import "../../assimilators/mainnet/usdcReserves/mainnetUsdcToUsdcAssimilator.sol";
// import "../../assimilators/mainnet/usdtReserves/mainnetUsdtToUsdtAssimilator.sol";
// import "../../assimilators/mainnet/susdReserves/mainnetSUsdToSUsdAssimilator.sol";

contract AssimilatorSetup is StorageSetup {

    event log_bytes(bytes32, bytes4);

    function setupAssimilatorsSetOneLocal () public {

        daiAssimilator = IAssimilator(address(new LocalDaiToDaiAssimilator(address(dai))));
        usdcAssimilator = IAssimilator(address(new LocalUsdcToUsdcAssimilator(address(usdc))));
        usdtAssimilator = IAssimilator(address(new LocalUsdtToUsdtAssimilator(address(usdt))));
        susdAssimilator = IAssimilator(address(new LocalSUsdToSUsdAssimilator(address(susd))));

    }

    function setupAssimilatorsSetOneKovan () public {

        daiAssimilator = IAssimilator(address(new KovanDaiToDaiAssimilator()));
        usdcAssimilator = IAssimilator(address(new KovanUsdcToUsdcAssimilator()));
        usdtAssimilator = IAssimilator(address(new KovanUsdtToUsdtAssimilator()));
        susdAssimilator = IAssimilator(address(new KovanSUsdToSUsdAssimilator()));

    }

    function setupAssimilatorsSetOneMainnet () public {

        // daiAssimilator = IAssimilator(address(new MainnetDaiToDaiAssimilator(address(dai))));
        // usdcAssimilator = IAssimilator(address(new MainnetUsdcToUsdcAssimilator(address(usdc))));
        // usdtAssimilator = IAssimilator(address(new MainnetUsdtToUsdtAssimilator(address(usdt))));
        // susdAssimilator = IAssimilator(address(new MainnetSUsdToSUsdAssimilator(address(susd))));

    }
}
