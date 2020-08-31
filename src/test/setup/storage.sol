pragma solidity ^0.5.0;

import "../../interfaces/IERC20.sol";
import "../../interfaces/IERC20NoBool.sol";
import "../../interfaces/IAssimilator.sol";

contract StorageSetup {

    IERC20 dai;
    IERC20 usdc;
    IERC20NoBool usdt;
    IERC20 susd;

    address aaveLpCore;

    IAssimilator daiAssimilator;

    IAssimilator usdcAssimilator;

    IAssimilator usdtAssimilator;

    IAssimilator susdAssimilator;

    uint256 epsilon;
    uint256 delta;
    uint256 lambda;
    uint256 alpha;
    uint256 beta;

}