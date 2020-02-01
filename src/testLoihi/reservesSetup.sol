pragma solidity ^0.5.6;

import "../reserves/chai.sol";
import "../reserves/cusdc.sol";
import "../reserves/usdt.sol";

contract ReservesSetup {
    address chaiReserve;
    address cusdcReserve;
    address usdtReserve;

    function setupReserves() public {
        chaiReserve = address(new ChaiReserve());
        cusdcReserve = address(new cUsdcReserve());
        usdtReserve = address(new UsdtReserve());
    }

}