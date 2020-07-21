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

    IERC20 usdc;
    ICToken cusdc;

    IERC20NoBool usdt;
    IAToken ausdt;

    IERC20 susd;
    IAToken asusd;

    IPot pot;

    address aaveLpCore;

    IAssimilator daiAssimilator;
    IAssimilator chaiAssimilator;
    IAssimilator cdaiAssimilator;

    IAssimilator usdcAssimilator;
    IAssimilator cusdcAssimilator;

    IAssimilator usdtAssimilator;
    IAssimilator ausdtAssimilator;

    IAssimilator susdAssimilator;
    IAssimilator asusdAssimilator;

    uint256 epsilon;
    uint256 delta;
    uint256 lambda;
    uint256 alpha;
    uint256 beta;

}