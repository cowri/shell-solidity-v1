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
            balance += reservesList[i].delegateCall(abi.encodeWithSignature("getBalance()"))
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

    function executeOriginTrade (address origin, uint256 originAmount, address target, uint256 minTargetAmount, uint256 deadline, address recipient) public returns (uint256) {
        Flavor memory originRolodex = flavors[origin];
        Flavor memory targetRolodex = flavors[target];
        uint256 originNumeraireAmount = originRolodex.adaptation.delegateCall(abi.encodeWithSignature("getNumeraireAmount(uint256)", originAmount));
        uint256 originNumeraireBalance = originRolodex.reserve.delegateCall(abi.encodeWithSignature("getNumeraireBalance()"));
        uint256 targetNumeraireBalance = targetRolodex.reserve.delegateCall(abi.encodeWithSignature("getNumeraireBalance()"));
        uint256 targetNumeraireAmount = wdiv(
            wmul(originNumeraireAmount, targetNumeraireBalance),
            add(originNumeraireAmount, originNumeraireBalance)
        );

        if (origin == originRolodex.reserve) {
            originRolodex.reserve.delegateCall(abi.encode("transferFrom", msg.sender, originAmount));
        } else {
            uint256 originNumeraireAddition = originRolodex.adaptation.delegateCall(abi.encodeWithSignature("unwrap(intake(uint256)", originAmount));
            originRolodex.reserve.delegateCall(abi.encodeWithSignature("wrap(uint256)"), originNumeraireAddition);
        }

        if (target == targetRolodex.reserve) {
            uint256 targetRolodex.delegateCall(abi.encode("transferNumeraireAmount", recipient, targetNumeraireAmount));
        } else {
            uint256 targetNumeraireSubtraction = targetRolodex.reserve.delegateCall(abi.encode("unwrap(uint256"), targetNumeraireAmount));
            return targetRolodex.adaptation.delegateCall(abi.encode("transferNumeraireAmount(address,uint256)", recipient, targetNumeraireSubtraction));
        }

    }

    function executeTargetTrade (address origin, uint256 maxOriginAmount, address target, uint256 targetAmount, uint256 deadline, address recipient) public returns (uint256) {
        require(deadline > now, "transaction deadline has passed");
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

            bool haltCheck = newBalance <= wmul(alpha+1, wmul(balances[i+2], newSum));
            require(haltCheck, "halt check deposit");

            uint feePoint = wmul(balances[i+2], wmul(newSum, add(beta, WAD)));
            if (newBalance <= feePoint) {
                new_shells += depositAmount;
            } else if (oldBalance > feePoint) {
                uint256 fee = sub(WAD, wmul(
                    wdiv(depositAmount, wmul(balances[i+2], newSum))
                    wdiv(feeDerivative, WAD*2)
                ));
                newShells = add(newShells, fee);
            } else {
                uint256 fee = sub(WAD, wdiv(
                    sub(newBalance, wmul(balances[i+2], wmul(newSum, beta+1)),
                    wmul(wmul(balances[i+2], newBalance), wdiv(feeDerivative, 2))
                ));
                newShells = add(newShells, fee);
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

            bool haltCheck = newBalance >= wmul(balances[i+2], wmul(newSum, sub(1,alpha)));
            require(haltCheck, "withdraw halt check");

            if (newBalance >= wmul(balances[i+2], wmul(newBalance, sub(WAD, beta)))) {
                shellsBurned += wmul(withdrawAmount, add(WAD, baseFee));
            } else if (oldBalance < wmul(balances[i+2], wmul(newSum, sub(WAD, beta)))) {
                uint256 fee = add(WAD, add(baseFee, wdiv(
                    withdrawAmount,
                    wmul(wmul(balances[i+2], newSum), wdiv(feeDerivative, WAD*2))
                ));
                shellsBurned += wmul(amountWithdrawn, fee);
            } else {

                total_fee = (w*new_sum*(1-beta) - new_balance_i)/(w*new_sum) * m/2 + fixed_fee
                uint256 fee = add(WAD, add(baseFee, wmul(
                    wdiv(
                        sub(wmul(balances[i+2], wmul(newSum, sub(WAD, beta))), newBalance),
                        wmul(balances[i+2], newSum)
                    ),
                    wdiv(feeDerivative, WAD*2)
                )));
                shellsBurned += wmul(amountWithdrawn, fee);
        }}
    }
}