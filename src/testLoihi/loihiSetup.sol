
pragma solidity ^0.5.6;

import "./adaptersSetup.sol";
import "../Loihi.sol";

import "../LoihiLiquidity.sol";
import "../LoihiExchange.sol";
import "../LoihiERC20.sol";

contract LoihiSetup is AdaptersSetup {
    Loihi l;

    event log_named_address(bytes32, address);
    function setupLoihi () public {

        l = new Loihi(
            address(new LoihiExchange()),
            address(new LoihiLiquidity()),
            address(new LoihiERC20())
        );

        uint256 WAD = 10 ** 18;
        uint256 weight = WAD / 3;

        emit log_named_address("me", address(this));

        l.includeNumeraireAndReserve(dai, cdaiAdapter);
        l.includeNumeraireAndReserve(usdc, cusdcAdapter);
        l.includeNumeraireAndReserve(usdt, usdtAdapter);

        l.includeAdapter(chai, chaiAdapter, cdaiAdapter, weight);
        l.includeAdapter(dai, daiAdapter, cdaiAdapter, weight);
        l.includeAdapter(cdai, cdaiAdapter, cdaiAdapter, weight);
        l.includeAdapter(cusdc, cusdcAdapter, cusdcAdapter, weight);
        l.includeAdapter(usdc, usdcAdapter, cusdcAdapter, weight);
        l.includeAdapter(usdt, usdtAdapter, usdtAdapter, weight);

        l.setAlpha((5 * WAD) / 10);
        l.setBeta((25 * WAD) / 100);
        l.setFeeDerivative(WAD / 10);
        l.setFeeBase(500000000000000);

    }

}