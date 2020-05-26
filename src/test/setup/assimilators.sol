pragma solidity ^0.5.0;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IBadERC20.sol";

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

// import "../../assimilators/local/LocalDaiAssimilator.sol";
// import "../../assimilators/local/LocalCDaiAssimilator.sol";
// import "../../assimilators/local/LocalChaiAssimilator.sol";
// import "../../assimilators/local/LocalUsdcAssimilator.sol";
// import "../../assimilators/local/LocalCUsdcAssimilator.sol";
// import "../../assimilators/local/LocalUsdtAssimilator.sol";
// import "../../assimilators/local/LocalAusdtAssimilator.sol";
// import "../../assimilators/local/LocalSUsdAssimilator.sol";
// import "../../assimilators/local/LocalASUsdAssimilator.sol";

contract AssimilatorSetup is StorageSetup {

    function setupAssimilatorsLocal () public {

        // daiAssimilator = address(new LocalDaiAssimilator(cdai));
        // cdaiAssimilator = address(new LocalCDaiAssimilator(cdai));
        // chaiAssimilator = address(new LocalChaiAssimilator(cdai, pot));

        // usdcAssimilator = address(new LocalUsdcAssimilator(cusdc));
        // cusdcAssimilator = address(new LocalCUsdcAssimilator(cusdc));

        // usdtAssimilator = address(new LocalUsdtAssimilator(ausdt));
        // ausdtAssimilator = address(new LocalAUsdtAssimilator(ausdt));

        // susdAssimilator = address(new LocalSUsdAssimilator(asusd));
        // asusdAssimilator = address(new LocalASUsdAssimilator(asusd));

    }

    function setupAssimilatorsKovan () public {

        usdcAssimilator = address(new KovanUsdcAssimilator());
        cusdcAssimilator = address(new KovanCUsdcAssimilator());

        daiAssimilator = address(new KovanDaiAssimilator());
        cdaiAssimilator = address(new KovanCDaiAssimilator());
        chaiAssimilator = address(new KovanChaiAssimilator());

        usdtAssimilator = address(new KovanUsdtAssimilator());
        ausdtAssimilator = address(new KovanAUsdtAssimilator());

        susdAssimilator = address(new KovanSUsdAssimilator());
        asusdAssimilator = address(new KovanASUsdAssimilator());

    }

    function setupAssimilatorsMainnet () public {

        usdcAssimilator = address(new MainnetUsdcAssimilator());
        cusdcAssimilator = address(new MainnetCUsdcAssimilator());

        daiAssimilator = address(new MainnetDaiAssimilator());
        cdaiAssimilator = address(new MainnetCDaiAssimilator());
        chaiAssimilator = address(new MainnetChaiAssimilator());

        usdtAssimilator = address(new MainnetUsdtAssimilator());
        ausdtAssimilator = address(new MainnetAUsdtAssimilator());

        susdAssimilator = address(new MainnetSUsdAssimilator());
        asusdAssimilator = address(new MainnetASUsdAssimilator());

    }
    
    
    function setupDeployedAssimilatorsMainnet () public {

        usdcAssimilator = 0x54B7b567bc634E19632A8E85EEaE4EAE955ae9f9;
        cusdcAssimilator = 0xf5AB3FFD9F92893cAf1CBCcEC01b1c6EaA140C3f;

        daiAssimilator = 0x9E77104724A8390b6f2e80E222B5E8fe7eb7383f;
        cdaiAssimilator = 0xaEb74F5a22935FB6c812395c3e2fE2F5258c8d6E;
        chaiAssimilator = 0x21C09C793cc94c964D76cEC0A80D2cC61f155375;

        usdtAssimilator = 0xCd0dA368E6e32912DD6633767850751969346d15;
        ausdtAssimilator = 0xA4906F20a7806ca28626d3D607F9a594f1B9ed3B;

        susdAssimilator = 0x4CB5174C962a40177876799836f353e8E9c4eF75;
        asusdAssimilator = 0x68747564d7B4e7b654BE26D09f60f7756Cf54BF8;

    }

}