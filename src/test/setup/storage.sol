pragma solidity ^0.5.0;

import "../../interfaces/IERC20.sol";
import "../../interfaces/IERC20NoBool.sol";
import "../../interfaces/IAssimilator.sol";
import "../../interfaces/IAToken.sol";
import "../../interfaces/ICToken.sol";
import "../../interfaces/IChai.sol";
import "../../interfaces/IPot.sol";

contract StorageSetup {

    IERC20 dai;
    IChai chai;
    ICToken cdai;
    IAToken adai;

    IERC20 usdc;
    ICToken cusdc;
    IAToken ausdc;

    IERC20NoBool usdt;
    IAToken ausdt;
    ICToken cusdt;

    IERC20 susd;
    IAToken asusd;

    IPot pot;

    address aaveLpCore;

    IAssimilator daiAssimilator;
    IAssimilator chaiAssimilator;
    IAssimilator cdaiAssimilator;
    IAssimilator adaiAssimilator;

    IAssimilator usdcAssimilator;
    IAssimilator cusdcAssimilator;
    IAssimilator ausdcAssimilator;

    IAssimilator usdtAssimilator;
    IAssimilator ausdtAssimilator;
    IAssimilator cusdtAssimilator;

    IAssimilator susdAssimilator;
    IAssimilator asusdAssimilator;

    uint256 epsilon;
    uint256 delta;
    uint256 lambda;
    uint256 alpha;
    uint256 beta;

}