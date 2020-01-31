pragma solidity ^0.5.12;

import "ds-math/math.sol";

import "./ChaiI.sol";
import "./CTokenI.sol";
import "./ERC20I.sol";
import "./ERC20Token.sol";

contract PotLike {
    function chi() external returns (uint256);
}

contract Loihi is DSMath { 

    mapping(address => uint256) public reserves;
    mapping(address => Flavor) public flavors;
    address[] public reservesList;
    address[] public numeraireAssets;
    struct Flavor { address adaptation; address reserve; uint256 weight; }

    uint256 alpha = 950000000000000000; // 95%
    uint256 beta = 475000000000000000; // half of 95%
    uint256 feeBase = 500000000000000; // 5 bps 
    uint256 feeDerivative = 052631578940000000; // marginal fee will be 5% at alpha point

    constructor ( ) public {     }

    function includeAdaptation (address numeraire, address adaptation, address reserve) public {

    }

    function excludeAdaptation (address numeraire) public {

    }

    function includeReserve (address reserve, address numeraire) public {

    }

    function excludeReserve (address reserve) public {

    }

    function getNumeraireAmount (address addr, uint256 amount) internal returns (uint256) {
        (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSignature("getNumeraireAmount(uint256)", amount));
        assert(success);
        return abi.decode(result, (uint256));
    }

    function getBalance (address addr) internal returns (uint256) {
        (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSignature("getBalance()"));
        assert(success);
        return abi.decode(result, (uint256));
    }

    function wrap (address addr, uint256 amount) internal returns (uint256) {
        (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSignature("wrap(uint256)", amount));
        assert(success);
        return abi.decode(result, (uint256));
    }

    function unwrap (address addr, uint256 amount) internal returns (uint256) {
        (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSignature("unwrap(uint256)", amount));
        assert(success);
        return abi.decode(result, (uint256));
    }

    function transfer (address addr, address recipient, uint256 amount) internal returns (uint256) {
        (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSignature("transfer(address, uint256)", recipient, amount));
        assert(success);
        return abi.decode(result, (uint256));
    }

    function transferFrom (address addr, address from, uint256 amount) internal returns (uint256) {
        (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSignature("transferFrom(address, uint256)", from, amount));
        assert(success);
        return abi.decode(result, (uint256));
    }

    function swapByTarget (address origin, uint256 maxOriginAmount, address target, uint256 targetAmount, uint256 deadline) public returns (uint256) {
        return executeTargetTrade(origin, maxOriginAmount, target, targetAmount, deadline, msg.sender);
    }
    function transferByTarget (address origin, uint256 maxOriginAmount, address target, uint256 targetAmount, uint256 deadline, address recipient) public returns (uint256) {
        return executeTargetTrade(origin, maxOriginAmount, target, targetAmount, deadline, recipient);
    }
    function swapByOrigin (address origin, uint256 originAmount, address target, uint256 minTargetAmount, uint256 deadline) public returns (uint256) {
        return executeOriginTrade(origin, originAmount, target, minTargetAmount, deadline, msg.sender);
    }
    function transferByOrigin (address origin, uint256 originAmount, address target, uint256 minTargetAmount, uint256 deadline, address recipient) public returns (uint256) {
        return executeOriginTrade(origin, originAmount, target, minTargetAmount, deadline, recipient);
    }

    function executeOriginTrade (address origin, uint256 oAmt, address target, uint256 minTargetAmount, uint256 deadline, address recipient) public returns (uint256) {

        Flavor memory oRolo = flavors[origin]; // origin rolodex
        Flavor memory tRolo = flavors[target]; // target rolodex
        uint256 oPool; // origin pool balance
        uint256 tPool; // target pool balance
        uint256 tAmt; // target swap amount
        uint256 grossLiq; // total liquidity in all coins

        for (uint i = 0; i < reservesList.length; i++) {
            if (reservesList[i] == oRolo.reserve) {
                oAmt = getNumeraireAmount(oRolo.adaptation, oAmt);
                oPool = add(getBalance(oRolo.reserve), oAmt);
                grossLiq += oPool;
            } else if (reservesList[i] == tRolo.reserve) {
                tPool = getBalance(tRolo.reserve);
                grossLiq += tPool;
            } else grossLiq += getBalance(reservesList[i]);
        }

        require(oPool <= wmul(oRolo.weight, wmul(grossLiq, alpha + WAD)), "origin swap halt check");

        uint256 feeThreshold = wmul(oRolo.weight, wmul(grossLiq, beta + WAD));
        if (oPool < feeThreshold) {
            oAmt = oAmt;
        } else if (sub(oPool, oAmt) >= feeThreshold) {
            uint256 fee = wmul(feeDerivative, wdiv(oAmt, wmul(oRolo.weight, grossLiq)));
            oAmt = wmul(oAmt, WAD - fee);
        } else {
            uint256 fee = wmul(feeDerivative, wdiv(
                sub(oPool, feeThreshold),
                wmul(oRolo.weight, grossLiq)
            ));
            oAmt = add(
                sub(feeThreshold, sub(oPool, oAmt)),
                wmul(sub(oPool, feeThreshold), WAD - fee)
            );
        }

        tAmt = oAmt;
        require(sub(tPool, tAmt) >= wmul(tRolo.weight, wmul(grossLiq, WAD - alpha)), "target swap halt check");

        feeThreshold = wmul(tRolo.weight, wmul(grossLiq, WAD - beta));
        if (sub(tPool, tAmt) > feeThreshold) {
            tAmt = wmul(tAmt, WAD - feeBase);
        } else if (tPool <= feeThreshold) {
            uint256 fee = wmul(feeDerivative, wdiv(tAmt, wmul(tRolo.weight, grossLiq))) - feeBase;
            tAmt = wmul(tAmt, WAD - fee);
        } else {
            uint256 fee = wmul(feeDerivative, wdiv(
                sub(feeThreshold, sub(tPool, tAmt)),
                wmul(tRolo.weight, grossLiq)
            ));
            tAmt = wmul(add(
                sub(tPool, feeThreshold),
                wmul(sub(feeThreshold, sub(tPool, tAmt)), WAD - fee);
            ), WAD - feeBase);
        }

        if (oRolo.reserve == origin) {
            transferFrom(oRolo.reserve, msg.sender, oAmt);
        } else {
            uint256 numeraire = unwrap(oRolo.adaptation, oAmt);
            wrap(oRolo.reserve, numeraire);
        }

        if (tRolo.reserve == target) {
            transfer(tRolo.reserve, recipient, tAmt);
        } else {
            uint256 numeraire = unwrap(tRolo.reserve, tAmt);
            return wrap(tRolo.adaptation, numeraire);
        }

    }

    function executeTargetTrade (address origin, uint256 maxOriginAmount, address target, uint256 tAmt, uint256 deadline, address recipient) public returns (uint256) {
        require(deadline > now, "transaction deadline has passed");

        Flavor memory tRolo = flavors[target]; // target rolodex
        Flavor memory oRolo = flavors[origin]; // origin rolodex
        uint256 tPool; // target pool balance
        uint256 oPool; // origin pool balance
        uint256 oAmt; // origin swap amount
        uint256 grossLiq; // gross liquidity

        for (uint i = 0; i < reservesList.length; i++) {
            if (reservesList[i] == oRolo.reserve) {
                oPool = getBalance(oRolo.reserve);
                grossLiq += oPool;
            } else if (reservesList[i] == tRolo.reserve) {
                tAmt = getNumeraireAmount(tRolo.adaptation, tAmt);
                tPool = sub(getBalance(tRolo.reserve), tAmt);
                grossLiq += tPool;
            } else grossLiq += getBalance(reservesList[i]);
        }

        require(tPool - tAmt >= wmul(tRolo.weight, wmul(grossLiq, WAD - alpha)), "target halt check");

        uint256 feeThreshold = wmul(tRolo.weight, wmul(grossLiq, WAD - beta));
        if (tPool > feeThreshold) {
            tAmt = wmul(tAmt, WAD - feeBase);
        } else if (add(tPool, tAmt) <= feeThreshold) {
            uint256 fee = wmul(feeDerivative, wdiv(tAmt, wmul(tRolo.weight, grossLiq))) + feeBase;
            tAmt = wmul(tAmt, WAD + fee);
        } else {
            uint256 fee = wmul(feeDerivative, wdiv(
                    sub(feeThreshold, tPool),
                    wmul(tRolo.weight, grossLiq)
            ));
            tAmt = wmul(add(
                sub(add(tPool, tAmt), feeThreshold),
                wmul(sub(feeThreshold, tPool), WAD + fee)
            ), WAD + feeBase);
        }

        oAmt = tAmt;
        require(oPool + oAmt <= wmul(oRolo.weight, wmul(grossLiq, WAD + alpha)));

        feeThreshold = wmul(oRolo.weight, wmul(grossLiq, WAD + beta));
        if (oPool + oAmt < feeThreshold) { }
        else if (oPool >= feeThreshold) {
            uint256 fee = wmul(feeDerivative, wdiv(oRolo.weight, grossLiq));
            oAmt = wmul(oAmt, WAD + fee);
        } else {
            uint256 fee = wmul(feeDerivative, wdiv(
                sub(feeThreshold, oPool),
                wmul(oRolo.weight, grossLiq)
            ));
            oAmt = add(
                sub(feeThreshold, oPool),
                wmul(sub(add(oPool, oAmt), feeThreshold), WAD + fee)
            );
        }

        if (oRolo.reserve == origin) {
            transferFrom(oRolo.reserve, msg.sender, oAmt);
        } else {
            uint256 numeraire = unwrap(oRolo.adaptation, oAmt);
            wrap(oRolo.reserve, numeraire);
        }

        if (tRolo.reserve == target) {
            transfer(tRolo.reserve, recipient, tAmt);
        } else {
            uint256 numeraire = unwrap(tRolo.reserve, tAmt);
            return wrap(tRolo.adaptation, numeraire);
        }

    }

    function selectiveDeposit (address[] calldata _flavors, uint256[] calldata _amounts) external returns (uint256) {

        uint256 newSum;
        uint256 newShells;
        uint256[] memory balances = new uint256[](reservesList.length * 3);
        for (uint i = 0; i < _flavors.length; i += 3) {
            Flavor memory rolodex = flavors[_flavors[i]];
            for (uint j = 0; j < reservesList.length; j++) {
                if (reservesList[i] == rolodex.reserve) {
                    if (balances[i] == 0) {
                        balances[i] = getBalance(rolodex.reserve);
                        balances[i+1] = getNumeraireAmount(rolodex.adaptation, _amounts[i]);
                        balances[i+2] = rolodex.weight;
                        newSum = add(balances[i+1], newSum);
                    } else {
                        uint256 numeraireDeposit = getNumeraireAmount(rolodex.adaptation, _amounts[i]);
                        balances[i+1] = add(numeraireDeposit, balances[i+1]);
                        newSum = add(numeraireDeposit, newSum);
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

    }

    function selectiveWithdraw (address[] calldata _flavors, uint256[] calldata _amounts) external returns (uint256) {

        uint256 newSum;
        uint256 shellsBurned;
        uint256[] memory balances = new uint256[](reservesList.length * 3);
        for (uint i = 0; i < _flavors.length; i += 3) {
            Flavor memory rolodex = flavors[_flavors[i]];
            for (uint j = 0; j < reservesList.length; j++) {
                if (reservesList[i] == rolodex.reserve) {
                    if (balances[i] == 0) {
                        balances[i] = getBalance(rolodex.reserve);
                        balances[i+1] = getNumeraireAmount(rolodex.adaptation, _amounts[i]);
                        balances[i+2] = rolodex.weight;
                        newSum = sub(add(newSum, balances[i]), balances[i+1]);
                    } else {
                        uint256 numeraireWithdraw = getNumeraireAmount(rolodex.adaptation, _amounts[i]);
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
                ) + feeBase;
                shellsBurned += wmul(withdrawAmount, feePrep + WAD);
            } else {
                uint256 feePrep = wmul(
                    wdiv(
                        sub(feeThreshold, newBalance),
                        wmul(balances[i+2], newSum)
                    ),
                    feeDerivative 
                );
                shellsBurned += wmul(add(
                    sub(oldBalance, feeThreshold)
                    wmul(sub(feeThreshold, newBalance), feePrep + WAD);
                ), feeBase + WAD);
        }}
    }
}