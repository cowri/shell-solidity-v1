
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
            // address(new LoihiExchange()),
            // address(new LoihiViews())
            // address(new LoihiLiquidity())
            // address(new LoihiERC20())
        );

    }

}