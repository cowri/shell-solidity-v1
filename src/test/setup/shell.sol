pragma solidity ^0.5.0;

import "../../Shell.sol";

import "../../interfaces/IERC20.sol";
import "../../interfaces/IERC20NoBool.sol";

import "./storage.sol";

contract ApproveFrom {
    function TEST_safeApprove(address _token, address _spender, uint256 _value) public;
}

contract ShellSetup is StorageSetup {

    event log_uint(bytes32, uint256);

    function setParamsSetOne (Shell _shell) public {

        uint256 _alpha = .5e18;
        uint256 _beta = .25e18;
        uint256 _max = .05e18;
        uint256 _epsilon = 2.5e14;
        uint256 _lambda = .2e18;

        _shell.setParams(_alpha, _beta, _max, _epsilon, _lambda);

    }

    function setParamsSetTwo (Shell _shell) public {

       uint256 _alpha = .5e18;
       uint256 _beta = .25e18;
       uint256 _max = .05e18;
       uint256 _epsilon = 5e14;
       uint256 _lambda = .2e18;

       _shell.setParams(_alpha, _beta, _max, _epsilon, _lambda);

    }

    function setParamsSetThree (Shell _shell) public {

        uint256 _alpha = .5e18;
        uint256 _beta = .25e18;
        uint256 _max = .05e18;
        uint256 _epsilon = 0;
        uint256 _lambda = 1e18;

        _shell.setParams(_alpha, _beta, _max, _epsilon, _lambda);

    }

    function setParamsSetFour (Shell _shell) public {

        uint256 _alpha = .5e18;
        uint256 _beta = .48e18;
        uint256 _max = .49e18;
        uint256 _epsilon = 2.5e14;
        uint256 _lambda = .2e18;

        _shell.setParams(_alpha, _beta, _max, _epsilon, _lambda);

    }

    function setParamsSetFive (Shell _shell) public {

        uint256 _alpha = .9e18;
        uint256 _beta = .4e18;
        uint256 _max = .15e18;
        uint256 _epsilon = 3.5e14;
        uint256 _lambda = .5e18;

        _shell.setParams(_alpha, _beta, _max, _epsilon, _lambda);

    }

    // function includeAssimilatorsSetOne (Shell _shell) public {

    //     _shell.includeAssimilator(address(chai), address(dai), address(dai), address(chaiAssimilator));

    //     _shell.includeAssimilator(address(cdai), address(dai), address(dai), address(cdaiAssimilator));

    //     _shell.includeAssimilator(address(cusdc), address(usdc), address(usdc), address(cusdcAssimilator));

    //     _shell.includeAssimilator(address(ausdt), address(usdt), address(usdt), address(ausdtAssimilator));

    //     _shell.includeAssimilator(address(asusd), address(susd), address(susd), address(asusdAssimilator));

    // }

    // function includeAssimilatorsSetTwo (Shell _shell) public {

    //     _shell.includeAssimilator(address(chai), address(dai), address(cdai), address(chaiAssimilator));

    // }

    // function includeAssetsSetOne (Shell _shell) public {

    //     _shell.includeAsset(address(dai), address(daiAssimilator), address(dai), address(daiAssimilator), .3e18);

    //     _shell.includeAsset(address(usdc), address(usdcAssimilator), address(usdc), address(usdcAssimilator), .3e18);

    //     _shell.includeAsset(address(usdt), address(usdtAssimilator), address(usdt), address(usdtAssimilator), .3e18);

    //     _shell.includeAsset(address(susd), address(susdAssimilator), address(susd), address(susdAssimilator), .1e18);

    // }

    // function includeAssetsSetTwo (Shell _shell) public {

    //     _shell.includeAsset(address(dai), address(daiAssimilator), address(cdai), address(cdaiAssimilator), .3e18);

    //     _shell.includeAsset(address(usdc), address(usdcAssimilator), address(cusdc), address(cusdcAssimilator), .3e18);

    //     _shell.includeAsset(address(usdt), address(usdtAssimilator), address(ausdt), address(ausdtAssimilator), .3e18);

    //     _shell.includeAsset(address(susd), address(susdAssimilator), address(asusd), address(asusdAssimilator), .1e18);

    // }

    // function includeAssetsSetThree (Shell _shell) public {

    //     _shell.includeAsset(address(dai), address(daiAssimilator), address(dai), address(daiAssimilator), 333333333333333333);

    //     _shell.includeAsset(address(usdc), address(usdcAssimilator), address(usdc), address(usdcAssimilator), 333333333333333333);

    //     _shell.includeAsset(address(usdt), address(usdtAssimilator), address(usdt), address(usdtAssimilator), 333333333333333333);

    // }

    // function includeAssetsSetFour (Shell _shell) public {

    //     _shell.includeAsset(address(dai), address(daiAssimilator), address(cdai), address(cdaiAssimilator), 333333333333333333);

    //     _shell.includeAsset(address(usdc), address(usdcAssimilator), address(cusdc), address(cusdcAssimilator), 333333333333333333);
       
    //     _shell.includeAsset(address(usdt), address(usdtAssimilator), address(ausdt), address(ausdtAssimilator), 333333333333333333);

    // }

    function approveStablecoins (address _approveTo) public {

        approve(address(dai), _approveTo);
        approve(address(chai), _approveTo);
        approve(address(cdai), _approveTo);

        approve(address(usdc), _approveTo);
        approve(address(cusdc), _approveTo);

        approveBad(address(usdt), _approveTo);
        approve(address(ausdt), _approveTo);

        approve(address(susd), _approveTo);
        approve(address(asusd), _approveTo);

    }

    event log(bytes32);

    function interApproveStablecoinsLocal (address _approveFrom) public {

        address[] memory targets = new address[](5);
        address[] memory spenders = new address[](5);
        targets[0] = address(dai); spenders[0] = address(chai);
        targets[1] = address(dai); spenders[1] = address(cdai);
        targets[2] = address(susd); spenders[2] = address(asusd);
        targets[3] = address(usdc); spenders[3] = address(cusdc);
        targets[4] = address(usdt); spenders[4] = address(ausdt);

        for (uint i = 0; i < targets.length; i++) {

            emit log_uint("i", i);

            ApproveFrom(_approveFrom).TEST_safeApprove(targets[i], spenders[i], uint256(0));
            ApproveFrom(_approveFrom).TEST_safeApprove(targets[i], spenders[i], uint256(-1));
        }

    }

    function interApproveStablecoinsRPC (address _approveFrom) public {

        address[] memory targets = new address[](5);
        address[] memory spenders = new address[](5);
        targets[0] = address(dai); spenders[0] = address(chai);
        targets[1] = address(dai); spenders[1] = address(cdai);
        targets[2] = address(susd); spenders[2] = aaveLpCore;
        targets[3] = address(usdc); spenders[3] = address(cusdc);
        targets[4] = address(usdt); spenders[4] = aaveLpCore;

        for (uint i = 0; i < targets.length; i++) {
            ApproveFrom(_approveFrom).TEST_safeApprove(targets[i], spenders[i], uint256(0));
            ApproveFrom(_approveFrom).TEST_safeApprove(targets[i], spenders[i], uint256(-1));
        }

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