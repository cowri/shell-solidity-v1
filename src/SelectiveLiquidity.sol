pragma solidity ^0.5.0;

import "./Assimilators.sol";

import "./ShellStorage.sol";

import "./ShellMath.sol";

import "./UnsafeMath64x64.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";


library SelectiveLiquidity {

    using ABDKMath64x64 for int128;
    using UnsafeMath64x64 for int128;

    event Transfer(address indexed from, address indexed to, uint256 value);

    int128 constant ONE = 0x10000000000000000;

    function selectiveDeposit (
        ShellStorage.Shell storage shell,
        address[] calldata _derivatives,
        uint[] calldata _amounts,
        uint _minShells
    ) external returns (
        uint shells_
    ) {

        (   int128 _oGLiq,
            int128 _nGLiq,
            int128[] memory _oBals,
            int128[] memory _nBals ) = getLiquidityDepositData(shell, _derivatives, _amounts);

        int128 _shells = ShellMath.calculateLiquidityMembrane(shell, _oGLiq, _nGLiq, _oBals, _nBals);

        shells_ = _shells.mulu(1e18);

        require(_minShells < shells_, "Shell/under-minimum-shells");

        mint(shell, msg.sender, shells_);

    }

    function viewSelectiveDeposit (
        ShellStorage.Shell storage shell,
        address[] calldata _derivatives,
        uint[] calldata _amounts
    ) external view returns (
        uint shells_
    ) {

        (   int128 _oGLiq,
            int128 _nGLiq,
            int128[] memory _oBals,
            int128[] memory _nBals ) = viewLiquidityDepositData(shell, _derivatives, _amounts);

        int128 _shells = ShellMath.calculateLiquidityMembrane(shell, _oGLiq, _nGLiq, _oBals, _nBals);

        shells_ = _shells.mulu(1e18);

    }

    function selectiveWithdraw (
        ShellStorage.Shell storage shell,
        address[] calldata _derivatives,
        uint[] calldata _amounts,
        uint _maxShells
    ) external returns (
        uint256 shells_
    ) {

        (   int128 _oGLiq,
            int128 _nGLiq,
            int128[] memory _oBals,
            int128[] memory _nBals ) = getLiquidityWithdrawData(shell, _derivatives, msg.sender, _amounts);

        int128 _shells = ShellMath.calculateLiquidityMembrane(shell, _oGLiq, _nGLiq, _oBals, _nBals);

        _shells = _shells.neg().us_mul(ONE + shell.epsilon);

        shells_ = _shells.mulu(1e18);

        require(shells_ < _maxShells, "Shell/above-maximum-shells");

        burn(shell, msg.sender, shells_);

    }

    function viewSelectiveWithdraw (
        ShellStorage.Shell storage shell,
        address[] calldata _derivatives,
        uint[] calldata _amounts
    ) external view returns (
        uint shells_
    ) {

        (   int128 _oGLiq,
            int128 _nGLiq,
            int128[] memory _oBals,
            int128[] memory _nBals ) = viewLiquidityWithdrawData(shell, _derivatives, _amounts);

        int128 _shells = ShellMath.calculateLiquidityMembrane(shell, _oGLiq, _nGLiq, _oBals, _nBals);

        _shells = _shells.neg().us_mul(ONE + shell.epsilon);

        shells_ = _shells.mulu(1e18);

    }

    function getLiquidityDepositData (
        ShellStorage.Shell storage shell,
        address[] memory _derivatives,
        uint[] memory _amounts
    ) private returns (
        int128 oGLiq_,
        int128 nGLiq_,
        int128[] memory,
        int128[] memory
    ) {

        uint _length = shell.weights.length;
        int128[] memory oBals_ = new int128[](_length);
        int128[] memory nBals_ = new int128[](_length);

        for (uint i = 0; i < _derivatives.length; i++) {

            ShellStorage.Assimilator memory _assim = shell.assimilators[_derivatives[i]];

            require(_assim.addr != address(0), "Shell/unsupported-derivative");

            if ( nBals_[_assim.ix] == 0 && 0 == oBals_[_assim.ix]) {

                ( int128 _amount, int128 _balance ) = Assimilators.intakeRawAndGetBalance(_assim.addr, _amounts[i]);

                nBals_[_assim.ix] = _balance;

                oBals_[_assim.ix] = _balance.sub(_amount);

            } else {

                int128 _amount = Assimilators.intakeRaw(_assim.addr, _amounts[i]);

                nBals_[_assim.ix] = nBals_[_assim.ix].add(_amount);

            }

        }

        return completeLiquidityData(shell, oBals_, nBals_);

    }

    function getLiquidityWithdrawData (
        ShellStorage.Shell storage shell,
        address[] memory _derivatives,
        address _rcpnt,
        uint[] memory _amounts
    ) private returns (
        int128 oGLiq_,
        int128 nGLiq_,
        int128[] memory,
        int128[] memory
    ) {

        uint _length = shell.weights.length;
        int128[] memory oBals_ = new int128[](_length);
        int128[] memory nBals_ = new int128[](_length);

        for (uint i = 0; i < _derivatives.length; i++) {

            ShellStorage.Assimilator memory _assim = shell.assimilators[_derivatives[i]];

            require(_assim.addr != address(0), "Shell/unsupported-derivative");

            if ( nBals_[_assim.ix] == 0 && 0 == oBals_[_assim.ix]) {

                ( int128 _amount, int128 _balance ) = Assimilators.outputRawAndGetBalance(_assim.addr, _rcpnt, _amounts[i]);

                nBals_[_assim.ix] = _balance;
                oBals_[_assim.ix] = _balance.sub(_amount);

            } else {

                int128 _amount = Assimilators.outputRaw(_assim.addr, _rcpnt, _amounts[i]);

                nBals_[_assim.ix] = nBals_[_assim.ix].add(_amount);

            }

        }

        return completeLiquidityData(shell, oBals_, nBals_);

    }

    function viewLiquidityDepositData (
        ShellStorage.Shell storage shell,
        address[] memory _derivatives,
        uint[] memory _amounts
    ) private view returns (
        int128 oGLiq_,
        int128 nGLiq_,
        int128[] memory,
        int128[] memory
    ) {

        uint _length = shell.assets.length;
        int128[] memory oBals_ = new int128[](_length);
        int128[] memory nBals_ = new int128[](_length);

        for (uint i = 0; i < _derivatives.length; i++) {

            ShellStorage.Assimilator memory _assim = shell.assimilators[_derivatives[i]];

            require(_assim.addr != address(0), "Shell/unsupported-derivative");

            if ( nBals_[_assim.ix] == 0 && 0 == oBals_[_assim.ix]) {

                ( int128 _amount, int128 _balance ) = Assimilators.viewNumeraireAmountAndBalance(_assim.addr, _amounts[i]);

                nBals_[_assim.ix] = _balance.add(_amount);

                oBals_[_assim.ix] = _balance;

            } else {

                int128 _amount = Assimilators.viewNumeraireAmount(_assim.addr, _amounts[i]);

                nBals_[_assim.ix] = nBals_[_assim.ix].add(_amount);

            }

        }

        return completeLiquidityData(shell, oBals_, nBals_);

    }

    function viewLiquidityWithdrawData (
        ShellStorage.Shell storage shell,
        address[] memory _derivatives,
        uint[] memory _amounts
    ) private view returns (
        int128 oGLiq_,
        int128 nGLiq_,
        int128[] memory,
        int128[] memory
    ) {

        uint _length = shell.assets.length;
        int128[] memory oBals_ = new int128[](_length);
        int128[] memory nBals_ = new int128[](_length);

        for (uint i = 0; i < _derivatives.length; i++) {

            ShellStorage.Assimilator memory _assim = shell.assimilators[_derivatives[i]];

            require(_assim.addr != address(0), "Shell/unsupported-derivative");

            if ( nBals_[_assim.ix] == 0 && 0 == oBals_[_assim.ix]) {

                ( int128 _amount, int128 _balance ) = Assimilators.viewNumeraireAmountAndBalance(_assim.addr, _amounts[i]);

                nBals_[_assim.ix] = _balance.sub(_amount);

                oBals_[_assim.ix] = _balance;

            } else {

                int128 _amount = Assimilators.viewNumeraireAmount(_assim.addr, _amounts[i]);

                nBals_[_assim.ix] = nBals_[_assim.ix].sub(_amount);

            }

        }

        return completeLiquidityData(shell, oBals_, nBals_);

    }

    function completeLiquidityData (
        ShellStorage.Shell storage shell,
        int128[] memory oBals_,
        int128[] memory nBals_
    ) private view returns (
        int128 oGLiq_,
        int128 nGLiq_,
        int128[] memory,
        int128[] memory
    ) {

        uint _length = oBals_.length;

        for (uint i = 0; i < _length; i++) {

            if (oBals_[i] == 0 && 0 == nBals_[i]) {

                nBals_[i] = oBals_[i] = Assimilators.viewNumeraireBalance(shell.assets[i].addr);
                
            }

            oGLiq_ += oBals_[i];
            nGLiq_ += nBals_[i];

        }

        return ( oGLiq_, nGLiq_, oBals_, nBals_ );

    }

    function burn (ShellStorage.Shell storage shell, address account, uint256 amount) private {

        shell.balances[account] = burn_sub(shell.balances[account], amount);

        shell.totalSupply = burn_sub(shell.totalSupply, amount);

        emit Transfer(msg.sender, address(0), amount);

    }

    function mint (ShellStorage.Shell storage shell, address account, uint256 amount) private {

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