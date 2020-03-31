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

    /// @notice this function allows selective the withdrawal of any supported stablecoin flavor from the contract by burning a corresponding amount of shell tokens
    /// @param _flvrs an array of flavors to withdraw from the reserves
    /// @param _amts an array of amounts to withdraw that maps to _flavors
    /// @param _maxShells maximum number of shells to burn
    /// @param _deadline deadline for tx in block time
    /// @return shellsBurned_ the corresponding amount of shell tokens to withdraw the specified amount of specified flavors
    function selectiveWithdraw (address[] calldata _flvrs, uint256[] calldata _amts, uint256 _maxShells, uint256 _deadline) external returns (uint256 shellsBurned_) {
        require(_deadline >= now, "deadline has passed for this transaction");

        ( uint256[] memory _balances, uint256[] memory _withdrawals ) = getBalancesAndAmounts(_flvrs, _amts);

        shellsBurned_ = calculateShellsToBurn(_balances, _withdrawals);

        shellsBurned_ = wmul(shellsBurned_, WAD+epsilon);
        
        require(shellsBurned_ <= balances[msg.sender], "withdrawal amount exceeds balance");
        require(shellsBurned_ <= _maxShells, "withdrawal exceeds max shells limit");

        for (uint i = 0; i < _flvrs.length; i++) if (_amts[i] > 0) dOutputRaw(flavors[_flvrs[i]].adapter, msg.sender, _amts[i]);

        _burn(msg.sender, shellsBurned_);

        emit ShellsBurned(msg.sender, shellsBurned_, _flvrs, _amts);

        return shellsBurned_;

    }

    /// @notice this function calculates the amount of shells to burn by taking the balances and numeraire deposits of the reserve tokens being deposited into
    /// @param _balances an array of current numeraire balances for each reserve
    /// @param _withdrawals an array of numeraire amounts to withdraw from each reserve
    /// @return shellsBurned_ the amount of shells the withdraw will burn
    function calculateShellsToBurn (uint256[] memory _balances, uint256[] memory _withdrawals) internal returns (uint256 shellsBurned_) {

        uint256 _nSum; uint256 _oSum;
        for (uint i = 0; i < _balances.length; i++) {
            _nSum = add(_nSum, sub(_balances[i], _withdrawals[i]));
            _oSum = add(_oSum, _balances[i]);
        }

        uint256 _psi;
        for (uint i = 0; i < _balances.length; i++) {
            uint256 _nBal = sub(_balances[i], _withdrawals[i]);
            uint256 _nIdeal = wmul(_nSum, weights[i]);
            require(_nBal <= wmul(_nIdeal, WAD + alpha), "withdraw upper halt check");
            require(_nBal >= wmul(_nIdeal, WAD - alpha), "withdraw lower halt check");
            _psi += makeFee(_nBal, _nIdeal);
        }

        if (omega < _psi) {
            uint256 _oUtil = sub(_oSum, omega);
            uint256 _nUtil = sub(_nSum, _psi);
            if (_oUtil == 0) shellsBurned_ = _nUtil;
            else shellsBurned_ = wdiv(wmul(sub(_oUtil, _nUtil), totalSupply), _oUtil);
        } else {
            uint256 _oUtil = sub(_oSum, omega);
            uint256 _nUtil = sub(_nSum, wmul(_psi, lambda));
            if (_oUtil == 0) shellsBurned_ = _nUtil;
            else {
                uint256 _oUtilPrime = sub(_oSum, wmul(omega, lambda));
                shellsBurned_ = wdiv(wmul(sub(_oUtilPrime, _nUtil), totalSupply), _oUtil);
            }
        }

        omega = _psi;

    }

    /// @notice this function allows selective depositing of any supported stablecoin flavor into the contract in return for corresponding shell tokens
    /// @param _flvrs an array containing the addresses of the flavors being deposited into
    /// @param _amts an array containing the values of the flavors you wish to deposit into the contract
    /// @param _minShells minimum acceptable number of shells to mint
    /// @param _deadline deadline in block time for tx
    /// @return shellsToMint_ the amount of shells to mint for the deposited stablecoin flavors
    function selectiveDeposit (address[] calldata _flvrs, uint256[] calldata _amts, uint256 _minShells, uint256 _deadline) external returns (uint256 shellsMinted_) {
        require(_deadline >= now, "deadline has passed for this transaction");

        ( uint256[] memory _balances, uint256[] memory _deposits ) = getBalancesAndAmounts(_flvrs, _amts);

        shellsMinted_ = calculateShellsToMint(_balances, _deposits);
        shellsMinted_ = wmul(shellsMinted_, WAD-epsilon);

        require(shellsMinted_ >= _minShells, "minted shells less than minimum shells");

        _mint(msg.sender, shellsMinted_);

        for (uint i = 0; i < _flvrs.length; i++) if (_amts[i] > 0) dIntakeRaw(flavors[_flvrs[i]].adapter, _amts[i]);

        emit ShellsMinted(msg.sender, shellsMinted_, _flvrs, _amts);

        return shellsMinted_;

    }

    /// @notice this function calculates the amount of shells to mint by taking the balances and numeraire deposits of the reserve tokens being deposited into
    /// @param _balances an array of current numeraire balances for each reserve
    /// @param _deposits an array of numeraire amounts to deposit into each reserve
    /// @return shellsMinted_ the amount of shells the deposit will mint
    function calculateShellsToMint (uint256[] memory _balances, uint256[] memory _deposits) internal returns (uint256 shellsMinted_) {

        uint256 _nSum; uint256 _oSum;
        for (uint i = 0; i < _balances.length; i++) {
            _oSum = add(_oSum, _balances[i]);
            _nSum = add(_nSum, add(_balances[i], _deposits[i]));
        }

        uint256 _psi;
        for (uint i = 0; i < _balances.length; i++) {
            uint256 _nBal = add(_balances[i], _deposits[i]);
            uint256 _nIdeal = wmul(weights[i], _nSum);
            require(_nBal <= wmul(_nIdeal, WAD + alpha), "deposit upper halt check");
            require(_nBal >= wmul(_nIdeal, WAD - alpha), "deposit lower halt check");
            _psi += makeFee(_nBal, _nIdeal);
        }

        if (omega < _psi) {
            uint256 _oUtil = sub(_oSum, omega);
            uint256 _nUtil = sub(_nSum, _psi);
            if (_oUtil == 0 || totalSupply == 0) shellsMinted_ = _nUtil;
            else shellsMinted_ = wdiv(wmul(sub(_nUtil, _oUtil), totalSupply), _oUtil);
        } else {
            uint256 _oUtil = sub(_oSum, omega);
            uint256 _nUtil = sub(_nSum, wmul(_psi, lambda));
            if (_oUtil == 0 || totalSupply == 0) shellsMinted_ = _nUtil;
            else {
                uint256 _oUtilPrime = sub(_oSum, wmul(omega, lambda));
                shellsMinted_ = wdiv(wmul(sub(_nUtil, _oUtilPrime), totalSupply), _oUtil);
            }
        }

        omega = _psi;

    }

    /// @author james foley http://github.com/realisation
    /// @dev this function is used in selective deposits and selective withdraws
    /// @dev it finds the reserves corresponding to the flavors and attributes the amounts to these reserves
    /// @param _flvrs the addresses of the stablecoin flavor
    /// @param _amts the specified amount of each stablecoin flavor
    /// @return three arrays each the length of the number of reserves containing the balances, token amounts and weights for each reserve
    function getBalancesAndAmounts (address[] memory _flvrs, uint256[] memory _amts) internal returns (uint256[] memory, uint256[] memory) {

        uint256[] memory balances_ = new uint256[](reserves.length);
        uint256[] memory amounts_ = new uint256[](reserves.length);

        for (uint i = 0; i < _flvrs.length; i++) {

            Flavor memory _f = flavors[_flvrs[i]]; // withdrawing adapter + weight
            require(_f.adapter != address(0), "flavor not supported");

            for (uint j = 0; j < reserves.length; j++) {
                if (balances_[j] == 0) balances_[j] = dViewNumeraireBalance(reserves[j], address(this));
                if (reserves[j] == _f.reserve && _amts[i] > 0) amounts_[j] += dViewNumeraireAmount(_f.adapter, _amts[i]);
            }
        }

        return (balances_, amounts_);
    }

    /// @author james foley http://github.com/realisation
    /// @notice this function makes our fees!
    /// @return fee_ the fee.
    function makeFee (uint256 _bal, uint256 _ideal) internal view returns (uint256 fee_) {

        uint256 _threshold;
        if (_bal < (_threshold = wmul(_ideal, WAD-beta))) {
            fee_ = wdiv(delta, _ideal);
            fee_ = wmul(fee_, (_threshold = sub(_threshold, _bal)));
            fee_ = wmul(fee_, _threshold);
        } else if (_bal > (_threshold = wmul(_ideal, WAD+beta))) {
            fee_ = wdiv(delta, _ideal);
            fee_ = wmul(fee_, (_threshold = sub(_bal, _threshold)));
            fee_ = wmul(fee_, _threshold);
        } else fee_ = 0;

    }

    /// @author james foley http://github.com/realisation
    /// @notice this function takes a total amount to deposit into the pool with no slippage across the numeraire assets the pool supports
    /// @param _deposit the full amount you want to deposit into the pool which will be divided up evenly amongst the numeraire assets of the pool
    /// @return shellsToMint_ the amount of shells you receive in return for your deposit
    function proportionalDeposit (uint256 _deposit) public returns (uint256) {

        uint256[] memory _amounts = new uint256[](numeraires.length);
        uint256 _oSum;

        for (uint i = 0; i < reserves.length; i++) {
            uint256 _oBal = dViewNumeraireBalance(reserves[i], address(this));
            _amounts[i] = _oBal;
            _oSum += _oBal;
        }

        if (_oSum == 0) {

            for (uint i = 0; i < reserves.length; i++) {
                Flavor memory _f = flavors[numeraires[i]];
                _amounts[i] = dIntakeNumeraire(_f.adapter, wmul(_deposit, weights[i]));
            }

        } else {

            uint256 _multiplier = wdiv(_deposit, _oSum);
            for (uint i = 0; i < reserves.length; i++) {
                Flavor memory _f = flavors[numeraires[i]];
                uint256 _value = wmul(_amounts[i], _multiplier);
                _amounts[i] = dIntakeNumeraire(_f.adapter, _value);
            }
            omega = wmul(omega, WAD + _multiplier);

        }

        _deposit = wmul(_deposit, WAD-epsilon);

        if (totalSupply > 0) _deposit = wmul(wdiv(_deposit, _oSum), totalSupply);

        _mint(msg.sender, _deposit);

        emit ShellsMinted(msg.sender, _deposit, numeraires, _amounts);

        return _deposit;

    }

    /// @author james foley http://github.com/realisation
    /// @notice this function takes a total amount to from the the pool with no slippage from the numeraire assets of the pool
    /// @param _withdrawal the full amount you want to withdraw from the pool which will be withdrawn from evenly amongst the numeraire assets of the pool
    /// @return withdrawnAmts_ the amount withdrawn from each of the numeraire assets
    function proportionalWithdraw (uint256 _withdrawal) public returns (uint256[] memory) {

        require(_withdrawal <= balances[msg.sender], "withdrawal amount exceeds your balance");

        uint256 _oSum;
        uint256[] memory withdrawals_ = new uint256[](reserves.length);

        for (uint i = 0; i < reserves.length; i++) {
            uint256 _oBal = dViewNumeraireBalance(reserves[i], address(this));
            withdrawals_[i] = _oBal;
            _oSum += _oBal;
        }

        uint256 _multiplier = wdiv(wmul(_withdrawal, WAD-epsilon), totalSupply);

        for (uint i = 0; i < reserves.length; i++) {
            uint256 _value = wmul(withdrawals_[i], _multiplier);
            Flavor memory _f = flavors[numeraires[i]];
            withdrawals_[i] = dOutputNumeraire(_f.adapter, msg.sender, _value);
        }

        omega = wmul(omega, WAD - _multiplier);

        _burn(msg.sender, _withdrawal);

        emit ShellsBurned(msg.sender, _withdrawal, numeraires, withdrawals_);

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