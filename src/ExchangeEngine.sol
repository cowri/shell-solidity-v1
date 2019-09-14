pragma solidity ^0.5.0;

import "ds-math/math.sol";
import "./Shell.sol";
import "./ERC20Token.sol";
import "./CowriState.sol";
import "./Adjusters.sol";

contract ExchangeEngine is DSMath, Adjusters, CowriState {

   function getPairLiquidity (address[] memory _shells, address origin, address target) private view returns (uint256, uint256) {
        uint256 originLiquidity;
        uint256 targetLiquidity;
        for (uint8 i = 0; i < _shells.length; i++) {
            originLiquidity += shells[_shells[i]][origin];
            targetLiquidity += shells[_shells[i]][target];
        }
        return (originLiquidity, targetLiquidity);
    }

    function calculateOriginPrice (uint256 originAmount, uint256 originLiquidity, uint256 targetLiquidity) private pure returns (uint256) {
        return wdiv(
            wmul(originAmount, targetLiquidity),
            add(originAmount, originLiquidity)
        );
    }

    function getOriginPrice (uint256 originAmount, address origin, address target) public view returns (uint256) {
<<<<<<< HEAD
        address[] memory _shells = pairsToActiveShellAddresses[origin][target];
=======
        address[] memory _shells = pairsToShellAddresses[origin][target];
>>>>>>> master
        (uint256 originLiquidity, uint256 targetLiquidity) = getPairLiquidity(_shells, origin, target);
        return calculateOriginPrice(originAmount, originLiquidity, targetLiquidity);
    }

    function calculateTargetPrice (uint256 targetAmount, uint256 originLiquidity, uint256 targetLiquidity) private pure returns (uint256) {
        return wdiv(
            wmul(targetAmount, originLiquidity),
            sub(targetLiquidity, targetAmount)
        );
    }

    function getTargetPrice (uint256 targetAmount, address origin, address target) public view returns (uint256) {
<<<<<<< HEAD
        address[] memory _shells = pairsToActiveShellAddresses[origin][target];
=======
        address[] memory _shells = pairsToShellAddresses[origin][target];
>>>>>>> master
        (uint256 originLiquidity, uint256 targetLiquidity) = getPairLiquidity(_shells, origin, target);
        return calculateTargetPrice(targetAmount, originLiquidity, targetLiquidity);
    }

    function swapByOrigin (uint256 amount, address origin, address target) public returns (uint256) {
        return executeOriginTrade(amount, origin, target, msg.sender);
    }

    function transferByOrigin (uint256 amount, address origin, address target, address recipient) public returns (uint256) {
        return executeOriginTrade(amount, origin, target, recipient);
    }

    function executeOriginTrade (uint256 originAmount, address origin, address target, address recipient) private returns (uint256) {

<<<<<<< HEAD
        address[] memory _shells = pairsToActiveShellAddresses[origin][target];
=======
        address[] memory _shells = pairsToShellAddresses[origin][target];
>>>>>>> master
        (uint256 originLiquidity, uint256 targetLiquidity) = getPairLiquidity(_shells, origin, target);

        uint256 targetAmount = calculateOriginPrice(originAmount, originLiquidity, targetLiquidity);
        balanceShells(_shells, origin, originAmount, target, targetAmount, targetLiquidity);

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

<<<<<<< HEAD
        address[] memory _shells = pairsToActiveShellAddresses[origin][target];
=======
        address[] memory _shells = pairsToShellAddresses[origin][target];
>>>>>>> master
        (uint256 originLiquidity, uint256 targetLiquidity) = getPairLiquidity(_shells, origin, target);

        uint256 originAmount = calculateTargetPrice(targetAmount, originLiquidity, targetLiquidity);
        balanceShells(_shells, origin, originAmount, target, targetAmount, targetLiquidity);

        adjustedTransfer(ERC20Token(target), recipient, targetAmount);
        return adjustedTransferFrom(ERC20Token(origin), recipient, originAmount);

    }

    function balanceShells (address[] memory _shells, address origin, uint256 originAmount, address target, uint256 targetAmount, uint256 targetLiquidity) private {
        uint256 originBalance;
        uint256 targetBalance;
        for (uint8 i = 0; i < _shells.length; i++) {

            targetBalance = shells[_shells[i]][target];
            shells[_shells[i]][target] = sub(
                targetBalance,
                wdiv(
                    wmul(targetAmount, targetBalance),
                    targetLiquidity
                )
            );

            originBalance = shells[_shells[i]][origin];
            shells[_shells[i]][origin] = add(
                originBalance,
                wdiv(
                    wmul(originAmount, targetBalance),
                    targetLiquidity
                )
            );
        }
    }

}