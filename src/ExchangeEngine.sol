pragma solidity ^0.5.0;

import "./ERC20Token.sol";
import "./LoihiRoot.sol";

contract ExchangeEngine is LoihiRoot {

    function getRevenue (
        address token
    ) public view returns (uint256) {
        return revenue[token];
    }

    event trade(
        address indexed buyer,
        address indexed origin,
        uint256 originSold,
        address indexed target,
        uint256 targetBought
    );

    function getLiquidity (
        address[] memory _shells,
        address token
    ) private view returns (uint256) {

        uint256 liquidity;
        for (uint8 i = 0; i < _shells.length; i++) {
            liquidity += shellBalances[makeKey(_shells[i], token)];
        }
        return liquidity;

    }

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

    function getMicroOriginPrice (
        address shell,
        address origin,
        address target,
        uint256 originAmount
    ) public  returns (uint256) {

        return calculateOriginPrice(
            originAmount,
            shellBalances[makeKey(shell, origin)],
            shellBalances[makeKey(shell, target)]
        );

    }

    function getOriginPrice (
        address origin,
        address target,
        uint256 originAmount
    ) public view returns (uint256) {
        address[] memory _shells = pairsToActiveShells[makeKey(origin, target)];
        uint256 originLiquidity = getLiquidity(_shells, origin);
        uint256 targetLiquidity = getLiquidity(_shells, target);
        assert(originLiquidity > 0);
        assert(targetLiquidity > 0);

        uint256 originAmountWithProtocolFee = wmul(
            originAmount,
            wdiv(BASIS - protocolFee, BASIS)
        );

        uint256 targetAmount;
        for (uint8 i = 0; i < _shells.length; i++) {
            uint256 originBalance = shellBalances[makeKey(_shells[i], origin)];
            uint256 targetBalance = shellBalances[makeKey(_shells[i], target)];
            uint256 originCut = wdiv(wmul(originAmountWithProtocolFee, targetBalance), targetLiquidity);
            uint256 originCutWithLiquidityFee = wmul(originCut, wdiv(BASIS - liquidityFee, BASIS));
            targetAmount += calculateOriginPrice(originCutWithLiquidityFee, originBalance, targetBalance);
        }

        return targetAmount;
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

    function getMicroTargetPrice (
        address shell,
        address origin,
        address target,
        uint256 targetAmount
    ) public view returns (uint256) {
        return calculateTargetPrice(
            targetAmount,
            shellBalances[makeKey(shell, origin)],
            shellBalances[makeKey(shell, target)]
        );
    }

    function getTargetPrice (
        address origin,
        address target,
        uint256 targetAmount
    ) public view returns (uint256) {
        address[] memory _shells = pairsToActiveShells[makeKey(origin, target)];
        uint256 originLiquidity = getLiquidity(_shells, origin);
        uint256 targetLiquidity = getLiquidity(_shells, target);
        require(originLiquidity > 0, "origin liquidity is zero");
        require(targetLiquidity > 0, "target liquidity is zero");

        uint256 originAmount;
        for (uint8 i = 0; i < _shells.length; i++) {
            uint256 originBalance = shellBalances[makeKey(_shells[i], origin)];
            uint256 targetBalance = shellBalances[makeKey(_shells[i], target)];
            uint256 targetContribution = wdiv(wmul(targetAmount, targetBalance), targetLiquidity);
            uint256 originCut = calculateTargetPrice(targetContribution, originBalance, targetBalance);
            originAmount += originCut;
        }

        return wmul(originAmount, wdiv(BASIS + protocolFee, BASIS));

    }


    function swapByOrigin (
        address shell,
        address origin,
        address target,
        uint256 originAmount,
        uint256 targetMin,
        uint256 deadline
    ) public  returns (uint256) {

        address[] memory _shells = new address[](1);
        _shells[0] = shell;
        return executeOriginTrade(_shells, origin, target, originAmount, targetMin, deadline, msg.sender);

    }

    function swapByOrigin (
        address origin,
        address target,
        uint256 originAmount,
        uint256 targetMin,
        uint256 deadline
    ) public  returns (uint256) {

        address[] memory _shells = pairsToActiveShells[makeKey(origin, target)];
        return executeOriginTrade(_shells, origin, target, originAmount, targetMin, deadline, msg.sender);

    }

    function swapByOrigin (
        address[] memory _shells,
        address origin,
        address target,
        uint256 originAmount,
        uint256 targetMin,
        uint256 deadline
    ) public returns (uint256) {

        return executeOriginTrade(_shells, origin, target, originAmount, targetMin, deadline, msg.sender);

    }

    function transferByOrigin (
        address shell,
        address origin,
        address target,
        uint256 originAmount,
        uint256 targetMin,
        uint256 deadline,
        address recipient
    ) public returns (uint256) {

        address[] memory _shells = new address[](1);
        _shells[0] = shell;
        return executeOriginTrade(_shells, origin, target, originAmount, targetMin, deadline, recipient);

    }

    function transferByOrigin (
        address origin,
        address target,
        uint256 originAmount,
        uint256 targetMin,
        uint256 deadline,
        address recipient
    ) public returns (uint256) {

        address[] memory _shells = pairsToActiveShells[makeKey(origin, target)];
        return executeOriginTrade(_shells, origin, target, originAmount, targetMin, deadline, recipient);

    }

    function transferByOrigin (
        address[] memory _shells,
        address origin,
        address target,
        uint256 originAmount,
        uint256 targetMin,
        uint256 deadline,
        address recipient
    ) public returns (uint256) {

        return executeOriginTrade(_shells, origin, target, originAmount, targetMin, deadline, recipient);

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
        address[] memory _shells,
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

        uint256 targetLiquidity = getLiquidity(_shells, target);

        uint256 targetAmount;
        for (uint8 i = 0; i < _shells.length; i++) {

            uint256 originBalance = shellBalances[makeKey(_shells[i], origin)];
            uint256 targetBalance = shellBalances[makeKey(_shells[i], target)];

            emit log_named_uint("origin balance before", originBalance);
            emit log_named_uint("target balance before", targetBalance);

            uint256 originCutAfterLiquidityFee = executeOriginCreditOrigin(
                _shells[i],
                origin,
                originAmount,
                targetBalance,
                targetLiquidity
            );

            uint256 targetContribution = executeOriginDebitTarget(
                _shells[i],
                target,
                originCutAfterLiquidityFee,
                originBalance,
                targetBalance
            );

            // haltCheck(
            //     _shells[i],
            //     origin,
            //     target,
            //     add(originCutAfterLiquidityFee, originBalance),
            //     sub(targetBalance, targetContribution)
            // );

            targetAmount += targetContribution;

        }

        require(targetAmount >= targetMin, "target amount was not greater than minimum target amount");

        return finalizeOriginTrade(
            origin,
            target,
            originAmount,
            targetAmount,
            recipient
        );

    }

    function haltCheck (address shell, address origin, address target, uint256 originBalance, uint256 targetBalance) private {
            uint256 power = CowriShell(shell).getNumberOfTokens() - 1;
            uint256 product = getHaltCheckProduct(shell, origin, target);

            emit log_named_uint("power", power);
            emit log_named_uint("product", product);

            uint256 originCheck = wmul(
                wpow(wmul(targetBalance, haltAlpha), power),
                wdiv(WAD, product)
            );

            emit log_named_uint("origin check", originCheck);
            emit log_named_uint("origin balance", originBalance);

            // require(originBalance < originCheck, "halt stop origin");

            uint256 targetCheck = wmul(
                wpow(wdiv(originBalance, haltAlpha), power),
                wdiv(WAD, product)
            );

            emit log_named_uint("target check", targetCheck);
            emit log_named_uint("target balance", targetBalance);

            // require(targetBalance > targetCheck, "halt stop target");

    }

    event log_named_uint(bytes32, uint256);

    function getHaltCheckProduct (address shell, address origin, address target) private returns (uint256) {
        address[] memory tokens = CowriShell(shell).getTokens();
        uint256 product = WAD;
        for (uint i = 0; i < tokens.length; i++) {
            if (tokens[i] == origin || tokens[i] == target) continue;
            product = wmul(product, shellBalances[makeKey(shell, tokens[i])]);
        }
        return product;
    }

    function swapByTarget (
        address origin,
        address target,
        uint256 targetAmount,
        uint256 originMax,
        uint256 deadline,
        address[] memory _shells
    ) public returns (uint256) {

        return executeTargetTrade(_shells, origin, target, targetAmount, originMax, deadline, msg.sender);

    }


    function swapByTarget (
        address origin,
        address target,
        uint256 targetAmount,
        uint256 originMax,
        uint256 deadline
    ) public returns (uint256) {

        address[] memory _shells = pairsToActiveShells[makeKey(origin, target)];
        return executeTargetTrade(_shells, origin, target, targetAmount, originMax, deadline, msg.sender);

    }

    function transferByTarget (
        address origin,
        address target,
        uint256 targetAmount,
        uint256 originMax,
        uint256 deadline,
        address recipient
    ) public returns (uint256) {

        address[] memory _shells = pairsToActiveShells[makeKey(origin, target)];
        return executeTargetTrade(_shells, origin, target, targetAmount, originMax, deadline, recipient);

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