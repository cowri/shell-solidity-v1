pragma solidity ^0.5.12;

import "./LoihiRoot.sol";
import "./ChaiI.sol";
import "./CTokenI.sol";
import "./ERC20I.sol";
import "./BadERC20I.sol";
import "./PotI.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract Loihi is LoihiRoot {

    ChaiI chai;
    CTokenI cdai;
    ERC20I dai;
    PotI pot;
    CTokenI cusdc;
    ERC20I usdc;
    IERC20 usdt;

    constructor (address _chai, address _cdai, address _dai, address _pot, address _cusdc, address _usdc, address _usdt) public {
        chai = ChaiI(_chai);
        cdai = CTokenI(_cdai);
        dai = ERC20I(_dai);
        pot = PotI(_pot);
        cusdc = CTokenI(_cusdc);
        usdc = ERC20I(_usdc);
        usdt = IERC20(_usdt);
    }

    function fakeMint (uint256 amount) public {
        _mint(msg.sender, amount);
    }

    function setAlpha (uint256 _alpha) public {
        alpha = _alpha;
    }

    function setBeta (uint256 _beta) public {
        beta = _beta;
    }

    function setFeeDerivative (uint256 _feeDerivative) public {
        feeDerivative = _feeDerivative;
    }

    function setFeeBase (uint256 _feeBase) public {
        feeBase = _feeBase;
    }

    function includeNumeraireAndReserve (address numeraire, address reserve) public {
        numeraires.push(numeraire);
        reserves.push(reserve);
    }

    function includeAdapter (address flavor, address adapter, address reserve, uint256 weight) public {
        flavors[flavor] = Flavor(adapter, reserve, weight);
    }

    function excludeAdapter (address flavor) public {
        delete flavors[flavor];
    }

    function dGetNumeraireAmount (address addr, uint256 amount) internal returns (uint256) {
        (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSignature("getNumeraireAmount(uint256)", amount));
        assert(success);
        return abi.decode(result, (uint256));
    }

    function dGetNumeraireBalance (address addr) internal returns (uint256) {
        (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSignature("getNumeraireBalance()"));
        assert(success);
        return abi.decode(result, (uint256));
    }

    function dIntakeRaw (address addr, uint256 amount) internal {
        (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSignature("intakeRaw(uint256)", amount));
        assert(success);
    }

    function dIntakeNumeraire (address addr, uint256 amount) internal returns (uint256) {
        (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSignature("intakeNumeraire(uint256)", amount));
        assert(success);
        return abi.decode(result, (uint256));
    }

    function dOutputRaw (address addr, address dst, uint256 amount) internal returns (uint256) {
        (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSignature("outputRaw(address,uint256)", dst, amount));
        assert(success);
        return abi.decode(result, (uint256));
    }


    function dOutputNumeraire (address addr, address dst, uint256 amount) internal returns (uint256) {
        (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSignature("outputNumeraire(address,uint256)", dst, amount));
        assert(success);
        return abi.decode(result, (uint256));
    }

    function swapByTarget (address origin, uint256 maxOriginAmount, address target, uint256 targetAmount, uint256 deadline) public returns (uint256) {
        return executeTargetTrade(origin, target, maxOriginAmount, targetAmount, deadline, msg.sender);
    }
    function transferByTarget (address origin, uint256 maxOriginAmount, address target, uint256 targetAmount, uint256 deadline, address recipient) public returns (uint256) {
        return executeTargetTrade(origin, target, maxOriginAmount, targetAmount, deadline, recipient);
    }
    function swapByOrigin (address origin, uint256 originAmount, address target, uint256 minTargetAmount, uint256 deadline) public returns (uint256) {
        return executeOriginTrade(origin, target, originAmount, minTargetAmount, deadline, msg.sender);
    }
    function transferByOrigin (address origin, uint256 originAmount, address target, uint256 minTargetAmount, uint256 deadline, address recipient) public returns (uint256) {
        return executeOriginTrade(origin, target, originAmount, minTargetAmount, deadline, recipient);
    }

    event log(string);
    event log_address(bytes32, address);
    event log_uint(bytes32, uint256);

    function executeOriginTrade (address _origin, address _target, uint256 _oAmt, uint256 _minTargetAmount, uint256 _deadline, address _recipient) public returns (uint256) {

        Flavor memory _o = flavors[_origin]; // origin adapter + weight
        Flavor memory _t = flavors[_target]; // target adapter + weight

        ( uint256 _oNAmt,
          uint256 _oPool,
          uint256 _tPool,
          uint256 _tNAmt,
          uint256 _grossLiq ) = getOriginTradeVariables(_o, _t, _oAmt);

        _oNAmt = calculateOriginTradeOriginAmount(_o.weight, _oPool, _oNAmt, _grossLiq);
        _tNAmt = _oNAmt;
        uint256 tNAmt_ = calculateOriginTradeTargetAmount(_t.weight, _tPool, _tNAmt, _grossLiq);

        // dIntakeRaw(o.adapter, oAmt);
        // dOutputNumeraire(t.adapter, recipient, tNAmt);
        return tNAmt_;

    }

    function getOriginTradeVariables (Flavor memory _o, Flavor memory _t, uint256 _oAmt) private returns (uint, uint, uint, uint, uint) {

        uint oNAmt_;
        uint oPool_;
        uint tPool_;
        uint tNAmt_;
        uint grossLiq_;

        for (uint i = 0; i < reserves.length; i++) {
            if (reserves[i] == _o.reserve) {
                oNAmt_ = dGetNumeraireAmount(_o.adapter, _oAmt);
                oPool_ = dGetNumeraireBalance(_o.adapter);
                grossLiq_ += oPool_;
                oPool_ = add(oPool_, oNAmt_);
            } else if (reserves[i] == _t.reserve) {
                tPool_ = dGetNumeraireBalance(_t.adapter);
                grossLiq_ += tPool_;
            } else grossLiq_ += dGetNumeraireBalance(reserves[i]);
        }

        return (oNAmt_, oPool_, tPool_, tNAmt_, grossLiq_);

    }

    function calculateOriginTradeOriginAmount (uint256 _oWeight, uint256 _oPool, uint256 _oNAmt, uint256 _grossLiq) private returns (uint256) {

        require(_oPool <= wmul(_oWeight, wmul(_grossLiq, alpha + WAD)), "origin swap origin halt check");

        uint256 oNAmt_;

        uint256 _feeThreshold = wmul(_oWeight, wmul(_grossLiq, beta + WAD));
        if (_oPool < _feeThreshold) {

            oNAmt_ = _oNAmt;

        } else if (sub(_oPool, _oNAmt) >= _feeThreshold) {

            uint256 _fee = wdiv(
                sub(_oPool, _feeThreshold),
                wmul(_oWeight, _grossLiq)
            );
            _fee = wmul(_fee, feeDerivative);
            oNAmt_ = wmul(_oNAmt, WAD - _fee);

        } else {

            uint256 _fee = wmul(feeDerivative, wdiv(
                sub(_oPool, _feeThreshold),
                wmul(_oWeight, _grossLiq)
            ));
            oNAmt_ = add(
                sub(_feeThreshold, sub(_oPool, _oNAmt)),
                wmul(sub(_oPool, _feeThreshold), WAD - _fee)
            );

        }

        return oNAmt_;

    }

    function calculateOriginTradeTargetAmount (uint256 _tWeight, uint256 _tPool, uint256 _tNAmt, uint256 _grossLiq) private returns (uint256) {

        require(sub(_tPool, _tNAmt) >= wmul(_tWeight, wmul(_grossLiq, WAD - alpha)), "target swap halt check");

        uint256 tNAmt_;

        uint256 _feeThreshold = wmul(_tWeight, wmul(_grossLiq, WAD - beta));
        if (sub(_tPool, _tNAmt) > _feeThreshold) {

            tNAmt_ = wmul(_tNAmt, WAD - feeBase);

        } else if (_tPool <= _feeThreshold) {

            uint256 _fee = wdiv(
                sub(_feeThreshold, sub(_tPool, _tNAmt)),
                wmul(_tWeight, _grossLiq)
            );
            _fee = wmul(_fee, feeDerivative);
            _tNAmt = wmul(_tNAmt, WAD - _fee);
            tNAmt_ = wmul(_tNAmt, WAD - feeBase);

        } else {

            uint256 _fee = wmul(feeDerivative, wdiv(
                sub(_feeThreshold, sub(_tPool, _tNAmt)),
                wmul(_tWeight, _grossLiq)
            ));
            tNAmt_ = wmul(add(
                sub(_tPool, _feeThreshold),
                wmul(sub(_feeThreshold, sub(_tPool, _tNAmt)), WAD - _fee)
            ), WAD - feeBase);

        }

        return tNAmt_;

    }



    function executeTargetTrade (address _origin, address _target, uint256 _maxOriginAmount, uint256 _tAmt, uint256 _deadline, address _recipient) public returns (uint256) {

        Flavor memory _o = flavors[_origin];
        Flavor memory _t = flavors[_target];

        ( uint256 _oNAmt,
          uint256 _oPool,
          uint256 _tPool,
          uint256 _tNAmt,
          uint256 _grossLiq ) = getTargetTradeVariables(_o, _t, _tAmt) ;

        _oNAmt = calculateTargetTradeTargetAmount(_t.weight, _tPool, _tNAmt, _grossLiq);
        uint256 oNAmt_ = calculateTargetTradeOriginAmount(_o.weight, _oPool, _oNAmt, _grossLiq);

        // dOutputNumeraire(_tAdapter, recipient, tNAmt);
        // dIntakeNumeraire(_oAdapter, oNAmt);
        return oNAmt_;

    }

    function getTargetTradeVariables (Flavor memory _o, Flavor memory _t, uint256 _tAmt) private returns (uint, uint, uint, uint, uint) {

        uint tNAmt_;
        uint tPool_;
        uint oPool_;
        uint oNAmt_;
        uint grossLiq_;

        for (uint i = 0; i < reserves.length; i++) {
            if (reserves[i] == _o.reserve) {
                oPool_ = dGetNumeraireBalance(_o.adapter);
                grossLiq_ += oPool_;
            } else if (reserves[i] == _t.reserve) {
                tNAmt_ = dGetNumeraireAmount(_t.adapter, _tAmt);
                tPool_ = dGetNumeraireBalance(_t.adapter);
                grossLiq_ += tPool_;
                tPool_ = sub(tPool_, tNAmt_);
            } else grossLiq_ += dGetNumeraireBalance(reserves[i]);
        }

        return (oNAmt_, oPool_, tPool_, tNAmt_, grossLiq_);

    }

    function calculateTargetTradeTargetAmount(uint256 _tWeight, uint256 _tPool, uint256 _tNAmt, uint256 _grossLiq) public returns (uint256 tNAmt_) {

        require(_tPool >= wmul(_tWeight, wmul(_grossLiq, WAD - alpha)), "target halt check for target trade");

        uint256 _feeThreshold = wmul(_tWeight, wmul(_grossLiq, WAD - beta));
        if (_tPool > _feeThreshold) {

            tNAmt_ = wmul(_tNAmt, WAD + feeBase);

        } else if (add(_tPool, _tNAmt) <= _feeThreshold) {

            uint256 _fee = wdiv(sub(_feeThreshold, _tPool), wmul(_tWeight, _grossLiq));
            _fee = wmul(_fee, feeDerivative);
            _tNAmt = wmul(_tNAmt, WAD + _fee);
            tNAmt_ = wmul(_tNAmt, WAD + feeBase);

        } else {

            uint256 _fee = wmul(feeDerivative, wdiv(
                    sub(_feeThreshold, _tPool),
                    wmul(_tWeight, _grossLiq)
            ));

            _tNAmt = add(
                sub(add(_tPool, _tNAmt), _feeThreshold),
                wmul(sub(_feeThreshold, _tPool), WAD + _fee)
            );

            tNAmt_ = wmul(_tNAmt, WAD + feeBase);

        }

        return tNAmt_;

    }

    function calculateTargetTradeOriginAmount (uint256 _oWeight, uint256 _oPool, uint256 _oNAmt, uint256 _grossLiq) public returns (uint256 oNAmt_) {

        require(add(_oPool, _oNAmt) <= wmul(_oWeight, wmul(_grossLiq, WAD + alpha)), "origin halt check for target trade");

        uint256 _feeThreshold = wmul(_oWeight, wmul(_grossLiq, WAD + beta));
        if (_oPool + _oNAmt <= _feeThreshold) {

            oNAmt_ = _oNAmt;

        } else if (_oPool >= _feeThreshold) {

            uint256 _fee = wdiv(
                sub(add(_oNAmt, _oPool), _feeThreshold),
                wmul(_oWeight, _grossLiq)
            );
            _fee = wmul(_fee, feeDerivative);
            oNAmt_ = wmul(_oNAmt, WAD + _fee);

        } else {

            uint256 _fee = wmul(feeDerivative, wdiv(
                sub(add(_oPool, _oNAmt), _feeThreshold),
                wmul(_oWeight, _grossLiq)
            ));

            oNAmt_ = add(
                sub(_feeThreshold, _oPool),
                wmul(sub(add(_oPool, _oNAmt), _feeThreshold), WAD + _fee)
            );

        }

        return oNAmt_;

    }

    event log_address_arr(bytes32, address[]);
    event log_uint_arr(bytes32, uint256[]);

    function getBalancesTokenAmountsAndWeights (address[] memory _flavors, uint256[] memory _amounts) internal returns (uint256[] memory, uint256[] memory, uint256[] memory) {

        uint256[] memory balances_ = new uint256[](reserves.length);
        uint256[] memory tokenAmounts_ = new uint256[](reserves.length);
        uint256[] memory weights_ = new uint[](reserves.length);

        for (uint i = 0; i < _flavors.length; i++) {
            Flavor memory _f = flavors[_flavors[i]]; // withdrawing adapter + weight
            for (uint j = 0; j < reserves.length; j++) {
                if (reserves[j] == _f.reserve) {
                    if (balances_[j] == 0) {
                        balances_[j] = dGetNumeraireBalance(_f.adapter);
                        tokenAmounts_[j] = dGetNumeraireAmount(_f.adapter, _amounts[i]);
                        weights_[j] = _f.weight;
                        break;
                    } else {
                        tokenAmounts_[j] += dGetNumeraireAmount(_f.adapter, _amounts[i]);
                        break;
                    }
                }
            }
        }

        return (balances_, tokenAmounts_, weights_);

    }

    function selectiveDeposit (address[] calldata _flavors, uint256[] calldata _amounts) external returns (uint256) {

        ( uint256[] memory _balances,
          uint256[] memory _deposits,
          uint256[] memory _weights ) = getBalancesTokenAmountsAndWeights(_flavors, _amounts);

        uint256 shellsToMint_ = calculateShellsToMint(_balances, _deposits, _weights);

        for (uint i = 0; i < _flavors.length; i++) {
            if (_amounts[i] == 0) continue;
            dIntakeNumeraire(flavors[_flavors[i]].adapter, _amounts[i]);
        }

        _mint(msg.sender, shellsToMint_);

        return shellsToMint_;

    }

    function calculateShellsToMint (uint256[] memory _balances, uint256[] memory _deposits, uint256[] memory _weights) public returns (uint256) {

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

            } else if (_oldBalance > _feeThreshold) {

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

        return wmul(shellsToMint_, wdiv(_oldSum, totalSupply()));

    }

    function selectiveWithdraw (address[] calldata _flavors, uint256[] calldata _amounts) external returns (uint256) {

        ( uint256[] memory _balances,
          uint256[] memory _withdrawals,
          uint256[] memory _weights ) = getBalancesTokenAmountsAndWeights(_flavors, _amounts);

        uint256 shellsBurned_ = calculateShellsToBurn(_balances, _withdrawals, _weights);

        // for (uint i = 0; i < _flavors.length; i++) dOutputNumeraire(flavors[_flavors[i]].adapter, msg.sender, _amounts[i]);

        _burn(msg.sender, shellsBurned_);

        return shellsBurned_;

    }

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

            } else if (_oldBal < _feeThreshold) {

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

        return wmul(_numeraireShellsToBurn, wdiv(_oldSum, totalSupply()));

    }


    function proportionalDeposit (uint256 totalDeposit) public returns (uint256) {

        uint256 totalBalance;
        uint256 _totalSupply = totalSupply();

        uint256[] memory amounts = new uint256[](3);

        for (uint i = 0; i < reserves.length; i++) {
            uint256 numeBalance = dGetNumeraireBalance(reserves[i]);
            totalBalance += numeBalance;
            Flavor memory d = flavors[numeraires[i]];
            amounts[i] = wmul(d.weight, totalDeposit);
        }

        if (totalBalance == 0) {
            totalBalance = WAD;
            _totalSupply = WAD;
        }

        uint256 newShells = wmul(totalDeposit, wdiv(totalBalance, _totalSupply));
        _mint(msg.sender, newShells);

        for (uint i = 0; i < reserves.length; i++ ) {
            Flavor memory d = flavors[numeraires[i]];
            dIntakeNumeraire(d.adapter, amounts[i]);
        }

        return newShells;

    }


    function proportionalWithdraw (uint256 totalWithdrawal) public returns (uint256[] memory) {

        uint256[] memory withdrawalAmounts = new uint256[](reserves.length);
        uint256 shellsToBurn = wmul(totalWithdrawal, WAD + feeBase);

        uint256 oldTotal;
        for (uint i = 0; i < reserves.length; i++) {
            withdrawalAmounts[i] = dGetNumeraireBalance(reserves[i]);
            oldTotal += withdrawalAmounts[i];
        }


        for (uint i = 0; i < reserves.length; i++) {
            Flavor storage w = flavors[numeraires[i]];
            uint256 numeraireToWithdraw = wmul(totalWithdrawal, wdiv(withdrawalAmounts[i], oldTotal));
            // uint256 numeraireToWithdraw = wdiv(withdrawalAmounts[i], wmul(oldTotal, totalWithdrawal));
            uint256 amountWithdrawn = dOutputNumeraire(w.adapter, msg.sender, numeraireToWithdraw);
            withdrawalAmounts[i] = amountWithdrawn;
        }


        _burnFrom(msg.sender, shellsToBurn);
        return withdrawalAmounts;

    }


}