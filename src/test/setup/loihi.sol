pragma solidity ^0.5.0;

import "../../Loihi.sol";

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IBadERC20.sol";

import "./storage.sol";

library Methods {

    using Methods for Loihi;

    function deposit (
        Loihi loihi,
        address _token,
        uint256 _amt
    ) internal returns (uint256 shells_) {
        address[] memory _stblcns = new address[](1);
        uint256[] memory _amts = new uint256[](1);
        _stblcns[0] = _token;
        _amts[0] = _amt;

        shells_ = loihi.deposit(_stblcns, _amts);

    }

    function deposit (Loihi loihi, address[] memory _flvrs, uint256[] memory _amts) internal returns (uint256 shells_) {

        shells_ = loihi.selectiveDeposit(_flvrs, _amts, 0, 1e50);

    }
}

contract LoihiSetup is StorageSetup {

    function setupLoihi30_30_30_10_Local () public returns (Loihi loihi_) {

        loihi_ = new Loihi();
        setLoihiReserves30_30_30_10(loihi_);
        includeAssimilators(loihi_);
        approveStablecoins(loihi_);
        executeInterStablecoinApprovalsLocal(loihi_);

    }

    function setupLoihi30_30_30_10_RPC () public returns (Loihi loihi_) {

        loihi_ = new Loihi();
        setLoihiReserves30_30_30_10(loihi_);
        includeAssimilators(loihi_);
        approveStablecoins(loihi_);
        executeInterStablecoinApprovalsRPC(loihi_);

    }

    function setLoihiParamsSetNumberOne (Loihi _loihi) public {

        uint256 _alpha = 500000000000000000;
        uint256 _beta = 250000000000000000;
        uint256 _delta = 100000000000000000;
        uint256 _epsilon = 250000000000000;
        uint256 _lambda = 200000000000000000;

        _loihi.setParams(_alpha, _beta, _delta, _epsilon, _lambda, 0);

    }

    function setLoihiParamsSetNumberTwo (Loihi _loihi) public {

        uint256 _alpha = 500000000000000000;
        uint256 _beta = 250000000000000000;
        uint256 _delta = 100000000000000000;
        uint256 _epsilon = 0;
        uint256 _lambda = 1000000000000000000;

        _loihi.setParams(_alpha, _beta, _delta, _epsilon, _lambda, 0);

    }

    function includeAssimilators (Loihi _loihi) public {

        _loihi.includeAssimilator(dai, daiAssimilator, cdaiAssimilator);
        _loihi.includeAssimilator(chai, chaiAssimilator, cdaiAssimilator);
        _loihi.includeAssimilator(cdai, cdaiAssimilator, cdaiAssimilator);

        _loihi.includeAssimilator(usdc, usdcAssimilator, cusdcAssimilator);
        _loihi.includeAssimilator(cusdc, cusdcAssimilator, cusdcAssimilator);

        _loihi.includeAssimilator(usdt, usdtAssimilator, ausdtAssimilator);
        _loihi.includeAssimilator(ausdt, ausdtAssimilator, ausdtAssimilator);

        _loihi.includeAssimilator(asusd, asusdAssimilator, asusdAssimilator);
        _loihi.includeAssimilator(susd, susdAssimilator, asusdAssimilator);

    }

    function setLoihiReserves30_30_30_10 (Loihi _loihi) public {

        _loihi.includeNumeraireAsset(dai, cdaiAssimilator, 300000000000000000);
        _loihi.includeNumeraireAsset(usdc, cusdcAssimilator, 300000000000000000);
        _loihi.includeNumeraireAsset(usdt, ausdtAssimilator, 300000000000000000);
        _loihi.includeNumeraireAsset(susd, asusdAssimilator, 100000000000000000);

    }

    function setLoihiReserves33_33_33 (Loihi _loihi) public {

        _loihi.includeNumeraireAsset(dai, cdaiAssimilator, 333333333333333333);
        _loihi.includeNumeraireAsset(usdc, cusdcAssimilator, 333333333333333333);
        _loihi.includeNumeraireAsset(usdt, ausdtAssimilator, 333333333333333333);

    }

    function approveStablecoins (Loihi _loihi) public {

        approve(dai, address(_loihi));
        approve(chai, address(_loihi));
        approve(cdai, address(_loihi));

        approve(usdc, address(_loihi));
        approve(cusdc, address(_loihi));

        approveBad(usdt, address(_loihi));
        approve(ausdt, address(_loihi));

        approve(susd, address(_loihi));
        approve(asusd, address(_loihi));

    }

    function executeInterStablecoinApprovalsLocal (Loihi _loihi) public {

        address[] memory targets = new address[](5);
        address[] memory spenders = new address[](5);
        targets[0] = dai; spenders[0] = chai;
        targets[1] = dai; spenders[1] = cdai;
        targets[2] = susd; spenders[2] = asusd;
        targets[3] = usdc; spenders[3] = cusdc;
        targets[4] = usdt; spenders[4] = ausdt;

        for (uint i = 0; i < targets.length; i++) {
            _loihi.safeApprove(targets[i], spenders[i], uint256(0));
            _loihi.safeApprove(targets[i], spenders[i], uint256(-1));
        }

    }

    function executeInterStablecoinApprovalsRPC (Loihi _loihi) public {

        address[] memory targets = new address[](5);
        address[] memory spenders = new address[](5);
        targets[0] = dai; spenders[0] = chai;
        targets[1] = dai; spenders[1] = cdai;
        targets[2] = susd; spenders[2] = aaveLpCore;
        targets[3] = usdc; spenders[3] = cusdc;
        targets[4] = usdt; spenders[4] = aaveLpCore;

        for (uint i = 0; i < targets.length; i++) {
            _loihi.safeApprove(targets[i], spenders[i], uint256(0));
            _loihi.safeApprove(targets[i], spenders[i], uint256(-1));
        }

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