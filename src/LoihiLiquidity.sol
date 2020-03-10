// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

pragma solidity ^0.5.15;

import "./LoihiRoot.sol";
import "./LoihiDelegators.sol";

contract LoihiLiquidity is LoihiRoot, LoihiDelegators {

    /// @author james foley http://github.com/realisation
    /// @dev this function is used in selective deposits and selective withdraws
    /// @dev it finds the reserves corresponding to the flavors and attributes the amounts to these reserves
    /// @param _flvrs the addresses of the stablecoin flavor
    /// @param _amts the specified amount of each stablecoin flavor
    /// @return three arrays each the length of the number of reserves containing the balances, token amounts and weights for each reserve
    function getBalancesTokenAmountsAndWeights (address[] memory _flvrs, uint256[] memory _amts) private returns (uint256[] memory, uint256[] memory, uint256[] memory) {

        uint256[] memory balances_ = new uint256[](reserves.length);
        uint256[] memory tokenAmounts_ = new uint256[](reserves.length);
        uint256[] memory weights_ = new uint[](reserves.length);

        emit log_uints("amts", _amts);
        emit log_addrs("flvrs", _flvrs);

        for (uint i = 0; i < _flvrs.length; i++) {

            Flavor memory _f = flavors[_flvrs[i]]; // withdrawing adapter + weight
            require(_f.adapter != address(0), "flavor not supported");

            for (uint j = 0; j < reserves.length; j++) {
                if (balances_[j] == 0) {
                    balances_[j] = dGetNumeraireBalance(reserves[j]);
                    weights_[j] = weights[j];
                }
                if (reserves[j] == _f.reserve && _amts[i] > 0) tokenAmounts_[j] += dGetNumeraireAmount(_f.adapter, _amts[i]);
            }

        }

        return (balances_, tokenAmounts_, weights_);

    }

    event log_addrs(bytes32, address[]);

    /// @author james foley http://github.com/realisation
    /// @notice this function allows selective depositing of any supported stablecoin flavor into the contract in return for corresponding shell tokens
    /// @param _flvrs an array containing the addresses of the flavors being deposited into
    /// @param _amts an array containing the values of the flavors you wish to deposit into the contract. each amount should have the same index as the flavor it is meant to deposit
    /// @return shellsToMint_ the amount of shells to mint for the deposited stablecoin flavors
    function selectiveDeposit (address[] calldata _flvrs, uint256[] calldata _amts, uint256 _minShells, uint256 _deadline) external returns (uint256 shellsToMint_) {
        require(_deadline >= now, "deadline has passed for this transaction");

        ( uint256[] memory _balances,
          uint256[] memory _deposits,
          uint256[] memory _weights ) = getBalancesTokenAmountsAndWeights(_flvrs, _amts);

          emit log_uints("balances", _balances);
          emit log_uints("deposits", _deposits);
          emit log_uints("weights", _weights);

        shellsToMint_ = calculateShellsToMint(_balances, _deposits);

        require(shellsToMint_ >= _minShells, "minted shells less than minimum shells");

        _mint(msg.sender, shellsToMint_);

        for (uint i = 0; i < _flvrs.length; i++) if (_amts[i] > 0) dIntakeRaw(flavors[_flvrs[i]].adapter, _amts[i]);

        emit ShellsMinted(msg.sender, shellsToMint_, _flvrs, _amts);

        return shellsToMint_;

    }

    /// @author james foley http://github.com/realisation
    /// @notice this function calculates the amount of shells to mint by taking the balances, numeraire deposits and weights of the reserve tokens being deposited into
    /// @dev each array is the same length. each index in each array refers to the same reserve - index 0 is for the reserve token at index 0 in the reserves array, index 1 is for the reserve token at index 1 in the reserve array and so forth.
    /// @param _balances an array of current numeraire balances for each reserve
    /// @param _deposits an array of numeraire amounts to deposit into each reserve
    // / @param _weights an array of the balance weights for each of the reserves
    /// @return shellsToMint_ the amount of shell tokens to mint according to the dynamic fee relative to the balance of each reserve deposited into
    function calculateShellsToMint (uint256[] memory _balances, uint256[] memory _deposits) private returns (uint256) {

        uint256 shellsToMint_;

        uint256 _newSum;
        uint256 _oldSum;
        for (uint i = 0; i < _balances.length; i++) {
            _oldSum = add(_oldSum, _balances[i]);
            _newSum = add(_newSum, add(_balances[i], _deposits[i]));
        }

        for (uint i = 0; i < _balances.length; i++) {
            uint256 _oBal = _balances[i];
            uint256 _nBal = add(_oBal, _deposits[i]);

            require(_nBal <= wmul(weights[i], wmul(_newSum, WAD + alpha)), "deposit upper halt check");
            require(_nBal >= wmul(weights[i], wmul(_newSum, WAD - alpha)), "deposit lower halt check");

            uint256 threshold;
            uint256 _oFee;
            uint256 _nFee;

            emit log_uint("~~~~~~~ i ~~~~~~~", i);

            if (_oBal < (threshold = wmul(weights[i], wmul(_oldSum, WAD-beta)))) {
                _oFee = wdiv(feeDerivative, wmul(_oldSum, weights[i]));
                _oFee = wmul(_oFee, sub(threshold, _oBal));
                _oFee = wmul(_oFee, sub(threshold, _oBal));
                emit log_uint("dep old lower threshold fee", _oFee);
            } else if (_oBal > (threshold = wmul(weights[i], wmul(_oldSum, WAD+beta)))) {
                _oFee = wdiv(feeDerivative, wmul(_oldSum, weights[i]));
                _oFee = wmul(_oFee, sub(_oBal, threshold));
                _oFee = wmul(_oFee, sub(_oBal, threshold));
                emit log_uint("dep old upper threshold fee", _oFee);
            } else _oFee = 0;

            if (_nBal < (threshold = wmul(weights[i], wmul(_newSum, WAD-beta)))) {
                _nFee = wdiv(feeDerivative, wmul(_newSum, weights[i]));
                _nFee = wmul(_nFee, sub(threshold, _nBal));
                _nFee = wmul(_nFee, sub(threshold, _nBal));
                emit log_uint("dep lower threshold fee", _nFee);
            } else if (_nBal > (threshold = wmul(weights[i], wmul(_newSum, WAD+beta)))) {
                _nFee = wdiv(feeDerivative, wmul(_newSum, weights[i]));
                _nFee = wmul(_nFee, sub(_nBal, threshold));
                _nFee = wmul(_nFee, sub(_nBal, threshold));
                emit log_uint("dep upper threshold fee", _nFee);
            } else _nFee = 0;

            if (_oFee > _nFee) {
                shellsToMint_ += add(_deposits[i], wmul(arbPiece, sub(_oFee, _nFee)));
                emit log_uint("_oFee > _nFee", shellsToMint_);
            } else if (_oFee + _deposits[i] > _nFee) {
                shellsToMint_ += sub(add(_oFee, _deposits[i]), _nFee);
                emit log_uint("_oFee + deposits > _nFee", shellsToMint_);
            }
            else {
                emit log_uint("_nFee", _nFee);
                emit log_uint("_oFee", _oFee);
                emit log_uint("deposits[i]", _deposits[i]);
                uint256 assessed = sub(_nFee, add(_oFee, _deposits[i]));
                shellsToMint_ = sub(shellsToMint_, assessed);
                emit log_uint("else", shellsToMint_);
            }

            emit log_uint("_______ i _______", i);

            // if (_oFee == _nFee) shellsToMint_ += _deposits[i];
            // else if (_oFee > _nFee) shellsToMint_ += add(_deposits[i], wmul(arbPiece, sub(_oFee, _nFee)));
            // else if (_nFee < _oFee + _deposits[i]) shellsToMint_ += sub(add(_deposits[i], _oFee), _nFee);
            // else if (_nFee > _oFee + _deposits[i]) shellsToMint_ -= sub(_nFee, add(_deposits[i], _oFee));

        }

        emit log_uint("Shells to mint", shellsToMint_);
        
        return shellsToMint_;

    }

    /// @author james foley http://github.com/realisation
    /// @notice this function allows selective the withdrawal of any supported stablecoin flavor from the contract by burning a corresponding amount of shell tokens
    /// @param _flvrs an array of flavors to withdraw from the reserves
    /// @param _amts an array of amounts to withdraw that maps to _flavors
    /// @return shellsBurned_ the corresponding amount of shell tokens to withdraw the specified amount of specified flavors
    function selectiveWithdraw (address[] calldata _flvrs, uint256[] calldata _amts, uint256 _maxShells, uint256 _deadline) external returns (uint256 shellsBurned_) {
        require(_deadline >= now, "deadline has passed for this transaction");

        ( uint256[] memory _balances,
          uint256[] memory _withdrawals,
          uint256[] memory _weights ) = getBalancesTokenAmountsAndWeights(_flvrs, _amts);

        shellsBurned_ = calculateShellsToBurn(_balances, _withdrawals, _weights);

        require(shellsBurned_ <= _maxShells, "withdrawal exceeds max shells limit");
        require(shellsBurned_ <= balances[msg.sender], "withdrawal amount exceeds balance");

        for (uint i = 0; i < _flvrs.length; i++) if (_amts[i] > 0) dOutputRaw(flavors[_flvrs[i]].adapter, msg.sender, _amts[i]);

        _burn(msg.sender, shellsBurned_);

        emit ShellsBurned(msg.sender, shellsBurned_, _flvrs, _amts);

        return shellsBurned_;

    }

    event log_uints(bytes32, uint256[]);
    event log_addr(bytes32, address);

    /// @author james foley http://github.com/realisation
    /// @notice this function calculates the amount of shells to mint by taking the balances, numeraire deposits and weights of the reserve tokens being deposited into
    /// @dev each array is the same length. each index in each array refers to the same reserve - index 0 is for the reserve token at index 0 in the reserves array, index 1 is for the reserve token at index 1 in the reserve array and so forth.
    /// @param _balances an array of current numeraire balances for each reserve
    /// @param _withdrawals an array of numeraire amounts to deposit into each reserve
    /// @param _weights an array of the balance weights for each of the reserves
    /// @return shellsToBurn_ the amount of shell tokens to burn according to the dynamic fee of each withdraw relative to the balance of each reserve
    function calculateShellsToBurn (uint256[] memory _balances, uint256[] memory _withdrawals, uint256[] memory _weights) internal returns (uint256) {

        uint256 _newSum;
        uint256 _oldSum;
        for (uint i = 0; i < _balances.length; i++) {
            _oldSum = add(_oldSum, _balances[i]);
            _newSum = add(_newSum, sub(_balances[i], _withdrawals[i]));
        }

        uint256 shellsToBurn_;

        for (uint i = 0; i < _balances.length; i++) {
            uint256 _oBal = _balances[i];
            uint256 _nBal = sub(_oBal, _withdrawals[i]);
            emit log_uint("~~~~~~ i ~~~~~~", i);

            emit log_uint("_oBal", _oBal);
            emit log_uint("_nBal", _nBal);

            emit log_uint("upper halt", wmul(weights[i], wmul(_newSum, WAD + alpha)));
            emit log_uint("lower halt", wmul(weights[i], wmul(_newSum, WAD - alpha)));

            require(_nBal <= wmul(weights[i], wmul(_newSum, WAD + alpha)), "withdraw upper halt check");
            require(_nBal >= wmul(weights[i], wmul(_newSum, WAD - alpha)), "withdraw lower halt check");

            uint256 threshold;
            uint256 _oFee;
            uint256 _nFee;

            if (_oBal < (threshold = wmul(weights[i], wmul(_oldSum, WAD-beta)))) {
                _oFee = wdiv(feeDerivative, wmul(_oldSum, weights[i]));
                _oFee = wmul(_oFee, sub(threshold, _oBal));
                _oFee = wmul(_oFee, sub(threshold, _oBal));
                emit log_uint("old lower threshold fee", _oFee);
            } else if (_oBal > (threshold = wmul(weights[i], wmul(_oldSum, WAD+beta)))) {
                _oFee = wdiv(feeDerivative, wmul(_oldSum, weights[i]));
                _oFee = wmul(_oFee, sub(_oBal, threshold));
                _oFee = wmul(_oFee, sub(_oBal, threshold));
                emit log_uint("old upper threshold fee", _oFee);
            } else _oFee = 0;

            if (_nBal < (threshold = wmul(weights[i], wmul(_newSum, WAD-beta)))) {
                _nFee = wdiv(feeDerivative, wmul(_newSum, weights[i]));
                _nFee = wmul(_nFee, sub(threshold, _nBal));
                _nFee = wmul(_nFee, sub(threshold, _nBal));
                emit log_uint("new lower threshold fee", _nFee);
            } else if (_nBal > (threshold = wmul(weights[i], wmul(_newSum, WAD+beta)))) {
                _nFee = wdiv(feeDerivative, wmul(_newSum, weights[i]));
                _nFee = wmul(_nFee, sub(_nBal, threshold));
                _nFee = wmul(_nFee, sub(_nBal, threshold));
                emit log_uint("new upper threshold fee", _nFee);
            } else _nFee = 0;

            emit log_uint("_nFee", _nFee);
            emit log_uint("_0Fee", _oFee);

            if (_nFee > _oFee) {
                shellsToBurn_ += add(_withdrawals[i], sub(_nFee, _oFee));
                emit log_uint("burn _nFee > _oFee", shellsToBurn_);
            } else {
                shellsToBurn_ += add(_withdrawals[i], wmul(arbPiece, _nFee));
                shellsToBurn_ -= wmul(_oFee, arbPiece);
                emit log_uint("burn else", shellsToBurn_);
            }

            emit log_uint("_______ i ______", i);


        }

        emit log_uint("shellsToBurn)", shellsToBurn_);
        return wmul(shellsToBurn_, WAD + feeBase);

    }

    function getFees (uint256 _bal, uint256 _sum, uint256 _weight) public returns (uint256 _oFee, uint256 _nFee) {
        
    }

    event log_uint(bytes32, uint256);

    /// @author james foley http://github.com/realisation
    /// @notice this function takes a total amount to deposit into the pool with no slippage from the numeraire assets the pool supports
    /// @param _deposit the full amount you want to deposit into the pool which will be divided up evenly amongst the numeraire assets of the pool
    /// @return shellsToMint_ the amount of shells you receive in return for your deposit
    function proportionalDeposit (uint256 _deposit) public returns (uint256) {

        uint256[] memory _amounts = new uint256[](numeraires.length);

        for (uint i = 0; i < reserves.length; i++) {
            Flavor memory _f = flavors[numeraires[i]];
            _amounts[i] = dIntakeNumeraire(_f.adapter, wmul(_f.weight, _deposit));
        }

        emit ShellsMinted(msg.sender, _deposit, numeraires, _amounts);

        _mint(msg.sender, _deposit);

        return _deposit;

    }

    /// @author james foley http://github.com/realisation
    /// @notice this function takes a total amount to from the the pool with no slippage from the numeraire assets of the pool
    /// @param _withdrawal the full amount you want to withdraw from the pool which will be withdrawn from evenly amongst the numeraire assets of the pool
    /// @return withdrawnAmts_ the amount withdrawn from each of the numeraire assets
    function proportionalWithdraw (uint256 _withdrawal) public returns (uint256[] memory) {

        require(_withdrawal <= balances[msg.sender], "withdrawal amount exceeds your balance");

        uint256 _withdrawMultiplier = wdiv(_withdrawal, totalSupply);

        _burn(msg.sender, _withdrawal);

        uint256[] memory withdrawalAmts_ = new uint256[](reserves.length);
        for (uint i = 0; i < reserves.length; i++) {
            uint256 _proportionateValue = wmul(
                wmul(dGetNumeraireBalance(reserves[i]), _withdrawMultiplier),
                WAD - feeBase
            );
            Flavor memory _f = flavors[numeraires[i]];
            withdrawalAmts_[i] = dOutputNumeraire(_f.adapter, msg.sender, _proportionateValue);
        }

        emit ShellsBurned(msg.sender, _withdrawal, numeraires, withdrawalAmts_);

        return withdrawalAmts_;

    }


    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");
        balances[account] = sub(balances[account], amount);
        totalSupply = sub(totalSupply, amount);
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");
        totalSupply = add(totalSupply, amount);
        balances[account] = add(balances[account], amount);
    }

}