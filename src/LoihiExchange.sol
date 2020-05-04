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
import "./LoihiMath.sol";

library LoihiExchange {

    using LoihiDelegators for address;
    using LoihiMath for uint256;
    
    event Trade(address indexed trader, address indexed origin, address indexed target, uint256 originAmount, uint256 targetAmount);

    uint256 constant OCTOPUS = 1e18;

    event log_uint(bytes32, uint256);
    event log_addr(bytes32, address);
    event log_uints(bytes32, uint256[]);
    event log_addrs(bytes32, address[]);

    /// @dev executes the origin trade. refer to Loihi.bin swapByOrigin and transferByOrigin for detailed explanation of paramters
    /// @return tAmt_ the target amount
    function executeOriginTrade (LoihiRoot.Shell storage shell, address _origin, address _target, uint256 _oAmt, uint256 _mTAmt, uint256 _dline, address _rcpnt) internal returns (uint256 tAmt_) {
        emit log_uint("deadline", _dline);
        require(_dline >= now, "deadline has passed for this trade");

        LoihiRoot.Assimilator memory _o = shell.assimilators[_origin];
        LoihiRoot.Assimilator memory _t = shell.assimilators[_target];


        require(_o.addr != address(0), "origin flavor not supported");
        require(_t.addr != address(0), "target flavor not supported");

        if (_o.ix == _t.ix) {
            uint256 _oNAmt = _o.addr.intakeRaw(_oAmt);
            uint256 tAmt_ = _t.addr.outputNumeraire(_rcpnt, _oNAmt);
            emit Trade(msg.sender, _origin, _target, _oAmt, tAmt_);
            return tAmt_;
        }


        ( uint256[] memory _balances, uint256 _grossLiq ) = getBalancesAndGrossLiq(shell);

        uint256 _oNAmt = _o.addr.intakeRaw(_oAmt);

        ( tAmt_, shell.omega ) = calculateTargetAmount(shell, _o.ix, _t.ix, _oNAmt, _balances, _grossLiq);

        tAmt_ = _t.addr.outputNumeraire(_rcpnt, tAmt_);

        require(tAmt_ >= _mTAmt, "target amount is less than min target amount");

        emit Trade(msg.sender, _origin, _target, _oAmt, tAmt_);

        return tAmt_;

    }

    function viewOriginTrade (LoihiRoot.Shell storage shell, address _origin, address _target, uint256 _oAmt) internal returns (uint256) {

        LoihiRoot.Assimilator memory _o = shell.assimilators[_origin];
        LoihiRoot.Assimilator memory _t = shell.assimilators[_target];

        require(_o.addr != address(0), "origin flavor not supported");
        require(_t.addr != address(0), "target flavor not supported");

        if (_o.ix == _t.ix) {
            uint256 _oNAmt = _o.addr.viewNumeraireAmount(_oAmt);
            return _t.addr.viewRawAmount(_oNAmt);
        }

        ( uint256[] memory _balances, uint256 _grossLiq ) = getBalancesAndGrossLiq(shell);

        uint256 _oNAmt = _o.addr.viewNumeraireAmount(_oAmt);

        ( uint256 _tNAmt, ) = calculateTargetAmount(shell, _o.ix, _t.ix, _oNAmt, _balances, _grossLiq);

        return _t.addr.viewRawAmount(_tNAmt);

    }

    /// @dev executes the target trade. refer to Loihi.bin swapByTarget and transferByTarget for detailed explanation of parameters
    /// @return oAmt_ origin amount
    function executeTargetTrade (LoihiRoot.Shell storage shell, address _origin, address _target, uint256 _maxOAmt, uint256 _tAmt, uint256 _dline, address _recipient) internal returns (uint256 oAmt_) {
        require(_dline >= now, "deadline has passed for this trade");

        LoihiRoot.Assimilator memory _o = shell.assimilators[_origin];
        LoihiRoot.Assimilator memory _t = shell.assimilators[_target];

        require(_o.addr != address(0), "origin flavor not supported");
        require(_t.addr != address(0), "target flavor not supported");

        if (_o.ix == _t.ix) {
            uint256 _tNAmt = _t.addr.outputRaw(_recipient, _tAmt);
            uint256 oAmt_ = _o.addr.intakeNumeraire(_tNAmt);
            emit Trade(msg.sender, _origin, _target, oAmt_, _tAmt);
            return oAmt_;
        }

        ( uint256[] memory _balances, uint256 _grossLiq ) = getBalancesAndGrossLiq(shell);

        uint256 _tNAmt = _t.addr.outputRaw(_recipient, _tAmt);

        ( oAmt_, shell.omega ) = calculateOriginAmount(shell, _o.ix, _t.ix, _tNAmt, _balances, _grossLiq);

        oAmt_ = _o.addr.intakeNumeraire(oAmt_);

        require(oAmt_ <= _maxOAmt, "origin amount is greater than max origin amount");

        emit Trade(msg.sender, _origin, _target, oAmt_, _tAmt);

        return oAmt_;

    }

    function viewTargetTrade (LoihiRoot.Shell storage shell, address _origin, address _target, uint256 _tAmt) internal returns (uint256) {

        LoihiRoot.Assimilator memory _o = shell.assimilators[_origin];
        LoihiRoot.Assimilator memory _t = shell.assimilators[_target];

        require(_o.addr != address(0), "origin flavor not supported");
        require(_t.addr != address(0), "target flavor not supported");

        if (_o.ix == _t.ix) {
            uint256 _tNAmt = _t.addr.viewNumeraireAmount(_tAmt);
            return _o.addr.viewRawAmount(_tNAmt);
        }

        ( uint256[] memory _balances, uint256 _grossLiq ) = getBalancesAndGrossLiq(shell);

        uint256 _tNAmt = _t.addr.viewNumeraireAmount(_tAmt);

        ( uint256 _oNAmt, ) = calculateOriginAmount(shell, _o.ix, _t.ix, _tNAmt, _balances, _grossLiq);

        return _o.addr.viewRawAmount(_oNAmt);

    }


    /// @dev this function figures out the origin amount
    /// @return tNAmt_ target amount
    function calculateTargetAmount (LoihiRoot.Shell storage shell, uint8 _oIndex, uint8 _tIndex, uint256 _oNAmt, uint256[] memory _balances, uint256 _grossLiq) internal returns (uint256 tNAmt_, uint256 psi_) {

        emit log_uint("o index", uint256(_oIndex));
        emit log_uint("t index", _tIndex);

        emit log_addrs("shell.numeraires", shell.numeraires);
        emit log_addrs("shell.reserves", shell.reserves);

        emit log_uint("shell.alpha", shell.alpha);
        emit log_uint("shell.beta", shell.beta);
        emit log_uint("shell.delta", shell.delta);
        emit log_uint("shell.epsilon", shell.epsilon);
        emit log_uint("shell.lambda", shell.lambda);
        emit log_uint("shell.omega", shell.omega);
        emit log_uints("shell.weights", shell.weights);

        tNAmt_ = _oNAmt.omul(OCTOPUS - shell.epsilon);

        emit log_uint("tNAmt_", tNAmt_);

        uint256 _oNFAmt = tNAmt_;
        uint256 _nGLiq;
        for (uint8 j = 0; j < 10; j++) {

            emit log_uint("tNAmt_", tNAmt_);

            psi_ = 0;
            _nGLiq = _grossLiq + _oNAmt - tNAmt_;

            for (uint8 i = 0; i < shell.reserves.length; i++) {

                uint256 _bal;
                uint256 _nIdeal = _nGLiq.omul(shell.weights[i]);

                if (i == _oIndex) _bal = _balances[i] + _oNAmt;
                else if (i == _tIndex) _bal = _balances[i] - tNAmt_;
                else _bal = _balances[i];

                psi_ += makeFee(shell, _bal, _nIdeal);

            }


            if (shell.omega < psi_) { // 32.7k gas savings against 10^13/10^14 vs 10^10
                if ((tNAmt_ = _oNFAmt + shell.omega - psi_) / 1e14 == tNAmt_ / 1e14) break;
            } else {
                if ((tNAmt_ = _oNFAmt + shell.lambda.omul(shell.omega - psi_)) / 1e14 == tNAmt_ / 1e14) break;
            }

        }

        {
            uint256 _alpha = shell.alpha; // 400-800 gas savings
            for (uint8 i = 0; i < _balances.length; i++) {

                if (i == _oIndex) {
                    require(_balances[i].add(_oNAmt) < _nGLiq.omul(shell.weights[i]).omul(OCTOPUS + _alpha), "origin halt check");
                    continue; // 480 - 1415 gas savings
                } else if (i == _tIndex) {
                    
                    emit log_uint("octopus", OCTOPUS);
                    emit log_uint("alpha", _alpha);
                    emit log_uint("balances[i]", _balances[i]);
                    emit log_uint("tNAmt_", tNAmt_);
                    emit log_uint("new bal", _balances[i].sub(tNAmt_));
                    emit log_uint("new ideal", _nGLiq.omul(shell.weights[i]));
                    emit log_uint("new lower alpha", _nGLiq.omul(shell.weights[i]).omul(OCTOPUS - _alpha));

                    require(_balances[i].sub(tNAmt_) > _nGLiq.omul(shell.weights[i]).omul(OCTOPUS - _alpha), "target halt check");
                }

            }
        }

        tNAmt_ = tNAmt_.omul(OCTOPUS - shell.epsilon);

    }

    /// @dev this function figures out the origin amount
    /// @return oNAmt_ origin amount
    function calculateOriginAmount (LoihiRoot.Shell storage shell, uint8 _oIndex, uint8 _tIndex, uint256 _tNAmt, uint256[] memory _balances, uint256 _grossLiq) internal returns (uint256 oNAmt_, uint256 psi_) {

        oNAmt_ = _tNAmt.omul(OCTOPUS + shell.epsilon);

        uint256 _tNFAmt = oNAmt_;
        uint256 _nGLiq;
        for (uint8 j = 0; j < 10; j++) {

            psi_ = 0;
            _nGLiq = _grossLiq + oNAmt_ - _tNAmt;

            for (uint8 i = 0; i < shell.reserves.length; i++) {

                uint256 _bal;
                uint256 _nIdeal = _nGLiq.omul(shell.weights[i]);

                if (i == _oIndex) _bal = _balances[i] + oNAmt_;
                else if (i == _tIndex) _bal = _balances[i] - _tNAmt;
                else _bal = _balances[i];

                psi_ += makeFee(shell, _bal, _nIdeal);

            }

            if (shell.omega < psi_) {
                if ((oNAmt_ = _tNFAmt + psi_ - shell.omega) / 1e14 == oNAmt_ / 1e14) break;
            } else {
                if ((oNAmt_ = _tNFAmt - shell.lambda.omul(shell.omega - psi_)) / 1e14 == oNAmt_ / 1e14) break;
            }

        }

        {
            uint256 _alpha = shell.alpha;
            for (uint8 i = 0; i < _balances.length; i++) {
                if (i == _oIndex) {
                    require(_balances[i].add(oNAmt_) < _nGLiq.omul(shell.weights[i]).omul(OCTOPUS + _alpha), "origin halt check");
                    continue;
                } else if (i == _tIndex) require(_balances[i].sub(_tNAmt) > _nGLiq.omul(shell.weights[i]).omul(OCTOPUS - _alpha), "target halt check");
            }
        }

        oNAmt_ = oNAmt_.omul(OCTOPUS + shell.epsilon);

    }

    /// @notice this function makes our fees!
    /// @return fee_ the fee.
    function makeFee (LoihiRoot.Shell storage shell, uint256 _bal, uint256 _ideal) internal view returns (uint256 fee_) {

        uint256 _threshold;
        uint256 _beta = shell.beta;
        uint256 _delta = shell.delta;
        if (_bal < (_threshold = _ideal.omul(OCTOPUS-_beta))) {
            fee_ = _delta.odiv(_ideal);
            fee_ = fee_.omul(_threshold = _threshold.sub(_bal));
            fee_ = fee_.omul(_threshold);
        } else if (_bal > (_threshold = _ideal.omul(OCTOPUS+_beta))) {
            fee_ = _delta.odiv(_ideal);
            fee_ = fee_.omul(_threshold = _bal.sub(_threshold));
            fee_ = fee_.omul(_threshold);
        } else fee_ = 0;

    }

    function getBalancesAndGrossLiq (LoihiRoot.Shell storage shell) internal view returns (uint256[] memory, uint256 grossLiq_) {
        uint256[] memory balances_ = new uint256[](shell.reserves.length);
        for (uint8 i = 0; i < shell.reserves.length; i++) {
            balances_[i] = shell.reserves[i].viewNumeraireBalance(address(this));
            grossLiq_ = grossLiq_.add(balances_[i]);
        }
        return (balances_, grossLiq_);
    }

}