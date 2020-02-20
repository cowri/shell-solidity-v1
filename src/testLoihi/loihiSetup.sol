
pragma solidity ^0.5.6;

import "./adaptersSetup.sol";
import "../Loihi.sol";

import "../LoihiLiquidity.sol";
import "../LoihiExchange.sol";
import "../LoihiERC20.sol";
import "../LoihiViews.sol";

contract LoihiSetup is AdaptersSetup {
    Loihi l;

    event log_named_address(bytes32, address);
    function setupLoihi () public {

        l = new Loihi(
// 0xA24fddB488c3602635B55915cA052E8fC7135616
            address(new LoihiExchange()),
            address(new LoihiViews()),
            address(new LoihiLiquidity()),
            address(new LoihiERC20())
        );

    }

}