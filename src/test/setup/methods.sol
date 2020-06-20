pragma solidity ^0.5.0;

import "../../Loihi.sol";
import "abdk-libraries-solidity/ABDKMath64x64.sol";

library AssimilatorMethods {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint;
    using AssimilatorMethods for address;

    event log(bytes32);

    IAssimilator constant iAsmltr = IAssimilator(address(0));

    function viewRawAmount (address _assim, int128 _amt) internal returns (uint256 amount_) {

        // amount_ = IAssimilator(_assim.addr).viewRawAmount(_assim.amt);

        bytes memory data = abi.encodeWithSelector(iAsmltr.viewRawAmount.selector, _amt);

        amount_ = abi.decode(_assim.delegate(data), (uint256));

    }

    function viewNumeraireAmount (address _assim, uint256 _amt) internal returns (int128 amt_) {

        bytes memory data = abi.encodeWithSelector(iAsmltr.viewNumeraireAmount.selector, _amt);

        amt_ = abi.decode(_assim.delegate(data), (int128));

    }

    function viewNumeraireBalance (address _assim) internal returns (int128 nAmt_) {

        bytes memory data = abi.encodeWithSelector(iAsmltr.viewNumeraireBalance.selector, address(this));

        nAmt_ = abi.decode(_assim.delegate(data), (int128));

    }

    function intakeRaw (address _assim, uint256 _amount) internal returns (int128 amount_, int128 balance_) {

        bytes memory data = abi.encodeWithSelector(iAsmltr.intakeRaw.selector, _amount);

        ( amount_, balance_ ) = abi.decode(_assim.delegate(data), (int128,int128));

    }

    function intakeNumeraire (address _assim, int128 _amt) internal returns (uint256 rawAmt_) {

        bytes memory data = abi.encodeWithSelector(iAsmltr.intakeNumeraire.selector, _amt);

        rawAmt_ = abi.decode(_assim.delegate(data), (uint256));

    }

    function outputRaw (address _assim, address _dst, uint256 _amount) internal returns (int128 amount_, int128 balance_) {

        bytes memory data = abi.encodeWithSelector(iAsmltr.outputRaw.selector, _dst, _amount);

        ( amount_, balance_ ) = abi.decode(_assim.delegate(data), (int128,int128));

        amount_ = amount_.neg();

    }

    function outputNumeraire (address _assim, address _dst, int128 _amt) internal returns (uint256 rawAmt_) {

        bytes memory data = abi.encodeWithSelector(iAsmltr.outputNumeraire.selector, _dst, _amt.abs());

        rawAmt_ = abi.decode(_assim.delegate(data), (uint256));

    }

    function delegate(address _assim, bytes memory _data) internal returns (bytes memory) {

        (bool _success, bytes memory returnData_) = _assim.delegatecall(_data);

        assembly { if eq(_success, 0) { revert(add(returnData_, 0x20), returndatasize()) } }

        return returnData_;

    }


}

