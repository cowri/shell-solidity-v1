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
        (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSignature("outputRaw(address, uint256)", dst, amount));
        assert(success);
        return abi.decode(result, (uint256));
    }


    function dOutputNumeraire (address addr, address dst, uint256 amount) internal returns (uint256) {
        (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSignature("outputNumeraire(address, uint256)", dst, amount));
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
        emit log_address("origin", origin);
        emit log_address("target", target);
        emit log_uint("oAmt", oAmt);
        emit log_uint("minTargetAmount", minTargetAmount);

        uint256 oNAmt; // origin numeraire amount
        uint256 oPool; // origin pool balance
        uint256 tPool; // target pool balance
        uint256 tNAmt; // target numeraire swap amount
        uint256 grossLiq; // total liquidity in all coins
        Flavor memory o = flavors[origin]; // origin adapter + weight
        Flavor memory t = flavors[target]; // target adapter + weight

        for (uint i = 0; i < reserves.length; i++) {
            emit log_uint("i", i);
            if (reserves[i] == o.reserve) {
                oNAmt = dGetNumeraireAmount(o.adapter, oAmt);
                oPool = add(dGetNumeraireBalance(o.adapter), oNAmt);
                grossLiq += oPool;
            } else if (reserves[i] == t.reserve) {
                tPool = dGetNumeraireBalance(t.adapter);
                grossLiq += tPool;
            } else grossLiq += dGetNumeraireBalance(reserves[i]);
        }

        emit log("after tallying total liquidity");

        emit log_uint("origin halt check", wmul(o.weight, wmul(grossLiq, alpha + WAD)));
        emit log_uint("halt check from targ", wmul(o.weight, wmul(grossLiq, WAD + alpha)));
        emit log_uint("oPool", oPool);
        emit log_uint("grossLiq", grossLiq);
        emit log_uint("oweight", o.weight);

        require(oPool <= wmul(o.weight, wmul(grossLiq, alpha + WAD)), "origin swap origin halt check");


        uint256 feeThreshold = wmul(o.weight, wmul(grossLiq, beta + WAD));
        if (oPool < feeThreshold) {
        } else if (sub(oPool, oNAmt) >= feeThreshold) {
            uint256 fee = wdiv(oNAmt, wmul(o.weight, grossLiq));
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

        emit log("after assessing origin fee");
        emit log_uint("oNAmt", oNAmt);

        emit log_uint("t.weight", t.weight);
        emit log_uint("grossliq", grossLiq);
        emit log_uint("WAD - alpha", WAD - alpha);
        emit log_uint("alpha", alpha);


        tNAmt = oNAmt;
        emit log_uint("tPool", tPool);
        emit log_uint("tNAmt", tNAmt);
        // TODO: move this after the calculation of tNAmt?
        require(sub(tPool, tNAmt) >= wmul(t.weight, wmul(grossLiq, WAD - alpha)), "target swap halt check");

        emit log("after target halt check");

        feeThreshold = wmul(t.weight, wmul(grossLiq, WAD - beta));
        if (sub(tPool, tNAmt) > feeThreshold) {
            tNAmt = wmul(tNAmt, WAD - feeBase);
        } else if (tPool <= feeThreshold) {
            uint256 fee = wmul(feeDerivative, wdiv(tNAmt, wmul(t.weight, grossLiq))) - feeBase;
            tNAmt = wmul(tNAmt, WAD - fee);
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

        emit log_uint("oAmt", oAmt);
        emit log_uint("tNAmt", tNAmt);
        dIntakeRaw(o.adapter, oAmt);
        dOutputNumeraire(t.adapter, recipient, tNAmt);

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
            oNAmt = wmul(tNAmt, WAD + feeBase);
        } else if (add(tPool, tNAmt) <= feeThreshold) {
            uint256 fee = wmul(feeDerivative, wdiv(tNAmt, wmul(t.weight, grossLiq)));
            oNAmt = wmul(tNAmt, WAD + fee);
            oNAmt = wmul(oNAmt, WAD + feeBase);
        } else {
            uint256 fee = wmul(feeDerivative, wdiv(
                    sub(feeThreshold, tPool),
                    wmul(t.weight, grossLiq)
            ));
            oNAmt = add(
                sub(add(tPool, tNAmt), feeThreshold),
                wmul(sub(feeThreshold, tPool), WAD + fee)
            );
            oNAmt = wmul(oNAmt, WAD + feeBase);
        }

        require(add(oPool, oNAmt) <= wmul(o.weight, wmul(grossLiq, WAD + alpha)), "origin halt check for target trade");

        feeThreshold = wmul(o.weight, wmul(grossLiq, WAD + beta));
        if (oPool + oNAmt <= feeThreshold) {

        } else if (oPool >= feeThreshold) {
            uint256 fee = wmul(feeDerivative, wdiv(o.weight, grossLiq));
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

        dOutputNumeraire(t.adapter, recipient, tNAmt);
        dIntakeNumeraire(o.adapter, oNAmt);

    }

    function selectiveDeposit (address[] calldata _flavors, uint256[] calldata _amounts) external returns (uint256) {

        uint256 oldSum;
        uint256 newSum;
        uint256 newShells;
        uint256[] memory balances = new uint256[](reserves.length * 3);
        for (uint i = 0; i < _flavors.length; i++) {
            Flavor memory d = flavors[_flavors[i]]; // depositing adapter/weight
            for (uint j = 0; j < reserves.length; j++) {
                if (reserves[j] == d.adapter) {
                    if (balances[j*3+1] == 0) {
                        balances[j*3] = dGetNumeraireBalance(d.adapter);
                        balances[j*3+1] = dGetNumeraireAmount(d.adapter, _amounts[i]);
                        balances[j*3+2] = d.weight;
                        newSum = add(balances[j*3+1], newSum);
                        break;
                    } else {
                        uint256 numeraireDeposit = dGetNumeraireAmount(d.adapter, _amounts[i]);
                        balances[j*3+1] = add(numeraireDeposit, balances[j*3+1]);
                        newSum = add(numeraireDeposit, newSum);
                        break;
                    }
                    break;
        } } }

        for (uint i = 0; i < balances.length; i += 3) {
            uint256 oldBalance = balances[i];
            uint256 depositAmount = balances[i+1];
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
                    wmul(balances[i+2], newBalance)
                ));
                newShells += add(
                    sub(feeThreshold, oldBalance),
                    wmul(sub(newBalance, feeThreshold), WAD - feePrep)
                );
        } }

        newShells = wdiv(newShells, wmul(oldSum, totalSupply()));

        for (uint i = 0; i < _flavors.length; i++) dOutputNumeraire(_flavors[i], msg.sender, _amounts[i]);

        _mint(msg.sender, newShells);

    }

    function selectiveWithdraw (address[] calldata _flavors, uint256[] calldata _amounts) external returns (uint256) {

        uint256 newSum;
        uint256 oldSum;
        uint256 shellsBurned;
        uint256[] memory balances = new uint256[](reserves.length * 3);
        for (uint i = 0; i < _flavors.length; i += 3) {
            Flavor memory w = flavors[_flavors[i]]; // withdrawing adapter + weight
            for (uint j = 0; j < reserves.length; j++) {
                if (reserves[i] == w.adapter) {
                    if (balances[i] == 0) {
                        balances[i] = dGetNumeraireBalance(w.adapter);
                        balances[i+1] = dGetNumeraireAmount(w.adapter, _amounts[i]);
                        balances[i+2] = w.weight;
                        newSum = sub(add(newSum, balances[i]), balances[i+1]);
                        oldSum += balances[i];
                    } else {
                        uint256 numeraireWithdraw = dGetNumeraireAmount(w.adapter, _amounts[i]);
                        balances[i+1] = add(numeraireWithdraw, balances[i+1]);
                        newSum = sub(newSum, numeraireWithdraw);
                    }
                    break;
        } } }

        for (uint i = 0; i < balances.length; i += 3) {
            uint256 oldBalance = balances[i];
            uint256 withdrawAmount = balances[i+1];
            uint256 newBalance = sub(oldBalance, withdrawAmount);

            bool haltCheck = newBalance >= wmul(balances[i+2], wmul(newBalance, alpha - WAD));
            require(haltCheck, "withdraw halt check");

            uint256 feeThreshold = wmul(balances[i+2], wmul(newBalance, WAD - beta));
            if (newBalance >= feeThreshold) {
                shellsBurned += wmul(withdrawAmount, add(WAD, feeBase));
            } else if (oldBalance < feeThreshold) {
                uint256 feePrep = wdiv(withdrawAmount,
                    wmul(wmul(balances[i+2], newSum), wdiv(feeDerivative, WAD*2))
                );
                shellsBurned += wmul(withdrawAmount, feePrep + feeBase + WAD);
            } else {
                uint256 feePrep = wdiv(
                    sub(feeThreshold, newBalance),
                    wmul(balances[i+2], newSum)
                );
                feePrep = wmul(feeDerivative, feePrep);
                shellsBurned += wmul(add(
                    sub(oldBalance, feeThreshold),
                    wmul(sub(feeThreshold, newBalance), feePrep + WAD)
                ), feeBase + WAD);
        }}

        shellsBurned = wdiv(shellsBurned, wmul(oldSum, totalSupply()));

        for (uint i = 0; i < _flavors.length; i++) dOutputNumeraire(_flavors[i], msg.sender, _amounts[i]);

        _burnFrom(msg.sender, shellsBurned);

    }

    function balancedDeposit (uint256 totalDeposit) public returns (uint256) {

        uint256 totalBalance;
        uint256 _totalSupply = totalSupply();

        uint256[] memory amounts = new uint256[](3);

        for (uint i = 0; i < reserves.length; i++) {
            uint256 numeBalance = dGetNumeraireBalance(reserves[i]);
            totalBalance += numeBalance;
            Flavor memory d = flavors[numeraires[i]];
            uint256 depositAmount = wmul(d.weight, totalDeposit);
            amounts[i] = dIntakeNumeraire(d.adapter, depositAmount);
        }

        if (totalBalance == 0) {
            totalBalance = 10 ** 18;
            _totalSupply = 10 ** 18;
        }

        uint256 newShells = wmul(totalDeposit, wdiv(totalBalance, _totalSupply));
        _mint(msg.sender, newShells);

        return newShells;

    }


    function balancedWithdraw (uint256 totalWithdrawal) public returns (uint256[] memory) {

        uint256[] memory withdrawalAmounts = new uint256[](reserves.length);
        uint256 shellsToBurn = wmul(totalWithdrawal, WAD + feeBase);

        uint256 oldTotal;
        for (uint i = 0; i < reserves.length; i++) {
            withdrawalAmounts[i] = dGetNumeraireBalance(reserves[i]);
            oldTotal += withdrawalAmounts[i];
        }


        for (uint i = 0; i < reserves.length; i++) {
            emit log_uint("totalWithdrawal", totalWithdrawal);
            emit log_uint("oldTotal", oldTotal);
            emit log_uint("balance of i", withdrawalAmounts[i]);
            Flavor storage w = flavors[numeraires[i]];
            uint256 numeraireToWithdraw = wmul(totalWithdrawal, wdiv(withdrawalAmounts[i], oldTotal));
            // uint256 numeraireToWithdraw = wdiv(withdrawalAmounts[i], wmul(oldTotal, totalWithdrawal));
            emit log_uint("numeraireToWithdraw", numeraireToWithdraw);
            uint256 amountWithdrawn = dOutputNumeraire(w.adapter, msg.sender, numeraireToWithdraw);
            emit log_uint("amountWithdrawn", amountWithdrawn);
            withdrawalAmounts[i] = amountWithdrawn;
        }


        _burnFrom(msg.sender, shellsToBurn);
        return withdrawalAmounts;

    }


}