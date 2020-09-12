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
    IAToken adai;
    ICToken cdai;
    IChai chai;

    IERC20 usdc;
    IAToken ausdc;
    ICToken cusdc;

    IERC20NoBool usdt;
    IAToken ausdt;
    ICToken cusdt;

    IERC20 susd;
    IAToken asusd;

    IPot pot;

    address aaveLpCore;

    IAssimilator daiAssimilator;
    IAssimilator adaiAssimilator;
    IAssimilator cdaiAssimilator;
    IAssimilator chaiAssimilator;

    IAssimilator usdcAssimilator;
    IAssimilator ausdcAssimilator;
    IAssimilator cusdcAssimilator;

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