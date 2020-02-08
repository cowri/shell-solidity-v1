pragma solidity ^0.5.12;

import "./Loihi.sol";
import "./ChaiI.sol";
import "./CTokenI.sol";
import "./ERC20I.sol";
import "./BadERC20I.sol";
import "./PotI.sol";
import "./LoihiRoot.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract LoihiLocal is LoihiRoot {

    ChaiI chai;
    CTokenI cdai;
    ERC20I dai;
    PotI pot;
    CTokenI cusdc;
    ERC20I usdc;
    IERC20 usdt;

}