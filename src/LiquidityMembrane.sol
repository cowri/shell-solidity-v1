pragma solidity ^0.5.0;

import "ds-math/math.sol";
import "./Adjusters.sol";
import "./CowriState.sol";
import "./Shell.sol";
import "./ERC20Token.sol";

contract LiquidityMembrane is DSMath, Adjusters, CowriState {

    function depositLiquidity(address shellAddress, uint amount) public returns (uint256) {

        Shell shell = Shell(shellAddress);
        uint capitalDeposited = mul(shell.getTokens().length, amount);

        uint liqTokensMinted = shell.totalSupply() == 0
            ? capitalDeposited
            : wdiv(
                wmul(shell.totalSupply(), capitalDeposited),
                getTotalCapital(shell)
            );

        ERC20Token[] memory tokens = shell.getTokens();
        for(uint i = 0; i < tokens.length; i++) {

            adjustedTransferFrom(
                tokens[i],
                msg.sender,
                amount
            );

            shells[shellAddress][address(tokens[i])] = add(
                shells[shellAddress][address(tokens[i])],
                amount
            );

        }

        shell.mint(msg.sender, liqTokensMinted);

        return liqTokensMinted;
    }

    function withdrawLiquidity(address shellAddress, uint liquidityTokensToBurn) public returns (uint256[] memory) {
        Shell shell = Shell(shellAddress);

        uint256 totalCapital = getTotalCapital(shell);
        uint256 capitalWithdrawn = wdiv(
            wmul(getTotalCapital(shell), liquidityTokensToBurn),
            shell.totalSupply()
        );

        ERC20Token[] memory tokens = Shell(shellAddress).getTokens();
        uint256[] memory amountsWithdrawn = new uint256[](tokens.length);
        for(uint i = 0; i < tokens.length; i++) {

            uint amount = wdiv(
                wmul(capitalWithdrawn, shells[address(shell)][address(tokens[i])]),
                totalCapital
            );

            amountsWithdrawn[i] = adjustedTransfer(
                tokens[i],
                msg.sender,
                amount
            );

            shells[address(shell)][address(tokens[i])] = sub(
                shells[address(shell)][address(tokens[i])],
                amount
            );

        }

        Shell(shellAddress).testBurn(msg.sender, liquidityTokensToBurn);

        return amountsWithdrawn;
    }


    function getTotalCapital(Shell shell) public view returns (uint totalCapital) {
        address[] memory tokens = shell.getTokenAddresses();
        for (uint i = 0; i < tokens.length; i++) {
            totalCapital = add(totalCapital, shells[address(shell)][tokens[i]]);
        }
        return(totalCapital);
    }

}