library LoihiMethods {

    using LoihiMethods for Loihi;

    function deposit (
        Loihi loihi,
        address[] memory _flvrs,
        uint256[] memory _amts
    ) internal returns (uint256 shells_) {

        shells_ = loihi.selectiveDeposit(_flvrs, _amts, 0, 1e50);

    }

    function deposit (
        Loihi loihi,
        address _token,
        uint256 _amt
    ) internal returns (uint256 shells_) {
        address[] memory _stblcns = new address[](1);
        uint256[] memory _amts = new uint256[](1);
        _stblcns[0] = _token;
        _amts[0] = _amt;

        shells_ = loihi.selectiveDeposit(_stblcns, _amts, 0, 1e50);

    }

    function deposit (
        Loihi loihi,
        address _token1,
        uint256 _amt1,
        address _token2,
        uint256 _amt2
    ) internal returns (uint256 shells_) {

        address[] memory _stblcns = new address[](2);
        uint256[] memory _amts = new uint256[](2);
        _stblcns[0] = _token1;
        _amts[0] = _amt1;
        _stblcns[1] = _token2;
        _amts[1] = _amt2;

        shells_ = loihi.selectiveDeposit(_stblcns, _amts, 0, 1e50);

    }

    function deposit (
        Loihi loihi,
        address _token1,
        uint256 _amt1,
        address _token2,
        uint256 _amt2,
        address _token3,
        uint256 _amt3
    ) internal returns (uint256 shells_) {

        address[] memory _stblcns = new address[](3);
        uint256[] memory _amts = new uint256[](3);
        _stblcns[0] = _token1;
        _amts[0] = _amt1;
        _stblcns[1] = _token2;
        _amts[1] = _amt2;
        _stblcns[2] = _token3;
        _amts[2] = _amt3;

        shells_ = loihi.selectiveDeposit(_stblcns, _amts, 0, 1e50);

    }

    function deposit (
        Loihi loihi,
        address _token1,
        uint256 _amt1,
        address _token2,
        uint256 _amt2,
        address _token3,
        uint256 _amt3,
        address _token4,
        uint256 _amt4
    ) internal returns (uint256 shells_) {

        address[] memory _stblcns = new address[](4);
        uint256[] memory _amts = new uint256[](4);
        _stblcns[0] = _token1;
        _amts[0] = _amt1;
        _stblcns[1] = _token2;
        _amts[1] = _amt2;
        _stblcns[2] = _token3;
        _amts[2] = _amt3;
        _stblcns[3] = _token4;
        _amts[3] = _amt4;

        shells_ = loihi.selectiveDeposit(_stblcns, _amts, 0, 1e50);

    }

    function depositSuccess (
        Loihi loihi,
        address _token1,
        uint256 _amt1,
        address _token2,
        uint256 _amt2,
        address _token3,
        uint256 _amt3,
        address _token4,
        uint256 _amt4
    ) internal returns (bool success_) {

        address[] memory _stblcns = new address[](4);
        uint256[] memory _amts = new uint256[](4);
        _stblcns[0] = _token1;
        _amts[0] = _amt1;
        _stblcns[1] = _token2;
        _amts[1] = _amt2;
        _stblcns[2] = _token3;
        _amts[2] = _amt3;
        _stblcns[3] = _token4;
        _amts[3] = _amt4;

        ( success_, ) = address(loihi).call(abi.encodeWithSelector(
            loihi.selectiveDeposit.selector,
            _stblcns,
            _amts,
            0,
            1e50
        ));

    }

    function depositSuccess (
        Loihi loihi,
        address _token1,
        uint256 _amt1,
        address _token2,
        uint256 _amt2,
        address _token3,
        uint256 _amt3
    ) internal returns (bool success_) {

        address[] memory _stblcns = new address[](3);
        uint256[] memory _amts = new uint256[](3);
        _stblcns[0] = _token1;
        _amts[0] = _amt1;
        _stblcns[1] = _token2;
        _amts[1] = _amt2;
        _stblcns[2] = _token3;
        _amts[2] = _amt3;

        ( success_, ) = address(loihi).call(abi.encodeWithSelector(
            loihi.selectiveDeposit.selector,
            _stblcns,
            _amts,
            0,
            1e50
        ));

    }

    function depositSuccess (
        Loihi loihi,
        address _token1,
        uint256 _amt1,
        address _token2,
        uint256 _amt2
    ) internal returns (bool success_) {

        address[] memory _stblcns = new address[](2);
        uint256[] memory _amts = new uint256[](2);
        _stblcns[0] = _token1;
        _amts[0] = _amt1;
        _stblcns[1] = _token2;
        _amts[1] = _amt2;

        ( success_, ) = address(loihi).call(abi.encodeWithSelector(
            loihi.selectiveDeposit.selector,
            _stblcns,
            _amts,
            0,
            1e50
        ));

    }

    function depositSuccess (
        Loihi loihi,
        address _token1,
        uint256 _amt1
    ) internal returns (bool success_) {

        address[] memory _stblcns = new address[](1);
        uint256[] memory _amts = new uint256[](1);
        _stblcns[0] = _token1;
        _amts[0] = _amt1;

        ( success_, ) = address(loihi).call(abi.encodeWithSelector(
            loihi.selectiveDeposit.selector,
            _stblcns,
            _amts,
            0,
            1e50
        ));

    }

    function withdraw (
        Loihi loihi,
        address[] memory _flvrs,
        uint256[] memory _amts
    ) internal returns (uint256 shells_) {

        shells_ = loihi.selectiveWithdraw(_flvrs, _amts, 1e50, 1e50);

    }

    function withdraw (
        Loihi loihi,
        address _token,
        uint256 _amt
    ) internal returns (uint256 shells_) {
        address[] memory _stblcns = new address[](1);
        uint256[] memory _amts = new uint256[](1);
        _stblcns[0] = _token;
        _amts[0] = _amt;

        shells_ = loihi.selectiveWithdraw(_stblcns, _amts, 1e50, 1e50);

    }

    function withdraw (
        Loihi loihi,
        address _token1,
        uint256 _amt1,
        address _token2,
        uint256 _amt2
    ) internal returns (uint256 shells_) {

        address[] memory _stblcns = new address[](2);
        uint256[] memory _amts = new uint256[](2);
        _stblcns[0] = _token1;
        _amts[0] = _amt1;
        _stblcns[1] = _token2;
        _amts[1] = _amt2;

        shells_ = loihi.selectiveWithdraw(_stblcns, _amts, 1e50, 1e50);

    }

    function withdraw (
        Loihi loihi,
        address _token1,
        uint256 _amt1,
        address _token2,
        uint256 _amt2,
        address _token3,
        uint256 _amt3
    ) internal returns (uint256 shells_) {

        address[] memory _stblcns = new address[](3);
        uint256[] memory _amts = new uint256[](3);
        _stblcns[0] = _token1;
        _amts[0] = _amt1;
        _stblcns[1] = _token2;
        _amts[1] = _amt2;
        _stblcns[2] = _token3;
        _amts[2] = _amt3;

        shells_ = loihi.selectiveWithdraw(_stblcns, _amts, 1e50, 1e50);

    }

    function withdraw (
        Loihi loihi,
        address _token1,
        uint256 _amt1,
        address _token2,
        uint256 _amt2,
        address _token3,
        uint256 _amt3,
        address _token4,
        uint256 _amt4
    ) internal returns (uint256 shells_) {

        address[] memory _stblcns = new address[](4);
        uint256[] memory _amts = new uint256[](4);
        _stblcns[0] = _token1;
        _amts[0] = _amt1;
        _stblcns[1] = _token2;
        _amts[1] = _amt2;
        _stblcns[2] = _token3;
        _amts[2] = _amt3;
        _stblcns[3] = _token4;
        _amts[3] = _amt4;

        shells_ = loihi.selectiveWithdraw(_stblcns, _amts, 1e50, 1e50);

    }

    // function withdrawHack (
    //     Loihi loihi,
    //     address[] memory _flvrs,
    //     uint256[] memory _amts
    // ) internal returns (uint256 shells_) {

    //     shells_ = loihi.selectiveWithdrawHack(_flvrs, _amts, 1e50, 1e50);

    // }

    // function withdrawHack (
    //     Loihi loihi,
    //     address _token,
    //     uint256 _amt
    // ) internal returns (uint256 shells_) {
    //     address[] memory _stblcns = new address[](1);
    //     uint256[] memory _amts = new uint256[](1);
    //     _stblcns[0] = _token;
    //     _amts[0] = _amt;

    //     shells_ = loihi.selectiveWithdrawHack(_stblcns, _amts, 1e50, 1e50);

    // }

    // function withdrawHack (
    //     Loihi loihi,
    //     address _token1,
    //     uint256 _amt1,
    //     address _token2,
    //     uint256 _amt2
    // ) internal returns (uint256 shells_) {

    //     address[] memory _stblcns = new address[](2);
    //     uint256[] memory _amts = new uint256[](2);
    //     _stblcns[0] = _token1;
    //     _amts[0] = _amt1;
    //     _stblcns[1] = _token2;
    //     _amts[1] = _amt2;

    //     shells_ = loihi.selectiveWithdrawHack(_stblcns, _amts, 1e50, 1e50);

    // }

    // function withdrawHack (
    //     Loihi loihi,
    //     address _token1,
    //     uint256 _amt1,
    //     address _token2,
    //     uint256 _amt2,
    //     address _token3,
    //     uint256 _amt3
    // ) internal returns (uint256 shells_) {

    //     address[] memory _stblcns = new address[](3);
    //     uint256[] memory _amts = new uint256[](3);
    //     _stblcns[0] = _token1;
    //     _amts[0] = _amt1;
    //     _stblcns[1] = _token2;
    //     _amts[1] = _amt2;
    //     _stblcns[2] = _token3;
    //     _amts[2] = _amt3;

    //     shells_ = loihi.selectiveWithdrawHack(_stblcns, _amts, 1e50, 1e50);

    // }

    // function withdrawHack (
    //     Loihi loihi,
    //     address _token1,
    //     uint256 _amt1,
    //     address _token2,
    //     uint256 _amt2,
    //     address _token3,
    //     uint256 _amt3,
    //     address _token4,
    //     uint256 _amt4
    // ) internal returns (uint256 shells_) {

    //     address[] memory _stblcns = new address[](4);
    //     uint256[] memory _amts = new uint256[](4);
    //     _stblcns[0] = _token1;
    //     _amts[0] = _amt1;
    //     _stblcns[1] = _token2;
    //     _amts[1] = _amt2;
    //     _stblcns[2] = _token3;
    //     _amts[2] = _amt3;
    //     _stblcns[3] = _token4;
    //     _amts[3] = _amt4;

    //     shells_ = loihi.selectiveWithdrawHack(_stblcns, _amts, 1e50, 1e50);

    // }

    function withdrawSuccess (
        Loihi loihi,
        address _token1,
        uint256 _amt1,
        address _token2,
        uint256 _amt2,
        address _token3,
        uint256 _amt3,
        address _token4,
        uint256 _amt4
    ) internal returns (bool success_) {

        address[] memory _stblcns = new address[](4);
        uint256[] memory _amts = new uint256[](4);
        _stblcns[0] = _token1;
        _amts[0] = _amt1;
        _stblcns[1] = _token2;
        _amts[1] = _amt2;
        _stblcns[2] = _token3;
        _amts[2] = _amt3;
        _stblcns[3] = _token4;
        _amts[3] = _amt4;

        ( success_, ) = address(loihi).call(abi.encodeWithSelector(
            loihi.selectiveWithdraw.selector,
            _stblcns,
            _amts,
            1e50,
            1e50
        ));

    }

    function withdrawSuccess (
        Loihi loihi,
        address _token1,
        uint256 _amt1,
        address _token2,
        uint256 _amt2,
        address _token3,
        uint256 _amt3
    ) internal returns (bool success_) {

        address[] memory _stblcns = new address[](3);
        uint256[] memory _amts = new uint256[](3);
        _stblcns[0] = _token1;
        _amts[0] = _amt1;
        _stblcns[1] = _token2;
        _amts[1] = _amt2;
        _stblcns[2] = _token3;
        _amts[2] = _amt3;

        ( success_, ) = address(loihi).call(abi.encodeWithSelector(
            loihi.selectiveWithdraw.selector,
            _stblcns,
            _amts,
            1e50,
            1e50
        ));

    }

    function withdrawSuccess (
        Loihi loihi,
        address _token1,
        uint256 _amt1,
        address _token2,
        uint256 _amt2
    ) internal returns (bool success_) {

        address[] memory _stblcns = new address[](2);
        uint256[] memory _amts = new uint256[](2);
        _stblcns[0] = _token1;
        _amts[0] = _amt1;
        _stblcns[1] = _token2;
        _amts[1] = _amt2;

        ( success_, ) = address(loihi).call(abi.encodeWithSelector(
            loihi.selectiveWithdraw.selector,
            _stblcns,
            _amts,
            1e50,
            1e50
        ));

    }

    function withdrawSuccess (
        Loihi loihi,
        address _token1,
        uint256 _amt1
    ) internal returns (bool success_) {

        address[] memory _stblcns = new address[](1);
        uint256[] memory _amts = new uint256[](1);
        _stblcns[0] = _token1;
        _amts[0] = _amt1;

        ( success_, ) = address(loihi).call(abi.encodeWithSelector(
            loihi.selectiveWithdraw.selector,
            _stblcns,
            _amts,
            1e50,
            1e50
        ));

    }

    function originSwap (
        Loihi loihi,
        address _origin,
        address _target,
        uint256 _originAmount
    ) internal returns (uint256 targetAmount_) {

        targetAmount_ = loihi.swapByOrigin(_origin, _target, _originAmount, 0, 1e50);

    }

    // function originSwapHack (
    //     Loihi loihi,
    //     address _origin,
    //     address _target,
    //     uint256 _originAmount
    // ) internal returns (uint256 targetAmount_) {

    //     targetAmount_ = loihi.swapByOriginHack(_origin, _target, _originAmount, 0, 1e50);

    // }

    function originSwapSuccess (
        Loihi loihi,
        address _origin,
        address _target,
        uint256 _originAmount
    ) internal returns (bool success_) {

        ( success_, ) = address(loihi).call(abi.encodeWithSelector(
            loihi.swapByOrigin.selector,
            _origin,
            _target,
            _originAmount,
            0,
            1e50
        ));

    }

    function targetSwap (
        Loihi loihi,
        address _origin,
        address _target,
        uint256 _targetAmount
    ) internal returns (uint256 originAmount_) {

        originAmount_ = loihi.swapByTarget(_origin, _target, 1e50, _targetAmount, 1e50);

    }

    // function targetSwapHack (
    //     Loihi loihi,
    //     address _origin,
    //     address _target,
    //     uint256 _targetAmount
    // ) internal returns (uint256 originAmount_) {

    //     originAmount_ = loihi.swapByTargetHack(_origin, _target, 1e50, _targetAmount, 1e50);

    // }

    function targetSwapSuccess (
        Loihi loihi,
        address _origin,
        address _target,
        uint256 _targetAmount
    ) internal returns (bool success_) {

        ( success_, ) = address(loihi).call(abi.encodeWithSelector(
            loihi.swapByTarget.selector,
            _origin,
            _target,
            1e50,
            _targetAmount,
            1e50
        ));

    }

    // function depositHack (
    //     Loihi loihi,
    //     address[] memory _flvrs,
    //     uint256[] memory _amts
    // ) internal returns (uint256 shells_) {

    //     shells_ = loihi.selectiveDepositHack(_flvrs, _amts, 0, 1e50);

    // }

    // function depositHack (
    //     Loihi loihi,
    //     address _token,
    //     uint256 _amt
    // ) internal returns (uint256 shells_) {
    //     address[] memory _stblcns = new address[](1);
    //     uint256[] memory _amts = new uint256[](1);
    //     _stblcns[0] = _token;
    //     _amts[0] = _amt;

    //     shells_ = loihi.selectiveDepositHack(_stblcns, _amts, 0, 1e50);

    // }

    // function depositHack (
    //     Loihi loihi,
    //     address _token1,
    //     uint256 _amt1,
    //     address _token2,
    //     uint256 _amt2
    // ) internal returns (uint256 shells_) {

    //     address[] memory _stblcns = new address[](2);
    //     uint256[] memory _amts = new uint256[](2);
    //     _stblcns[0] = _token1;
    //     _amts[0] = _amt1;
    //     _stblcns[1] = _token2;
    //     _amts[1] = _amt2;

    //     shells_ = loihi.selectiveDepositHack(_stblcns, _amts, 0, 1e50);

    // }

    // function depositHack (
    //     Loihi loihi,
    //     address _token1,
    //     uint256 _amt1,
    //     address _token2,
    //     uint256 _amt2,
    //     address _token3,
    //     uint256 _amt3
    // ) internal returns (uint256 shells_) {

    //     address[] memory _stblcns = new address[](3);
    //     uint256[] memory _amts = new uint256[](3);
    //     _stblcns[0] = _token1;
    //     _amts[0] = _amt1;
    //     _stblcns[1] = _token2;
    //     _amts[1] = _amt2;
    //     _stblcns[2] = _token3;
    //     _amts[2] = _amt3;

    //     shells_ = loihi.selectiveDepositHack(_stblcns, _amts, 0, 1e50);

    // }

    // function depositHack (
    //     Loihi loihi,
    //     address _token1,
    //     uint256 _amt1,
    //     address _token2,
    //     uint256 _amt2,
    //     address _token3,
    //     uint256 _amt3,
    //     address _token4,
    //     uint256 _amt4
    // ) internal returns (uint256 shells_) {

    //     address[] memory _stblcns = new address[](4);
    //     uint256[] memory _amts = new uint256[](4);
    //     _stblcns[0] = _token1;
    //     _amts[0] = _amt1;
    //     _stblcns[1] = _token2;
    //     _amts[1] = _amt2;
    //     _stblcns[2] = _token3;
    //     _amts[2] = _amt3;
    //     _stblcns[3] = _token4;
    //     _amts[3] = _amt4;

    //     shells_ = loihi.selectiveDepositHack(_stblcns, _amts, 0, 1e50);

    // }

}
