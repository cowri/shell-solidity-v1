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

contract LoihiExchange is LoihiRoot, LoihiDelegators {

    event log_addr(bytes32, address);

    function viewOriginTrade (address _origin, address _target, uint256 _oAmt) external returns (uint256) {

        Flavor memory _o = flavors[_origin];
        Flavor memory _t = flavors[_target];

        require(_o.adapter != address(0), "origin flavor not supported");
        require(_t.adapter != address(0), "target flavor not supported");

        if (_o.reserve == _t.reserve) {
            uint256 _oNAmt = dViewNumeraireAmount(_o.adapter, _oAmt);
            return dViewRawAmount(_t.adapter, _oNAmt);
        }

        (uint256[] memory _balances, uint256 _grossLiq) = viewBalancesAndGrossLiq();

        uint256 _oNAmt = dViewNumeraireAmount(_o.adapter, _oAmt);
        uint256 _tNAmt = getTargetAmount(_o.reserve, _t.reserve, _oNAmt, _balances, _grossLiq);
        _tNAmt = wmul(_tNAmt, WAD - feeBase);

        return dViewRawAmount(_t.adapter, _tNAmt);

    }

    /// @notice given an origin amount this function will find the corresponding target amount according to the contracts state and make the swap between the two
    /// @param _origin the address of the origin flavor
    /// @param _target the address of the target flavor
    /// @param _oAmt the raw amount of the origin flavor - will be converted to numeraire amount
    /// @param _minTAmt the minimum target amount you are willing to accept for this trade
    /// @param _deadline the block by which this transaction is no longer valid
    /// @param _recipient the address for where to send the resultant target amount
    /// @return tNAmt_ the target numeraire amount
    function executeOriginTrade (uint256 _deadline, uint256 _minTAmt, address _recipient, address _origin, address _target, uint256 _oAmt) external returns (uint256) {

        Flavor memory _o = flavors[_origin]; // origin adapter + reserve + weight
        Flavor memory _t = flavors[_target]; // target adapter + weight

        require(_o.adapter != address(0), "origin flavor not supported");
        require(_t.adapter != address(0), "target flavor not supported");

        if (_o.reserve == _t.reserve) {
            uint256 _oNAmt = dIntakeRaw(_o.adapter, _oAmt);
            uint256 tAmt_ = dOutputNumeraire(_t.adapter, _recipient, _oNAmt);
            emit Trade(msg.sender, _origin, _target, _oAmt, tAmt_);
            return tAmt_;
        }

        (uint256[] memory _balances, uint256 _grossLiq) = getBalancesAndGrossLiq();

        uint256 _oNAmt = dGetNumeraireAmount(_o.adapter, _oAmt);
        _oNAmt = wmul(_oNAmt, WAD-(feeBase/2));
        uint256 _tNAmt = getTargetAmount(_o.reserve, _t.reserve, _oNAmt, _balances, _grossLiq);
        _tNAmt = wmul(_tNAmt, WAD-(feeBase/2));

        dIntakeRaw(_o.adapter, _oAmt);
        uint256 tAmt_ = dOutputNumeraire(_t.adapter, _recipient, _tNAmt);
        emit Trade(msg.sender, _origin, _target, _oAmt, tAmt_);
        return tAmt_;

    }



    // / @author james foley http://github.com/realisation
    // / @notice given an amount of the target currency this function will derive the corresponding origin amount according to the current state of the contract
    // / @param _origin the address of the origin stablecoin flavor
    // / @param _target the address of the target stablecoin flavor
    // / @param _maxOAmt the highest amount of the origin stablecoin flavor you are willing to trade
    // / @param _tAmt the raw amount of the target stablecoin flavor to be converted into numeraire amount
    // / @param _deadline the block number at which this transaction is no longer valid
    // / @param _recipient the address for where to send the target amount
    function executeTargetTrade (uint256 _deadline, address _origin, address _target, uint256 _maxOAmt, uint256 _tAmt, address _recipient) external returns (uint256) {
        require(_deadline >= now, "deadline has passed for this trade");

        Flavor memory _o = flavors[_origin];
        Flavor memory _t = flavors[_target];

        require(_o.adapter != address(0), "origin flavor not supported");
        require(_t.adapter != address(0), "target flavor not supported");

        if (_o.reserve == _t.reserve) {
            uint256 _tNAmt = dOutputRaw(_t.adapter, _recipient, _tAmt);
            uint256 oAmt_ = dIntakeNumeraire(_o.adapter, _tNAmt);
            emit Trade(msg.sender, _origin, _target, oAmt_, _tAmt);
            return oAmt_;
        }

        (uint256[] memory _balances, uint256 _grossLiq) = getBalancesAndGrossLiq();

        uint256 _tNAmt = dGetNumeraireAmount(_t.adapter, _tAmt);
        _tNAmt = wmul(_tNAmt, WAD+(feeBase/2));
        uint256 _oNAmt = getOriginAmount(_o.reserve, _t.reserve, _tNAmt, _balances, _grossLiq);
        _oNAmt = wmul(_oNAmt, WAD+(feeBase/2));

        require(dViewRawAmount(_o.adapter, _oNAmt) <= _maxOAmt, "origin amount is greater than max origin amount");

        dOutputRaw(_t.adapter, _recipient, _tAmt);
        uint256 oAmt_ = dIntakeNumeraire(_o.adapter, _oNAmt);

        emit Trade(msg.sender, _origin, _target, oAmt_, _tAmt);

        return oAmt_;

    }

    function getBalancesAndGrossLiq () internal returns (uint256[] memory, uint256 grossLiq_) {
        uint256[] memory balances_ = new uint256[](reserves.length);
        for (uint i = 0; i < reserves.length; i++) {
            balances_[i] = dGetNumeraireBalance(reserves[i]);
            grossLiq_ += balances_[i];
        }
        return (balances_, grossLiq_);
    }

    function viewTargetTrade (address _origin, address _target, uint256 _tAmt) external returns (uint256) {

        Flavor memory _o = flavors[_origin];
        Flavor memory _t = flavors[_target];

        require(_o.adapter != address(0), "origin flavor not supported");
        require(_t.adapter != address(0), "target flavor not supported");

        if (_o.reserve == _t.reserve) {
            uint256 _tNAmt = dViewNumeraireAmount(_t.adapter, _tAmt);
            return dViewRawAmount(_o.adapter, _tNAmt);
        }

        (uint256[] memory _balances, uint256 _grossLiq) = viewBalancesAndGrossLiq();

        uint256 _tNAmt = dViewNumeraireAmount(_t.adapter, _tAmt);
        uint256 _oNAmt = getOriginAmount(_o.reserve, _t.reserve, _tNAmt, _balances, _grossLiq);
        _oNAmt = wmul(_oNAmt, WAD + feeBase);

        return dViewRawAmount(_o.adapter, _oNAmt);

    }

    function viewBalancesAndGrossLiq () internal view returns (uint256[] memory balances_, uint256 grossLiq_) {
        for (uint i = 0; i < reserves.length; i++) {
            balances_[i] = dViewNumeraireBalance(reserves[i], address(this));
            grossLiq_ += balances_[i];
        }
    }

    event log_uints (bytes32, uint256[]);
    function getTargetAmount (address _oRsrv, address _tRsrv, uint256 _oNAmt, uint256[] memory _balances, uint256 _grossLiq) internal view returns (uint256 tNAmt_) {
        
        tNAmt_ = _oNAmt;
        uint256 _oFees;
        uint256 _nFees;
        uint256 _oIdeal;
        uint256 _tIdeal;
        for (uint j = 0; j < 10; j++) {
            _nFees = 0;
            for (uint i = 0; i < reserves.length; i++) {
                if (j == 0) _oFees += makeFee(_balances[i], wmul(_grossLiq, weights[i]));
                uint256 _nGLiq = _grossLiq + _oNAmt - tNAmt_;
                uint256 _nIdeal = wmul(_nGLiq, weights[i]);
                if (reserves[i] == _oRsrv) {
                    _nFees += makeFee(_balances[i] + _oNAmt, _nIdeal);
                    _oIdeal = _nIdeal;
                } else if (reserves[i] == _tRsrv) {
                    _nFees += makeFee(_balances[i] - tNAmt_, _nIdeal);
                    _tIdeal = _nIdeal;
                } else _nFees += makeFee(_balances[i], _nIdeal);
            }
            if ((tNAmt_ = _oNAmt + _oFees - _nFees) / 10000000000 == tNAmt_ / 10000000000) break;
        }

        if (_oFees > _nFees) tNAmt_ = add(_oNAmt, wmul(arbPiece, sub(_oFees, _nFees)));

        for (uint i = 0; i < _balances.length; i++) {
            if (reserves[i] == _oRsrv) require(_balances[i] + _oNAmt < wmul(_oIdeal, WAD + alpha), "origin halt check");
            if (reserves[i] == _tRsrv) require(_balances[i] - tNAmt_ > wmul(_tIdeal, WAD - alpha), "target halt check");
        }

    }

    function getOriginAmount (address _oRsrv, address _tRsrv, uint256 _tNAmt, uint256[] memory _balances, uint256 _grossLiq) internal returns (uint256 oNAmt_) {

        oNAmt_ = _tNAmt;
        uint256 _oFees;
        uint256 _nFees;
        uint256 _tIdeal;
        uint256 _oIdeal;
        for (uint j = 0; j < 10; j++) {
            _nFees = 0;
            for (uint i = 0; i < reserves.length; i++) {
                if (j == 0) _oFees += makeFee(_balances[i], wmul(_grossLiq, weights[i]));
                uint256 _nGLiq = _grossLiq + oNAmt_ - _tNAmt;
                uint256 _nIdeal = wmul(_nGLiq, weights[i]);
                if (reserves[i] == _oRsrv) {
                    _nFees += makeFee(_balances[i] + oNAmt_, _nIdeal);
                    _oIdeal = _nIdeal;
                } else if (reserves[i] == _tRsrv) {
                    _nFees += makeFee(_balances[i] - _tNAmt, _nIdeal);
                    _tIdeal = _nIdeal;
                } else _nFees += makeFee(_balances[i], _nIdeal);
            }
            if ((oNAmt_ = _tNAmt + _nFees - _oFees) / 10000000000 == oNAmt_ / 10000000000) break;
        }

        if (_oFees > _nFees) oNAmt_ = sub(_tNAmt, wmul(arbPiece, sub(_oFees, _nFees)));

        for (uint i = 0; i < _balances.length; i++) {
            if (reserves[i] == _oRsrv) require(_balances[i] + oNAmt_ < wmul(_oIdeal, WAD + alpha), "origin halt check");
            if (reserves[i] == _tRsrv) require(_balances[i] - _tNAmt > wmul(_tIdeal, WAD - alpha), "target halt check");
        }

    }

    event log_uint(bytes32, uint256);

    /// @notice this function allows selective the withdrawal of any supported stablecoin flavor from the contract by burning a corresponding amount of shell tokens
    /// @param _flvrs an array of flavors to withdraw from the reserves
    /// @param _amts an array of amounts to withdraw that maps to _flavors
    /// @return shellsBurned_ the corresponding amount of shell tokens to withdraw the specified amount of specified flavors
    function selectiveWithdraw (address[] calldata _flvrs, uint256[] calldata _amts, uint256 _maxShells, uint256 _deadline) external returns (uint256 shellsBurned_) {
        require(_deadline >= now, "deadline has passed for this transaction");

        ( uint256[] memory _balances, uint256[] memory _withdrawals ) = getBalancesAndTokenAmounts(_flvrs, _amts);

        shellsBurned_ = calculateShellsToBurn(_balances, _withdrawals);

        require(shellsBurned_ <= balances[msg.sender], "withdrawal amount exceeds balance");

        shellsBurned_ = wmul(shellsBurned_, WAD+(feeBase/2));

        require(shellsBurned_ <= _maxShells, "withdrawal exceeds max shells limit");

        for (uint i = 0; i < _flvrs.length; i++) if (_amts[i] > 0) dOutputRaw(flavors[_flvrs[i]].adapter, msg.sender, _amts[i]);

        _burn(msg.sender, shellsBurned_);

        emit ShellsBurned(msg.sender, shellsBurned_, _flvrs, _amts);

        return shellsBurned_;

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
            uint256 _nUtil = sub(_nSum, wmul(_nFees, arbPiece));
            if (_oUtil == 0) return _nUtil;
            uint256 _oUtilPrime = sub(_oSum, wmul(_oFees, arbPiece));
            shellsBurned_ = wdiv(wmul(sub(_oUtilPrime, _nUtil), totalSupply), _oUtil);
        }

    }

    /// @notice this function allows selective depositing of any supported stablecoin flavor into the contract in return for corresponding shell tokens
    /// @param _flvrs an array containing the addresses of the flavors being deposited into
    /// @param _amts an array containing the values of the flavors you wish to deposit into the contract. each amount should have the same index as the flavor it is meant to deposit
    /// @return shellsToMint_ the amount of shells to mint for the deposited stablecoin flavors
    function selectiveDeposit (address[] calldata _flvrs, uint256[] calldata _amts, uint256 _minShells, uint256 _deadline) external returns (uint256 shellsMinted_) {
        require(_deadline >= now, "deadline has passed for this transaction");

        ( uint256[] memory _balances, uint256[] memory _deposits ) = getBalancesAndTokenAmounts(_flvrs, _amts);

        shellsMinted_ = calculateShellsToMint(_balances, _deposits);
        shellsMinted_ = wmul(shellsMinted_, WAD-(feeBase/2));

        require(shellsMinted_ >= _minShells, "minted shells less than minimum shells");

        _mint(msg.sender, shellsMinted_);

        for (uint i = 0; i < _flvrs.length; i++) if (_amts[i] > 0) dIntakeRaw(flavors[_flvrs[i]].adapter, _amts[i]);

        emit ShellsMinted(msg.sender, shellsMinted_, _flvrs, _amts);

        return shellsMinted_;

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
            uint256 _nUtil = sub(_nSum, wmul(_nFees, arbPiece));
            if (_oUtil == 0) return _nUtil;
            uint256 _oUtilPrime = sub(_oSum, wmul(_oFees, arbPiece));
            shellsMinted_ = wdiv(wmul(sub(_nUtil, _oUtilPrime), totalSupply), _oUtil);
        }

    }

    /// @author james foley http://github.com/realisation
    /// @dev this function is used in selective deposits and selective withdraws
    /// @dev it finds the reserves corresponding to the flavors and attributes the amounts to these reserves
    /// @param _flvrs the addresses of the stablecoin flavor
    /// @param _amts the specified amount of each stablecoin flavor
    /// @return three arrays each the length of the number of reserves containing the balances, token amounts and weights for each reserve
    function getBalancesAndTokenAmounts (address[] memory _flvrs, uint256[] memory _amts) private returns (uint256[] memory, uint256[] memory) {

        uint256[] memory balances_ = new uint256[](reserves.length);
        uint256[] memory tokenAmounts_ = new uint256[](reserves.length);

        for (uint i = 0; i < _flvrs.length; i++) {

            Flavor memory _f = flavors[_flvrs[i]]; // withdrawing adapter + weight
            require(_f.adapter != address(0), "flavor not supported");

            for (uint j = 0; j < reserves.length; j++) {
                if (balances_[j] == 0) balances_[j] = dGetNumeraireBalance(reserves[j]);
                if (reserves[j] == _f.reserve && _amts[i] > 0) tokenAmounts_[j] += dGetNumeraireAmount(_f.adapter, _amts[i]);
            }
        }

        return (balances_, tokenAmounts_);
    }

    function makeFee (uint256 _bal, uint256 _ideal) public view returns (uint256 _fee) {

        uint256 threshold;
        if (_bal < (threshold = wmul(_ideal, WAD-beta))) {
            _fee = wdiv(feeDerivative, _ideal);
            _fee = wmul(_fee, (threshold = sub(threshold, _bal)));
            _fee = wmul(_fee, threshold);
        } else if (_bal > (threshold = wmul(_ideal, WAD+beta))) {
            _fee = wdiv(feeDerivative, _ideal);
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

        for (uint i = 0; i < reserves.length; i++) {
            Flavor memory _f = flavors[numeraires[i]];
            _amounts[i] = dIntakeNumeraire(_f.adapter, wmul(_f.weight, _deposit));
        }

        _mint(msg.sender, (_deposit = wmul(_deposit, WAD-(feeBase/2))));

        emit ShellsMinted(msg.sender, _deposit, numeraires, _amounts);

        return _deposit;

    }

    /// @author james foley http://github.com/realisation
    /// @notice this function takes a total amount to from the the pool with no slippage from the numeraire assets of the pool
    /// @param _withdrawal the full amount you want to withdraw from the pool which will be withdrawn from evenly amongst the numeraire assets of the pool
    /// @return withdrawnAmts_ the amount withdrawn from each of the numeraire assets
    function proportionalWithdraw (uint256 _withdrawal) public returns (uint256[] memory) {

        require((_withdrawal = wmul(_withdrawal, WAD+(feeBase/2))) <= balances[msg.sender], "withdrawal amount exceeds your balance");

        uint256 _withdrawMultiplier = wdiv(_withdrawal, totalSupply);

        _burn(msg.sender, _withdrawal);

        uint256[] memory withdrawalAmts_ = new uint256[](reserves.length);
        for (uint i = 0; i < reserves.length; i++) {
            uint256 _proportionateValue = wmul(wmul(dGetNumeraireBalance(reserves[i]), _withdrawMultiplier), WAD-feeBase);
            Flavor memory _f = flavors[numeraires[i]];
            withdrawalAmts_[i] = dOutputNumeraire(_f.adapter, msg.sender, _proportionateValue);
        }

        emit ShellsBurned(msg.sender, _withdrawal, numeraires, withdrawalAmts_);

        return withdrawalAmts_;

    }

    function totalReserves (address[] calldata _reserves, address _addr) external view returns (uint256, uint256[] memory) {
        uint256 totalBalance;
        uint256[] memory balances = new uint256[](_reserves.length);
        for (uint i = 0; i < _reserves.length; i++) {
            balances[i] = dViewNumeraireBalance(_reserves[i], _addr);
            totalBalance += balances[i];
        }
        return (totalBalance, balances);
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