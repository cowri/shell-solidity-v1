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
    ICToken cusdt;
    IAToken ausdt;

    IERC20 susd;
    IAToken asusd;

    IPot pot;

    address aaveLpCore;
    
    IERC20 pBTC;
    IERC20 sBTC;
    IERC20 tBTC;
    IERC20 wBTC;
    IERC20 renBTC;

    IAssimilator daiAssimilator;
    IAssimilator chaiAssimilator;
    IAssimilator adaiAssimilator;
    IAssimilator cdaiAssimilator;

    IAssimilator usdcAssimilator;
    IAssimilator ausdcAssimilator;
    IAssimilator cusdcAssimilator;

    IAssimilator usdtAssimilator;
    IAssimilator cusdtAssimilator;
    IAssimilator ausdtAssimilator;

    IAssimilator susdAssimilator;
    IAssimilator asusdAssimilator;

    IAssimilator renbtcAssimilator;
    IAssimilator wbtcAssimilator;
    IAssimilator tbtcAssimilator;
    IAssimilator sbtcAssimilator;
    IAssimilator pbtcAssimilator;

    uint256 epsilon;
    uint256 delta;
    uint256 lambda;
    uint256 alpha;
    uint256 beta;

}