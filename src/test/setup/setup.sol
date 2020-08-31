pragma solidity ^0.5.0;

import "../../Loihi.sol";

import "./stablecoins.sol";
import "./assimilators.sol";
import "./loihi.sol";

contract Setup is StablecoinSetup, AssimilatorSetup, LoihiSetup {

    function getLoihiSuiteOne () public returns (Loihi loihi_) {

        loihi_ = getLoihiSuiteOneKovan();

    }

    function getLoihiSuiteOneKovan () public returns (Loihi loihi_) {

        setupStablecoinsKovan();
        setupAssimilatorsSetOneKovan();

        loihi_ = new Loihi();
        // loihi_ = Loihi(0x250579b9EED23129b2Bbb16c4f9d6e25A2E979DE);

        includeAssetsSetOne(loihi_);
        setParamsSetOne(loihi_);

        approveStablecoins(address(loihi_));

    }

}