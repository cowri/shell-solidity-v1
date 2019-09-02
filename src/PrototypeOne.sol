pragma solidity ^0.5.0;

import "ds-math/math.sol";
import "./Shell.sol";

contract PrototypeOne is DSMath {

    address[] tokens;
    Shell[] public shellList;
    mapping(address => mapping(address => Shell[])) public pairsToShells;
    mapping(address => mapping(address => address[])) public pairsToShellAddresses;
    mapping(address => mapping(address => uint)) public shells;

    event balanceOf(bytes32, uint256);
    event log_named_uint(bytes32, uint256);
    event log_named_uint_arr(bytes32, uint256[]);

    function __init__ (address[] memory _tokens) public {
        tokens = _tokens;
    }

    function getTokens () public view returns (address[] memory) {
        return tokens;
    }

    function createShell(address[] memory coins) public returns (address) {

        Shell shell = new Shell(coins);
        shellList.push(shell);

        for (uint8 i = 0; i < coins.length; i++) {
            for (uint8 j = i + 1; j < coins.length; j++){
                pairsToShells[coins[i]][coins[j]].push(shell);
                pairsToShells[coins[j]][coins[i]].push(shell);
                pairsToShellAddresses[coins[j]][coins[i]].push(address(shell));
                pairsToShellAddresses[coins[i]][coins[j]].push(address(shell));
            }
            shells[address(shell)][coins[i]] = 0;
        }

        return address(shell);

    }

    function depositLiquidity(address shellAddress, uint amount) public returns (uint256) {
        Shell shell = Shell(shellAddress);
        uint supportedTokensNumber = shell.getTokens().length;
        uint liqTokensMinted = 0;

        if(shell.totalSupply() > 0){

            uint capitalDeposited = wmul(supportedTokensNumber, amount * WAD);
            liqTokensMinted = wdiv(wmul(shell.totalSupply(), capitalDeposited), getTotalCapital(shell));
            depositTokens(shell, msg.sender, amount);
            depositShellBalance(shell, amount); //doesn't change the tokens, but changes the shells
            shell.mint(msg.sender, liqTokensMinted);

        } else {

            liqTokensMinted = wmul(supportedTokensNumber, amount * WAD);
            depositTokens(shell, msg.sender, amount);
            depositShellBalance(shell, amount); //updates the shells, not the ERC20 balanceOf...
            shell.mint(msg.sender, liqTokensMinted);

        }
        return liqTokensMinted;
    }

    function withdrawLiquidity(address shellAddress, uint liquidityTokensToBurn) public returns (uint256[] memory) {
        Shell shell = Shell(shellAddress);
        uint256 totalCapital = getTotalCapital(shell);
        uint256 totalShellSupply = shell.totalSupply();
        uint256 capitalWithdrawn = wdiv(wmul(totalCapital, liquidityTokensToBurn * WAD), totalShellSupply * WAD);
        emit log_named_uint("capital withdrawn", capitalWithdrawn);
        // uint256 capitalWithdrawn = multiplyDivide(getTotalCapital(shell), liquidityTokensToBurn, shell.totalSupply());
        uint256[] memory tokenAmountWithdrawn = tokenAmountWithdrawnCalc(shell, capitalWithdrawn);
        Shell(shellAddress).testBurn(msg.sender, liquidityTokensToBurn);
        withdrawTokens(shellAddress, msg.sender, tokenAmountWithdrawn);
        withdrawShellBalance(shellAddress, tokenAmountWithdrawn);
        return tokenAmountWithdrawn;
    }

    function swap(address originCurrency, address targetCurrency, uint swapAmountOrigin) public returns (uint256) {
        address[] memory _shells = pairsToShellAddresses[originCurrency][targetCurrency];

        uint originBalance; //balance of originCurrency in a given shell
        uint targetBalance; //balance of targetCurrency in a given shell

        uint originLiquidity = 0; //total supply of originCurrency in shells that support the trading pair
        uint targetLiquidity = 0; //total supply of targetCurrency in shells that support the trading pair
        for (uint i = 0; i < _shells.length; i++) {
            originLiquidity = add(originLiquidity, shells[_shells[i]][originCurrency]);
            targetLiquidity = add(targetLiquidity, shells[_shells[i]][targetCurrency]);
        }

        emit log_named_uint("originLiquidity", originLiquidity);
        emit log_named_uint("targetLiquidity", targetLiquidity);
        emit log_named_uint("swap amount origin", swapAmountOrigin);
        //calculating the swap amount for the target currency
        uint numerator = wmul(swapAmountOrigin * WAD, targetLiquidity);
        uint denominator = add(swapAmountOrigin, originLiquidity) * WAD;
        uint swapAmountTarget = wdiv(numerator, denominator);
        emit log_named_uint("numerator to swapAmountTarget", numerator);
        emit log_named_uint("denominator to swapAmountTarget", numerator);
        emit log_named_uint("swap amount target", swapAmountTarget);

        //calculating the % contribution and updating the shell balances
        for(uint i = 0; i < _shells.length; i++) {

            targetBalance = shells[_shells[i]][targetCurrency];
            numerator = wmul(swapAmountTarget * WAD, targetBalance);
            targetBalance = sub(targetBalance, wdiv(numerator, targetLiquidity * WAD));
            shells[_shells[i]][targetCurrency] = targetBalance;
            emit log_named_uint("target balance", targetBalance);
            emit log_named_uint("numer to target balance ", numerator);
            emit log_named_uint("denom to target balance ", targetLiquidity);
            emit log_named_uint("target balance after alteration", targetBalance);

            originBalance = shells[_shells[i]][originCurrency];
            numerator = wmul(swapAmountOrigin * WAD, targetBalance);
            originBalance = add(originBalance, wdiv(numerator, targetLiquidity * WAD));
            shells[_shells[i]][originCurrency] = originBalance;

            emit log_named_uint("origin balance", originBalance);
            emit log_named_uint("numer to origin balance ", numerator);
            emit log_named_uint("denom to origin balance ", targetLiquidity);
            emit log_named_uint("origin balance after alteration", originBalance);

        }

        //executing the swap (finally)
        ERC20(originCurrency).transferFrom(msg.sender, address(this), swapAmountOrigin);
        ERC20(targetCurrency).transfer(msg.sender, swapAmountTarget / WAD);

        return swapAmountTarget;

    }

    function getShellBalanceOf(address _shell, address _token) public view returns (uint) {
        return shells[_shell][_token];
    }

    ////////////////////////////////////
    ///UTILITY FUNCTIONS FOR EXCHANGE///
    ////////////////////////////////////

    function depositTokens(Shell shell, address liquidityProvider, uint amount) private {
        ERC20[] memory supportedTokens = shell.getTokens();
        for(uint i = 0; i < supportedTokens.length; i++) {
            supportedTokens[i].transferFrom(liquidityProvider, address(this), amount);
        }
    }

    function withdrawTokens(address shellAddress, address liquidityProvider, uint[] memory tokenAmountWithdrawn) private {
        ERC20[] memory supportedTokens = Shell(shellAddress).getTokens();
        for(uint i = 0; i < supportedTokens.length; i++) {
            supportedTokens[i].transfer(liquidityProvider, tokenAmountWithdrawn[i]);
        }
    }

  function tokenAmountWithdrawnCalc(Shell shell, uint capitalRemoved) private returns(uint[] memory) {
        ERC20[] memory supportedTokens = shell.getTokens();
        uint[] memory tokenAmountWithdrawn = new uint[](supportedTokens.length);
        uint totalCapital = getTotalCapital(shell);
        for(uint i = 0; i < supportedTokens.length; i++) {
            //currently getting the stablecoins of the exchange contract
            //need to update and get the stablecoins of the shell
            tokenAmountWithdrawn[i] = wdiv(
                wmul(capitalRemoved * WAD, shells[address(shell)][address(supportedTokens[i])]),
                totalCapital * WAD
            );
        }
        emit log_named_uint_arr("token amount withdrawn", tokenAmountWithdrawn);
        return(tokenAmountWithdrawn);
    }

    /////////////////////////////////
    ///UTILITY FUNCTIONS FOR SHELL///
    /////////////////////////////////

    //current function gets balance of exchange contract, not the Shell
    //need to change!
    function getTotalCapital(Shell shell) public view returns (uint totalCapital) {
        address[] memory supportedTokens = shell.getTokenAddresses();
        for (uint i = 0; i < supportedTokens.length; i++) {
            totalCapital = add(totalCapital, shells[address(shell)][supportedTokens[i]]);
        }
        return(totalCapital);
    }

    //updates the shell's balance as recorded on the exchange (called when depositing capital)
    function depositShellBalance(Shell shell, uint amount) private {
        ERC20[] memory supportedTokens = shell.getTokens();
        address shellAddress = address(shell);
        uint currentBalance;
        for (uint i = 0; i < supportedTokens.length; i++) {
            currentBalance = shells[shellAddress][address(supportedTokens[i])];
            shells[shellAddress][address(supportedTokens[i])] = add(currentBalance, amount);
        }
    }

    //function is incorrect. We want to use tokenAmountWithdrawn[] so that each balance
    //is incremented differently, not by the same amount
    function withdrawShellBalance(address shellAddress, uint[] memory tokenAmountWithdrawn) private {
        ERC20[] memory supportedTokens = Shell(shellAddress).getTokens();
        uint currentBalance;
        for(uint i = 0; i < supportedTokens.length; i++) {
            currentBalance = shells[shellAddress][address(supportedTokens[i])];
            shells[shellAddress][address(supportedTokens[i])] = sub(currentBalance, tokenAmountWithdrawn[i]);
        }
    }

    //the address balance of shell tokens (not the shell's balance of stablecoins)
    function getShellBalance(uint index, address _address) public view returns(uint) {
        return(shellList[index].balanceOf(_address));
    }

    // function getShellSupportedTokens(uint index) public view returns(ERC20[] memory) {
    //     Shell shell = shellList[index];
    //     return(shell.getSupportedTokens());
    // }

    //  function checkShellMinter(uint index, address _minter) public view returns(bool) {
    //      Shell shell = shellList[index];
    //      return(shell.isMinter(_minter));
    //  }

    // function mintShellTokens(Shell shell, address recipient, uint amount) private {
    //     Shell shell = shellList[index];
    //     shell.mint(recipient, amount);
    // }

    // function burnFromShellTokens(Shell shell, address account, uint amount) private {
    //     shell.testBurn(account, amount); //using an unsafe function rn bc its hard to set allowance
    // }

    //before burning a token (for liquidity withrawal), approve the exchange contract
    // function approveShellForBurn(uint index, uint amount) public {
    //     Shell shell = shellList[index];
    //     shell.approve(address(this), amount);
    // }

    ////////////////////////////////
    ///UTILITY FUNCTIONS FOR MATH///
    ////////////////////////////////

}


    // function updateShellBalancesForSwap(address targetCurrency, uint swapAmountTarget, Shell[] memory shells, uint[] memory shellContribution) private {
    //     address shellAddress;
    //     for(uint i=0; i<shells.length; i++) {
    //         shellAddress = shells[i].getShellAddress();
    //         shells[shellAddress][targetCurrency] =
    //     }
    // }

    //For testing: way to check how many tokens the contract supports
    // function howManySupportedTokens() public view returns(uint result) {
    //     result = supportedTokens.length;
    //     return(result);
    // }


    //creating trading pairs
    //  address[] originTokens;
    //  address[] targetTokens;
    //  for(uint i=0; i<supportedTokens.length; i++) {
    //      for(uint j=1; j<supportedTokens.length - 1; j++) {
    //          originTokens.push(supportedTokens[i]);
    //          targetTokens.push(supportedTokens[j+1]);
    //      }
    //  }


    // function swapRateCalc(uint originSupply, uint targetSupply, uint swapAmountOrigin) private view returns(uint swapAmountTarget){
    //     swapAmountTarget = multiplyDivide(swapAmountOrigin, targetSupply, swapAmountOrigin.add(originSupply));
    //     return(swapAmountTarget);
    // }

    //should I update the shell balances here? (No)
    // function getLiquidity(address originCurrency, address targetCurrency) public returns(uint[2] memory liquidity) {
    //     Shell[] shells = pairsToShells[originCurrency][targetCurrency];
    //     address shellAddress;
    //     for(uint i=0; i<shells.length; i++) {
    //         shellAddress = shells[i].getShellAddress();
    //         //entry 0 is origin balance, entry 1 is target balance
    //         liquidity[0] = liquidity[0].add(shells[shellAddress][originCurrency]);
    //         liquidity[1] = liquidity[1].add(shells[shellAddress][targetCurrency]);
    //     }
    //     return(liquidity)
    // }

    // function getShellContribution(address targetCurrency, uint targetLiquidity) public returns(uint[] memory contribution) {
    //     Shell[] shells = pairsToShells[originCurrency][targetCurrency];
    //     address shellAddress;
    //     for(uint i=0; i<shells.length; i++) {
    //         shellAddress = shells[i].getShellAddress();
    //         //.mul(10000) is so that the integer reflects parts in ten thousand
    //         contribution[i] = shells[shellAddress][targetCurrency].mul(10000).div(targetLiquidity);
    //     }
    //     return(contribution);
    // }