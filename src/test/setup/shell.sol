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

    function setParamsSetSix (Shell _shell) public {

        uint256 _alpha = .8e18;
        uint256 _beta = .1e18;
        uint256 _max = .08e18;
        uint256 _epsilon = 3.5e14;
        uint256 _lambda = .9995e18;

        _shell.setParams(_alpha, _beta, _max, _epsilon, _lambda);

    }

    function approveStablecoins (address _approveTo) public {

        approve(address(dai), _approveTo);
        approve(address(adai), _approveTo);
        approve(address(cdai), _approveTo);
        approve(address(chai), _approveTo);

        approve(address(usdc), _approveTo);
        approve(address(ausdc), _approveTo);
        approve(address(cusdc), _approveTo);

        approveBad(address(usdt), _approveTo);
        approve(address(ausdt), _approveTo);
        approve(address(cusdt), _approveTo);

        approve(address(susd), _approveTo);
        approve(address(asusd), _approveTo);

        approve(address(pBTC), _approveTo);
        approve(address(renBTC), _approveTo);
        approve(address(sBTC), _approveTo);
        approve(address(tBTC), _approveTo);
        approve(address(wBTC), _approveTo);

        approve(address(ousd), _approveTo);

    }

    function interApproveStablecoinsLocal (address _approveFrom) public {

        address[] memory targets = new address[](5);
        address[] memory spenders = new address[](5);
        targets[0] = address(dai); spenders[0] = address(chai);
        targets[1] = address(dai); spenders[1] = address(cdai);
        targets[2] = address(susd); spenders[2] = address(asusd);
        targets[3] = address(usdc); spenders[3] = address(cusdc);
        targets[4] = address(usdt); spenders[4] = address(ausdt);

        for (uint i = 0; i < targets.length; i++) {

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