pragma solidity ^0.5.0;

import "ds-math/math.sol";
import "./Shell.sol";
import "./ERC20Token.sol";
import "./CowriState.sol";
import "./Utilities.sol";

contract ExchangeEngine is DSMath, Utilities, CowriState {

    function getLiquidity (address[] memory _shells, address token) private view returns (uint256) {
        uint256 liquidity;
        for (uint8 i = 0; i < _shells.length; i++) {
            liquidity += shellBalances[makeKey(_shells[i], token)];
        }
        return liquidity;
    }

    function getPairLiquidity (address[] memory _shells, address origin, address target) private view returns (uint256, uint256) {
       uint256 originLiquidity;
       uint256 targetLiquidity;
        for (uint8 i = 0; i < _shells.length; i++) {
            uint256 originPairKey = makeKey(_shells[i], origin);
            originLiquidity += shellBalances[originPairKey];
            uint256 targetPairKey = makeKey(_shells[i], target);
            targetLiquidity += shellBalances[targetPairKey];
        }
        return (originLiquidity, targetLiquidity);
    }

    function calculateOriginPrice (uint256 originAmount, uint256 originLiquidity, uint256 targetLiquidity) private pure returns (uint256) {
        return wdiv(
            wmul(originAmount, targetLiquidity),
            add(originAmount, originLiquidity)
        );
    }

    function getOriginPrice (uint256 originAmount, address origin, address target) public  returns (uint256) {
        address[] memory _shells = pairsToActiveShells[makeKey(origin, target)];
        (uint256 originLiquidity, uint256 targetLiquidity) = getPairLiquidity(_shells, origin, target);

        uint256 targetAmount;
        for (uint8 i = 0; i < _shells.length; i++) {
            uint256 originBalance = shellBalances[makeKey(_shells[i], origin)];
            uint256 targetBalance = shellBalances[makeKey(_shells[i], target)];
            uint256 originCut = wdiv(wmul(originAmount, targetBalance), targetLiquidity);
            targetAmount += calculateOriginPrice(originCut, originBalance, targetBalance);
        }

        return targetAmount;
    }

    function calculateTargetPrice (uint256 targetAmount, uint256 originLiquidity, uint256 targetLiquidity) private pure returns (uint256) {
        return wdiv(
            wmul(targetAmount, originLiquidity),
            sub(targetLiquidity, targetAmount)
        );
    }

    function getTargetPrice (uint256 targetAmount, address origin, address target) public view returns (uint256) {

        address[] memory _shells = pairsToActiveShells[makeKey(origin, target)];
        (uint256 originLiquidity, uint256 targetLiquidity) = getPairLiquidity(_shells, origin, target);

        uint256 originAmount;
        for (uint8 i = 0; i < _shells.length; i++) {
            uint256 originBalance = shellBalances[makeKey(_shells[i], origin)];
            uint256 targetBalance = shellBalances[makeKey(_shells[i], target)];
            uint256 targetContribution = wdiv(wmul(targetAmount, targetBalance), targetLiquidity);
            originAmount += calculateTargetPrice(targetContribution, originBalance, targetBalance);
        }

        return originAmount;

    }

    function swapByOrigin (uint256 amount, address origin, address target) public returns (uint256) {
        return executeOriginTrade(amount, origin, target, msg.sender);
    }

    function transferByOrigin (uint256 amount, address origin, address target, address recipient) public returns (uint256) {
        return executeOriginTrade(amount, origin, target, recipient);
    }

    function executeOriginTrade (uint256 originAmount, address origin, address target, address recipient) private returns (uint256) {

        address[] memory _shells = pairsToActiveShells[makeKey(origin, target)];
        uint256 targetLiquidity = getLiquidity(_shells, target);

        uint256 targetAmount;
        for (uint8 i = 0; i < _shells.length; i++) {
            uint256 originKey = makeKey(_shells[i], origin);
            uint256 originBalance = shellBalances[originKey];
            uint256 targetKey = makeKey(_shells[i], target);
            uint256 targetBalance = shellBalances[targetKey];
            uint256 originCut = wdiv(wmul(originAmount, targetBalance), targetLiquidity);
            uint256 targetContribution = calculateOriginPrice(originCut, originBalance, targetBalance);
            shellBalances[originKey] = add(originBalance, originCut);
            shellBalances[targetKey] = sub(targetBalance, targetContribution);
            targetAmount += targetContribution;
        }

        adjustedTransferFrom(ERC20Token(origin), recipient, originAmount);
        return adjustedTransfer(ERC20Token(target), recipient, targetAmount);

    }

    function swapByTarget (uint256 amount, address origin, address target) public returns (uint256) {
        return executeTargetTrade(amount, origin, target, msg.sender);
    }

    function transferByTarget (uint256 amount, address origin, address target, address recipient) public returns (uint256) {
        return executeTargetTrade(amount, origin, target, recipient);
    }

    function executeTargetTrade (uint256 targetAmount, address origin, address target, address recipient) private returns (uint256) {

        address[] memory _shells = pairsToActiveShells[makeKey(origin, target)];
        uint256 targetLiquidity = getLiquidity(_shells, target);

        uint256 originAmount;
        for (uint8 i = 0; i < _shells.length; i++) {
            uint256 originKey = makeKey(_shells[i], origin);
            uint256 targetKey = makeKey(_shells[i], target);
            uint256 originBalance = shellBalances[originKey];
            uint256 targetBalance = shellBalances[targetKey];
            uint256 targetContribution = wdiv(wmul(targetAmount, targetBalance), targetLiquidity);
            uint256 originCut = calculateTargetPrice(targetContribution, originBalance, targetBalance);
            shellBalances[originKey] = add(originBalance, originCut);
            shellBalances[targetKey] = sub(targetBalance, targetContribution);
            originAmount += originCut;
        }

        adjustedTransfer(ERC20Token(target), recipient, targetAmount);
        return adjustedTransferFrom(ERC20Token(origin), recipient, originAmount);

    }

}