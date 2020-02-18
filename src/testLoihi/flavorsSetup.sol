pragma solidity ^0.5.6;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract FlavorsSetup {
    address chai;
    address dai;
    address cusdc;
    address usdt;
    address usdc;
    address cdai;
    address pot;
    address asusd;

    function setupFlavors() public {

        chai = 0xB641957b6c29310926110848dB2d464C8C3c3f38;
        cdai = 0xe7bc397DBd069fC7d0109C0636d06888bb50668c;
        dai = 0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa;

        cusdc = 0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35;
        usdc = 0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF;

        usdt = 0x13512979ADE267AB5100878E2e0f485B568328a4;
        ausdt = 0xA01bA9fB493b851F4Ac5093A324CB081A909C34B;

        asusd = 0xb9c1434ab6d5811d1d0e92e8266a37ae8328e901;
        susd = 0xD868790F57B39C9B2B51b12de046975f986675f9;
    }

    event log_address(bytes32, address);
    function approveFlavors (address addr) public {
        emit log_address("ADDR", addr);
        IERC20(chai).approve(addr, 1000000000 * (10 ** 18));
        IERC20(cdai).approve(addr, 1000000000 * (10 ** 18));
        IERC20(dai).approve(addr, 1000000000 * (10 ** 18));
        IERC20(cusdc).approve(addr, 10000000000 * (10 ** 18));
        IERC20(usdc).approve(addr, 1000000000 * (10 ** 18));
        IERC20(usdt).approve(addr, 1000000000 * (10 ** 18));
        IERC20(asusd).approve(addr, 1000000000 * (10 ** 18));
    }

}