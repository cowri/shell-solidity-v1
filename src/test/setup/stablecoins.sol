pragma solidity ^0.5.0;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IBadERC20.sol";

import "../../interfaces/IAToken.sol";
import "../../interfaces/ICToken.sol";
import "../../interfaces/IChai.sol";

import "./mocks/chai.sol";
import "./mocks/cdai.sol";
import "./mocks/cusdc.sol";
import "./mocks/atoken.sol";
import "./mocks/baderc20.sol";
import "./mocks/erc20.sol";
import "./mocks/pot.sol";

import "./storage.sol";

contract StablecoinSetup is StorageSetup {

    function setupStablecoinsMainnet () public {

        dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
        chai = 0x06AF07097C9Eeb7fD685c692751D5C66dB49c215;
        cdai = 0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643;

        usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
        cusdc = 0x39AA39c021dfbaE8faC545936693aC917d5E7563;

        usdt = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
        ausdt = 0x71fc860F7D3A592A4a98740e39dB31d25db65ae8;

        susd = 0x57Ab1ec28D129707052df4dF418D58a2D46d5f51;
        asusd = 0x625aE63000f46200499120B906716420bd059240;

        aaveLpCore = 0x3dfd23A6c5E8BbcFc9581d2E864a68feb6a076d3;

    }

    function setupStablecoinsKovan() public {

        chai = 0xB641957b6c29310926110848dB2d464C8C3c3f38;
        cdai = 0xe7bc397DBd069fC7d0109C0636d06888bb50668c;
        dai = 0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa;

        cusdc = 0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35;
        usdc = 0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF;

        usdt = 0x13512979ADE267AB5100878E2e0f485B568328a4;
        ausdt = 0xA01bA9fB493b851F4Ac5093A324CB081A909C34B;

        susd = 0xD868790F57B39C9B2B51b12de046975f986675f9;
        asusd = 0xb9c1434aB6d5811D1D0E92E8266A37Ae8328e901;

        aaveLpCore = 0x95D1189Ed88B380E319dF73fF00E479fcc4CFa45;

    }

    function setupStablecoinsLocal () public {

        dai = address(new ERC20Mock("dai", "dai", 18, uint256(-1)/2));
        chai = address(new ChaiMock(dai, "chai", "chai", 18, 0));
        cdai = address(new CDaiMock(dai, "cdai", "cdai", 8, 0));

        usdc = address(new ERC20Mock("usdc", "usdc", 6, uint256(-1)/2));
        cusdc = address(new CUsdcMock(usdc, "cusdc", "cusdc", 8, 0));
        usdt = address(new BadERC20Mock("usdt", "usdt", 6, uint256(-1)/2));
        ausdt = address(new ATokenMock(usdt, "ausdt", "ausdt", 6, 0));
        susd = address(new ERC20Mock("susd", "susd", 18, uint256(-1)/2));
        asusd = address(new ATokenMock(susd, "asusd", "asusd", 18, 0));
        pot = address(new PotMock());

        aaveLpCore = 0x95D1189Ed88B380E319dF73fF00E479fcc4CFa45; // just for tests bootstrap

        IERC20(dai).approve(chai, uint256(-1));
        IChai(chai).join(address(this), 1e30);

        IERC20(dai).approve(cdai, uint256(-1));
        ICToken(cdai).mint(1e30);

        IERC20(usdc).approve(cusdc, uint256(-1));
        ICToken(cusdc).mint(1e30);

        IBadERC20(usdt).approve(ausdt, uint256(-1));
        IAToken(ausdt).deposit(1e30);

        IERC20(susd).approve(asusd, uint256(-1));
        IAToken(asusd).deposit(1e30);
    }

    function approve (address token, address l) public {
        uint256 approved = IERC20(token).allowance(address(this), l);
        if (approved > 0) IERC20(token).approve(l, 0);
        IERC20(token).approve(l, uint256(-1));
    }

    function approveBad (address token, address l) public {
        uint256 approved = IBadERC20(token).allowance(address(this), l);
        if (approved > 0) IBadERC20(token).approve(l, 0);
        IBadERC20(token).approve(l, uint256(-1));
    }
    

}