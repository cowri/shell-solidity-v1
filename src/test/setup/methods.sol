pragma solidity ^0.5.0;

import "abdk-libraries-solidity/ABDKMath64x64.sol";

import "../../Shell.sol";

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

library ShellMethods {

    using ShellMethods for Shell;

    function deposit (
        Shell shell,
        address[] memory _flvrs,
        uint256[] memory _amts
    ) internal returns (uint256 shells_) {

        shells_ = shell.selectiveDeposit(_flvrs, _amts, 0, 1e50);

    }

    function deposit (
        Shell shell,
        address _token,
        uint256 _amt
    ) internal returns (uint256 shells_) {
        address[] memory _stblcns = new address[](1);
        uint256[] memory _amts = new uint256[](1);
        _stblcns[0] = _token;
        _amts[0] = _amt;

        shells_ = shell.selectiveDeposit(_stblcns, _amts, 0, 1e50);

    }

    function deposit (
        Shell shell,
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

        shells_ = shell.selectiveDeposit(_stblcns, _amts, 0, 1e50);

    }

    function deposit (
        Shell shell,
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

        shells_ = shell.selectiveDeposit(_stblcns, _amts, 0, 1e50);

    }

    function deposit (
        Shell shell,
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

        shells_ = shell.selectiveDeposit(_stblcns, _amts, 0, 1e50);

    }

    function viewDeposit (
        Shell shell,
        address[] memory _flvrs,
        uint256[] memory _amts
    ) internal returns (uint256 shells_) {

        shells_ = shell.viewSelectiveDeposit(_flvrs, _amts);

    }

    function viewDeposit (
        Shell shell,
        address _token,
        uint256 _amt
    ) internal returns (uint256 shells_) {
        address[] memory _stblcns = new address[](1);
        uint256[] memory _amts = new uint256[](1);
        _stblcns[0] = _token;
        _amts[0] = _amt;

        shells_ = shell.viewSelectiveDeposit(_stblcns, _amts);

    }

    function viewDeposit (
        Shell shell,
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

        shells_ = shell.viewSelectiveDeposit(_stblcns, _amts);

    }

    function viewDeposit (
        Shell shell,
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

        shells_ = shell.viewSelectiveDeposit(_stblcns, _amts);

    }

    function viewDeposit (
        Shell shell,
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

        shells_ = shell.viewSelectiveDeposit(_stblcns, _amts);

    }

    function depositSuccess (
        Shell shell,
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

        ( success_, ) = address(shell).call(abi.encodeWithSelector(
            shell.selectiveDeposit.selector,
            _stblcns,
            _amts,
            0,
            1e50
        ));

    }

    function depositSuccess (
        Shell shell,
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

        ( success_, ) = address(shell).call(abi.encodeWithSelector(
            shell.selectiveDeposit.selector,
            _stblcns,
            _amts,
            0,
            1e50
        ));

    }

    function depositSuccess (
        Shell shell,
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

        ( success_, ) = address(shell).call(abi.encodeWithSelector(
            shell.selectiveDeposit.selector,
            _stblcns,
            _amts,
            0,
            1e50
        ));

    }

    function depositSuccess (
        Shell shell,
        address _token1,
        uint256 _amt1
    ) internal returns (bool success_) {

        address[] memory _stblcns = new address[](1);
        uint256[] memory _amts = new uint256[](1);
        _stblcns[0] = _token1;
        _amts[0] = _amt1;

        ( success_, ) = address(shell).call(abi.encodeWithSelector(
            shell.selectiveDeposit.selector,
            _stblcns,
            _amts,
            0,
            1e50
        ));

    }

    function withdraw (
        Shell shell,
        address[] memory _flvrs,
        uint256[] memory _amts
    ) internal returns (uint256 shells_) {

        shells_ = shell.selectiveWithdraw(_flvrs, _amts, 1e50, 1e50);

    }

    function withdraw (
        Shell shell,
        address _token,
        uint256 _amt
    ) internal returns (uint256 shells_) {
        address[] memory _stblcns = new address[](1);
        uint256[] memory _amts = new uint256[](1);
        _stblcns[0] = _token;
        _amts[0] = _amt;

        shells_ = shell.selectiveWithdraw(_stblcns, _amts, 1e50, 1e50);

    }

    function withdraw (
        Shell shell,
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

        shells_ = shell.selectiveWithdraw(_stblcns, _amts, 1e50, 1e50);

    }

    function withdraw (
        Shell shell,
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

        shells_ = shell.selectiveWithdraw(_stblcns, _amts, 1e50, 1e50);

    }

    function withdraw (
        Shell shell,
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

        shells_ = shell.selectiveWithdraw(_stblcns, _amts, 1e50, 1e50);

    }

    function viewWithdraw (
        Shell shell,
        address[] memory _flvrs,
        uint256[] memory _amts
    ) internal returns (uint256 shells_) {

        shells_ = shell.viewSelectiveWithdraw(_flvrs, _amts);

    }

    function viewWithdraw (
        Shell shell,
        address _token,
        uint256 _amt
    ) internal returns (uint256 shells_) {
        address[] memory _stblcns = new address[](1);
        uint256[] memory _amts = new uint256[](1);
        _stblcns[0] = _token;
        _amts[0] = _amt;

        shells_ = shell.viewSelectiveWithdraw(_stblcns, _amts);

    }

    function viewWithdraw (
        Shell shell,
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

        shells_ = shell.viewSelectiveWithdraw(_stblcns, _amts);

    }

    function viewWithdraw (
        Shell shell,
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

        shells_ = shell.viewSelectiveWithdraw(_stblcns, _amts);

    }

    function viewWithdraw (
        Shell shell,
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

        shells_ = shell.viewSelectiveWithdraw(_stblcns, _amts);

    }

    function withdrawSuccess (
        Shell shell,
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

        ( success_, ) = address(shell).call(abi.encodeWithSelector(
            shell.selectiveWithdraw.selector,
            _stblcns,
            _amts,
            1e50,
            1e50
        ));

    }

    function withdrawSuccess (
        Shell shell,
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

        ( success_, ) = address(shell).call(abi.encodeWithSelector(
            shell.selectiveWithdraw.selector,
            _stblcns,
            _amts,
            1e50,
            1e50
        ));

    }

    function withdrawSuccess (
        Shell shell,
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

        ( success_, ) = address(shell).call(abi.encodeWithSelector(
            shell.selectiveWithdraw.selector,
            _stblcns,
            _amts,
            1e50,
            1e50
        ));

    }

    function withdrawSuccess (
        Shell shell,
        address _token1,
        uint256 _amt1
    ) internal returns (bool success_) {

        address[] memory _stblcns = new address[](1);
        uint256[] memory _amts = new uint256[](1);
        _stblcns[0] = _token1;
        _amts[0] = _amt1;

        ( success_, ) = address(shell).call(abi.encodeWithSelector(
            shell.selectiveWithdraw.selector,
            _stblcns,
            _amts,
            1e50,
            1e50
        ));

    }

    function originSwap (
        Shell shell,
        address _origin,
        address _target,
        uint256 _originAmount
    ) internal returns (uint256 targetAmount_) {

        targetAmount_ = shell.originSwap(_origin, _target, _originAmount, 0, 1e50);

    }

    function originSwapSuccess (
        Shell shell,
        address _origin,
        address _target,
        uint256 _originAmount
    ) internal returns (bool success_) {

        ( success_, ) = address(shell).call(abi.encodeWithSignature(
            "originSwap(address,address,uint256,uint256,uint256)",
            _origin,
            _target,
            _originAmount,
            0,
            1e50
        ));

    }

    function targetSwap (
        Shell shell,
        address _origin,
        address _target,
        uint256 _targetAmount
    ) internal returns (uint256 originAmount_) {

        originAmount_ = shell.targetSwap(_origin, _target, 1e50, _targetAmount, 1e50);

    }

    function targetSwapSuccess (
        Shell shell,
        address _origin,
        address _target,
        uint256 _targetAmount
    ) internal returns (bool success_) {

        ( success_, ) = address(shell).call(abi.encodeWithSignature(
            "targetSwap(address,address,uint256,uint256,uint256)",
            _origin,
            _target,
            1e50,
            _targetAmount,
            1e50
        ));

    }

    function partitionedWithdraw (
        Shell shell,
        address _token1,
        uint _amount1
    ) internal returns (uint[] memory) {

        address[] memory _tokens = new address[](1);
        uint[] memory _amounts = new uint[](1);

        _tokens[0] = _token1;
        _amounts[0] = _amount1;

        return shell.partitionedWithdraw(_tokens, _amounts);

    }


    function partitionedWithdraw (
        Shell shell,
        address _token1,
        uint _amount1,
        address _token2,
        uint _amount2
    ) internal returns (uint[] memory) {

        address[] memory _tokens = new address[](2);
        uint256[] memory _amounts = new uint[](2);

        _tokens[0] = _token1;
        _amounts[0] = _amount1;
        _tokens[1] = _token2;
        _amounts[1] = _amount2;

        return shell.partitionedWithdraw(_tokens, _amounts);

    }

    function partitionedWithdraw (
        Shell shell,
        address _token1,
        uint _amount1,
        address _token2,
        uint _amount2,
        address _token3,
        uint _amount3
    ) internal returns (uint[] memory) {

        address[] memory _tokens = new address[](3);
        uint256[] memory _amounts = new uint[](3);

        _tokens[0] = _token1;
        _amounts[0] = _amount1;
        _tokens[1] = _token2;
        _amounts[1] = _amount2;
        _tokens[2] = _token3;
        _amounts[2] = _amount3;

        return shell.partitionedWithdraw(_tokens, _amounts);

    }

    function partitionedWithdraw (
        Shell shell,
        address _token1,
        uint _amount1,
        address _token2,
        uint _amount2,
        address _token3,
        uint _amount3,
        address _token4,
        uint _amount4
    ) internal returns (uint[] memory) {

        address[] memory _tokens = new address[](4);
        uint256[] memory _amounts = new uint[](4);

        _tokens[0] = _token1;
        _amounts[0] = _amount1;
        _tokens[0] = _token2;
        _amounts[0] = _amount2;
        _tokens[0] = _token3;
        _amounts[0] = _amount3;
        _tokens[0] = _token4;
        _amounts[0] = _amount4;

        return shell.partitionedWithdraw(_tokens, _amounts);

    }

}