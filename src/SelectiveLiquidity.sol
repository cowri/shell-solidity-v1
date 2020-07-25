pragma solidity ^0.5.0;

import "./Assimilators.sol";

import "./Loihi.sol";

import "./ShellMath.sol";

import "./UnsafeMath64x64.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";


library SelectiveLiquidity {

    using ABDKMath64x64 for int128;
    using UnsafeMath64x64 for int128;

    event Transfer(address indexed from, address indexed to, uint256 value);

    int128 constant ONE = 0x10000000000000000;

    function getLiquidityData (
        Loihi.Shell storage shell,
        address[] memory _flvrs,
        address _rcpnt,
        uint[] memory _amts,
        bool _isDeposit
    ) private returns (
        int128 oGLiq_,
        int128 nGLiq_,
        int128[] memory,
        int128[] memory
    ) {

        uint _length = shell.weights.length;
        int128[] memory oBals_ = new int128[](_length);
        int128[] memory nBals_ = new int128[](_length);

        for (uint i = 0; i < _flvrs.length; i++) {

            Loihi.Assimilator memory _assim = shell.assimilators[_flvrs[i]];

            require(_assim.addr != address(0), "Shell/unsupported-derivative");

            if ( nBals_[_assim.ix] == 0 && oBals_[_assim.ix] == 0 ) {

                int128 _amount; int128 _balance;

                if (_isDeposit) ( _amount, _balance ) = Assimilators.intakeRawAndGetBalance(_assim.addr, _amts[i]);
                else ( _amount, _balance ) = Assimilators.outputRawAndGetBalance(_assim.addr, _rcpnt, _amts[i]);

                nBals_[_assim.ix] = _balance;
                oBals_[_assim.ix] = _balance.sub(_amount);

            } else {

                int128 _amount;

                if (_isDeposit) _amount = Assimilators.intakeRaw(_assim.addr, _amts[i]);
                else _amount = Assimilators.outputRaw(_assim.addr, _rcpnt, _amts[i]);

                nBals_[_assim.ix] = nBals_[_assim.ix].sub(_amount);

            }

        }

        for (uint i = 0; i < _length; i++) {

            if (oBals_[i] == 0 && nBals_[i] == 0) nBals_[i] = oBals_[i] = Assimilators.viewNumeraireBalance(shell.reserves[i].addr);

            oGLiq_ += oBals_[i];
            nGLiq_ += nBals_[i];

        }

        return ( oGLiq_, nGLiq_, oBals_, nBals_ );

    }

    function viewLiquidityData (
        Loihi.Shell storage shell,
        address[] memory _flvrs,
        uint[] memory _amts,
        bool _isDeposit
    ) private view returns (
        int128 oGLiq_,
        int128 nGLiq_,
        int128[] memory,
        int128[] memory
    ) {

        uint _length = shell.reserves.length;
        int128[] memory oBals_ = new int128[](_length);
        int128[] memory nBals_ = new int128[](_length);

        for (uint i = 0; i < _flvrs.length; i++) {

            Loihi.Assimilator memory _assim = shell.assimilators[_flvrs[i]];

            require(_assim.addr != address(0), "Shell/unsupported-derivative");

            if ( nBals_[_assim.ix] == 0 && oBals_[_assim.ix] == 0 ) {

                ( int128 _amount, int128 _balance ) = Assimilators.viewNumeraireAmountAndBalance(_assim.addr, _amts[i]);
                if (!_isDeposit) _amount = _amount.neg();
                nBals_[_assim.ix] = _balance.add(_amount);
                oBals_[_assim.ix] = _balance;

            } else {

                int128 _amount = Assimilators.viewNumeraireAmount(_assim.addr, _amts[i]);
                if (!_isDeposit) _amount = _amount.neg();

                nBals_[_assim.ix] = nBals_[_assim.ix].sub(_amount);

            }

        }

        for (uint i = 0; i < _length; i++) {

            if (oBals_[i] == 0 && nBals_[i] == 0) nBals_[i] = oBals_[i] = Assimilators.viewNumeraireBalance(shell.reserves[i].addr);

            oGLiq_ += oBals_[i];
            nGLiq_ += nBals_[i];

        }

        return ( oGLiq_, nGLiq_, oBals_, nBals_ );

    }

    // / @author james foley http://github.com/realisation
    // / @notice selectively deposit any supported stablecoin flavor into the contract in return for corresponding amount of shell tokens
    // / @param _flvrs an array containing the addresses of the flavors being deposited into
    // / @param _amts an array containing the values of the flavors you wish to deposit into the contract. each amount should have the same index as the flavor it is meant to deposit
    // / @param _minShells minimum acceptable amount of shells
    // / @param _dline deadline for tx
    // / @return shellsToMint_ the amount of shells to mint for the deposited stablecoin flavors
    function selectiveDeposit (
        Loihi.Shell storage shell,
        address[] calldata _flvrs,
        uint[] calldata _amts,
        uint _minShells
    ) external returns (
        uint shells_
    ) {

        (   int128 _oGLiq,
            int128 _nGLiq,
            int128[] memory _oBals,
            int128[] memory _nBals ) = getLiquidityData(shell, _flvrs, address(0), _amts, true);

        int128 _shells;
        ( _shells, shell.omega ) = ShellMath.calculateLiquidityMembrane(shell, _oGLiq, _nGLiq, _oBals, _nBals);

        shells_ = _shells.mulu(1e18);

        require(_minShells < shells_, "Shell/under-minimum-shells");

        mint(shell, msg.sender, shells_);

    }

    // / @author james folew http://github.com/realisation
    // / @notice view how many shell tokens a deposit will mint
    // / @param _flvrs an array containing the addresses of the flavors being deposited into
    // / @param _amts an array containing the values of the flavors you wish to deposit into the contract. each amount should have the same index as the flavor it is meant to deposit
    // / @return shellsToMint_ the amount of shells to mint for the deposited stablecoin flavors
    function viewSelectiveDeposit (
        Loihi.Shell storage shell,
        address[] calldata _flvrs,
        uint[] calldata _amts
    ) external view returns (
        uint shells_
    ) {

        (   int128 _oGLiq,
            int128 _nGLiq,
            int128[] memory _oBals,
            int128[] memory _nBals ) = viewLiquidityData(shell, _flvrs, _amts, true);

        ( int128 _shells, ) = ShellMath.calculateLiquidityMembrane(shell, _oGLiq, _nGLiq, _oBals, _nBals);

        shells_ = _shells.mulu(1e18);

    }


    // / @author james foley http://github.com/realisation
    // / @notice selectively withdrawal any supported stablecoin flavor from the contract by burning a corresponding amount of shell tokens
    // / @param _flvrs an array of flavors to withdraw from the reserves
    // / @param _amts an array of amounts to withdraw that maps to _flavors
    // / @return shellsBurned_ the corresponding amount of shell tokens to withdraw the specified amount of specified flavors
    function selectiveWithdraw (
        Loihi.Shell storage shell,
        address[] calldata _flvrs,
        uint[] calldata _amts,
        uint _maxShells
    ) external returns (
        uint256 shells_
    ) {

        (   int128 _oGLiq,
            int128 _nGLiq,
            int128[] memory _oBals,
            int128[] memory _nBals ) = getLiquidityData(shell, _flvrs, msg.sender, _amts, false);

        int128 _shells;

        ( _shells, shell.omega ) = ShellMath.calculateLiquidityMembrane(shell, _oGLiq, _nGLiq, _oBals, _nBals);

        _shells = _shells.abs().us_mul(ONE + shell.epsilon);

        shells_ = _shells.mulu(1e18);

        require(shells_ < _maxShells, "Shell/above-maximum-shells");

        burn(shell, msg.sender, shells_);

    }

    // / @author james foley http://github.com/realisation
    // / @notice view how many shell tokens a withdraw will consume
    // / @param _flvrs an array of flavors to withdraw from the reserves
    // / @param _amts an array of amounts to withdraw that maps to _flavors
    // / @return shellsBurned_ the corresponding amount of shell tokens to withdraw the specified amount of specified flavors
    function viewSelectiveWithdraw (
        Loihi.Shell storage shell,
        address[] calldata _flvrs,
        uint[] calldata _amts
    ) external view returns (
        uint shells_
    ) {

        (   int128 _oGLiq,
            int128 _nGLiq,
            int128[] memory _oBals,
            int128[] memory _nBals ) = viewLiquidityData(shell, _flvrs, _amts, false);

        ( int128 _shells, ) = ShellMath.calculateLiquidityMembrane(shell, _oGLiq, _nGLiq, _oBals, _nBals);

        _shells = _shells.abs().us_mul(ONE + shell.epsilon);

        shells_ = _shells.mulu(1e18);

    }

    function burn (Loihi.Shell storage shell, address account, uint256 amount) private {

        shell.balances[account] = burn_sub(shell.balances[account], amount);

        shell.totalSupply = burn_sub(shell.totalSupply, amount);

        emit Transfer(msg.sender, address(0), amount);

    }

    function mint (Loihi.Shell storage shell, address account, uint256 amount) private {

        shell.totalSupply = mint_add(shell.totalSupply, amount);

        shell.balances[account] = mint_add(shell.balances[account], amount);

        emit Transfer(address(0), msg.sender, amount);

    }

    function mint_add(uint x, uint y) private pure returns (uint z) {
        require((z = x + y) >= x, "Shell/mint-overflow");
    }

    function burn_sub(uint x, uint y) private pure returns (uint z) {
        require((z = x - y) <= x, "Shell/burn-underflow");
    }

}