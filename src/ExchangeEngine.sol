pragma solidity ^0.5.0;

import "ds-math/math.sol";
import "./Shell.sol";
import "./ERC20Token.sol";
import "./CowriState.sol";
import "./Adjusters.sol";

contract ExchangeEngine is DSMath, Adjusters, CowriState {

    event log_addr_arr(bytes32 key, address[] val);
    event log_addr(bytes32 key, address val);
    event log_named_uint(bytes32 key, uint256 val);

    function getPairLiquidity (address[] memory _shells, address origin, address target) private view returns (uint256, uint256) {
       uint256 originLiquidity;
       uint256 targetLiquidity;
        for (uint8 i = 0; i < _shells.length; i++) {
            originLiquidity += shellBalances[_shells[i]][origin];
            targetLiquidity += shellBalances[_shells[i]][target];
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
        address[] memory _shells = pairsToActiveShells[origin][target];
        (uint256 originLiquidity, uint256 targetLiquidity) = getPairLiquidity(_shells, origin, target);

        uint256 targetAmount;
        for (uint8 i = 0; i < _shells.length; i++) {
            uint256 originBalance = shellBalances[_shells[i]][origin];
            uint256 targetBalance = shellBalances[_shells[i]][target];
            uint256 originCut = wdiv(wmul(originAmount, targetBalance), targetLiquidity);
            uint256 targetContribution = calculateOriginPrice(originCut, originBalance, targetBalance);
            targetAmount += targetContribution;
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
        address[] memory _shells = pairsToActiveShells[origin][target];
        (uint256 originLiquidity, uint256 targetLiquidity) = getPairLiquidity(_shells, origin, target);

        uint256 originAmount;
        for (uint8 i = 0; i < _shells.length; i++) {
            uint256 targetBalance = shellBalances[_shells[i]][target];
            uint256 originBalance = shellBalances[_shells[i]][origin];
            uint256 targetContribution = wdiv(wmul(targetAmount, targetBalance), targetLiquidity);
            uint256 originCut = calculateTargetPrice(targetContribution, originBalance, targetBalance);
            originAmount += originCut;
        }

        return originAmount;
    }

    function swapByTarget (uint256 amount, address origin, address target) public returns (uint256) {
        return executeTargetTrade(amount, origin, target, msg.sender);
    }

    function transferByTarget (uint256 amount, address origin, address target, address recipient) public returns (uint256) {
        return executeTargetTrade(amount, origin, target, recipient);
    }

    function executeTargetTrade (uint256 targetAmount, address origin, address target, address recipient) private returns (uint256) {

        address[] memory _shells = pairsToActiveShells[origin][target];
        (uint256 originLiquidity, uint256 targetLiquidity) = getPairLiquidity(_shells, origin, target);

        uint256 originAmount;
        for (uint8 i = 0; i < _shells.length; i++) {
            uint256 targetBalance = shellBalances[_shells[i]][target];
            uint256 originBalance = shellBalances[_shells[i]][origin];

            uint256 targetContribution = wdiv(
                wmul(targetAmount, targetBalance),
                targetLiquidity
            );

            uint256 originCut = calculateTargetPrice(targetContribution, originBalance, targetBalance);
            originAmount += originCut;

            shellBalances[_shells[i]][origin] = add(originBalance, originCut);
            shellBalances[_shells[i]][target] = sub(targetBalance, targetContribution);
        }

        adjustedTransfer(ERC20Token(target), recipient, targetAmount);
        return adjustedTransferFrom(ERC20Token(origin), recipient, originAmount);

    }

    function swapByOrigin (uint256 amount, address origin, address target) public returns (uint256) {
        return executeOriginTrade(amount, origin, target, msg.sender);
    }

    function transferByOrigin (uint256 amount, address origin, address target, address recipient) public returns (uint256) {
        return executeOriginTrade(amount, origin, target, recipient);
    }

    function executeOriginTrade (uint256 originAmount, address origin, address target, address recipient) private returns (uint256) {

        address[] memory _shells = pairsToActiveShells[origin][target];
        (uint256 originLiquidity, uint256 targetLiquidity) = getPairLiquidity(_shells, origin, target);

        uint256 targetAmount;
        for (uint8 i = 0; i < _shells.length; i++) {

            uint256 originBalance = shellBalances[_shells[i]][origin];
            uint256 targetBalance = shellBalances[_shells[i]][target];

            uint256 originCut = wdiv(
                wmul(originAmount, targetBalance),
                targetLiquidity
            );

            uint256 targetContribution = calculateOriginPrice(originCut, originBalance, targetBalance);

            shellBalances[_shells[i]][origin] = add(originBalance, originCut);
            shellBalances[_shells[i]][target] = sub(targetBalance, targetContribution);

            targetAmount += targetContribution;

        }

        adjustedTransferFrom(ERC20Token(origin), recipient, originAmount);
        return adjustedTransfer(ERC20Token(target), recipient, targetAmount);

    }

}