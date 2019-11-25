pragma solidity ^0.5.0;

import "./Shell.sol";
import "./ERC20Token.sol";
import "./CowriRoot.sol";

contract ExchangeEngine is CowriRoot {

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
        uint256 originAmount,
        address shell,
        address origin,
        address target
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
        uint256 targetAmount,
        address shell,
        address origin,
        address target
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

    event log_arr(bytes32, address[]);
    /**
    * Execute any amount of micro or macro swaps
    *
    * @param _shells array of shell addresses
    * @param tokens array of token addresses
    * @param pairs pairs of origin and targets as indexes referring to tokens array
    * @param amounts amount of input, origin for origin trade, target for target trade
    * @param limits limits of output, min target for origin trade, max origin for target trade
    * @param types true for origin trade, false for target trade
    * @return origin amount or target amount from origin/target trades.
    */
    function omnibus (
        address[] memory _shells,
        address[] memory tokens,
        uint256[] memory pairs,
        uint256[] memory amounts,
        uint256[] memory limits,
        bool[] memory types,
        uint256 deadline
    ) public returns (uint256[] memory) {
        require(block.timestamp <= deadline, "transaction must be processed before deadline");

        address[] memory shellArr;
        uint256[] memory derivedAmounts = new uint256[](pairs.length / 2);
        uint256[] memory protocolFees = new uint256[](pairs.length / 2);
        for (uint256 i = 0; i < _shells.length; i++) {

            if (_shells[i] == address(0)) {
                shellArr = pairsToActiveShells
                    [makeKey(tokens[pairs[i*2]], tokens[pairs[i*2+1]])];
            } else {
                shellArr = new address[](1);
                shellArr[0] = _shells[i];
            }

            if (types[i]) { // origin trade

                protocolFees[pairs[i * 2]] += calculateProtocolFeeForOriginTrade(amounts[i]);
                uint256 targetAmountAfterLiquidityFee = executeOriginTrade(
                    shellArr,
                    tokens[pairs[i * 2]],
                    tokens[pairs[i * 2 + 1]],
                    calculateOriginAmountForOriginTrade(amounts[i])
                );

                require(targetAmountAfterLiquidityFee >= limits[i],
                    "target amounnt was not greater than or equal to min target amount");

                derivedAmounts[i] = targetAmountAfterLiquidityFee;

            } else { // target trade

                uint256 originAmountIncludingFees = executeTargetTrade(
                    shellArr,
                    tokens[pairs[i * 2]],
                    tokens[pairs[i * 2 + 1]],
                    amounts[i]
                );

                protocolFees[pairs[i*2]] += calculateProtocolFeeForTargetTrade(originAmountIncludingFees);
                originAmountIncludingFees = calculateOriginAmountForTargetTrade(originAmountIncludingFees);

                require(originAmountIncludingFees <= limits[i],
                    "origin amount was not greater than or equal to max origin amount");

                derivedAmounts[i] = originAmountIncludingFees;

            }

        }

        for (uint256 i = 0; i < tokens.length; i++) revenue[tokens[i]] += protocolFees[i];

        for (uint256 i = 0; i < derivedAmounts.length; i++) {
            if (types[i]) { // origin trade

                finalizeOriginTrade(
                    tokens[pairs[i*2]],
                    tokens[pairs[i*2+1]],
                    amounts[i],
                    derivedAmounts[i],
                    msg.sender
                );

            } else { // target trade

                finalizeTargetTrade(
                    tokens[pairs[i*2]],
                    tokens[pairs[i*2+1]],
                    derivedAmounts[i],
                    amounts[i],
                    msg.sender
                );

            }

        }

        return derivedAmounts;

    }

    event log_arr(bytes32, uint256[]);
    event log_named_bool(bytes32, bool);

    function microSwapByOrigin (
        address shell,
        address origin,
        address target,
        uint256 originAmount,
        uint256 minTargetAmount,
        uint256 deadline
    ) public returns (uint256) {

        require(block.timestamp <= deadline,
            "transaction must be processed before deadline");
        require(originAmount > 0 && minTargetAmount > 0,
            "origin amount and min target amount must be valid values");

        revenue[origin] += calculateProtocolFeeForOriginTrade(originAmount);

        address[] memory _shells = new address[](1);
        _shells[0] = shell;
        uint256 targetAmountWithLiquidityFee = executeOriginTrade(
            _shells,
            origin,
            target,
            calculateOriginAmountForOriginTrade(originAmount)
        );

        require(targetAmountWithLiquidityFee >= minTargetAmount,
            "target amount was not greater than minimum target amount");

        return finalizeOriginTrade(
            origin,
            target,
            originAmount,
            targetAmountWithLiquidityFee,
            msg.sender
        );

    }

    function microTransferByOrigin (
        address shell,
        address origin,
        address target,
        uint256 originAmount,
        uint256 minTargetAmount,
        address recipient,
        uint256 deadline
    ) public returns (uint256) {

        require(block.timestamp <= deadline,
            "transaction must be processed before deadline");
        require(recipient != address(this) && recipient != address(0),
            "recipient must be valid address");
        require(originAmount > 0 && minTargetAmount > 0,
            "origin amount and min target amount must be valid values");

        revenue[origin] += calculateProtocolFeeForOriginTrade(originAmount);

        address[] memory _shells = new address[](1);
        _shells[0] = shell;
        uint256 targetAmountAfterFees = executeOriginTrade(
            _shells,
            origin,
            target,
            calculateOriginAmountForOriginTrade(originAmount)
        );

        require(targetAmountAfterFees >= minTargetAmount,
            "target amount was not greater than minimum target amount");

        return finalizeOriginTrade(
            origin,
            target,
            originAmount,
            targetAmountAfterFees,
            msg.sender
        );

    }

    function macroSwapByOrigin (
        address origin,
        address target,
        uint256 originAmount,
        uint256 minTargetAmount,
        uint256 deadline
    ) public returns (uint256) {

        require(block.timestamp <= deadline,
            "transaction must be processed before deadline");
        require(originAmount > 0 && minTargetAmount > 0,
            "origin amount and min target amount must be valid values");

        revenue[origin] += calculateProtocolFeeForOriginTrade(originAmount);

        address[] memory _shells = pairsToActiveShells[makeKey(origin, target)];
        uint256 targetAmountAfterFees = executeOriginTrade(
            _shells,
            origin,
            target,
            calculateOriginAmountForOriginTrade(originAmount)
        );

        require(targetAmountAfterFees >= minTargetAmount,
            "target amount was not greater than or equal to min target amount");

        return finalizeOriginTrade(
            origin,
            target,
            originAmount,
            targetAmountAfterFees,
            msg.sender
        );

    }


    function macroTransferByOrigin (
        address origin,
        address target,
        uint256 originAmount,
        uint256 minTargetAmount,
        address recipient,
        uint256 deadline
    ) public returns (uint256) {

        require(block.timestamp <= deadline,
            "transaction must be processed before deadline");
        require(recipient != address(this) && recipient != address(0),
            "recipient must be valid address");
        require(originAmount > 0 && minTargetAmount > 0,
            "origin amount and min target amount must be valid values");

        revenue[origin] += calculateProtocolFeeForOriginTrade(originAmount);

        address[] memory _shells = pairsToActiveShells[makeKey(origin, target)];
        uint256 targetAmountAfterFees = executeOriginTrade(
            _shells,
            origin,
            target,
            calculateOriginAmountForOriginTrade(originAmount)
        );

        require(targetAmountAfterFees >= minTargetAmount,
            "target amount was not greater than or equal to minimum target amount");

        return finalizeOriginTrade(
            origin,
            target,
            originAmount,
            targetAmountAfterFees,
            recipient
        );

    }

    event log_named_address(bytes32, address);

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
        return wmul(originAmount, wdiv(BASIS + protocolFee, BASIS));
        // return add(
        //     originAmount,
        //     calculateProtocolFeeForOriginTrade(originAmount)
        // );
    }

    function calculateProtocolFeeForTargetTrade (
        uint256 originAmount
    ) private view returns (uint256) {
        return sub(
            // wdiv(wmul(originAmount, BASIS + protocolFee), BASIS),
            wmul(originAmount, wdiv(BASIS + protocolFee, BASIS)),
            originAmount
        );
    }

    event log_addr(bytes32 key, address val);

    function executeOriginTrade (
        address[] memory _shells,
        address origin,
        address target,
        uint256 originAmountAfterProtocolFee
    ) private returns (uint256) {

        uint256 targetLiquidity = getLiquidity(_shells, target);

        uint256 targetAmount;
        for (uint8 i = 0; i < _shells.length; i++) {

            uint256 originBalance = shellBalances[makeKey(_shells[i], origin)];
            uint256 targetBalance = shellBalances[makeKey(_shells[i], target)];

            uint256 originCutWithLiquidityFee = executeOriginCreditOrigin(
                _shells[i],
                origin,
                originAmountAfterProtocolFee,
                targetBalance,
                targetLiquidity
            );

            uint256 targetContribution = executeOriginDebitTarget(
                _shells[i],
                target,
                originCutWithLiquidityFee,
                originBalance,
                targetBalance
            );

            targetAmount += targetContribution;

        }

        return targetAmount;

    }

    function microSwapByTarget (
        address shell,
        address origin,
        address target,
        uint256 targetAmount,
        uint256 maxOriginAmount,
        uint256 deadline
    ) public returns (uint256) {

        require(block.timestamp <= deadline,
            "transaction must be processed before deadline");
        require(targetAmount > 0 && maxOriginAmount > 0,
            "target amount and max origin amount must be valid values");

        address[] memory _shells = new address[](1);
        _shells[0] = shell;
        uint256 originAmountIncludingFees = executeTargetTrade(
            _shells,
            origin,
            target,
            targetAmount
        );

        revenue[origin] += calculateProtocolFeeForTargetTrade(originAmountIncludingFees);
        originAmountIncludingFees = calculateOriginAmountForTargetTrade(originAmountIncludingFees);

        require(maxOriginAmount >= originAmountIncludingFees,
            "origin amount must be less than or equal to maximum origin amount");

        return finalizeTargetTrade(
            origin,
            target,
            originAmountIncludingFees,
            targetAmount,
            msg.sender
        );

    }

    function microTransferByTarget (
        address shell,
        address origin,
        address target,
        uint256 targetAmount,
        uint256 maxOriginAmount,
        address recipient,
        uint256 deadline
    ) public returns (uint256) {

        require(block.timestamp <= deadline,
            "transaction must be processed before deadline");
        require(recipient != address(this) && recipient != address(0),
            "recipient must be valid address");
        require(targetAmount > 0 && maxOriginAmount > 0,
            "target amount and max origin amount must be valid values");

        address[] memory _shells = new address[](1);
        _shells[0] = shell;
        uint256 originAmountIncludingFees = executeTargetTrade(
            _shells,
            origin,
            target,
            targetAmount
        );

        revenue[origin] += calculateProtocolFeeForTargetTrade(originAmountIncludingFees);
        originAmountIncludingFees = calculateOriginAmountForTargetTrade(originAmountIncludingFees);

        require(maxOriginAmount >= originAmountIncludingFees,
            "origin amount must be less than or equal to maximum origin amount");

        return finalizeTargetTrade(
            origin,
            target,
            originAmountIncludingFees,
            targetAmount,
            recipient
        );

    }

    function macroSwapByTarget (
        address origin,
        address target,
        uint256 targetAmount,
        uint256 maxOriginAmount,
        uint256 deadline
    ) public returns (uint256) {

        require(block.timestamp <= deadline,
            "transaction must be processed before deadline");
        require(targetAmount > 0 && maxOriginAmount > 0,
            "target amount and max origin amount must be valid values");

        uint256 originAmountIncludingFees = executeTargetTrade(
            pairsToActiveShells[makeKey(origin, target)],
            origin,
            target,
            targetAmount
        );

        revenue[origin] += calculateProtocolFeeForTargetTrade(originAmountIncludingFees);
        originAmountIncludingFees = calculateOriginAmountForTargetTrade(originAmountIncludingFees);

        require(maxOriginAmount >= originAmountIncludingFees,
            "origin amount must be less than or equal to maximum origin amount");

        return finalizeTargetTrade(
            origin,
            target,
            originAmountIncludingFees,
            targetAmount,
            msg.sender
        );

    }

    function macroTransferByTarget (
        address origin,
        address target,
        uint256 targetAmount,
        uint256 maxOriginAmount,
        address recipient,
        uint256 deadline
    ) public returns (uint256) {

        require(block.timestamp <= deadline,
            "transaction must be processed before deadline");
        require(recipient != address(this) && recipient != address(0),
            "recipient must be valid address");
        require(targetAmount > 0 && maxOriginAmount > 0,
            "target amount and max origin amount must be valid values");

        uint256 originAmountIncludingFees = executeTargetTrade(
            pairsToActiveShells[makeKey(origin, target)],
            origin,
            target,
            targetAmount
        );

        revenue[origin] += calculateProtocolFeeForTargetTrade(originAmountIncludingFees);
        originAmountIncludingFees = calculateOriginAmountForTargetTrade(originAmountIncludingFees);

        require(maxOriginAmount >= originAmountIncludingFees,
            "origin amount must be less than or equal to maximum origin amount");

        return finalizeTargetTrade(
            origin,
            target,
            originAmountIncludingFees,
            targetAmount,
            msg.sender
        );

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
        uint256 targetAmount
    ) private returns (uint256) {

        uint256 targetLiquidity = getLiquidity(_shells, target);

        uint256 originAmountsWithLiquidityFees;
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

            originAmountsWithLiquidityFees += executeTargetCreditOrigin(
                _shells[i],
                origin,
                targetContribution,
                originBalance,
                targetBalance
            );

        }

        return originAmountsWithLiquidityFees;

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