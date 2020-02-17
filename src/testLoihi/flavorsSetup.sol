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
        pot = 0xEA190DBDC7adF265260ec4dA6e9675Fd4f5A78bb;
        cusdc = 0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35;
        usdc = 0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF;
        usdt = 0x1886b2763b26C45c8DE3e4ccc2bbD02578f9e62D;
        asusd = 0x83Ced423459B419793aa1CE2C9e6fE61BB575cFd;
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