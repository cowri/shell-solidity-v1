
pragma solidity ^0.5.12;

import "./ChaiI.sol";
import "./CTokenI.sol";
import "./ERC20I.sol";
import "./BadERC20I.sol";
import "./PotI.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "./LoihiRoot.sol";

contract LoihiKovan is LoihiRoot {

    ChaiI constant internal chai = ChaiI(0xB641957b6c29310926110848dB2d464C8C3c3f38);
    CTokenI constant internal cdai = CTokenI(0xe7bc397DBd069fC7d0109C0636d06888bb50668c);
    IERC20 constant internal dai = IERC20(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa);
    PotI constant internal pot = PotI(0xEA190DBDC7adF265260ec4dA6e9675Fd4f5A78bb);
    CTokenI constant internal cusdc = CTokenI(0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35);
    IERC20 constant internal usdc = IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF);
    IERC20 constant internal usdt = IERC20(0x20F7963EF38AC716A85ed18fb683f064db944648);

    constructor () public { }

}