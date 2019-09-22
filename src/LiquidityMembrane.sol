pragma solidity ^0.5.0;

import "ds-math/math.sol";
import "./Adjusters.sol";
import "./CowriState.sol";
import "./Shell.sol";
import "./ERC20Token.sol";

contract LiquidityMembrane is DSMath, Adjusters, CowriState {

    event log_named_uint(bytes32 key, uint256 val);

    function depositLiquidity(address _shell, uint amount) public returns (uint256) {

        Shell shell = Shell(_shell);
        uint256 totalCapital = getTotalCapital(_shell);
        uint256 totalSupply = shell.totalSupply();
        uint256 liqTokensMinted;
        uint256 adjustedAmount;
        address[] memory tokens = shell.getTokens();

        if (totalSupply == 0) {

            liqTokensMinted = amount;
            adjustedAmount = wdiv(amount, tokens.length * WAD);

        } else liqTokensMinted = wdiv(wmul(totalSupply, amount), totalCapital);

        for(uint i = 0; i < tokens.length; i++) {

            uint256 currentBalance = shellBalances[_shell][address(tokens[i])];
            uint256 relativeAmount = totalSupply != 0
                ? wdiv(wmul(amount, currentBalance), totalCapital)
                : adjustedAmount;

            adjustedTransferFrom(
                ERC20Token(tokens[i]),
                msg.sender,
                relativeAmount
            );

            shellBalances[_shell][address(tokens[i])] = add(
                currentBalance,
                relativeAmount
            );

        }

        shell.mint(msg.sender, liqTokensMinted);

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

            uint amount = wdiv(
                wmul(capitalWithdrawn, shellBalances[address(shell)][address(tokens[i])]),
                totalCapital
            );

            amountsWithdrawn[i] = adjustedTransfer(
                ERC20Token(tokens[i]),
                msg.sender,
                amount
            );

            shellBalances[_shell][address(tokens[i])] = sub(
                shellBalances[_shell][address(tokens[i])],
                amount
            );

        }

        shell.testBurn(msg.sender, liquidityTokensToBurn);

        return amountsWithdrawn;
    }


    function getTotalCapital(address shell) public view returns (uint totalCapital) {
        address[] memory tokens = Shell(shell).getTokens();
        for (uint i = 0; i < tokens.length; i++) totalCapital = add(totalCapital, shellBalances[shell][tokens[i]]);
        return totalCapital;
    }

}