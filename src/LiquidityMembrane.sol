pragma solidity ^0.5.0;

import "./CowriRoot.sol";

contract LiquidityMembrane is CowriRoot {

    event addLiquidity(
        address indexed provider,
        address indexed shell,
        address[] indexed tokens,
        uint256[] amounts
    );

    event removeLiquidity(
        address indexed provider,
        address indexed shell,
        address[] indexed tokens,
        uint256[] amounts
    );

    function depositLiquidity(
        address _shell,
        uint256 amount,
        uint256 deadline
    ) public returns (uint256) {
        require(block.timestamp <= deadline, "must be processed before deadline");
        require(amount > 0, "amount must be above 0");

        Shell shell = Shell(_shell);
        uint256 totalCapital = getTotalCapital(_shell);
        uint256 totalSupply = shell.totalSupply();
        uint256 liqTokensMinted;
        uint256 adjustedAmount;
        address[] memory tokens = shell.getTokens();
        uint256[] memory liquidityAdded = new uint256[](tokens.length);

        if (totalSupply == 0) {

            liqTokensMinted = amount;
            adjustedAmount = wdiv(amount, tokens.length * WAD);

        } else liqTokensMinted = wdiv(wmul(totalSupply, amount), totalCapital);

        for(uint i = 0; i < tokens.length; i++) {

            uint256 balanceKey = makeKey(_shell, address(tokens[i]));
            uint256 currentBalance = shellBalances[balanceKey];
            uint256 relativeAmount = totalSupply != 0
                ? wdiv(wmul(amount, currentBalance), totalCapital)
                : adjustedAmount;

            liquidityAdded[i] = relativeAmount;

            adjustedTransferFrom(
                ERC20Token(tokens[i]),
                msg.sender,
                relativeAmount
            );

            shellBalances[balanceKey] = add(
                currentBalance,
                relativeAmount
            );

        }

        shell.mint(msg.sender, liqTokensMinted);

        emit addLiquidity(msg.sender, _shell, tokens, liquidityAdded);

        return liqTokensMinted;
    }

    event log_uint(bytes32 key, uint256 val);

    function withdrawLiquidity(
        address _shell,
        uint256 liquidityToBurn,
        uint256[] memory limits,
        uint256 deadline
    ) public returns (uint256[] memory) {
        require(block.timestamp <= deadline, "must be processed before deadline");

        Shell shell = Shell(_shell);
        require(shell.balanceOf(msg.sender) >= liquidityToBurn, "must only burn tokens you have");

        uint256 totalCapital = getTotalCapital(_shell);
        uint256 capitalWithdrawn = wdiv(
            wmul(totalCapital, liquidityToBurn),
            shell.totalSupply()
        );

        address[] memory tokens = shell.getTokens();
        uint256[] memory amountsWithdrawn = new uint256[](tokens.length);
        for(uint i = 0; i < tokens.length; i++) {

            uint256 balanceKey = makeKey(_shell, tokens[i]);

            uint amount = wdiv(
                wmul(capitalWithdrawn, shellBalances[balanceKey]),
                totalCapital
            );

            require(limits[i] <= amount, "withdrawn amount must be equal to or above minimum amount");

            amountsWithdrawn[i] = adjustedTransfer(
                ERC20Token(tokens[i]),
                msg.sender,
                amount
            );

            shellBalances[balanceKey] = sub(
                shellBalances[balanceKey],
                amount
            );

        }

        shell.testBurn(msg.sender, liquidityToBurn);

        emit removeLiquidity(msg.sender, _shell, tokens, amountsWithdrawn);

        return amountsWithdrawn;
    }


    function getTotalCapital(
        address shell
    ) public view returns (uint totalCapital) {
        address[] memory tokens = Shell(shell).getTokens();
        for (uint i = 0; i < tokens.length; i++) {
            uint256 balanceKey = makeKey(shell, tokens[i]);
            totalCapital = add(totalCapital, shellBalances[balanceKey]);
         }
        return totalCapital;
    }

}