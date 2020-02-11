pragma solidity ^0.5.12;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "./IChai.sol";
import "./ICToken.sol";
import "./IPot.sol";
import "./LoihiExchangeExecution.sol";
import "./LoihiLiquidityMembrane.sol";

contract Loihi is LoihiExchangeExecution, LoihiLiquidityMembrane {

    constructor (address _chai, address _cdai, address _dai, address _pot, address _cusdc, address _usdc, address _usdt) public {
        // chai = IChai(_chai);
        // cdai = ICToken(_cdai);
        // dai = IERC20(_dai);
        // pot = IPot(_pot);
        // cusdc = ICToken(_cusdc);
        // usdc = IERC20(_usdc);
        // usdt = IERC20(_usdt);
    }

}