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

import "../../assimilators/mainnet/MainnetDaiAssimilator.sol";
import "../../assimilators/mainnet/MainnetCDaiAssimilator.sol";
import "../../assimilators/mainnet/MainnetChaiAssimilator.sol";
import "../../assimilators/mainnet/MainnetUsdcAssimilator.sol";
import "../../assimilators/mainnet/MainnetCUsdcAssimilator.sol";
import "../../assimilators/mainnet/MainnetSUsdAssimilator.sol";
import "../../assimilators/mainnet/MainnetASUsdAssimilator.sol";
import "../../assimilators/mainnet/MainnetUsdtAssimilator.sol";
import "../../assimilators/mainnet/MainnetAUsdtAssimilator.sol";

import "../../assimilators/local/LocalDaiAssimilator.sol";
import "../../assimilators/local/LocalCDaiAssimilator.sol";
import "../../assimilators/local/LocalChaiAssimilator.sol";
import "../../assimilators/local/LocalUsdcAssimilator.sol";
import "../../assimilators/local/LocalCUsdcAssimilator.sol";
import "../../assimilators/local/LocalUsdtAssimilator.sol";
import "../../assimilators/local/LocalAusdtAssimilator.sol";
import "../../assimilators/local/LocalSUsdAssimilator.sol";
import "../../assimilators/local/LocalASUsdAssimilator.sol";

contract AssimilatorSetup is StorageSetup {

    event log_bytes(bytes32, bytes4);

    function setupAssimilatorsLocal () public {

        daiAssimilator = IAssimilator(address(new LocalDaiAssimilator(address(dai), address(cdai))));
        cdaiAssimilator = IAssimilator(address(new LocalCDaiAssimilator(address(cdai))));
        chaiAssimilator = IAssimilator(address(new LocalChaiAssimilator(address(dai), address(cdai), address(chai), address(pot))));

        usdcAssimilator = IAssimilator(address(new LocalUsdcAssimilator(address(usdc), address(cusdc))));
        cusdcAssimilator = IAssimilator(address(new LocalCUsdcAssimilator(address(cusdc))));

        usdtAssimilator = IAssimilator(address(new LocalUsdtAssimilator(address(usdt), address(ausdt))));
        ausdtAssimilator = IAssimilator(address(new LocalAUsdtAssimilator(address(ausdt))));

        susdAssimilator = IAssimilator(address(new LocalSUsdAssimilator(address(susd), address(asusd))));
        asusdAssimilator = IAssimilator(address(new LocalASUsdAssimilator(address(asusd))));

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

    function setupAssimilatorsMainnet () public {

        usdcAssimilator = IAssimilator(address(new MainnetUsdcAssimilator()));
        cusdcAssimilator = IAssimilator(address(new MainnetCUsdcAssimilator()));

        daiAssimilator = IAssimilator(address(new MainnetDaiAssimilator()));
        cdaiAssimilator = IAssimilator(address(new MainnetCDaiAssimilator()));
        chaiAssimilator = IAssimilator(address(new MainnetChaiAssimilator()));

        usdtAssimilator = IAssimilator(address(new MainnetUsdtAssimilator()));
        ausdtAssimilator = IAssimilator(address(new MainnetAUsdtAssimilator()));

        susdAssimilator = IAssimilator(address(new MainnetSUsdAssimilator()));
        asusdAssimilator = IAssimilator(address(new MainnetASUsdAssimilator()));

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