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

        for (uint i = 0; i < _flvrs.length; i++) {

            Flavor memory _f = flavors[_flvrs[i]]; // withdrawing adapter + weight
            require(_f.adapter != address(0), "flavor not supported");

            for (uint j = 0; j < reserves.length; j++) {
                if (balances_[j] == 0) balances_[j] = dGetNumeraireBalance(reserves[j]);
                if (reserves[j] == _f.reserve && _amts[i] > 0) {
                    tokenAmounts_[j] += dGetNumeraireAmount(_f.adapter, _amts[i]);
                    weights_[j] = _f.weight;
                }
            }

        }

        return (balances_, tokenAmounts_, weights_);

    }

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

        shellsToMint_ = calculateShellsToMint(_balances, _deposits, _weights);

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
    /// @param _weights an array of the balance weights for each of the reserves
    /// @return shellsToMint_ the amount of shell tokens to mint according to the dynamic fee relative to the balance of each reserve deposited into
    function calculateShellsToMint (uint256[] memory _balances, uint256[] memory _deposits, uint256[] memory _weights) private returns (uint256) {

        uint256 _newSum;
        uint256 _oldSum;
        for (uint i = 0; i < _balances.length; i++) {
            _oldSum = add(_oldSum, _balances[i]);
            _newSum = add(_newSum, add(_balances[i], _deposits[i]));
        }

        uint256 shellsToMint_;

        for (uint i = 0; i < _balances.length; i++) {
            if (_deposits[i] == 0) continue;
            uint256 _depositAmount = _deposits[i];
            uint256 _weight = _weights[i];
            uint256 _oldBalance = _balances[i];
            uint256 _newBalance = add(_oldBalance, _depositAmount);

            require(_newBalance <= wmul(_weight, wmul(_newSum, alpha + WAD)), "halt check deposit");

            uint256 _feeThreshold = wmul(_weight, wmul(_newSum, beta + WAD));
            if (_newBalance <= _feeThreshold) {

                shellsToMint_ += _depositAmount;

            } else if (_oldBalance >= _feeThreshold) {

                uint256 _feePrep = wmul(feeDerivative, wdiv(
                    sub(_newBalance, _feeThreshold),
                    wmul(_weight, _newSum)
                ));

                shellsToMint_ = add(shellsToMint_, wmul(_depositAmount, WAD - _feePrep));

            } else {

                uint256 _feePrep = wmul(feeDerivative, wdiv(
                    sub(_newBalance, _feeThreshold),
                    wmul(_weight, _newSum)
                ));

                shellsToMint_ += add(
                    sub(_feeThreshold, _oldBalance),
                    wmul(sub(_newBalance, _feeThreshold), WAD - _feePrep)
                );

            }
        }

        if (totalSupply == 0) return shellsToMint_;
        else return wmul(totalSupply, wdiv(shellsToMint_, _oldSum));

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

        uint256 _numeraireShellsToBurn;

        for (uint i = 0; i < reserves.length; i++) {
            if (_withdrawals[i] == 0) continue;
            uint256 _withdrawal = _withdrawals[i];
            uint256 _weight = _weights[i];
            uint256 _oldBal = _balances[i];
            uint256 _newBal = sub(_oldBal, _withdrawal);

            require(_newBal >= wmul(_weight, wmul(_newSum, WAD - alpha)), "withdraw halt check");

            uint256 _feeThreshold = wmul(_weight, wmul(_newSum, WAD - beta));

            if (_newBal >= _feeThreshold) {

                _numeraireShellsToBurn += wmul(_withdrawal, WAD + feeBase);

            } else if (_oldBal <= _feeThreshold) {

                uint256 _feePrep = wdiv(sub(_feeThreshold, _newBal), wmul(_weight, _newSum));

                _feePrep = wmul(_feePrep, feeDerivative);

                _numeraireShellsToBurn += wmul(wmul(_withdrawal, WAD + _feePrep), WAD + feeBase);

            } else {

                uint256 _feePrep = wdiv(sub(_feeThreshold, _newBal), wmul(_weight, _newSum));

                _feePrep = wmul(feeDerivative, _feePrep);

                _numeraireShellsToBurn += wmul(add(
                    sub(_oldBal, _feeThreshold),
                    wmul(sub(_feeThreshold, _newBal), WAD + _feePrep)
                ), WAD + feeBase);

            }
        }

        return wmul(totalSupply, wdiv(_numeraireShellsToBurn, _oldSum));

    }

    /// @author james foley http://github.com/realisation
    /// @notice this function takes a total amount to deposit into the pool with no slippage from the numeraire assets the pool supports
    /// @param _deposit the full amount you want to deposit into the pool which will be divided up evenly amongst the numeraire assets of the pool
    /// @return shellsToMint_ the amount of shells you receive in return for your deposit
    function proportionalDeposit (uint256 _deposit) public returns (uint256) {

        uint256 _totalBalance;
        uint256 _totalSupply = totalSupply;

        uint256[] memory _amounts = new uint256[](numeraires.length);

        if (_totalSupply == 0) {

            for (uint i = 0; i < reserves.length; i++) {
                Flavor memory _f = flavors[numeraires[i]];
                _amounts[i] = dIntakeNumeraire(_f.adapter, wmul(_f.weight, _deposit));
            }

            emit ShellsMinted(msg.sender, _deposit, numeraires, _amounts);

            _mint(msg.sender, _deposit);

            return _deposit;

        } else {

            for (uint i = 0; i < reserves.length; i++) {
                Flavor memory _f = flavors[numeraires[i]];
                _amounts[i] = wmul(_f.weight, _deposit);
                _totalBalance += dGetNumeraireBalance(reserves[i]);
            }

            uint256 shellsToMint_ = wmul(_totalSupply, wdiv(_deposit, _totalBalance));

            _mint(msg.sender, shellsToMint_);

            for (uint i = 0; i < reserves.length; i++) {
                Flavor memory d = flavors[numeraires[i]];
                _amounts[i] = dIntakeNumeraire(d.adapter, _amounts[i]);
            }

            emit ShellsMinted(msg.sender, shellsToMint_, numeraires, _amounts);

            return shellsToMint_;
        }

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
            uint256 amount = dGetNumeraireBalance(reserves[i]);
            uint256 proportionateValue = wmul(wmul(amount, _withdrawMultiplier), WAD - feeBase);
            Flavor memory _f = flavors[numeraires[i]];
            withdrawalAmts_[i] = dOutputNumeraire(_f.adapter, msg.sender, proportionateValue);
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