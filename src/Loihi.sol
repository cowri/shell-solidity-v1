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

    function selectiveDeposit (address[] calldata _flavors, uint256[] calldata _amounts) external returns (uint256) {

        uint256 oldSum;
        uint256 newSum;
        uint256 newShells;
        // array segmented in spans of 3 elements
        // first for balance, second for deposit amount, third for weight
        uint256[] memory balances = new uint256[](reserves.length * 3);

        for (uint i = 0; i < _flavors.length; i++) {
            Flavor memory d = flavors[_flavors[i]]; // depositing adapter/weight
            for (uint j = 0; j < reserves.length; j++) {
                if (reserves[j] == d.reserve) {
                    if (balances[j*3] == 0) {
                        uint256 balance = dGetNumeraireBalance(d.adapter);
                        balances[j*3] = balance;
                        uint256 deposit = dGetNumeraireAmount(d.adapter, _amounts[i]);
                        balances[j*3+1] = deposit;
                        balances[j*3+2] = d.weight;
                        newSum = add(balance + deposit, newSum);
                        oldSum += balance;
                        break;
                    } else {
                        uint256 deposit = dGetNumeraireAmount(d.adapter, _amounts[i]);
                        balances[j*3+1] = add(deposit, balances[j*3+1]);
                        newSum = add(deposit, newSum);
                        break;
                    }
                    break;
                }
            }
        }

        for (uint i = 0; i < balances.length; i += 3) {

            uint256 depositAmount = balances[i+1];
            if (depositAmount == 0) continue;

            uint256 oldBalance = balances[i];
            uint256 newBalance = add(oldBalance, depositAmount);

            require(newBalance <= wmul(balances[i+2], wmul(newSum, alpha + WAD)), "halt check deposit");

            uint256 feeThreshold = wmul(balances[i+2], wmul(newSum, beta + WAD));
            if (newBalance <= feeThreshold) {
                newShells += depositAmount;
            } else if (oldBalance > feeThreshold) {
                uint256 feePrep = wmul(feeDerivative, wdiv(depositAmount, wmul(balances[i+2], newSum)));
                newShells = add(newShells, WAD - feePrep);
            } else {
                uint256 feePrep = wmul(feeDerivative, wdiv(
                    sub(newBalance, feeThreshold),
                    wmul(balances[i+2], newSum)
                ));
                newShells += add(
                    sub(feeThreshold, oldBalance),
                    wmul(sub(newBalance, feeThreshold), WAD - feePrep)
                );
        } }

        newShells = wmul(newShells, wdiv(oldSum, totalSupply()));

        // for (uint i = 0; i < _flavors.length; i++) dIntakeNumeraire(_flavors[i], _amounts[i]);

        _mint(msg.sender, newShells);
        return newShells;

    }

    function selectiveWithdraw (address[] calldata _flavors, uint256[] calldata _amounts) external returns (uint256) {

        uint256 newSum;
        uint256 oldSum;
        uint256 shellsBurned;
        // segmented array in spans of 3 elements
        // 1st for balance, 2nd for withdrawals, 3rd for weight
        uint256[] memory balances = new uint256[](reserves.length * 3);
        for (uint i = 0; i < _flavors.length; i++) {
            Flavor memory w = flavors[_flavors[i]]; // withdrawing adapter + weight
            for (uint j = 0; j < reserves.length; j++) {
                if (reserves[j] == w.reserve) {
                    if (balances[j*3] == 0) {
                        uint256 balance = dGetNumeraireBalance(w.adapter);
                        balances[j*3] = balance;
                        uint256 withdrawal = dGetNumeraireAmount(w.adapter, _amounts[i]);
                        balances[j*3+1] = withdrawal;
                        balances[j*3+2] = w.weight;
                        newSum = add(newSum, sub(balance, withdrawal));
                        oldSum += balance;
                        break;
                    } else {
                        uint256 withdrawal = dGetNumeraireAmount(w.adapter, _amounts[i]);
                        balances[j*3+1] = add(withdrawal, balances[j*3+1]);
                        newSum = sub(newSum, withdrawal);
                        break;
                    }
                    break;
        } } }


        for (uint i = 0; i < reserves.length; i++) {
            uint256 withdrawAmount = balances[i*3+1];
            if (withdrawAmount == 0) continue;
            uint256 oldBalance = balances[i*3];
            uint256 newBalance = sub(oldBalance, withdrawAmount);

            bool haltCheck = newBalance >= wmul(balances[i*3+2], wmul(newSum, WAD - alpha));
            require(haltCheck, "withdraw halt check");

            uint256 feeThreshold = wmul(balances[i*3+2], wmul(newSum, WAD - beta));
            if (newBalance >= feeThreshold) {
                shellsBurned += wmul(withdrawAmount, WAD + feeBase);
            } else if (oldBalance < feeThreshold) {
                uint256 feePrep = wmul(wdiv(
                    withdrawAmount,
                    wmul(balances[i*3+2], newSum)
                ), feeDerivative);
                shellsBurned += wmul(
                    wmul(withdrawAmount, WAD + feePrep),
                    WAD + feeBase
                );
            } else {
                uint256 feePrep = wdiv(
                    sub(feeThreshold, newBalance),
                    wmul(balances[i*3+2], newSum)
                );
                feePrep = wmul(feeDerivative, feePrep);
                shellsBurned += wmul(add(
                    sub(oldBalance, feeThreshold),
                    wmul(sub(feeThreshold, newBalance), WAD + feePrep)
                ), WAD + feeBase);
            }

        }


        // for (uint i = 0; i < _flavors.length; i++) dOutputNumeraire(_flavors[i], msg.sender, _amounts[i]);

        // _burnFrom(msg.sender, shellsBurned);
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

        if (totalBalance == 0) { totalBalance = 10 * WAD; _totalSupply = 10 * WAD; }

        uint256 newShells = wmul(totalDeposit, wdiv(totalBalance, _totalSupply));
        _mint(msg.sender, newShells);

        for (uint i = 0; i < reserves.length; i++ ) {
            Flavor memory d = flavors[numeraires[i]];
            dIntakeNumeraire(d.adapter, amounts[i]);
            dOutputNumeraire(d.adapter, msg.sender, amounts[i]);
        }

        emit log_uint_arr("amounts", amounts);

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