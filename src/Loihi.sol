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

    uint256 feeDerivative;
    uint256 alpha;
    uint256 beta;

    constructor ( ) public {     }

    function getTotalBalance () internal returns (uint256) {
        uint256 balance;
        for (uint i = 0; i < reservesList; i++) {
            balance += reservesList[i].delegateCall(abi.encodeWithSignature("getPool()"))
        }
        return balance;
    }

    function includeAdaptation (address numeraire, address adaptation, address reserve) public onlyOwner {

    }

    function excludeAdaptation (address numeraire) public onlyOwner {

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
        return executeTargetTrade(origin, originAmount, target, minTargetAmount, deadline, recipient);
    }

    function executeOriginTrade (address origin, uint256 oAmt, address target, uint256 minTargetAmount, uint256 deadline, address recipient) public returns (uint256) {

        Flavor oRolo = flavors[origin]; // origin rolodex
        Flavor tRolo = flavors[target]; // target rolodex
        uint256 oAmt; // origin swap amount
        uint256 oPool; // origin pool balance
        uint256 tPool; // target pool balance
        uint256 tAmt; // target swap amount
        uint256 sheerLiq; // gross liquidity

        for (uint i = 0; i < reservesList.length; i++) {
            if (reservesList[i] == originRolodex.reserve) {
                oAmt = oRolo.adaptation.delegateCall(abi.encodeWithSignature("getNumeraireAmount(uint)", oAmt));
                oPool = oRolo.reserve.delegateCall(abi.encodeWithSignature("getBalance()"));
                sheerLiq += oPool;
            } else if (reservesList[i] == tRolo.reserve) {
                tPool = tRolo.reserve.delegateCall(abi.encodeWithSignature("getBalance()"));
                sheerLiq += tPool;
            } else sheerLiq += reservesList[i].delegateCall(abi.encodeWithSignature("getBalance()"));
        }

        require(add(oPool, oAmt) <= wmul(oRolo.weight, wmul(sheerLiq, alpha + WAD)), "origin swap halt check");

        if (add(oPool, oAmt) <= wmul(oRolo.weight, wmul(sheerLiq, beta + WAD))) {
            tAmt = oAmt;
        } else if (oPool > wmul(oRolo.weight, wmul(sheerLiq, beta + WAD))) {
            uint256 fee = wmul(baseFee/2, wdiv(oAmt, wmul(oRolo.weight, sheerLiq)));
            tAmt = wmul(oAmt, sub(WAD, fee));
        } else {
            uint256 fee = wmul(baseFee/2, wdiv(
                sub(add(oAmt, oPool), wmul(oRolo.weight, wmul(oPool, add(WAD, beta)))),
                wmul(oRolo.weight, oPool)
            ));
            tAmt = wmul(oAmt, WAD - fee);
        }

        require(sub(tPool, tAmt) >= wmul(tRolo.weight, wmul(sheerLiq, sub(WAD, alpha)), "target swap halt check"));
        
        if (sub(tPool, tAmt) => wmul(tRolo.weight, wmul(sheerLiq, WAD - beta))) {
            tAmt = wmul(tAmt, WAD - baseFee);
        } else if (tPool < wmul(tRolo.weight, wmul(tpool, WAD - beta))) {
            uint256 fee = wmul(m/2, wdiv(tAmt, wmul(tRolo.weight, sheerLiq))) + baseFee;
            tAmt = wmul(tAmt, WAD - fee);
        } else {
            uint256 fee = wmul(m/2, wdiv(
                sub(sub(tPool, tAmt), wmul(tRolo.weight, sheerLiq, WAD - beta)),
                wmul(tRolo.weight, sheerLiq)
            ) + baseFee;
            tAmt = wmul(tAmt, WAD - fee);
        }

        if (oRolo.reserve == origin) {
            oRolo.reserve.delegateCall(abi.encodeWithSignature("transferFrom(address, uint)", msg.sender, oAmt));
        } else {
            uint256 numeraire = oRolo.adapter.delegateCall(abi.encodeWithSignature("unwrap(uint)", oAmt));
            oRolo.reserve.delegateCall(abi.encodeWithSignature("wrap(uint)", numeraire));
        }

        if (tRolo.reserve == target) {
            tRolo.reserve.delegateCall(abi.encodeWithSignature("transfer(address, uint)", recipient, tAmt));
        } else {
            uint256 numeraire = tRolo.reserve.delegateCall(abi.encodeWithSignature("unwrap(uint)", tAmt));
            return tRolo.adapter.delegateCall(abi.encodeWithSignature("wrap()", numeraire));
        }

    }


    function executeTargetTrade (address origin, uint256 maxOriginAmount, address target, uint256 targetAmount, uint256 deadline, address recipient) public returns (uint256) {
        require(deadline > now, "transaction deadline has passed");

        Flavor tRolo = flavors[target]; // target rolodex
        Flavor oRolo = flavors[origin]; // origin rolodex
        uint256 tAmt; // target swap amount
        uint256 tPool; // target pool balance
        uint256 oPool; // origin pool balance
        uint256 oAmt; // origin swap amount
        uint256 sheerLiq; // gross liquidity

        for (uint i = 0; i < reservesList.length; i++) {
            if (reservesList[i] == originRolodex.reserve) {
                oAmt = oRolo.adaptation.delegateCall(abi.encodeWithSignature("getNumeraireAmount(uint)", oAmt));
                oPool = oRolo.reserve.delegateCall(abi.encodeWithSignature("getBalance()"));
                sheerLiq += oPool;
            } else if (reservesList[i] == tRolo.reserve) {
                tPool = tRolo.reserve.delegateCall(abi.encodeWithSignature("getBalance()"));
                sheerLiq += tPool;
            } else sheerLiq += reservesList[i].delegateCall(abi.encodeWithSignature("getBalance()"));
        }

        require(tPool - targetAmount >= wmul(tRolo.weight wmul(sheerLiq, WAD - alpha)), "target halt check");   

        uint256 check = wmul(tRolo.weight, wmul(sheerLiq, WAD - beta));
        if (tPool - tAmt >= check) {
            oAmt = wmul(tAmt, WAD - baseFee);
        } else if (tPool <= check) {
            uint256 fee = wmul(feeDerivative / 2, wdiv(tAmt, wmul(tRolo.weight, sheerLiq))) + baseFee;
            oAmt = wmul(tAmt, WAD - fee);
        } else {
            uint256 fee = wmul(feeDerivative / 2,
                wdiv(
                    wmul(tRolo.weight, wmul(sheerLiq, WAD - beta))- tPool - tAmt,
                    wmul(tRolo.weight, sheerLiq)
                )
            ) + baseFee;
            oAmt = wmul(tAmt, WAD - fee);
        }

        origin_balance += origin_amount
        require(oPool + oAmt <= wmul(oRolo.weight, wmul(sheerLiq, WAD - alpha)));
        check = wmul(oRolo.weight, wmul(sheerLiq, WAD - beta));
        if (oPool >= check) {
            
        } else if (oPool - oAmt <= check) {
            uint256 fee = wmul(wdiv(oRolo.weight, sheerLiq), feeDerivative / 2);
            oAmt = wmul(oAmt, WAD - fee);
        } else {
            uint256 fee = wmul(feeDerivative / 2,
                sub(wmul(oRolo.weight, wmul(sheerLiq, WAD - beta)), oPool),
                wmul(oRolo.weight, sheerLiq)
            );
            oAmt = wmul(oAmt, WAD - fee);
        }

    }

    function selectiveDeposit (address[] calldata _flavors, uint256[] calldata _amounts) external returns (uint256) {

        uint256 newSum;
        uint256 newShells; 
        uint256[] memory balances = new uint256[](reservesList.length * 3);
        for (uint i = 0; i < _flavors.length; i+=3) {
            Flavor memory rolodex = flavors[_flavors[i]];
            for (uint j = 0; j < reserves.length; j++) {
                if (reserves[i] == rolodex.reserve) {
                    if (balances[i] == 0) {
                        balances[i] = rolodex.reserve.delegateCall(abi.encodeWithSignature("getBalance()"));
                        balances[i+1] = rolodex.adaptation.delegateCall(encodeWithSignature("getNumeraireAmount(uint)", _amounts[i]));
                        balances[i+2] = rolodex.weight;
                        newSum = add(balances[i+1], newSum);
                    } else {
                        uint256 numeraireDeposit = rolodex.adaptation.delegateCall(abi.encodeWithSignature("getNumeraireAmount(uint)", _amounts[i]));
                        balances[i+1] = add(numeraireDeposit, balances[i+1]);
                        newSum = add(numeraireDeposit, newSum);
                    }
                    break;
        } } } 

        for (uint i = 0; i < balances.length; i+=3) {
            uint256 oldBalance = balances[i];
            uint256 depositAmount = balances[i+1];
            uint256 newBalance = add(oldBalance, depositAmount);

            require(newBalance <= wmul(balances[i+2], wmul(newSum, alpha + WAD)), "halt check deposit");

            if (newBalance <= wmul(balances[i+2], wmul(newSum, beta + WAD))) {
                new_shells += depositAmount;
            } else if (oldBalance > feePoint) {
                uint256 fee = wmul(wdiv(depositAmount, wmul(balances[i+2], newSum)), feeDerivative / 2);
                newShells = add(newShells, WAD - fee);
            } else {
                uint256 fee = wmul(feeDerivative / 2, wdiv(
                    sub(newBalance, wmul(balances[i+2], wmul(newSum, beta+WAD))),
                    wmul(balances[i+2], newBalance)
                );
                newShells = add(newShells, WAD - fee);
        } }

    }

    function selectiveWithdraw (address[] calldata flavors, uint256[] calldata amounts) external returns (uint256) {

        uint256 newSum;
        uint256 newShells; 
        uint256[] memory balances = new uint256[](reservesList.length * 3);
        for (uint i = 0; i < _flavors.length; i+=3) {
            Flavor memory rolodex = flavors[_flavors[i]];
            for (uint j = 0; j < reserves.length; j++) {
                if (reserves[i] == rolodex.reserve) {
                    if (balances[i] == 0) {
                        balances[i] = rolodex.reserve.delegateCall(abi.encodeWithSignature("getBalance()"));
                        balances[i+1] = rolodex.adaptation.delegateCall(encodeWithSignature("getNumeraireAmount", _amounts[i]));
                        balances[i+2] = rolodex.weight;
                        newSum = sub(add(newSum, balances[i]), balances[i+1]);
                    } else {
                        uint256 numeraireWithdraw = rolodex.adaptation.delegateCall(abi.encodeWithSignature("getNumeraireAmount(uint)", _amounts[i]));
                        balances[i+1] = add(numeraireWithdraw, balances[i+1])
                        newSum = sub(newSum, numeraireWithdraw); 
                    }
                    break;
        } } }

        for (uint i = 0; i < balances.length; i += 3) {
            uint256 oldBalance = balances[i];
            uint256 withdrawAmount = balances[i+1];
            uint256 newBalance = sub(oldBalance, withdrawAmount);

            bool haltCheck = newBalance >= wmul(balances[i+2], wmul(newBalance, alpha - WAD)));
            require(haltCheck, "withdraw halt check");

            if (newBalance >= wmul(balances[i+2], wmul(newBalance, WAD - beta))) {
                shellsBurned += wmul(withdrawAmount, add(WAD, baseFee));
            } else if (oldBalance < wmul(balances[i+2], wmul(newSum, WAD - beta))) {
                uint256 fee = wdiv(withdrawAmount,
                    wmul(wmul(balances[i+2], newSum), wdiv(feeDerivative, WAD*2))
                ) + baseFee;
                shellsBurned += wmul(amountWithdrawn, fee + WAD);
            } else {
                uint256 fee = wmul(
                    wdiv(
                        sub(wmul(balances[i+2], wmul(newSum, WAD - beta)), newBalance),
                        wmul(balances[i+2], newSum)
                    ),
                    wdiv(feeDerivative, WAD*2)
                ) + baseFee;
                shellsBurned += wmul(amountWithdrawn, fee + WAD);
        }}
    }
}