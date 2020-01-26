pragma solidity ^0.5.0;

import "./ERC20Token.sol";
import "./LoihiRoot.sol";

contract ExchangeEngine is LoihiRoot {

    event trade(
        address indexed buyer,
        address indexed origin,
        uint256 originSold,
        address indexed target,
        uint256 targetBought
    );

    function calculateOriginPrice (
        uint256 originAmount,
        uint256 originLiquidity,
        uint256 targetLiquidity
    ) private pure returns (uint256) {

        return wdiv(
            wmul(originAmount, targetLiquidity),
            add(originAmount, originLiquidity)
        );

    }

    function calculateTargetPrice (
        uint256 targetAmount,
        uint256 originLiquidity,
        uint256 targetLiquidity
    ) private pure returns (uint256) {
        return wdiv(
            wmul(targetAmount, originLiquidity),
            sub(targetLiquidity, targetAmount)
        );
    }

    function getOriginPrice (
        address origin,
        address target,
        uint256 originAmount
    ) public view returns (uint256) {
    }

    function getTargetPrice (
        address origin,
        address target,
        uint256 targetAmount
    ) public view returns (uint256) {
    }

    function swapByOrigin (address origin, address target, uint256 originAmount, uint256 targetMin, uint256 deadline) public  returns (uint256) {
        return executeOriginTrade(origin, target, originAmount, targetMin, deadline, msg.sender);
    }

    function transferByOrigin (address origin, address target, uint256 originAmount, uint256 targetMin, uint256 deadline, address recipient) public returns (uint256) {
        return executeOriginTrade(origin, target, originAmount, targetMin, deadline, recipient);
    }

    function swapByTarget (address origin, address target, uint256 targetAmount, uint256 originMax, uint256 deadline) public returns (uint256) {
        return executeTargetTrade(origin, target, targetAmount, originMax, deadline, msg.sender);
    }

    function transferByTarget (address origin, address target, uint256 targetAmount, uint256 originMax, uint256 deadline, address recipient) public returns (uint256) {
        return executeTargetTrade(origin, target, targetAmount, originMax, deadline, recipient);
    }

    function finalizeOriginTrade (
        address origin,
        address target,
        uint256 originAmount,
        uint256 targetAmount,
        address recipient
    ) private returns (uint256) {

        adjustedTransferFrom(ERC20Token(origin), recipient, originAmount);
        uint256 adjustedAmount = adjustedTransfer(ERC20Token(target), recipient, targetAmount);
        emit trade(msg.sender, origin, originAmount, target, adjustedAmount);
        return adjustedAmount;

    }

    function calculateOriginAmountForOriginTrade (
        uint256 originAmount
    ) private view returns (uint256) {
        return sub(
            originAmount,
            calculateProtocolFeeForOriginTrade(originAmount)
        );
    }

    function calculateProtocolFeeForOriginTrade (
        uint256 originAmount
    ) private view returns (uint256) {
        return sub(
            originAmount,
            wmul(
                originAmount,
                wdiv(BASIS - protocolFee, BASIS)
            )
        );
    }

    function calculateOriginAmountForTargetTrade (
        uint256 originAmount
    ) private view returns (uint256) {
        return wmul(
            originAmount,
            wdiv(BASIS + protocolFee, BASIS)
        );
    }

    function calculateProtocolFeeForTargetTrade (
        uint256 originAmount
    ) private view returns (uint256) {
        return sub(
            wmul(originAmount, wdiv(BASIS + protocolFee, BASIS)),
            originAmount
        );
    }

    function executeOriginTrade (
        address origin,
        address target,
        uint256 originAmount,
        uint256 targetMin,
        uint256 deadline,
        address recipient
    ) private returns (uint256) {
        require(block.timestamp <= deadline, "transaction must be processed before deadline");
        require(originAmount > 0 && targetMin > 0, "origin amount and min target amount must be valid values");

        revenue[origin] += calculateProtocolFeeForOriginTrade(originAmount);
        originAmount = calculateOriginAmountForOriginTrade(originAmount);

        uint256 originCutAfterLiquidityFee = executeOriginCreditOrigin(origin, originAmount, targetBalance, targetLiquidity);
        uint256 targetAmount = executeOriginDebitTarget(target, originCutAfterLiquidityFee, originBalance, targetBalance);

        require(targetAmount >= targetMin, "target amount was not greater than minimum target amount");

        return finalizeOriginTrade(origin, target, originAmount, targetAmount, recipient);

    }




    function transferByTarget (
        address origin,
        address target,
        uint256 targetAmount,
        uint256 originMax,
        uint256 deadline,
        address recipient,
        address[] memory _shells
    ) public returns (uint256) {

        return executeTargetTrade(_shells, origin, target, targetAmount, originMax, deadline, recipient);

    }

    function finalizeTargetTrade (
        address origin,
        address target,
        uint256 originAmountWithFees,
        uint256 targetAmount,
        address recipient
    ) private returns (uint256) {

        adjustedTransfer(ERC20Token(target), recipient, targetAmount);
        uint256 adjustedAmount = adjustedTransferFrom(ERC20Token(origin), recipient, originAmountWithFees);
        emit trade(msg.sender, origin, originAmountWithFees, target, adjustedAmount);
        return adjustedAmount;

    }

    function executeTargetTrade (
        address[] memory _shells,
        address origin,
        address target,
        uint256 targetAmount,
        uint256 maxOriginAmount,
        uint256 deadline,
        address recipient
    ) private returns (uint256) {
        require(block.timestamp <= deadline, "transaction must be processed before deadline");
        require(targetAmount > 0 && maxOriginAmount > 0, "target amount and max origin amount must be valid values");

        uint256 targetLiquidity = getLiquidity(_shells, target);

        uint256 originAmountWithFees;
        for (uint8 i = 0; i < _shells.length; i++) {

            uint256 originBalance = shellBalances[makeKey(_shells[i], origin)];
            uint256 targetBalance = shellBalances[makeKey(_shells[i], target)];

            uint256 targetContribution = executeTargetDebitTarget(
                _shells[i],
                target,
                targetAmount,
                targetBalance,
                targetLiquidity
            );

            originAmountWithFees += executeTargetCreditOrigin(
                _shells[i],
                origin,
                targetContribution,
                originBalance,
                targetBalance
            );

        }

        revenue[origin] += calculateProtocolFeeForTargetTrade(originAmountWithFees);
        originAmountWithFees = calculateOriginAmountForTargetTrade(originAmountWithFees);

        require(maxOriginAmount >= originAmountWithFees, "origin amount must be less than or equal to maximum origin amount");

        return finalizeTargetTrade(
            origin,
            target,
            originAmountWithFees,
            targetAmount,
            recipient
        );

    }

    function executeOriginDebitTarget (
        address shell,
        address target,
        uint256 originCut,
        uint256 originBalance,
        uint256 targetBalance
    ) private returns (uint256) {

        uint256 targetContribution = calculateOriginPrice(
            originCut,
            originBalance,
            targetBalance
        );

        shellBalances[makeKey(shell, target)] -= targetContribution;

        return targetContribution;

    }

    function executeOriginCreditOrigin (
        address shell,
        address origin,
        uint256 originAmountAfterProtocolFee,
        uint256 targetBalance,
        uint256 targetLiquidity
    ) private returns (uint256) {

        uint256 originCut = wdiv(
            wmul(originAmountAfterProtocolFee, targetBalance),
            targetLiquidity
        );

        uint256 originCutAfterLiquidityFee = wmul(
            originCut,
            wdiv(BASIS - liquidityFee, BASIS)
        );

        shellBalances[makeKey(shell, origin)] += originCut;

        return originCutAfterLiquidityFee;

    }

    function executeTargetCreditOrigin (
        address shell,
        address origin,
        uint256 targetContribution,
        uint256 originBalance,
        uint256 targetBalance
    ) private returns (uint256) {

        uint256 originCut = calculateTargetPrice(
            targetContribution,
            originBalance,
            targetBalance
        );

        uint256 originCutWithLiquidityFee = wmul(
            sub(originCut, protocolFee),
            wdiv(BASIS + liquidityFee, BASIS)
        );

        shellBalances[makeKey(shell, origin)] += originCutWithLiquidityFee;

        return originCutWithLiquidityFee;

    }

    function executeTargetDebitTarget (
        address shell,
        address target,
        uint256 targetAmount,
        uint256 targetBalance,
        uint256 targetLiquidity
    ) private returns (uint256) {

        uint256 targetContribution = wdiv(
            wmul(targetAmount, targetBalance),
            targetLiquidity
        );

        shellBalances[makeKey(shell, target)] -= targetContribution;

        return targetContribution;
    }

}