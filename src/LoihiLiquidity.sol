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

pragma solidity ^0.5.0;

import "./LoihiRoot.sol";
import "./LoihiDelegators.sol";

contract LoihiLiquidity is LoihiRoot, LoihiDelegators {

    /// @dev selective the withdrawal of any supported stablecoin flavor. refer to Loihi.bin selectiveWithdraw for detailed explanation of parameters
    /// @return shellsBurned_ amount of shell tokens to withdraw the specified amount of specified flavors
    function selectiveWithdraw (address[] calldata _flvrs, uint256[] calldata _amts, uint256 _maxShells, uint256 _deadline) external returns (uint256 shellsBurned_) {
        require(_deadline >= now, "deadline has passed for this transaction");

        ( uint256[] memory _balances, uint256[] memory _withdrawals ) = getBalancesAndAmounts(_flvrs, _amts);

        shellsBurned_ = calculateShellsToBurn(_balances, _withdrawals);

        shellsBurned_ = omul(shellsBurned_, OCTOPUS+epsilon);
        
        require(shellsBurned_ <= balances[msg.sender], "withdrawal amount exceeds balance");
        require(shellsBurned_ <= _maxShells, "withdrawal exceeds max shells limit");

        for (uint i = 0; i < _flvrs.length; i++) if (_amts[i] > 0) dOutputRaw(flavors[_flvrs[i]].adapter, msg.sender, _amts[i]);

        _burn(msg.sender, shellsBurned_);

        emit ShellsBurned(msg.sender, shellsBurned_, _flvrs, _amts);

        return shellsBurned_;

    }

    /// @dev this function calculates the amount of shells to burn by taking the balances and numeraire deposits of the reserve tokens being deposited into
    /// @return shellsBurned_ the amount of shells the withdraw will burn
    function calculateShellsToBurn (uint256[] memory _balances, uint256[] memory _withdrawals) internal returns (uint256 shellsBurned_) {

        uint256 _nSum; uint256 _oSum;
        for (uint i = 0; i < _balances.length; i++) {
            _oSum += _balances[i];
            _nSum += _balances[i] = sub(_balances[i], _withdrawals[i]);
        }

        uint256 _psi;
        {
            uint256 _alpha = alpha;
            uint256[] memory _weights = weights;
            for (uint i = 0; i < _balances.length; i++) {
                uint256 _nBal = _balances[i];
                uint256 _nIdeal = omul(_nSum, _weights[i]);
                require(_nBal <= omul(_nIdeal, OCTOPUS + _alpha), "withdraw upper halt check");
                require(_nBal >= omul(_nIdeal, OCTOPUS - _alpha), "withdraw lower halt check");
                _psi += makeFee(_nBal, _nIdeal);
            }
        }

        {
            uint256 _omega = omega;
            if (_omega < _psi) {
                uint256 _oUtil = sub(_oSum, _omega);
                uint256 _nUtil = sub(_nSum, _psi);
                if (_oUtil == 0) shellsBurned_ = _nUtil;
                else shellsBurned_ = odiv(omul(sub(_oUtil, _nUtil), totalSupply), _oUtil);
            } else {
                uint256 _lambda = lambda;
                uint256 _oUtil = sub(_oSum, _omega);
                uint256 _nUtil = sub(_nSum, omul(_psi, _lambda));
                if (_oUtil == 0) shellsBurned_ = _nUtil;
                else {
                    uint256 _oUtilPrime = sub(_oSum, omul(_omega, _lambda));
                    shellsBurned_ = odiv(omul(sub(_oUtilPrime, _nUtil), totalSupply), _oUtil);
                }
            }
        }

        omega = _psi;

    }

    /// @dev selective depositing of any supported stablecoin flavor into the contract in return for corresponding shell tokens
    /// @return shellsToMint_ the amount of shells to mint for the deposited stablecoin flavors
    function selectiveDeposit (address[] calldata _flvrs, uint256[] calldata _amts, uint256 _minShells, uint256 _deadline) external returns (uint256 shellsMinted_) {
        require(_deadline >= now, "deadline has passed for this transaction");

        ( uint256[] memory _balances, uint256[] memory _deposits ) = getBalancesAndAmounts(_flvrs, _amts);

        shellsMinted_ = calculateShellsToMint(_balances, _deposits);
        shellsMinted_ = omul(shellsMinted_, OCTOPUS-epsilon);

        require(shellsMinted_ >= _minShells, "minted shells less than minimum shells");

        _mint(msg.sender, shellsMinted_);

        for (uint i = 0; i < _flvrs.length; i++) if (_amts[i] > 0) dIntakeRaw(flavors[_flvrs[i]].adapter, _amts[i]);

        emit ShellsMinted(msg.sender, shellsMinted_, _flvrs, _amts);

        return shellsMinted_;

    }

    /// @dev this function calculates the amount of shells to mint by taking the balances and numeraire deposits of the reserve tokens being deposited into
    /// @return shellsMinted_ the amount of shells the deposit will mint
    function calculateShellsToMint (uint256[] memory _balances, uint256[] memory _deposits) internal returns (uint256 shellsMinted_) {

        uint256 _nSum; uint256 _oSum;
        for (uint i = 0; i < _balances.length; i++) {
            _oSum += _balances[i];
            _nSum = add(_nSum, (_balances[i] = add(_balances[i], _deposits[i])));
        }

        require(_oSum < _nSum, "insufficient-deposit");

        uint256 _psi;
        {
            uint256 _alpha = alpha;
            uint256[] memory _weights = weights;
            for (uint i = 0; i < _balances.length; i++) {
                uint256 _nBal = _balances[i];
                uint256 _nIdeal = omul(_weights[i], _nSum);
                require(_nBal <= omul(_nIdeal, OCTOPUS + _alpha), "deposit upper halt check");
                require(_nBal >= omul(_nIdeal, OCTOPUS - _alpha), "deposit lower halt check");
                _psi += makeFee(_nBal, _nIdeal);
            }
        }

        {
            uint256 _omega = omega;
            uint256 _totalSupply = totalSupply;
            if (omega < _psi) {
                uint256 _oUtil = _oSum - _omega;
                uint256 _nUtil = _nSum - _psi;
                if (_oUtil == 0 || _totalSupply == 0) shellsMinted_ = _nUtil;
                else shellsMinted_ = odiv(omul(_nUtil - _oUtil, _totalSupply), _oUtil);
            } else {
                uint256 _lambda = lambda;
                uint256 _oUtil = _oSum - _omega;
                uint256 _nUtil = _nSum - omul(_psi, _lambda);
                if (_oUtil == 0 || _totalSupply == 0) shellsMinted_ = _nUtil;
                else {
                    uint256 _oUtilPrime = _oSum - omul(_omega, _lambda);
                    shellsMinted_ = odiv(omul(_nUtil - _oUtilPrime, _totalSupply), _oUtil);
                }
            }
        }

        omega = _psi;

    }

    /// @dev get the current balances and incoming/outgoing token amounts for the deposit/withdraw
    /// @return two arrays the length of the number of reserves containing the current balances and incoming/outgoing token amounts
    function getBalancesAndAmounts (address[] memory _flvrs, uint256[] memory _amts) internal returns (uint256[] memory, uint256[] memory) {

        address[] memory _reserves = reserves;
        uint256[] memory balances_ = new uint256[](_reserves.length);
        uint256[] memory amounts_ = new uint256[](_reserves.length);

        for (uint i = 0; i < _flvrs.length; i++) {

            Flavor memory _f = flavors[_flvrs[i]]; // withdrawing adapter + weight
            require(_f.adapter != address(0), "flavor not supported");

            for (uint j = 0; j < _reserves.length; j++) {
                if (balances_[j] == 0) balances_[j] = dViewNumeraireBalance(_reserves[j], address(this));
                if (_reserves[j] == _f.reserve && _amts[i] > 0) amounts_[j] += dViewNumeraireAmount(_f.adapter, _amts[i]);
            }
        }

        return (balances_, amounts_);
    }

    /// @notice this function makes our fees!
    /// @return fee_ the fee.
    function makeFee (uint256 _bal, uint256 _ideal) internal view returns (uint256 fee_) {

        uint256 _threshold;
        uint256 _beta = beta;
        uint256 _delta = delta;
        if (_bal < (_threshold = omul(_ideal, OCTOPUS-_beta))) {
            fee_ = odiv(_delta, _ideal);
            fee_ = omul(fee_, (_threshold = _threshold - _bal));
            fee_ = omul(fee_, _threshold);
        } else if (_bal > (_threshold = omul(_ideal, OCTOPUS+_beta))) {
            fee_ = odiv(_delta, _ideal);
            fee_ = omul(fee_, (_threshold = _bal - _threshold));
            fee_ = omul(fee_, _threshold);
        } else fee_ = 0;

    }

    /// @dev see Loihi.bin proportionalDeposit for a detailed explanation of parameter
    /// @return shellsToMint_ the amount of shells you receive in return for your deposit
    function proportionalDeposit (uint256 _deposit) public returns (uint256) {

        address[] memory _numeraires = numeraires;
        address[] memory _reserves = reserves;

        uint256[] memory _amounts = new uint256[](_numeraires.length);
        uint256 _oSum;

        for (uint i = 0; i < _reserves.length; i++) {
            uint256 _oBal = dViewNumeraireBalance(_reserves[i], address(this));
            _amounts[i] = _oBal;
            _oSum += _oBal;
        }

        if (_oSum == 0) {

            uint256[] memory _weights = weights;
            for (uint i = 0; i < _reserves.length; i++) {
                Flavor memory _f = flavors[_numeraires[i]];
                _amounts[i] = dIntakeNumeraire(_f.adapter, omul(_deposit, _weights[i]));
            }

        } else {

            uint256 _multiplier = odiv(_deposit, _oSum);
            for (uint i = 0; i < _reserves.length; i++) {
                Flavor memory _f = flavors[_numeraires[i]];
                uint256 _value = omul(_amounts[i], _multiplier);
                _amounts[i] = dIntakeNumeraire(_f.adapter, _value);
            }

            omega = omul(omega, OCTOPUS + _multiplier);

        }

        _deposit = omul(_deposit, OCTOPUS-epsilon);

        if (totalSupply > 0) _deposit = omul(odiv(_deposit, _oSum), totalSupply);

        _mint(msg.sender, _deposit);

        emit ShellsMinted(msg.sender, _deposit, numeraires, _amounts);

        return _deposit;

    }

    /// @dev see Loihi.bin proportionalWithdraw for a detailed explanation of parameter
    /// @return withdrawnAmts_ the amount withdrawn from each of the numeraire assets
    function proportionalWithdraw (uint256 _withdrawal) public returns (uint256[] memory) {

        require(_withdrawal <= balances[msg.sender], "withdrawal amount exceeds your balance");

        address[] memory _reserves = reserves;
        address[] memory _numeraires = numeraires;

        uint256 _oSum;
        uint256[] memory withdrawals_ = new uint256[](_reserves.length);

        for (uint i = 0; i < _reserves.length; i++) {
            uint256 _oBal = dViewNumeraireBalance(_reserves[i], address(this));
            withdrawals_[i] = _oBal;
            _oSum += _oBal;
        }

        uint256 _multiplier = odiv(omul(_withdrawal, OCTOPUS-epsilon), totalSupply);

        for (uint i = 0; i < _reserves.length; i++) {
            uint256 _value = omul(withdrawals_[i], _multiplier);
            Flavor memory _f = flavors[_numeraires[i]];
            withdrawals_[i] = dOutputNumeraire(_f.adapter, msg.sender, _value);
        }

        omega = omul(omega, OCTOPUS - _multiplier);

        _burn(msg.sender, _withdrawal);

        emit ShellsBurned(msg.sender, _withdrawal, _numeraires, withdrawals_);

        return withdrawals_;

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