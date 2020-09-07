pragma solidity ^0.5.0;

// import "../../interfaces/IERC20.sol";
// import "../../interfaces/IERC20NoBool.sol";
import "../../interfaces/IAToken.sol";
import "../../interfaces/ICToken.sol";
import "../../interfaces/IChai.sol";

import "./mocks/chai.sol";
import "./mocks/cdai.sol";
import "./mocks/cusdc.sol";
import "./mocks/atoken.sol";
import "./mocks/erc20NoBool.sol";
import "./mocks/erc20.sol";
import "./mocks/pot.sol";

import "./storage.sol";

contract StablecoinSetup is StorageSetup {

    function setupStablecoinsMainnet () public {

        dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
        cdai = ICToken(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);
        chai = IChai(0x06AF07097C9Eeb7fD685c692751D5C66dB49c215);

        usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
        cusdc = ICToken(0x39AA39c021dfbaE8faC545936693aC917d5E7563);

        usdt = IERC20NoBool(0xdAC17F958D2ee523a2206206994597C13D831ec7);
        ausdt = IAToken(0x71fc860F7D3A592A4a98740e39dB31d25db65ae8);

        susd = IERC20(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51);
        asusd = IAToken(0x625aE63000f46200499120B906716420bd059240);

        aaveLpCore = 0x3dfd23A6c5E8BbcFc9581d2E864a68feb6a076d3;

    }

    function setupStablecoinsKovan() public {

        dai = IERC20(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa);
        cdai = ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c);
        chai = IChai(0xB641957b6c29310926110848dB2d464C8C3c3f38);

        usdc = IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF);
        cusdc = ICToken(0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35);

        usdt = IERC20NoBool(0x13512979ADE267AB5100878E2e0f485B568328a4);
        ausdt = IAToken(0xA01bA9fB493b851F4Ac5093A324CB081A909C34B);

        susd = IERC20(0xD868790F57B39C9B2B51b12de046975f986675f9);
        asusd = IAToken(0xb9c1434aB6d5811D1D0E92E8266A37Ae8328e901);

        aaveLpCore = 0x95D1189Ed88B380E319dF73fF00E479fcc4CFa45;

    }

    event log_addr(bytes32, address);

    function setupStablecoinsLocal () public {

        dai = IERC20(address(new ERC20Mock("dai", "dai", 18, uint256(-1)/2)));
        cdai = ICToken(address(new CDaiMock(address(dai), "cdai", "cdai", 8, 0)));
        chai = IChai(address(new ChaiMock(address(dai), "chai", "chai", 18, 0)));
        emit log_addr("DAI", address(dai));
        emit log_addr("ChaI", address(chai));

        pot = IPot(address(new PotMock()));

        usdc = IERC20(address(new ERC20Mock("usdc", "usdc", 6, uint256(-1)/2)));
        cusdc = ICToken(address(new CUsdcMock(address(usdc), "cusdc", "cusdc", 8, 0)));

        usdt = IERC20NoBool(address(new ERC20NoBoolMock("usdt", "usdt", 6, uint256(-1)/2)));
        ausdt = IAToken(address(new ATokenMock(address(usdt), "ausdt", "ausdt", 6, 0)));

        susd = IERC20(address(new ERC20Mock("susd", "susd", 18, uint256(-1)/2)));
        asusd = IAToken(address(new ATokenMock(address(susd), "asusd", "asusd", 18, 0)));

        aaveLpCore = 0x95D1189Ed88B380E319dF73fF00E479fcc4CFa45; // just for tests bootstrap

        dai.approve(address(chai), uint256(-1));
        chai.join(address(this), 1e30);

        dai.approve(address(cdai), uint256(-1));
        cdai.mint(1e30);

        usdc.approve(address(cusdc), uint256(-1));
        cusdc.mint(1e30);

        usdt.approve(address(ausdt), uint256(-1));
        ausdt.deposit(1e30);

        susd.approve(address(asusd), uint256(-1));
        asusd.deposit(1e30);

    }

    function approve (address token, address l) public {
        uint256 approved = IERC20(token).allowance(address(this), l);
        if (approved > 0) IERC20(token).approve(l, 0);
        IERC20(token).approve(l, uint256(-1));
    }

    function approveBad (address token, address l) public {
        uint256 approved = IERC20NoBool(token).allowance(address(this), l);
        if (approved > 0) IERC20NoBool(token).approve(l, 0);
        IERC20NoBool(token).approve(l, uint256(-1));
    }

}