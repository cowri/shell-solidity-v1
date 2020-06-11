pragma solidity ^0.5.0;

import "./storage.sol";

import "../../assimilators/kovan/KovanDaiAssimilator.sol";
import "../../assimilators/kovan/KovanCDaiAssimilator.sol";
import "../../assimilators/kovan/KovanChaiAssimilator.sol";
import "../../assimilators/kovan/KovanUsdcAssimilator.sol";
import "../../assimilators/kovan/KovanCUsdcAssimilator.sol";
import "../../assimilators/kovan/KovanSUsdAssimilator.sol";
import "../../assimilators/kovan/KovanASUsdAssimilator.sol";
import "../../assimilators/kovan/KovanUsdtAssimilator.sol";
import "../../assimilators/kovan/KovanAUsdtAssimilator.sol";

/* Assimilator set one - holding reserves in cDai, cUsdc, aUsdt and aSusd */
import "../../assimilators/mainnet/cdaiReserves/MainnetDaiToCDaiAssimilator.sol";
import "../../assimilators/mainnet/cdaiReserves/MainnetCDaiToCDaiAssimilator.sol";
import "../../assimilators/mainnet/cdaiReserves/MainnetChaiToCDaiAssimilator.sol";
import "../../assimilators/mainnet/cusdcReserves/MainnetUsdcToCUsdcAssimilator.sol";
import "../../assimilators/mainnet/cusdcReserves/MainnetCUsdcToCUsdcAssimilator.sol";
import "../../assimilators/mainnet/asusdReserves/MainnetSUsdToASUsdAssimilator.sol";
import "../../assimilators/mainnet/asusdReserves/MainnetASUsdToASUsdAssimilator.sol";
import "../../assimilators/mainnet/ausdtReserves/MainnetUsdtToAUsdtAssimilator.sol";
import "../../assimilators/mainnet/ausdtReserves/MainnetAUsdtToAUsdtAssimilator.sol";

/* Assimilator set one - holding reserves in cDai, cUsdc, aUsdt and aSusd */
import "../../assimilators/local/cdaiReserves/LocalDaiToCDaiAssimilator.sol";
import "../../assimilators/local/cdaiReserves/LocalCDaiToCDaiAssimilator.sol";
import "../../assimilators/local/cdaiReserves/LocalChaiToCDaiAssimilator.sol";
import "../../assimilators/local/cusdcReserves/LocalUsdcToCUsdcAssimilator.sol";
import "../../assimilators/local/cusdcReserves/LocalCUsdcToCUsdcAssimilator.sol";
import "../../assimilators/local/ausdtReserves/LocalUsdtToAUsdtAssimilator.sol";
import "../../assimilators/local/ausdtReserves/LocalAUsdtToAUsdtAssimilator.sol";
import "../../assimilators/local/asusdReserves/LocalSUsdToASUsdAssimilator.sol";
import "../../assimilators/local/asusdReserves/LocalASUsdToASUsdAssimilator.sol";

/* Assimilator set two - staking to dai, usdc, usdt and susd */
import "../../assimilators/local/daiReserves/LocalDaiToDaiAssimilator.sol";
import "../../assimilators/local/daiReserves/LocalCDaiToDaiAssimilator.sol";
import "../../assimilators/local/daiReserves/LocalChaiToDaiAssimilator.sol";
import "../../assimilators/local/usdcReserves/LocalUsdcToUsdcAssimilator.sol";
import "../../assimilators/local/usdcReserves/LocalCUsdcToUsdcAssimilator.sol";
import "../../assimilators/local/usdtReserves/LocalUsdtToUsdtAssimilator.sol";
import "../../assimilators/local/usdtReserves/LocalAUsdtToUsdtAssimilator.sol";
import "../../assimilators/local/susdReserves/LocalSUsdToSUsdAssimilator.sol";
import "../../assimilators/local/susdReserves/LocalASUsdToSUsdAssimilator.sol";


