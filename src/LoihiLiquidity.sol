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

    event log_addr(bytes32, address);

    /// @notice this function allows selective the withdrawal of any supported stablecoin flavor from the contract by burning a corresponding amount of shell tokens
    /// @param _flvrs an array of flavors to withdraw from the reserves
    /// @param _amts an array of amounts to withdraw that maps to _flavors
    /// @return shellsBurned_ the corresponding amount of shell tokens to withdraw the specified amount of specified flavors
    function selectiveWithdraw (address[] calldata _flvrs, uint256[] calldata _amts, uint256 _maxShells, uint256 _deadline) external returns (uint256 shellsBurned_) {
        require(_deadline >= now, "deadline has passed for this transaction");

        ( uint256[] memory _balances, uint256[] memory _withdrawals ) = getBalancesAndAmounts(_flvrs, _amts);

        shellsBurned_ = calculateShellsToBurn(_balances, _withdrawals);

        shellsBurned_ = wmul(shellsBurned_, WAD+(epsilon/2));
        
        require(shellsBurned_ <= balances[msg.sender], "withdrawal amount exceeds balance");
        require(shellsBurned_ <= _maxShells, "withdrawal exceeds max shells limit");

        for (uint i = 0; i < _flvrs.length; i++) if (_amts[i] > 0) dOutputRaw(flavors[_flvrs[i]].adapter, msg.sender, _amts[i]);

        _burn(msg.sender, shellsBurned_);

        emit ShellsBurned(msg.sender, shellsBurned_, _flvrs, _amts);

        return shellsBurned_;

    }

    /// @notice this function allows selective the withdrawal of any supported stablecoin flavor from the contract by burning a corresponding amount of shell tokens
    /// @param _flvrs an array of flavors to withdraw from the reserves
    /// @param _amts an array of amounts to withdraw that maps to _flavors
    /// @return shellsBurned_ the corresponding amount of shell tokens to withdraw the specified amount of specified flavors
    function viewSelectiveWithdraw (address[] calldata _flvrs, uint256[] calldata _amts) external returns (uint256) {
        ( uint256[] memory _balances, uint256[] memory _withdrawals ) = viewBalancesAndAmounts(_flvrs, _amts);
        uint256 shellsBurned_ = calculateShellsToBurn(_balances, _withdrawals);
        return wmul(shellsBurned_, WAD+(epsilon/2));
    }


    /// @notice this function calculates the amount of shells to mint by taking the balances, numeraire deposits and weights of the reserve tokens being deposited into
    /// @dev each array is the same length. each index in each array refers to the same reserve - index 0 is for the reserve token at index 0 in the reserves array, index 1 is for the reserve token at index 1 in the reserve array and so forth.
    /// @param _balances an array of current numeraire balances for each reserve
    /// @param _withdrawals an array of numeraire amounts to deposit into each reserve
    /// @return _oUtil old util
    /// @return _nUtil new util
    function calculateShellsToBurn (uint256[] memory _balances, uint256[] memory _withdrawals) internal returns (uint256 shellsBurned_) {

        uint256 _nSum; uint256 _oSum;
        for (uint i = 0; i < _balances.length; i++) {
            _nSum = add(_nSum, sub(_balances[i], _withdrawals[i]));
            _oSum = add(_oSum, _balances[i]);
        }

        uint256 _nFees; uint256 _oFees;
        for (uint i = 0; i < _balances.length; i++) {
            uint256 _nBal = sub(_balances[i], _withdrawals[i]);
            uint256 _nIdeal = wmul(_nSum, weights[i]);
            require(_nBal <= wmul(_nIdeal, WAD + alpha), "withdraw upper halt check");
            require(_nBal >= wmul(_nIdeal, WAD - alpha), "withdraw lower halt check");
            _nFees += makeFee(_nBal, _nIdeal);
            _oFees += makeFee(_balances[i], wmul(_oSum, weights[i]));
        }

        if (_oFees < _nFees) {
            uint256 _oUtil = sub(_oSum, _oFees);
            uint256 _nUtil = sub(_nSum, _nFees);
            if (_oUtil == 0) return _nUtil;
            shellsBurned_ = wdiv(wmul(sub(_oUtil, _nUtil), totalSupply), _oUtil);
        } else {
            uint256 _oUtil = sub(_oSum, _oFees);
            uint256 _nUtil = sub(_nSum, wmul(_nFees, lambda));
            if (_oUtil == 0) return _nUtil;
            uint256 _oUtilPrime = sub(_oSum, wmul(_oFees, lambda));
            shellsBurned_ = wdiv(wmul(sub(_oUtilPrime, _nUtil), totalSupply), _oUtil);
        }

        emit log_uint("old sum", _oSum);

    }

    /// @notice this function allows selective depositing of any supported stablecoin flavor into the contract in return for corresponding shell tokens
    /// @param _flvrs an array containing the addresses of the flavors being deposited into
    /// @param _amts an array containing the values of the flavors you wish to deposit into the contract. each amount should have the same index as the flavor it is meant to deposit
    /// @return shellsToMint_ the amount of shells to mint for the deposited stablecoin flavors
    function selectiveDeposit (address[] calldata _flvrs, uint256[] calldata _amts, uint256 _minShells, uint256 _deadline) external returns (uint256 shellsMinted_) {
        require(_deadline >= now, "deadline has passed for this transaction");

        ( uint256[] memory _balances, uint256[] memory _deposits ) = getBalancesAndAmounts(_flvrs, _amts);

        shellsMinted_ = calculateShellsToMint(_balances, _deposits);
        shellsMinted_ = wmul(shellsMinted_, WAD-(epsilon/2));

        require(shellsMinted_ >= _minShells, "minted shells less than minimum shells");

        _mint(msg.sender, shellsMinted_);

        for (uint i = 0; i < _flvrs.length; i++) if (_amts[i] > 0) dIntakeRaw(flavors[_flvrs[i]].adapter, _amts[i]);

        emit ShellsMinted(msg.sender, shellsMinted_, _flvrs, _amts);

        return shellsMinted_;

    }

    /// @notice this function allows selective depositing of any supported stablecoin flavor into the contract in return for corresponding shell tokens
    /// @param _flvrs an array containing the addresses of the flavors being deposited into
    /// @param _amts an array containing the values of the flavors you wish to deposit into the contract. each amount should have the same index as the flavor it is meant to deposit
    /// @return shellsToMint_ the amount of shells to mint for the deposited stablecoin flavors
    function viewSelectiveDeposit (address[] calldata _flvrs, uint256[] calldata _amts) external returns (uint256) {
        ( uint256[] memory _balances, uint256[] memory _deposits ) = viewBalancesAndAmounts(_flvrs, _amts);
        uint256 shellsMinted_ = calculateShellsToMint(_balances, _deposits);
        return wmul(shellsMinted_, WAD-(epsilon/2));
    }


    function calculateShellsToMint (uint256[] memory _balances, uint256[] memory _deposits) internal returns (uint256 shellsMinted_) {

        uint256 _nSum; uint256 _oSum;
        for (uint i = 0; i < _balances.length; i++) {
            _oSum = add(_oSum, _balances[i]);
            _nSum = add(_nSum, add(_balances[i], _deposits[i]));
        }

        uint256 _nFees; uint256 _oFees;
        for (uint i = 0; i < _balances.length; i++) {
            uint256 _nBal = add(_balances[i], _deposits[i]);
            uint256 _nIdeal = wmul(weights[i], _nSum);
            require(_nBal <= wmul(_nIdeal, WAD + alpha), "deposit upper halt check");
            require(_nBal >= wmul(_nIdeal, WAD - alpha), "deposit lower halt check");
            _nFees += makeFee(_nBal, _nIdeal);
            _oFees += makeFee(_balances[i], wmul(_oSum, weights[i]));
        }

        if (_oFees < _nFees) {
            uint256 _oUtil = sub(_oSum, _oFees);
            uint256 _nUtil = sub(_nSum, _nFees);
            if (_oUtil == 0) return _nUtil;
            shellsMinted_ = wdiv(wmul(sub(_nUtil, _oUtil), totalSupply), _oUtil);
        } else {
            uint256 _oUtil = sub(_oSum, _oFees);
            uint256 _nUtil = sub(_nSum, wmul(_nFees, lambda));
            if (_oUtil == 0) return _nUtil;
            uint256 _oUtilPrime = sub(_oSum, wmul(_oFees, lambda));
            shellsMinted_ = wdiv(wmul(sub(_nUtil, _oUtilPrime), totalSupply), _oUtil);
        }

        emit log_uint("old sum", _oSum);

    }

    event log_uint(bytes32, uint256);

    /// @author james foley http://github.com/realisation
    /// @dev this function is used in selective deposits and selective withdraws
    /// @dev it finds the reserves corresponding to the flavors and attributes the amounts to these reserves
    /// @param _flvrs the addresses of the stablecoin flavor
    /// @param _amts the specified amount of each stablecoin flavor
    /// @return three arrays each the length of the number of reserves containing the balances, token amounts and weights for each reserve
    function getBalancesAndAmounts (address[] memory _flvrs, uint256[] memory _amts) private returns (uint256[] memory, uint256[] memory) {

        uint256[] memory balances_ = new uint256[](reserves.length);
        uint256[] memory amounts_ = new uint256[](reserves.length);

        for (uint i = 0; i < _flvrs.length; i++) {

            Flavor memory _f = flavors[_flvrs[i]]; // withdrawing adapter + weight
            require(_f.adapter != address(0), "flavor not supported");

            for (uint j = 0; j < reserves.length; j++) {
                if (balances_[j] == 0) balances_[j] = dGetNumeraireBalance(reserves[j]);
                if (reserves[j] == _f.reserve && _amts[i] > 0) amounts_[j] += dGetNumeraireAmount(_f.adapter, _amts[i]);
            }
        }

        return (balances_, amounts_);
    }

    function viewBalancesAndAmounts (address[] memory _flvrs, uint256[] memory _amts) private view returns (uint256[] memory, uint256[] memory) {

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

    function makeFee (uint256 _bal, uint256 _ideal) internal view returns (uint256 _fee) {

        uint256 threshold;
        if (_bal < (threshold = wmul(_ideal, WAD-beta))) {
            _fee = wdiv(delta, _ideal);
            _fee = wmul(_fee, (threshold = sub(threshold, _bal)));
            _fee = wmul(_fee, threshold);
        } else if (_bal > (threshold = wmul(_ideal, WAD+beta))) {
            _fee = wdiv(delta, _ideal);
            _fee = wmul(_fee, (threshold = sub(_bal, threshold)));
            _fee = wmul(_fee, threshold);
        } else _fee = 0;

    }

    /// @author james foley http://github.com/realisation
    /// @notice this function takes a total amount to deposit into the pool with no slippage from the numeraire assets the pool supports
    /// @param _deposit the full amount you want to deposit into the pool which will be divided up evenly amongst the numeraire assets of the pool
    /// @return shellsToMint_ the amount of shells you receive in return for your deposit
    function proportionalDeposit (uint256 _deposit) public returns (uint256) {

        uint256[] memory _amounts = new uint256[](numeraires.length);
        uint256 _oSum;

        for (uint i = 0; i < reserves.length; i++) {
            Flavor memory _f = flavors[numeraires[i]];
            _oSum += dGetNumeraireBalance(reserves[i]);
            _amounts[i] = dIntakeNumeraire(_f.adapter, wmul(weights[i], _deposit));
        }

        _deposit = wmul(_deposit, WAD-(epsilon/2));

        if (totalSupply > 0) _deposit = wmul(wdiv(_deposit, _oSum), totalSupply);

        _mint(msg.sender, _deposit);

        emit ShellsMinted(msg.sender, _deposit, numeraires, _amounts);

        return _deposit;

    }

    function viewProportionalDeposit (uint256 _deposit) public view returns (uint256) {
        return wmul(_deposit, WAD-(epsilon/2));
    }


    /// @author james foley http://github.com/realisation
    /// @notice this function takes a total amount to from the the pool with no slippage from the numeraire assets of the pool
    /// @param _withdrawal the full amount you want to withdraw from the pool which will be withdrawn from evenly amongst the numeraire assets of the pool
    /// @return withdrawnAmts_ the amount withdrawn from each of the numeraire assets
    function proportionalWithdraw (uint256 _withdrawal) public returns (uint256[] memory) {

        require(_withdrawal <= balances[msg.sender], "withdrawal amount exceeds your balance");

        uint256 _oSum;
        uint256 _withdrawMultiplier = wdiv(wmul(_withdrawal, WAD+(epsilon/2)), totalSupply);
        uint256[] memory withdrawalAmts_ = new uint256[](reserves.length);
        for (uint i = 0; i < reserves.length; i++) {
            _oSum += dGetNumeraireBalance(reserves[i]);
            uint256 _proportionateValue = wmul(wmul(dGetNumeraireBalance(reserves[i]), _withdrawMultiplier), WAD-epsilon);
            Flavor memory _f = flavors[numeraires[i]];
            withdrawalAmts_[i] = dOutputNumeraire(_f.adapter, msg.sender, _proportionateValue);
        }

        _burn(msg.sender, _withdrawal);

        emit ShellsBurned(msg.sender, _withdrawal, numeraires, withdrawalAmts_);

        return withdrawalAmts_;

    }

    function viewProportionalWithdraw (uint256 _withdrawal) public view returns (uint256[] memory) {

        uint256 _withdrawMultiplier = wdiv(_withdrawal, totalSupply);
        uint256[] memory withdrawalAmts_ = new uint256[](reserves.length);
        for (uint i = 0; i < reserves.length; i++) {
            uint256 _proportionateValue = wmul(wmul(dViewNumeraireBalance(reserves[i], address(this)), _withdrawMultiplier), WAD-epsilon);
            Flavor memory _f = flavors[numeraires[i]];
            withdrawalAmts_[i] = dViewRawAmount(_f.adapter, _proportionateValue);
        }

        return withdrawalAmts_;
    }

    function totalReserves (address[] calldata _reserves, address _addr) external view returns (uint256, uint256[] memory) {
        uint256 totalBalance_;
        uint256[] memory balances_ = new uint256[](_reserves.length);
        for (uint i = 0; i < _reserves.length; i++) {
            balances_[i] = dViewNumeraireBalance(_reserves[i], _addr);
            totalBalance_ += balances_[i];
        }
        return (totalBalance_, balances_);
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