pragma solidity ^0.5.0;

import "./Assimilators.sol";

import "./Loihi.sol";

import "./UnsafeMath64x64.sol";

library ProportionalLiquidity {

    using ABDKMath64x64 for uint;
    using ABDKMath64x64 for int128;
    using UnsafeMath64x64 for int128;

    event Transfer(address indexed from, address indexed to, uint256 value);

    int128 constant ONE = 0x10000000000000000;

    // / @author james foley http://github.com/realisation
    // / @notice deposit into the pool with no slippage from the numeraire assets the pool supports
    // / @param  _deposit the full amount you want to deposit into the pool which will be divided up evenly amongst the numeraire assets of the pool
    // / @return shells_ the amount of shells you receive in return for your deposit
    // / @return deposits_ the amount deposited per stablecoin according to the current balances in the pool
    function proportionalDeposit (
        Loihi.Shell storage shell,
        uint256 _deposit
    ) internal returns (
        uint256 shells_,
        uint[] memory
    ) {

        int128 _shells = _deposit.divu(1e18);

        int128 _oGLiq;

        uint _length = shell.reserves.length;

        int128[] memory _oBals = new int128[](_length);

        uint[] memory deposits_ = new uint[](_length);

        for (uint i = 0; i < _length; i++) {

            int128 _bal = Assimilators.viewNumeraireBalance(shell.reserves[i].addr);

            _oBals[i] = _bal;
            _oGLiq += _bal;

        }

        if (_oGLiq == 0) {

            for (uint8 i = 0; i < _length; i++) {

                deposits_[i] = Assimilators.intakeNumeraire(shell.numeraires[i].addr, _shells.mul(shell.weights[i]));

            }

        } else {

            int128 _multiplier = _shells.div(_oGLiq);

            for (uint8 i = 0; i < _length; i++) {

                deposits_[i] = Assimilators.intakeNumeraire(shell.numeraires[i].addr, _oBals[i].mul(_multiplier));

            }

            shell.omega = shell.omega.mul(ONE.add(_multiplier));

        }

        if (shell.totalSupply > 0) _shells = _shells.div(_oGLiq).mul(shell.totalSupply.divu(1e18));

        mint(shell, msg.sender, shells_ = _shells.mulu(1e18));

        return (shells_, deposits_);

    }

    function viewProportionalDeposit (
        Loihi.Shell storage shell,
        uint256 _deposit
    ) internal view returns (
        uint shells_,
        uint[] memory
    ) {

        int128 _shells = _deposit.divu(1e18);

        int128 _oGLiq;

        uint _length = shell.reserves.length;

        int128[] memory _oBals = new int128[](_length);

        uint[] memory deposits_ = new uint[](_length);

        for (uint i = 0; i < _length; i++) {

            int128 _bal = Assimilators.viewNumeraireBalance(shell.reserves[i].addr);

            _oBals[i] = _bal;
            _oGLiq += _bal;

        }

        if (_oGLiq == 0) {

            for (uint8 i = 0; i < _length; i++) {

                deposits_[i] = Assimilators.viewRawAmount(shell.numeraires[i].addr, _shells.mul(shell.weights[i]));

            }

        } else {

            int128 _multiplier = _shells.div(_oGLiq);

            for (uint8 i = 0; i < _length; i++) {

                deposits_[i] = Assimilators.viewRawAmount(shell.numeraires[i].addr, _oBals[i].mul(_multiplier));

            }

        }

        shells_ = _shells.mulu(1e18);

        return ( shells_, deposits_ );

    }



    // / @author  james foley http://github.com/realisation
    // / @notice  withdrawas amount of shell tokens from the the pool equally from the numeraire assets of the pool with no slippage
    // / @param   _withdrawal the full amount you want to withdraw from the pool which will be withdrawn from evenly amongst the numeraire assets of the pool
    function proportionalWithdraw (
        Loihi.Shell storage shell,
        uint256 _withdrawal
    ) internal returns (
        uint[] memory
    ) {

        uint _length = shell.reserves.length;

        int128 _oGLiq;
        int128[] memory _oBals = new int128[](_length);

        uint[] memory withdrawals_ = new uint[](_length);

        for (uint i = 0; i < _length; i++) {

            int128 _bal = Assimilators.viewNumeraireBalance(shell.reserves[i].addr);

            _oGLiq += _bal;
            _oBals[i] = _bal;

        }

        int128 _multiplier = _withdrawal.divu(1e18)
            .mul(ONE.sub(shell.epsilon))
            .div(shell.totalSupply.divu(1e18));

        for (uint8 i = 0; i < _length; i++) {

            withdrawals_[i] = Assimilators.outputNumeraire(shell.reserves[i].addr, msg.sender, _oBals[i].mul(_multiplier));

        }

        shell.omega = shell.omega.mul(ONE.sub(_multiplier));

        burn(shell, msg.sender, _withdrawal);

        return withdrawals_;

    }

    // / @author  james foley http://github.com/realisation
    // / @notice  withdrawas amount of shell tokens from the the pool equally from the numeraire assets of the pool with no slippage
    // / @param   _withdrawal the full amount you want to withdraw from the pool which will be withdrawn from evenly amongst the numeraire assets of the pool
    function viewProportionalWithdraw (
        Loihi.Shell storage shell,
        uint256 _withdrawal
    ) internal view returns (
        uint[] memory
    ) {

        uint _length = shell.reserves.length;

        int128 _oGLiq;
        int128[] memory _oBals = new int128[](_length);

        uint[] memory withdrawals_ = new uint[](_length);

        for (uint i = 0; i < _length; i++) {

            int128 _bal = Assimilators.viewNumeraireBalance(shell.reserves[i].addr);

            _oGLiq += _bal;
            _oBals[i] = _bal;

        }

        int128 _multiplier = _withdrawal.divu(1e18)
            .mul(ONE.sub(shell.epsilon))
            .div(shell.totalSupply.divu(1e18));

        for (uint8 i = 0; i < _length; i++) {

            withdrawals_[i] = Assimilators.viewRawAmount(shell.reserves[i].addr, _oBals[i].mul(_multiplier));

        }

        return withdrawals_;

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