contract AssimilatorSetup is StorageSetup {

    event log_bytes(bytes32, bytes4);
    
    function setupAssimilatorsSetOneLocal () public {

        daiAssimilator = IAssimilator(address(new LocalDaiToDaiAssimilator(address(dai))));
        cdaiAssimilator = IAssimilator(address(new LocalCDaiToDaiAssimilator(address(dai), address(cdai))));
        chaiAssimilator = IAssimilator(address(new LocalChaiToDaiAssimilator(address(dai), address(chai), address(pot))));

        usdcAssimilator = IAssimilator(address(new LocalUsdcToUsdcAssimilator(address(usdc))));
        cusdcAssimilator = IAssimilator(address(new LocalCUsdcToUsdcAssimilator(address(usdc), address(cusdc))));

        usdtAssimilator = IAssimilator(address(new LocalUsdtToUsdtAssimilator(address(usdt))));
        ausdtAssimilator = IAssimilator(address(new LocalAUsdtToUsdtAssimilator(address(usdt), address(ausdt))));

        susdAssimilator = IAssimilator(address(new LocalSUsdToSUsdAssimilator(address(susd))));
        asusdAssimilator = IAssimilator(address(new LocalASUsdToSUsdAssimilator(address(susd), address(asusd))));

    }

    function setupAssimilatorsSetTwoLocal () public {

        daiAssimilator = IAssimilator(address(new LocalDaiToCDaiAssimilator(address(dai), address(cdai))));
        cdaiAssimilator = IAssimilator(address(new LocalCDaiToCDaiAssimilator(address(cdai))));
        chaiAssimilator = IAssimilator(address(new LocalChaiToCDaiAssimilator(address(dai), address(cdai), address(chai), address(pot))));

        usdcAssimilator = IAssimilator(address(new LocalUsdcToCUsdcAssimilator(address(usdc), address(cusdc))));
        cusdcAssimilator = IAssimilator(address(new LocalCUsdcToCUsdcAssimilator(address(cusdc))));

        usdtAssimilator = IAssimilator(address(new LocalUsdtToAUsdtAssimilator(address(usdt), address(ausdt))));
        ausdtAssimilator = IAssimilator(address(new LocalAUsdtToAUsdtAssimilator(address(ausdt))));

        susdAssimilator = IAssimilator(address(new LocalSUsdToASUsdAssimilator(address(susd), address(asusd))));
        asusdAssimilator = IAssimilator(address(new LocalASUsdToASUsdAssimilator(address(asusd))));

    }

    function setupAssimilatorsKovan () public {

        usdcAssimilator = IAssimilator(address(new KovanUsdcAssimilator()));
        cusdcAssimilator = IAssimilator(address(new KovanCUsdcAssimilator()));

        daiAssimilator = IAssimilator(address(new KovanDaiAssimilator()));
        cdaiAssimilator = IAssimilator(address(new KovanCDaiAssimilator()));
        chaiAssimilator = IAssimilator(address(new KovanChaiAssimilator()));

        usdtAssimilator = IAssimilator(address(new KovanUsdtAssimilator()));
        ausdtAssimilator = IAssimilator(address(new KovanAUsdtAssimilator()));

        susdAssimilator = IAssimilator(address(new KovanSUsdAssimilator()));
        asusdAssimilator = IAssimilator(address(new KovanASUsdAssimilator()));

    }

    function setupAssimilatorsSetOneMainnet () public {

        usdcAssimilator = IAssimilator(address(new MainnetUsdcToCUsdcAssimilator()));
        cusdcAssimilator = IAssimilator(address(new MainnetCUsdcToCUsdcAssimilator()));

        daiAssimilator = IAssimilator(address(new MainnetDaiToCDaiAssimilator()));
        cdaiAssimilator = IAssimilator(address(new MainnetCDaiToCDaiAssimilator()));
        chaiAssimilator = IAssimilator(address(new MainnetChaiToCDaiAssimilator()));

        usdtAssimilator = IAssimilator(address(new MainnetUsdtToAUsdtAssimilator()));
        ausdtAssimilator = IAssimilator(address(new MainnetAUsdtToAUsdtAssimilator()));

        susdAssimilator = IAssimilator(address(new MainnetSUsdToASUsdAssimilator()));
        asusdAssimilator = IAssimilator(address(new MainnetASUsdToASUsdAssimilator()));

    }

    function setupDeployedAssimilatorsMainnet () public {

        usdcAssimilator = IAssimilator(0x54B7b567bc634E19632A8E85EEaE4EAE955ae9f9);
        cusdcAssimilator = IAssimilator(0xf5AB3FFD9F92893cAf1CBCcEC01b1c6EaA140C3f);

        daiAssimilator = IAssimilator(0x9E77104724A8390b6f2e80E222B5E8fe7eb7383f);
        cdaiAssimilator = IAssimilator(0xaEb74F5a22935FB6c812395c3e2fE2F5258c8d6E);
        chaiAssimilator = IAssimilator(0x21C09C793cc94c964D76cEC0A80D2cC61f155375);

        usdtAssimilator = IAssimilator(0xCd0dA368E6e32912DD6633767850751969346d15);
        ausdtAssimilator = IAssimilator(0xA4906F20a7806ca28626d3D607F9a594f1B9ed3B);

        susdAssimilator = IAssimilator(0x4CB5174C962a40177876799836f353e8E9c4eF75);
        asusdAssimilator = IAssimilator(0x68747564d7B4e7b654BE26D09f60f7756Cf54BF8);

    }

}