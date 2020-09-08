pragma solidity ^0.5.0;

import "./Assimilators.sol";

import "./LoihiStorage.sol";

import "./ShellMath.sol";

import "./UnsafeMath64x64.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

library Swaps {

    using ABDKMath64x64 for int128;
    using UnsafeMath64x64 for int128;

    event Trade(address indexed trader, address indexed origin, address indexed target, uint256 originAmount, uint256 targetAmount);

    int128 constant ONE = 0x10000000000000000;

    function getOriginAndTarget (
        LoihiStorage.Shell storage shell,
        address _o,
        address _t
    ) private view returns (
        LoihiStorage.Assimilator memory,
        LoihiStorage.Assimilator memory
    ) {

        LoihiStorage.Assimilator memory o_ = shell.assimilators[_o];
        LoihiStorage.Assimilator memory t_ = shell.assimilators[_t];

        require(o_.addr != address(0), "Shell/origin-not-supported");
        require(t_.addr != address(0), "Shell/target-not-supported");

        return ( o_, t_ );

    }


    function originSwap (
        LoihiStorage.Shell storage shell,
        address _origin,
        address _target,
        uint256 _originAmount,
        address _recipient
    ) external returns (
        uint256 tAmt_
    ) {

        (   LoihiStorage.Assimilator memory _o,
            LoihiStorage.Assimilator memory _t  ) = getOriginAndTarget(shell, _origin, _target);

        if (_o.ix == _t.ix) return Assimilators.outputNumeraire(_t.addr, _recipient, Assimilators.intakeRaw(_o.addr, _originAmount));

        (   int128 _amt,
            int128 _oGLiq,
            int128 _nGLiq,
            int128[] memory _oBals,
            int128[] memory _nBals ) = getOriginSwapData(shell, _o.ix, _t.ix, _o.addr, _originAmount);

        ( _amt, shell.omega ) = ShellMath.calculateTrade(shell, _oGLiq, _nGLiq, _oBals, _nBals, _amt, _t.ix);

        _amt = _amt.us_mul(ONE - shell.epsilon);

        tAmt_ = Assimilators.outputNumeraire(_t.addr, _recipient, _amt);

        emit Trade(msg.sender, _origin, _target, _originAmount, tAmt_);

    }

    // / @author james foley http://github.com/realisation
    // / @notice view how much of the target currency the origin currency will provide
    // / @param _origin the address of the origin
    // / @param _target the address of the target
    // / @param _originAmount the origin amount
    // / @return tAmt_ the amount of target that has been swapped for the origin
    function viewOriginSwap (
        LoihiStorage.Shell storage shell,
        address _origin,
        address _target,
        uint256 _originAmount
    ) external view returns (
        uint256 tAmt_
    ) {

        (   LoihiStorage.Assimilator memory _o,
            LoihiStorage.Assimilator memory _t  ) = getOriginAndTarget(shell, _origin, _target);

        if (_o.ix == _t.ix) return Assimilators.viewRawAmount(_t.addr, Assimilators.viewNumeraireAmount(_o.addr, _originAmount));

        (   int128 _amt,
            int128 _oGLiq,
            int128 _nGLiq,
            int128[] memory _nBals,
            int128[] memory _oBals ) = viewOriginSwapData(shell, _o.ix, _t.ix, _originAmount, _o.addr);

        ( _amt, ) = ShellMath.calculateTrade(shell, _oGLiq, _nGLiq, _oBals, _nBals, _amt, _t.ix);

        _amt = _amt.us_mul(ONE - shell.epsilon);

        tAmt_ = Assimilators.viewRawAmount(_t.addr, _amt.abs());

    }

    // / @author james foley http://github.com/realisation
    // / @notice transfer a dynamic origin amount into a fixed target amount at the recipients address
    // / @param _origin the address of the origin
    // / @param _target the address of the target
    // / @param _mOAmt the maximum origin amount
    // / @param _targetAmount the target amount
    // / @param _dline deadline in block number after which the trade will not execute
    // / @param _recipient the address of the recipient of the target
    // / @return oAmt_ the amount of origin that has been swapped for the target
    function targetSwap (
        LoihiStorage.Shell storage shell,
        address _origin,
        address _target,
        uint256 _targetAmount,
        address _recipient
    ) external returns (
        uint256 oAmt_
    ) {

        (   LoihiStorage.Assimilator memory _o,
            LoihiStorage.Assimilator memory _t  ) = getOriginAndTarget(shell, _origin, _target);

        if (_o.ix == _t.ix) return Assimilators.intakeNumeraire(_o.addr, Assimilators.outputRaw(_t.addr, _recipient, _targetAmount));

        (   int128 _amt,
            int128 _oGLiq,
            int128 _nGLiq,
            int128[] memory _oBals,
            int128[] memory _nBals) = getTargetSwapData(shell, _t.ix, _o.ix, _t.addr, _recipient, _targetAmount);

        ( _amt, shell.omega ) = ShellMath.calculateTrade(shell, _oGLiq, _nGLiq, _oBals, _nBals, _amt, _o.ix);

        _amt = _amt.us_mul(ONE + shell.epsilon);

        oAmt_ = Assimilators.intakeNumeraire(_o.addr, _amt);

        emit Trade(msg.sender, _origin, _target, oAmt_, _targetAmount);

    }

    // / @author james foley http://github.com/realisation
    // / @notice view how much of the origin currency the target currency will take
    // / @param _origin the address of the origin
    // / @param _target the address of the target
    // / @param _targetAmount the target amount
    // / @return oAmt_ the amount of target that has been swapped for the origin
    function viewTargetSwap (
        LoihiStorage.Shell storage shell,
        address _origin,
        address _target,
        uint256 _targetAmount
    ) external view returns (
        uint256 oAmt_
    ) {

        (   LoihiStorage.Assimilator memory _o,
            LoihiStorage.Assimilator memory _t  ) = getOriginAndTarget(shell, _origin, _target);

        if (_o.ix == _t.ix) return Assimilators.viewRawAmount(_o.addr, Assimilators.viewNumeraireAmount(_t.addr, _targetAmount));

        (   int128 _amt,
            int128 _oGLiq,
            int128 _nGLiq,
            int128[] memory _nBals,
            int128[] memory _oBals ) = viewTargetSwapData(shell, _t.ix, _o.ix, _targetAmount, _t.addr);

        ( _amt, ) = ShellMath.calculateTrade(shell, _oGLiq, _nGLiq, _oBals, _nBals, _amt, _o.ix);

        _amt = _amt.us_mul(ONE + shell.epsilon);

        oAmt_ = Assimilators.viewRawAmount(_o.addr, _amt);

    }

    function getOriginSwapData (
        LoihiStorage.Shell storage shell,
        uint _inputIx,
        uint _outputIndex,
        address _assim,
        uint _amt
    ) private returns (
        int128 amt_,
        int128 oGLiq_,
        int128 nGLiq_,
        int128[] memory,
        int128[] memory
    ) {

        uint _length = shell.reserves.length;

        int128[] memory oBals_ = new int128[](_length);
        int128[] memory nBals_ = new int128[](_length);
        LoihiStorage.Assimilator[] memory _reserves = shell.reserves;

        for (uint i = 0; i < _length; i++) {

            if (i != _inputIx) nBals_[i] = oBals_[i] = Assimilators.viewNumeraireBalance(_reserves[i].addr);
            else {

                int128 _bal;
                ( amt_, _bal ) = Assimilators.intakeRawAndGetBalance(_assim, _amt);

                oBals_[i] = _bal - amt_;
                nBals_[i] = _bal;

            }

            oGLiq_ += oBals_[i];
            nGLiq_ += nBals_[i];

        }

        nGLiq_ = nGLiq_.sub(amt_);
        nBals_[_outputIndex] = ABDKMath64x64.sub(nBals_[_outputIndex], amt_);

        return ( amt_, oGLiq_, nGLiq_, oBals_, nBals_ );

    }

    function getTargetSwapData (
        LoihiStorage.Shell storage shell,
        uint _inputIx,
        uint _outputIndex,
        address _assim,
        address _recipient,
        uint _amt
    ) private returns (
        int128 amt_,
        int128 oGLiq_,
        int128 nGLiq_,
        int128[] memory,
        int128[] memory
    ) {

        uint _length = shell.reserves.length;

        int128[] memory oBals_ = new int128[](_length);
        int128[] memory nBals_ = new int128[](_length);
        LoihiStorage.Assimilator[] memory _reserves = shell.reserves;

        for (uint i = 0; i < _length; i++) {

            if (i != _inputIx) nBals_[i] = oBals_[i] = Assimilators.viewNumeraireBalance(_reserves[i].addr);
            else {

                int128 _bal;
                ( amt_, _bal ) = Assimilators.outputRawAndGetBalance(_assim, _recipient, _amt);

                oBals_[i] = _bal - amt_;
                nBals_[i] = _bal;

            }

            oGLiq_ += oBals_[i];
            nGLiq_ += nBals_[i];

        }

        nGLiq_ = nGLiq_.sub(amt_);
        nBals_[_outputIndex] = ABDKMath64x64.sub(nBals_[_outputIndex], amt_);

        return ( amt_, oGLiq_, nGLiq_, oBals_, nBals_ );

    }

    function viewOriginSwapData (
        LoihiStorage.Shell storage shell,
        uint _inputIx,
        uint _outputIndex,
        uint _amt,
        address _assim
    ) private view returns (
        int128 amt_,
        int128 oGLiq_,
        int128 nGLiq_,
        int128[] memory,
        int128[] memory
    ) {

        uint _length = shell.reserves.length;
        int128[] memory nBals_ = new int128[](_length);
        int128[] memory oBals_ = new int128[](_length);

        for (uint i = 0; i < _length; i++) {

            if (i != _inputIx) nBals_[i] = oBals_[i] = Assimilators.viewNumeraireBalance(shell.reserves[i].addr);
            else {

                int128 _bal;
                ( amt_, _bal ) = Assimilators.viewNumeraireAmountAndBalance(_assim, _amt);

                oBals_[i] = _bal;
                nBals_[i] = _bal.add(amt_);

            }

            oGLiq_ += oBals_[i];
            nGLiq_ += nBals_[i];

        }

        nGLiq_ = nGLiq_.sub(amt_);
        nBals_[_outputIndex] = ABDKMath64x64.sub(nBals_[_outputIndex], amt_);


        return ( amt_, oGLiq_, nGLiq_, nBals_, oBals_ );

    }

    function viewTargetSwapData (
        LoihiStorage.Shell storage shell,
        uint _inputIx,
        uint _outputIndex,
        uint _amt,
        address _assim
    ) private view returns (
        int128 amt_,
        int128 oGLiq_,
        int128 nGLiq_,
        int128[] memory,
        int128[] memory
    ) {

        uint _length = shell.reserves.length;
        int128[] memory nBals_ = new int128[](_length);
        int128[] memory oBals_ = new int128[](_length);

        for (uint i = 0; i < _length; i++) {

            if (i != _inputIx) nBals_[i] = oBals_[i] = Assimilators.viewNumeraireBalance(shell.reserves[i].addr);
            else {

                int128 _bal;
                ( amt_, _bal ) = Assimilators.viewNumeraireAmountAndBalance(_assim, _amt);
                amt_ = amt_.neg();

                oBals_[i] = _bal;
                nBals_[i] = _bal.add(amt_);

            }

            oGLiq_ += oBals_[i];
            nGLiq_ += nBals_[i];

        }

        nGLiq_ = nGLiq_.sub(amt_);
        nBals_[_outputIndex] = ABDKMath64x64.sub(nBals_[_outputIndex], amt_);


        return ( amt_, oGLiq_, nGLiq_, nBals_, oBals_ );

    }

}