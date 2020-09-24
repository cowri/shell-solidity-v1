pragma solidity ^0.5.0;

import "./Assimilators.sol";

import "./ShellStorage.sol";

import "./UnsafeMath64x64.sol";

import "./ShellMath.sol";


library ProportionalLiquidity {

    using ABDKMath64x64 for uint;
    using ABDKMath64x64 for int128;
    using UnsafeMath64x64 for int128;

    event Transfer(address indexed from, address indexed to, uint256 value);

    int128 constant ONE = 0x10000000000000000;
    int128 constant ONE_WEI = 0x12;

    // / @author james foley http://github.com/realisation
    // / @notice deposit into the pool with no slippage from the numeraire assets the pool supports
    // / @param  _deposit the full amount you want to deposit into the pool which will be divided up evenly amongst the numeraire assets of the pool
    // / @return shells_ the amount of shells you receive in return for your deposit
    // / @return deposits_ the amount deposited per stablecoin according to the current balances in the pool
    function proportionalDeposit (
        ShellStorage.Shell storage shell,
        uint256 _deposit
    ) internal returns (
        uint256 shells_,
        uint[] memory
    ) {

        int128 __deposit = _deposit.divu(1e18);

        uint _length = shell.assets.length;

        uint[] memory deposits_ = new uint[](_length);
        
        ( int128 _oGLiq, int128[] memory _oBals ) = getGrossLiquidityAndBalances(shell);

        if (_oGLiq == 0) {

            for (uint i = 0; i < _length; i++) {

                deposits_[i] = Assimilators.intakeNumeraire(shell.assets[i].addr, __deposit.mul(shell.weights[i]));

            }

        } else {

            int128 _multiplier = __deposit.div(_oGLiq);

            for (uint i = 0; i < _length; i++) {

                deposits_[i] = Assimilators.intakeNumeraire(shell.assets[i].addr, _oBals[i].mul(_multiplier));

            }

        }
        
        int128 _totalShells = shell.totalSupply.divu(1e18);
        
        int128 _newShells = _totalShells > 0
            ? __deposit.div(_oGLiq).mul(_totalShells)
            : __deposit;

        requireLiquidityInvariant(
            shell, 
            _totalShells,
            _newShells, 
            _oGLiq, 
            _oBals
        );        

        mint(shell, msg.sender, shells_ = _newShells.mulu(1e18));

        return (shells_, deposits_);

    }
    
    
    function viewProportionalDeposit (
        ShellStorage.Shell storage shell,
        uint256 _deposit
    ) internal view returns (
        uint shells_,
        uint[] memory
    ) {

        int128 __deposit = _deposit.divu(1e18);

        uint _length = shell.assets.length;

        ( int128 _oGLiq, int128[] memory _oBals ) = getGrossLiquidityAndBalances(shell);

        uint[] memory deposits_ = new uint[](_length);

        if (_oGLiq == 0) {

            for (uint i = 0; i < _length; i++) {

                deposits_[i] = Assimilators.viewRawAmount(shell.assets[i].addr, __deposit.mul(shell.weights[i]));

            }

        } else {

            int128 _multiplier = __deposit.div(_oGLiq);

            for (uint i = 0; i < _length; i++) {

                deposits_[i] = Assimilators.viewRawAmount(shell.assets[i].addr, _oBals[i].mul(_multiplier));

            }

        }
        
        int128 _totalShells = shell.totalSupply.divu(1e18);
        
        int128 _newShells = _totalShells > 0
            ? __deposit.div(_oGLiq).mul(_totalShells)
            : __deposit;
        
        shells_ = _newShells.mulu(1e18);

        return ( shells_, deposits_ );

    }

    // / @author  james foley http://github.com/realisation
    // / @notice  withdrawas amount of shell tokens from the the pool equally from the numeraire assets of the pool with no slippage
    // / @param   _withdrawal the full amount you want to withdraw from the pool which will be withdrawn from evenly amongst the numeraire assets of the pool
    function proportionalWithdraw (
        ShellStorage.Shell storage shell,
        uint256 _withdrawal
    ) internal returns (
        uint[] memory
    ) {

        uint _length = shell.assets.length;

        ( int128 _oGLiq, int128[] memory _oBals ) = getGrossLiquidityAndBalances(shell);

        uint[] memory withdrawals_ = new uint[](_length);
        
        int128 _totalShells = shell.totalSupply.divu(1e18);
        int128 __withdrawal = _withdrawal.divu(1e18);

        int128 _multiplier = __withdrawal
            .mul(ONE - shell.epsilon)
            .div(_totalShells);

        for (uint i = 0; i < _length; i++) {

            withdrawals_[i] = Assimilators.outputNumeraire(shell.assets[i].addr, msg.sender, _oBals[i].mul(_multiplier));

        }

        requireLiquidityInvariant(
            shell, 
            _totalShells, 
            __withdrawal.neg(), 
            _oGLiq, 
            _oBals
        );
        
        burn(shell, msg.sender, _withdrawal);

        return withdrawals_;

    }
    
    function viewProportionalWithdraw (
        ShellStorage.Shell storage shell,
        uint256 _withdrawal
    ) internal view returns (
        uint[] memory
    ) {

        uint _length = shell.assets.length;

        ( int128 _oGLiq, int128[] memory _oBals ) = getGrossLiquidityAndBalances(shell);

        uint[] memory withdrawals_ = new uint[](_length);

        int128 _multiplier = _withdrawal.divu(1e18)
            .mul(ONE - shell.epsilon)
            .div(shell.totalSupply.divu(1e18));

        for (uint i = 0; i < _length; i++) {

            withdrawals_[i] = Assimilators.viewRawAmount(shell.assets[i].addr, _oBals[i].mul(_multiplier));

        }

        return withdrawals_;

    }

    function getGrossLiquidityAndBalances (
        ShellStorage.Shell storage shell
    ) internal view returns (
        int128 grossLiquidity_,
        int128[] memory
    ) {
        
        uint _length = shell.assets.length;

        int128[] memory balances_ = new int128[](_length);
        
        for (uint i = 0; i < _length; i++) {

            int128 _bal = Assimilators.viewNumeraireBalance(shell.assets[i].addr);
            
            balances_[i] = _bal;
            grossLiquidity_ += _bal;
            
        }
        
        return (grossLiquidity_, balances_);

    }

    event log_int(bytes32, int);
    
    function requireLiquidityInvariant (
        ShellStorage.Shell storage shell,
        int128 _shells,
        int128 _newShells,
        int128 _oGLiq,
        int128[] memory _oBals
    ) private {
    
        ( int128 _nGLiq, int128[] memory _nBals ) = getGrossLiquidityAndBalances(shell);
        
        int128 _beta = shell.beta;
        int128 _delta = shell.delta;
        int128[] memory _weights = shell.weights;
        
        int128 _omega = ShellMath.calculateFee(_oGLiq, _oBals, _beta, _delta, _weights);

        int128 _psi = ShellMath.calculateFee(_nGLiq, _nBals, _beta, _delta, _weights);


        ShellMath.enforceLiquidityInvariant_no_view(_shells, _newShells, _oGLiq, _nGLiq, _omega, _psi);
        
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