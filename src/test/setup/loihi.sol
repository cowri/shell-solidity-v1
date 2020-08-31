pragma solidity ^0.5.0;

import "../../Loihi.sol";

import "../../interfaces/IERC20.sol";
import "../../interfaces/IERC20NoBool.sol";

import "./storage.sol";

contract ApproveFrom {
    function TEST_safeApprove(address _token, address _spender, uint256 _value) public;
}

contract LoihiSetup is StorageSetup {

    function setParamsSetOne (Loihi _loihi) public {

        uint256 _alpha = .5e18;
        uint256 _beta = .25e18;
        uint256 _max = .05e18;
        uint256 _epsilon = 2.5e14;
        uint256 _lambda = .2e18;

        _loihi.setParams(_alpha, _beta, _max, _epsilon, _lambda);

    }

    function includeAssetsSetOne (Loihi _loihi) public {

        _loihi.includeAsset(address(dai), address(daiAssimilator), address(dai), address(daiAssimilator), .3e18);
        _loihi.includeAsset(address(usdc), address(usdcAssimilator), address(usdc), address(usdcAssimilator), .3e18);
        _loihi.includeAsset(address(usdt), address(usdtAssimilator), address(usdt), address(usdtAssimilator), .3e18);
        _loihi.includeAsset(address(susd), address(susdAssimilator), address(susd), address(susdAssimilator), .1e18);

    }

    function approveStablecoins (address _approveTo) public {

        approve(address(dai), _approveTo);

        approve(address(usdc), _approveTo);

        approveBad(address(usdt), _approveTo);

        approve(address(susd), _approveTo);

    }

    function interApproveStablecoinsLocal (address _approveFrom) public {

        // address[] memory targets = new address[](5);
        // address[] memory spenders = new address[](5);
        // targets[0] = address(dai); spenders[0] = address(chai);
        // targets[1] = address(dai); spenders[1] = address(cdai);
        // targets[2] = address(susd); spenders[2] = address(asusd);
        // targets[3] = address(usdc); spenders[3] = address(cusdc);
        // targets[4] = address(usdt); spenders[4] = address(ausdt);

        // for (uint i = 0; i < targets.length; i++) {

        //     ApproveFrom(_approveFrom).TEST_safeApprove(targets[i], spenders[i], uint256(0));
        //     ApproveFrom(_approveFrom).TEST_safeApprove(targets[i], spenders[i], uint256(-1));
        // }

    }

    function interApproveStablecoinsRPC (address _approveFrom) public {

        // address[] memory targets = new address[](5);
        // address[] memory spenders = new address[](5);
        // targets[0] = address(dai); spenders[0] = address(chai);
        // targets[1] = address(dai); spenders[1] = address(cdai);
        // targets[2] = address(susd); spenders[2] = aaveLpCore;
        // targets[3] = address(usdc); spenders[3] = address(cusdc);
        // targets[4] = address(usdt); spenders[4] = aaveLpCore;

        // for (uint i = 0; i < targets.length; i++) {
        //     ApproveFrom(_approveFrom).TEST_safeApprove(targets[i], spenders[i], uint256(0));
        //     ApproveFrom(_approveFrom).TEST_safeApprove(targets[i], spenders[i], uint256(-1));
        // }

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