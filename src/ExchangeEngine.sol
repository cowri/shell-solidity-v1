pragma solidity ^0.5.0;

import "ds-math/math.sol";
import "./Shell.sol";
import "./ERC20Token.sol";
import "./CowriState.sol";
import "./Utilities.sol";

contract ExchangeEngine is DSMath, Utilities, CowriState {

    event trade(address indexed buyer, address indexed origin, uint256 originSold, address indexed target, uint256 targetBought);

    function getLiquidity (address[] memory _shells, address token) private view returns (uint256) {
        uint256 liquidity;
        for (uint8 i = 0; i < _shells.length; i++) {
            liquidity += shellBalances[makeKey(_shells[i], token)];
        }
        return liquidity;
    }

    function calculateOriginPrice (uint256 originAmount, uint256 originLiquidity, uint256 targetLiquidity) private pure returns (uint256) {
        return wdiv(
            wmul(originAmount, targetLiquidity),
            add(originAmount, originLiquidity)
        );
    }

    function getOriginPrice (address origin, address target, uint256 originAmount) public view returns (uint256) {
        address[] memory _shells = pairsToActiveShells[makeKey(origin, target)];
        uint256 originLiquidity = getLiquidity(_shells, origin);
        uint256 targetLiquidity = getLiquidity(_shells, target);
        assert(originLiquidity > 0);
        assert(targetLiquidity > 0);

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

    function getTargetPrice (address origin, address target, uint256 targetAmount) public view returns (uint256) {
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
            originAmount += calculateTargetPrice(targetContribution, originBalance, targetBalance);
        }

        return originAmount;

    }

    event log_uint(bytes32 key, uint256 val);

    function swapByOrigin (address origin, address target, uint256 originAmount, uint256 minTargetAmount, uint256 deadline) public returns (uint256) {

        emit log_uint("timestamp", block.timestamp);


        require(block.timestamp >= deadline, "transaction must be processed before deadline");
        require(originAmount > 0, "origin amount must be above 0");
        require(minTargetAmount > 0, "minimum target amount must be above 0");
        return executeOriginTrade(origin, target, originAmount, minTargetAmount, msg.sender);
    }

    function transferByOrigin (address origin, address target, uint256 originAmount, uint256 minTargetAmount, address recipient, uint256 deadline) public returns (uint256) {
        require(block.timestamp >= deadline, "transaction must be processed before deadline");
        require(recipient != address(this), "recipient must not be exchange address");
        require(recipient != address(0), "recipient must not be zero address");
        require(originAmount > 0, "origin amount must be above 0");
        require(minTargetAmount > 0, "minimum target amount must be above 0");
        return executeOriginTrade(origin, target, originAmount, minTargetAmount, recipient);
    }

    function executeOriginTrade (address origin, address target, uint256 originAmount, uint256 minTargetAmount, address recipient) private returns (uint256) {

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

        require(minTargetAmount < targetAmount, "calcualted target amount must be greater than specified target amount");

        adjustedTransferFrom(ERC20Token(origin), recipient, originAmount);
        uint256 adjustedAmount = adjustedTransfer(ERC20Token(target), recipient, targetAmount);

        emit transfer(msg.sender, origin, originAmount, target, adjustedAmount);

        return adjustedAmount;

    }

    function swapByTarget (address origin, address target, uint256 targetAmount, uint256 maxOriginAmount, uint256 deadline) public returns (uint256) {
        require(block.timestamp >= deadline, "transaction must be processed before deadline");
        require(targetAmount > 0, "target amount must be greater than 0");
        require(maxOriginAmount > 0, "max amount amount must be greater than 0");
        return executeTargetTrade(origin, target, targetAmount, maxOriginAmount, msg.sender);
    }

    function transferByTarget (address origin, address target, uint256 targetAmount, uint256 maxOriginAmount, address recipient, uint256 deadline) public returns (uint256) {
        require(block.timestamp >= deadline, "transaction must be processed before deadline");
        require(recipient != address(this), "recipient must not be exchange address");
        require(recipient != address(0), "recipient must not be zero address");
        require(targetAmount > 0, "target amount must be greater than 0");
        require(maxOriginAmount > 0, "max amount amount must be greater than 0");
        return executeTargetTrade(origin, target, targetAmount, maxOriginAmount, recipient);
    }

    function executeTargetTrade (address origin, address target, uint256 targetAmount, uint256 maxOriginAmount, address recipient) private returns (uint256) {

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

        require(maxOriginAmount >= originAmount, "calculated origin amount must be less than specified max");

        adjustedTransfer(ERC20Token(target), recipient, targetAmount);
        uint256 adjustedAmount = adjustedTransferFrom(ERC20Token(origin), recipient, originAmount);

        emit trade(msg.sender, origin, originAmount, target, adjustedAmount);

        return adjustedAmount;


    }

}