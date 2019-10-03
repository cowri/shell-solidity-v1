pragma solidity ^0.5.0;

import "ds-math/math.sol";
import "./Utilities.sol";
import "./CowriState.sol";
import "./Shell.sol";
import "./ERC20Token.sol";

contract LiquidityMembrane is DSMath, Utilities, CowriState {

    event addLiquidity(address indexed provider, address indexed shell, address[] indexed tokens, uint256[] amounts);
    event removeLiquidity(address indexed provider, address indexed shell, address[] indexed tokens, uint256[] amounts);

    function depositLiquidity(address _shell, uint amount) public returns (uint256) {

        Shell shell = Shell(_shell);
        uint256 totalCapital = getTotalCapital(_shell);
        uint256 totalSupply = shell.totalSupply();
        uint256 liqTokensMinted;
        uint256 adjustedAmount;
        address[] memory tokens = shell.getTokens();
        uint256[] liquidityAdded = new uint256[](tokens.length - 1);

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

    function withdrawLiquidity(address _shell, uint liquidityTokensToBurn) public returns (uint256[] memory) {

        Shell shell = Shell(_shell);
        assert(shell.balanceOf(msg.sender) >= liquidityTokensToBurn);

        uint256 totalCapital = getTotalCapital(_shell);
        uint256 capitalWithdrawn = wdiv(
            wmul(totalCapital, liquidityTokensToBurn),
            shell.totalSupply()
        );

        address[] memory tokens = shell.getTokens();
        uint256[] memory amountsWithdrawn = new uint256[](tokens.length);
        for(uint i = 0; i < tokens.length; i++) {

            uint256 balanceKey = makeKey(address(shell), address(tokens[i]));
            uint amount = wdiv(
                wmul(capitalWithdrawn, shellBalances[balanceKey]),
                totalCapital
            );

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

        shell.testBurn(msg.sender, liquidityTokensToBurn);

        emit removeLiquidity(msg.sender, _shell, tokens, amountsWithdrawn);

        return amountsWithdrawn;
    }


    function getTotalCapital(address shell) public view returns (uint totalCapital) {
        address[] memory tokens = Shell(shell).getTokens();
        for (uint i = 0; i < tokens.length; i++) {
            uint256 balanceKey = makeKey(shell, tokens[i]);
            totalCapital = add(totalCapital, shellBalances[balanceKey]);
         }
        return totalCapital;
    }

}