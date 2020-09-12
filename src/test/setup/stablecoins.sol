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
        adai = IAToken(0xfC1E690f61EFd961294b3e1Ce3313fBD8aa4f85d);
        cdai = ICToken(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);
        chai = IChai(0x06AF07097C9Eeb7fD685c692751D5C66dB49c215);

        usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
        ausdc = IAToken(0x9bA00D6856a4eDF4665BcA2C2309936572473B7E);
        cusdc = ICToken(0x39AA39c021dfbaE8faC545936693aC917d5E7563);

        usdt = IERC20NoBool(0xdAC17F958D2ee523a2206206994597C13D831ec7);
        ausdt = IAToken(0x71fc860F7D3A592A4a98740e39dB31d25db65ae8);
        cusdt = ICToken(0xf650C3d88D12dB855b8bf7D11Be6C55A4e07dCC9);

        susd = IERC20(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51);
        asusd = IAToken(0x625aE63000f46200499120B906716420bd059240);

        aaveLpCore = 0x3dfd23A6c5E8BbcFc9581d2E864a68feb6a076d3;

    }

}