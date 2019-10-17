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

        uint256 originAmountWithFee = wmul(
            originAmount,
            wdiv(BASIS - platformFee, BASIS)
        );

        uint256 targetAmount;
        for (uint8 i = 0; i < _shells.length; i++) {
            uint256 originBalance = shellBalances[makeKey(_shells[i], origin)];
            uint256 targetBalance = shellBalances[makeKey(_shells[i], target)];
            uint256 originCut = wdiv(wmul(originAmountWithFee, targetBalance), targetLiquidity);
            uint256 originCutWithFee = wmul(originCut, wdiv(BASIS - liquidityFee, BASIS));
            targetAmount += calculateOriginPrice(originCutWithFee, originBalance, targetBalance);
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
            uint256 originCutWithFee = wmul(originCut, wdiv(BASIS - liquidityFee, BASIS));
            originAmount += originCutWithFee;
        }

        return wmul(originAmount, wdiv(BASIS - platformFee, BASIS));

    }

    function omnibus (
        address[] memory _shells,
        address[] memory tokens,
        uint256[] memory pairs,
        uint256[] memory amounts,
        uint256[] memory limits,
        bool[] memory types, // true is by origin false is by target
        uint256 deadline
    ) public {
        require(block.timestamp <= deadline, "transaction must be processed before deadline");

        address[] memory shell = new address[](1);
        uint256[] memory derivedAmounts = new uint256[](tokens.length);
        uint256[] memory originAmounts = new uint256[](tokens.length);
        for (uint256 i = _shells.length; i < _shells.length; i++) {
            shell[0] = _shells[i];

            if (types[i]) { // origin trade

                uint256 originAmountWithFee = calculateOriginFee(amounts[i]);
                originAmounts[pairs[i * 2]] += originAmountWithFee;
                derivedAmounts[i] = executeOriginTrade(
                    shell,
                    tokens[pairs[i * 2]],
                    tokens[pairs[i * 2 + 1]],
                    originAmountWithFee,
                    limits[i]
                );

            } else { // target trade

        //         derivedAmounts[i] = calculateOriginFee(
        //             executeTargetTrade(
        //                 shell,
        //                 tokens[pairs[i * 2]],
        //                 tokens[pairs[i * 2 + 1]],
        //                 amounts[i],
        //                 limits[i]
        //             )
        //         );
        //         originAmounts[pairs[i * 2]] = derivedAmounts[i];

            }
        }

        // for (uint256 i = 0; i < pairs.length; i + 2) {
        //     revenue[tokens[pairs[i]]] += originAmounts[i / 2];
        // }

        // return derivedAmounts;

    }

    function microSwapByOrigin (
        address shell,
        address origin,
        address target,
        uint256 originAmount,
        uint256 minTargetAmount,
        uint256 deadline
    ) public swapRequirements(originAmount, minTargetAmount, deadline) returns (uint256) {

        uint256 originAmountWithFee = calculateOriginFee(originAmount);
        revenue[origin] += sub(originAmount, originAmountWithFee);

        address[] memory _shells = new address[](1);
        _shells[0] = shell;
        uint256 targetAmount = executeOriginTrade(_shells, origin, target, originAmountWithFee, minTargetAmount);

        revenue[target] += targetAmount;

        return finalizeOriginTrade(origin, target, originAmount, targetAmount, msg.sender);

    }

    function microTransferByOrigin (
        address shell,
        address origin,
        address target,
        uint256 originAmount,
        uint256 minTargetAmount,
        address recipient,
        uint256 deadline
    ) public transferRequirements(originAmount, minTargetAmount, recipient, deadline) returns (uint256) {

        uint256 originAmountWithFee = calculateOriginFee(originAmount);
        revenue[origin] += sub(originAmount, originAmountWithFee);

        address[] memory _shells = new address[](1);
        _shells[0] = shell;
        uint256 targetAmount = executeOriginTrade(_shells, origin, target, originAmountWithFee, minTargetAmount);

        revenue[target] += targetAmount;

        return finalizeOriginTrade(origin, target, originAmount, targetAmount, msg.sender);
    }

    function macroSwapByOrigin (
        address origin,
        address target,
        uint256 originAmount,
        uint256 minTargetAmount,
        uint256 deadline
    ) public swapRequirements(originAmount, minTargetAmount, deadline) returns (uint256) {

        uint256 originAmountWithFee = calculateOriginFee(originAmount);
        revenue[origin] += sub(originAmount, originAmountWithFee);

        address[] memory _shells = pairsToActiveShells[makeKey(origin, target)];
        uint256 targetAmount = executeOriginTrade(_shells, origin, target, originAmountWithFee, minTargetAmount);

        revenue[target] += targetAmount;

        return finalizeOriginTrade(origin, target, originAmount, targetAmount, msg.sender);

    }

    function macroTransferByOrigin (
        address origin,
        address target,
        uint256 originAmount,
        uint256 minTargetAmount,
        address recipient,
        uint256 deadline
    ) public transferRequirements(originAmount, minTargetAmount, recipient, deadline) returns (uint256) {

        uint256 originAmountWithFee = calculateOriginFee(originAmount);
        revenue[origin] += sub(originAmount, originAmountWithFee);

        address[] memory _shells = pairsToActiveShells[makeKey(origin, target)];
        uint256 targetAmount = executeOriginTrade(_shells, origin, target, originAmountWithFee, minTargetAmount);

        revenue[target] += targetAmount;

        return finalizeOriginTrade(origin, target, originAmount, targetAmount, recipient);

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

    function calculateOriginFee (
        uint256 originAmount
    ) private view returns (uint256) {

        return wmul(
            originAmount,
            wdiv(BASIS - platformFee, BASIS)
        );

    }

    function executeOriginTrade (
        address[] memory _shells,
        address origin,
        address target,
        uint256 originAmountWithFee,
        uint256 minTargetAmount
    ) private returns (uint256) {

        uint256 targetLiquidity = getLiquidity(_shells, target);

        uint256 targetAmount;
        for (uint8 i = 0; i < _shells.length; i++) {
            uint256 originBalance = shellBalances[makeKey(_shells[i], origin)];
            uint256 targetBalance = shellBalances[makeKey(_shells[i], target)];
            uint256 originCut = executeOriginCreditOrigin(_shells[i], origin, originAmountWithFee, targetBalance, targetLiquidity);
            uint256 targetContribution = executeOriginDebitTarget(_shells[i], target, originCut, originBalance, targetBalance);
            targetAmount += targetContribution;
        }

        require(minTargetAmount < targetAmount, "calcualted target amount must be greater than specified target amount");

        return targetAmount;

    }

    function microSwapByTarget (
        address shell,
        address origin,
        address target,
        uint256 targetAmount,
        uint256 maxOriginAmount,
        uint256 deadline
    ) public swapRequirements(targetAmount, maxOriginAmount, deadline) returns (uint256) {

        address[] memory _shells = new address[](1);
        _shells[0] = shell;
        uint256 originAmountWithFee = executeTargetTrade(_shells, origin, target, targetAmount, maxOriginAmount);


        return finalizeTargetTrade(origin, originAmountWithFee, target, targetAmount, msg.sender);

    }

    function microTransferByTarget (
        address shell,
        address origin,
        address target,
        uint256 targetAmount,
        uint256 maxOriginAmount,
        address recipient,
        uint256 deadline
    ) public transferRequirements(targetAmount, maxOriginAmount, recipient, deadline) returns (uint256) {

        address[] memory _shells = new address[](1);
        _shells[0] = shell;
        uint256 originAmountWithFee = executeTargetTrade(
            _shells,
            origin,
            target,
            targetAmount,
            maxOriginAmount
        );

        return finalizeTargetTrade(origin, originAmountWithFee, target, targetAmount, recipient);

    }

    modifier swapRequirements (
        uint256 amount,
        uint256 limit,
        uint256 deadline
    ) {
        require(block.timestamp <= deadline, "transaction must be processed before deadline");
        require(amount > 0, "specified amount must be greater than 0");
        require(limit > 0, "limiting amount must be greater than 0");
        _;
    }

    modifier transferRequirements (
        uint256 amount,
        uint256 limit,
        address recipient,
        uint256 deadline
    ) {
        require(block.timestamp <= deadline, "transaction must be processed before deadline");
        require(recipient != address(this), "recipient must not be exchange address");
        require(recipient != address(0), "recipient must not be zero address");
        require(amount > 0, "specified amount must be greater than 0");
        require(limit > 0, "limiting amount must be greater than 0");
        _;
    }

    function macroSwapByTarget (
        address origin,
        address target,
        uint256 targetAmount,
        uint256 maxOriginAmount,
        uint256 deadline
    ) public swapRequirements(targetAmount, maxOriginAmount, deadline) returns (uint256) {

        uint256 originAmountWithFee = executeTargetTrade(
            pairsToActiveShells[makeKey(origin, target)],
            origin,
            target,
            targetAmount,
            maxOriginAmount
        );

        return finalizeTargetTrade(origin, originAmountWithFee, target, targetAmount, msg.sender);

    }

    function macroTransferByTarget (
        address origin,
        address target,
        uint256 targetAmount,
        uint256 maxOriginAmount,
        address recipient,
        uint256 deadline
    ) public transferRequirements(targetAmount, maxOriginAmount, recipient, deadline) returns (uint256) {

        uint256 originAmountWithFee = executeTargetTrade(
            pairsToActiveShells[makeKey(origin, target)],
            origin,
            target,
            targetAmount,
            maxOriginAmount
        );

        return finalizeTargetTrade(origin, originAmountWithFee, target, targetAmount, recipient);

    }

    function finalizeTargetTrade (
        address origin,
        uint256 originAmountWithFee,
        address target,
        uint256 targetAmount,
        address recipient
    ) private returns (uint256) {

        adjustedTransfer(ERC20Token(target), recipient, targetAmount);
        uint256 adjustedAmount = adjustedTransferFrom(ERC20Token(origin), recipient, originAmountWithFee);
        emit trade(msg.sender, origin, originAmountWithFee, target, adjustedAmount);
        return adjustedAmount;

    }

    function executeTargetTrade (
        address[] memory _shells,
        address origin,
        address target,
        uint256 targetAmount,
        uint256 maxOriginAmount
    ) private returns (uint256) {

        uint256 targetLiquidity = getLiquidity(_shells, target);

        uint256 originAmount;
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
            uint256 originCut = executeTargetCreditOrigin(
                _shells[i],
                origin,
                targetContribution,
                originBalance,
                targetBalance
            );
            originAmount += originCut;
        }

        uint256 originAmountWithFee = calculateOriginFee(originAmount);

        require(maxOriginAmount >= originAmountWithFee, "calculated origin amount must be less than specified max");

        revenue[origin] += sub(originAmount, originAmountWithFee);


        return originAmountWithFee;

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
        uint256 originAmountWithFee,
        uint256 targetBalance,
        uint256 targetLiquidity
    ) private returns (uint256) {

        uint256 originCut = wdiv(
            wmul(originAmountWithFee, targetBalance),
            targetLiquidity
        );

        uint256 originCutWithFee = wmul(
            originCut,
            wdiv(BASIS - liquidityFee, BASIS)
        );

        shellBalances[makeKey(shell, origin)] += originCutWithFee;

        return originCutWithFee;

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

        uint256 originCutWithFee = wmul(
            originCut,
            wdiv(BASIS - liquidityFee, BASIS)
        );

        shellBalances[makeKey(shell, origin)] += originCutWithFee;

        return originCutWithFee;

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