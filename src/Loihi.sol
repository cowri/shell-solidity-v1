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
    function executeOriginTrade (address origin, address target, uint256 oAmt, uint256 minTargetAmount, uint256 deadline, address recipient) public returns (uint256) {

        uint256 oNAmt; // origin numeraire amount
        uint256 oPool; // origin pool balance
        uint256 tPool; // target pool balance
        uint256 tNAmt; // target numeraire swap amount
        uint256 grossLiq; // total liquidity in all coins
        Flavor memory o = flavors[origin]; // origin adapter + weight
        Flavor memory t = flavors[target]; // target adapter + weight

        for (uint i = 0; i < reserves.length; i++) {
            if (reserves[i] == o.reserve) {
                oNAmt = dGetNumeraireAmount(o.adapter, oAmt);
                uint256 oNBalance = dGetNumeraireBalance(o.adapter);
                oPool = add(oNBalance, oNAmt);
                grossLiq += oNBalance;
            } else if (reserves[i] == t.reserve) {
                tPool = dGetNumeraireBalance(t.adapter);
                grossLiq += tPool;
            } else {
                uint256 otherNBalance = dGetNumeraireBalance(reserves[i]);
                grossLiq += otherNBalance;
            }
        }

        require(oPool <= wmul(o.weight, wmul(grossLiq, alpha + WAD)), "origin swap origin halt check");

        uint256 feeThreshold = wmul(o.weight, wmul(grossLiq, beta + WAD));
        if (oPool < feeThreshold) {
        } else if (sub(oPool, oNAmt) >= feeThreshold) {
            uint256 fee = wdiv(sub(oPool, feeThreshold), wmul(o.weight, grossLiq));
            fee = wmul(fee, feeDerivative);
            oNAmt = wmul(oAmt, WAD - fee);
        } else {
            uint256 oldBalance = sub(oPool, oNAmt);
            uint256 fee = wmul(feeDerivative, wdiv(
                sub(oPool, feeThreshold),
                wmul(o.weight, grossLiq)
            ));
            oNAmt = add(
                sub(feeThreshold, oldBalance),
                wmul(sub(oPool, feeThreshold), WAD - fee)
            );
        }

        tNAmt = oNAmt;
        // TODO: move this after the calculation of tNAmt?
        require(sub(tPool, tNAmt) >= wmul(t.weight, wmul(grossLiq, WAD - alpha)), "target swap halt check");

        feeThreshold = wmul(t.weight, wmul(grossLiq, WAD - beta));
        if (sub(tPool, tNAmt) > feeThreshold) {
            tNAmt = wmul(tNAmt, WAD - feeBase);
        } else if (tPool <= feeThreshold) {

            uint256 fee = wdiv(
                sub(feeThreshold, sub(tPool, tNAmt)),
                wmul(t.weight, grossLiq)
            );
            fee = wmul(fee, feeDerivative);
            // uint256 fee = wmul(feeDerivative, wdiv(tNAmt, wmul(t.weight, grossLiq)));
            tNAmt = wmul(tNAmt, WAD - fee);
            tNAmt = wmul(tNAmt, WAD - feeBase);
        } else {
            uint256 fee = wmul(feeDerivative, wdiv(
                sub(feeThreshold, sub(tPool, tNAmt)),
                wmul(t.weight, grossLiq)
            ));
            tNAmt = wmul(add(
                sub(tPool, feeThreshold),
                wmul(sub(feeThreshold, sub(tPool, tNAmt)), WAD - fee)
            ), WAD - feeBase);
        }

        // dIntakeRaw(o.adapter, oAmt);
        // dOutputNumeraire(t.adapter, recipient, tNAmt);
        return tNAmt;

    }

    function executeTargetTrade (address origin, address target, uint256 maxOriginAmount, uint256 tAmt, uint256 deadline, address recipient) public returns (uint256) {

        Flavor memory t = flavors[target]; // target adapter + weight
        Flavor memory o = flavors[origin]; // origin adapter + weight
        uint256 tNAmt; // target numeraire swap amount
        uint256 tPool; // target pool balance
        uint256 oPool; // origin pool balance
        uint256 oNAmt; // origin numeriare swap amount
        uint256 grossLiq; // gross liquidity

        for (uint i = 0; i < reserves.length; i++) {
            if (reserves[i] == o.reserve) {
                oPool = dGetNumeraireBalance(o.adapter);
                grossLiq += oPool;
            } else if (reserves[i] == t.reserve) {
                tNAmt = dGetNumeraireAmount(t.adapter, tAmt);
                uint256 tNBalance = dGetNumeraireBalance(t.adapter);
                tPool = sub(tNBalance, tNAmt);
                grossLiq += tNBalance;
            } else grossLiq += dGetNumeraireBalance(reserves[i]);
        }

        require(tPool >= wmul(t.weight, wmul(grossLiq, WAD - alpha)), "target halt check for target trade");

        uint256 feeThreshold = wmul(t.weight, wmul(grossLiq, WAD - beta));
        if (tPool > feeThreshold) {
            tNAmt = wmul(tNAmt, WAD + feeBase);
        } else if (add(tPool, tNAmt) <= feeThreshold) {
            uint256 fee = wdiv(sub(feeThreshold, tPool), wmul(t.weight, grossLiq));
            fee = wmul(fee, feeDerivative);
            tNAmt = wmul(tNAmt, WAD + fee);
            tNAmt = wmul(tNAmt, WAD + feeBase);
        } else {
            uint256 fee = wmul(feeDerivative, wdiv(
                    sub(feeThreshold, tPool),
                    wmul(t.weight, grossLiq)
            ));
            tNAmt = add(
                sub(add(tPool, tNAmt), feeThreshold),
                wmul(sub(feeThreshold, tPool), WAD + fee)
            );
            tNAmt = wmul(tNAmt, WAD + feeBase);
        }

        oNAmt = tNAmt;

        require(add(oPool, oNAmt) <= wmul(o.weight, wmul(grossLiq, WAD + alpha)), "origin halt check for target trade");

        feeThreshold = wmul(o.weight, wmul(grossLiq, WAD + beta));
        if (oPool + oNAmt <= feeThreshold) {

        } else if (oPool >= feeThreshold) {
            uint256 fee = wdiv(
                sub(add(oNAmt, oPool), feeThreshold),
                wmul(o.weight, grossLiq)
            );
            fee = wmul(fee, feeDerivative);
            oNAmt = wmul(oNAmt, WAD + fee);
        } else {

            uint256 fee = wmul(feeDerivative, wdiv(
                sub(add(oPool, oNAmt), feeThreshold),
                wmul(o.weight, grossLiq)
            ));
            oNAmt = add(
                sub(feeThreshold, oPool),
                wmul(sub(add(oPool, oNAmt), feeThreshold), WAD + fee)
            );
        }

        // dOutputNumeraire(t.adapter, recipient, tNAmt);
        // dIntakeNumeraire(o.adapter, oNAmt);
        return oNAmt;

    }

    event log_address_arr(bytes32, address[]);
    event log_uint_arr(bytes32, uint256[]);

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

                uint256 _feePrep = wmul(feeDerivative, wdiv(_depositAmount, wmul(_weight, _newSum)));
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


    function getBalancesTokenAmountsAndWeights (address[] memory _flavors, uint256[] memory _amounts) internal returns (uint256[] memory, uint256[] memory, uint256[] memory) {

        uint256[] memory balances = new uint256[](reserves.length);
        uint256[] memory tokenAmounts = new uint256[](reserves.length);
        uint256[] memory weights = new uint[](reserves.length);

        for (uint i = 0; i < _flavors.length; i++) {
            Flavor memory f = flavors[_flavors[i]]; // withdrawing adapter + weight
            for (uint j = 0; j < reserves.length; j++) {
                if (reserves[j] == f.reserve) {
                    if (balances[j] == 0) {
                        balances[j] = dGetNumeraireBalance(f.adapter);
                        tokenAmounts[j] = dGetNumeraireAmount(f.adapter, _amounts[i]);
                        weights[j] = f.weight;
                        break;
                    } else {
                        tokenAmounts[j] += dGetNumeraireAmount(f.adapter, _amounts[i]);
                        break;
                    }
                }
            }
        }

        return (balances, tokenAmounts, weights);

    }

    function calculateShellsToBurn (uint256[] memory balances, uint256[] memory tokenAmounts, uint256[] memory weights) internal returns (uint256) {

        uint256 newSum;
        uint256 oldSum;
        for (uint i = 0; i < balances.length; i++) {
            oldSum = add(oldSum, balances[i]);
            newSum = add(newSum, sub(balances[i], tokenAmounts[i]));
        }

        uint256 numeraireShellsToBurn;

        for (uint i = 0; i < reserves.length; i++) {
            if (tokenAmounts[i] == 0) continue;
            uint256 withdrawAmount = tokenAmounts[i];
            uint256 weight = weights[i];
            uint256 oldBalance = balances[i];
            uint256 newBalance = sub(oldBalance, withdrawAmount);

            require(newBalance >= wmul(weight, wmul(newSum, WAD - alpha)), "withdraw halt check");

            uint256 feeThreshold = wmul(weight, wmul(newSum, WAD - beta));

            if (newBalance >= feeThreshold) {

                numeraireShellsToBurn += wmul(withdrawAmount, WAD + feeBase);

            } else if (oldBalance < feeThreshold) {

                uint256 feePrep = wdiv(withdrawAmount, wmul(weight, newSum));
                feePrep = wmul(feePrep, feeDerivative);

                numeraireShellsToBurn += wmul(
                    wmul(withdrawAmount, WAD + feePrep),
                    WAD + feeBase
                );

            } else {

                uint256 feePrep = wdiv(sub(feeThreshold, newBalance), wmul(weight, newSum));
                feePrep = wmul(feeDerivative, feePrep);

                numeraireShellsToBurn += wmul(add(
                    sub(oldBalance, feeThreshold),
                    wmul(sub(feeThreshold, newBalance), WAD + feePrep)
                ), WAD + feeBase);

            }
        }

        return wmul(numeraireShellsToBurn, wdiv(oldSum, totalSupply()));

    }

    function selectiveWithdraw (address[] calldata _flavors, uint256[] calldata _amounts) external returns (uint256) {

        ( uint256[] memory balances,
          uint256[] memory withdrawals,
          uint256[] memory weights ) = getBalancesTokenAmountsAndWeights(_flavors, _amounts);

        uint256 shellsBurned = calculateShellsToBurn(balances, withdrawals, weights);

        // for (uint i = 0; i < _flavors.length; i++) dOutputNumeraire(flavors[_flavors[i]].adapter, msg.sender, _amounts[i]);

        _burn(msg.sender, shellsBurned);

        return shellsBurned;

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