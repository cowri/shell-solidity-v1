pragma solidity ^0.5.0;

import "./storage.sol";

/* Mainnet Assimilators set one - holding reserves in cDai, cUsdc, aUsdt and aSusd */
import "../../assimilators/mainnet/daiReserves/mainnetDaiToDaiAssimilator.sol";
import "../../assimilators/mainnet/daiReserves/mainnetCDaiToDaiAssimilator.sol";
import "../../assimilators/mainnet/daiReserves/mainnetChaiToDaiAssimilator.sol";
import "../../assimilators/mainnet/usdcReserves/mainnetUsdcToUsdcAssimilator.sol";
import "../../assimilators/mainnet/usdcReserves/mainnetCUsdcToUsdcAssimilator.sol";
import "../../assimilators/mainnet/susdReserves/mainnetSUsdToSUsdAssimilator.sol";
import "../../assimilators/mainnet/susdReserves/mainnetASUsdToSUsdAssimilator.sol";
import "../../assimilators/mainnet/usdtReserves/mainnetUsdtToUsdtAssimilator.sol";
import "../../assimilators/mainnet/usdtReserves/mainnetAUsdtToUsdtAssimilator.sol";

contract AssimilatorSetup is StorageSetup {

    function setupAssimilatorsSetOneMainnet () public {

        daiAssimilator = IAssimilator(address(new MainnetDaiToDaiAssimilator()));
        cdaiAssimilator = IAssimilator(address(new MainnetCDaiToDaiAssimilator()));
        chaiAssimilator = IAssimilator(address(new MainnetChaiToDaiAssimilator()));

        usdcAssimilator = IAssimilator(address(new MainnetUsdcToUsdcAssimilator()));
        cusdcAssimilator = IAssimilator(address(new MainnetCUsdcToUsdcAssimilator()));

        usdtAssimilator = IAssimilator(address(new MainnetUsdtToUsdtAssimilator()));
        ausdtAssimilator = IAssimilator(address(new MainnetAUsdtToUsdtAssimilator()));

        susdAssimilator = IAssimilator(address(new MainnetSUsdToSUsdAssimilator()));
        asusdAssimilator = IAssimilator(address(new MainnetASUsdToSUsdAssimilator()));

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
