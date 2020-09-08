pragma solidity ^0.5.0;

import "./Assimilators.sol";

import "./LoihiStorage.sol";

import "./UnsafeMath64x64.sol";

library ProportionalLiquidity {

    using ABDKMath64x64 for uint;
    using ABDKMath64x64 for int128;
    using UnsafeMath64x64 for int128;

    event Transfer(address indexed from, address indexed to, uint256 value);

    int128 constant ONE = 0x10000000000000000;

    function proportionalDeposit (
        LoihiStorage.Shell storage shell,
        uint256 _deposit
    ) external returns (
        uint256 shells_,
        uint[] memory
    ) {

        int128 _shells = _deposit.divu(1e18);

        int128 _oGLiq;

        uint _length = shell.assetAssimilators.length;

        int128[] memory _oBals = new int128[](_length);

        uint[] memory deposits_ = new uint[](_length);

        for (uint i = 0; i < _length; i++) {

            int128 _bal = Assimilators.viewNumeraireBalance(shell.assetAssimilators[i].addr);

            _oBals[i] = _bal;
            _oGLiq += _bal;

        }

        if (_oGLiq == 0) {

            for (uint8 i = 0; i < _length; i++) {

                deposits_[i] = Assimilators.intakeNumeraire(shell.assetAssimilators[i].addr, _shells.mul(shell.weights[i]));

            }

        } else {

            int128 _multiplier = _shells.div(_oGLiq);

            for (uint8 i = 0; i < _length; i++) {

                deposits_[i] = Assimilators.intakeNumeraire(shell.assetAssimilators[i].addr, _oBals[i].mul(_multiplier));

            }

            shell.omega = shell.omega.mul(ONE.add(_multiplier));

        }

        if (shell.totalSupply > 0) _shells = _shells.div(_oGLiq).mul(shell.totalSupply.divu(1e18));

        mint(shell, msg.sender, shells_ = _shells.mulu(1e18));

        return (shells_, deposits_);

    }

    function viewProportionalDeposit (
        LoihiStorage.Shell storage shell,
        uint256 _deposit
    ) external view returns (
        uint shells_,
        uint[] memory
    ) {

        int128 _shells = _deposit.divu(1e18);

        int128 _oGLiq;

        uint _length = shell.assetAssimilators.length;

        int128[] memory _oBals = new int128[](_length);

        uint[] memory deposits_ = new uint[](_length);

        for (uint i = 0; i < _length; i++) {

            int128 _bal = Assimilators.viewNumeraireBalance(shell.assetAssimilators[i].addr);

            _oBals[i] = _bal;
            _oGLiq += _bal;

        }

        if (_oGLiq == 0) {

            for (uint8 i = 0; i < _length; i++) {

                deposits_[i] = Assimilators.viewRawAmount(shell.assetAssimilators[i].addr, _shells.mul(shell.weights[i]));

            }

        } else {

            int128 _multiplier = _shells.div(_oGLiq);

            for (uint8 i = 0; i < _length; i++) {

                deposits_[i] = Assimilators.viewRawAmount(shell.assetAssimilators[i].addr, _oBals[i].mul(_multiplier));

            }

        }

        shells_ = _shells.mulu(1e18);

        return ( shells_, deposits_ );

    }

    function proportionalWithdraw (
        LoihiStorage.Shell storage shell,
        uint256 _withdrawal
    ) external returns (
        uint[] memory
    ) {

        uint _length = shell.assetAssimilators.length;

        int128 _oGLiq;
        int128[] memory _oBals = new int128[](_length);

        uint[] memory withdrawals_ = new uint[](_length);

        for (uint i = 0; i < _length; i++) {

            int128 _bal = Assimilators.viewNumeraireBalance(shell.assetAssimilators[i].addr);

            _oGLiq += _bal;
            _oBals[i] = _bal;

        }

        int128 _multiplier = _withdrawal.divu(1e18)
            .mul(ONE.sub(shell.epsilon))
            .div(shell.totalSupply.divu(1e18));

        for (uint8 i = 0; i < _length; i++) {

            withdrawals_[i] = Assimilators.outputNumeraire(shell.assetAssimilators[i].addr, msg.sender, _oBals[i].mul(_multiplier));

        }

        shell.omega = shell.omega.mul(ONE.sub(_multiplier));

        burn(shell, msg.sender, _withdrawal);

        return withdrawals_;

    }

    function viewProportionalWithdraw (
        LoihiStorage.Shell storage shell,
        uint256 _withdrawal
    ) external view returns (
        uint[] memory
    ) {

        uint _length = shell.assetAssimilators.length;

        int128 _oGLiq;
        int128[] memory _oBals = new int128[](_length);

        uint[] memory withdrawals_ = new uint[](_length);

        for (uint i = 0; i < _length; i++) {

            int128 _bal = Assimilators.viewNumeraireBalance(shell.assetAssimilators[i].addr);

            _oGLiq += _bal;
            _oBals[i] = _bal;

        }

        int128 _multiplier = _withdrawal.divu(1e18)
            .mul(ONE.sub(shell.epsilon))
            .div(shell.totalSupply.divu(1e18));

        for (uint8 i = 0; i < _length; i++) {

            withdrawals_[i] = Assimilators.viewRawAmount(shell.assetAssimilators[i].addr, _oBals[i].mul(_multiplier));

        }

        return withdrawals_;

    }

    function burn (LoihiStorage.Shell storage shell, address account, uint256 amount) private {

        shell.balances[account] = burn_sub(shell.balances[account], amount);

        shell.totalSupply = burn_sub(shell.totalSupply, amount);

        emit Transfer(msg.sender, address(0), amount);

    }

    function mint (LoihiStorage.Shell storage shell, address account, uint256 amount) private {

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