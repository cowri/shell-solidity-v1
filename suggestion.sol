pragma solidity ^0.5.0;

import "./Shell.sol";

contract CowriPoolPrototype {
 using SafeMath for uint256;
 
 Shell[] public shellList;
 mapping(address => Shell) public shellAddressMap; 
 mapping(address => mapping(address => Shell[])) public pairsToShells;
 mapping(address => mapping(address => uint)) public shells;
 
 
 constructor() public {
     
 } 

 function createShell(ERC20[] memory supportedTokens, address[] memory originTokens, address[] memory targetTokens) public {
     Shell shell = new Shell(supportedTokens);
     shellList.push(shell);
     shellAddressMap[shell.getShellAddress()] = shell;
     //supportedTokens and originTokens need to be in a certain order
     for(uint i=0; i<originTokens.length; i++) {
         pairsToShells[originTokens[i]][targetTokens[i]].push(shell);
     }
 }
 
 function depositLiquidity(address shellAddress, uint amount) public {
     Shell shell = Shell(shellAddress);
     uint supportedTokensNumber = shell.getSupportedTokens().length;
     if(shell.totalSupply() > 0){
        uint capitalDeposited = amount.mul(supportedTokensNumber);
        uint liqTokensMinted = multiplyDivide(shell.totalSupply(), capitalDeposited, getTotalCapital(shell));
        depositTokens(shell, msg.sender, amount);
        depositShellBalance(shell, amount); //doesn't change the tokens, but changes the shells
        shell.mint(msg.sender, liqTokensMinted);
     } else {
         uint liqTokensMinted = amount.mul(supportedTokensNumber);
         depositTokens(shell, msg.sender, amount);
         depositShellBalance(shell, amount); //updates the shells, not the ERC20 balanceOf...
         shell.mint(msg.sender, liqTokensMinted);
     }
 }
 
 function withdrawLiquidity(address shellAddress, uint liquidityTokensToBurn) public {
     uint capitalWithdrawn = multiplyDivide(getTotalCapital(shellAddress), liquidityTokensToBurn, Shell(shellAddress).totalSupply());
     uint[] memory tokenAmountWithdrawn = tokenAmountWithdrawnCalc(shell, capitalWithdrawn);
     Shell(shellAddress).testBurn(msg.sender, liquidityTokensToBurn); //testBurn only used for testing purposes. Not secure right now. 
     withdrawTokens(shellAddress, msg.sender, tokenAmountWithdrawn);
     withdrawShellBalance(shellAddress, tokenAmountWithdrawn);
 }


 function swap(address originCurrency, address targetCurrency, uint swapAmountOrigin) public {
     Shell[]  memory shells = pairsToShells[originCurrency][targetCurrency];
     
     //change this to two variables: originLiquidity and targetLiquidity
     uint originLiquidity; //total supply of originCurrency in shells that support the trading pair
     uint targetLiquidity; //total supply of targetCurrency in shells that support the trading pair
     address shellAddress; 
     uint originBalance; //balance of originCurrency in a given shell 
     uint targetBalance; //balance of targetCurrency in a given shell 
     
     //calculating the total liquidity for that trading pair
     for(uint i=0; i<shells.length; i++) {
          shellAddress = address(shells[i]);
          originLiquidity = originLiquidity.add(shells[shellAddress][originCurrency]);
          targetLiquidity = targetLiquidity.add(shells[shellAddress][targetCurrency]);
     }
     
     //calculating the swap amount for the target currency
     uint swapAmountTarget = multiplyDivide(swapAmountOrigin, targetLiquidity, swapAmountOrigin.add(originLiquidity));
     
     //calculating the % contribution and updating the shell balances
     for(uint i=0; i<shells.length; i++) {
         shellAddress = address(shells[i]);
         
         targetBalance = shells[shellAddress][targetCurrency];
         targetBalance = targetBalance.sub(multiplyDivide(swapAmountTarget, targetBalance, targetLiquidity));
         shells[shellAddress][targetCurrency] = targetBalance;
         
         originBalance = shells[shellAddress][originCurrency];
         originBalance = originBalance.add(multiplyDivide(swapAmountOrigin, targetBalance, targetLiquidity));
         shells[shellAddress][originCurrency] = originBalance;
     }
     
     //originCurrencyBalance = originCurrencyBalance + (swapAmountOrigin*(% contribution of target currency))
     //targetCurrencyBalance = targetCurrencyBalance - (swapAmountTarget*(% contribution of target currency))
     
     //executing the swap (finally) 
     ERC20(originCurrency).transferFrom(msg.sender, address(this), swapAmountOrigin);
     ERC20(targetCurrency).transfer(msg.sender, swapAmountTarget);
 }
 
 ////////////////////////////////////
 ///UTILITY FUNCTIONS FOR EXCHANGE///
 ////////////////////////////////////
 
  
  function depositTokens(Shell shell, address liquidityProvider, uint amount) private {
      ERC20[] memory supportedTokens = shell.getSupportedTokens();
      for(uint i=0; i<supportedTokens.length; i++) {
          supportedTokens[i].transferFrom(liquidityProvider, address(this), amount);
      }
  }
  
  function withdrawTokens(address shellAddress, address liquidityProvider, uint[] memory tokenAmountWithdrawn) private {
      ERC20[] memory supportedTokens = Shell(shellAddress).getSupportedTokens();
      for(uint i=0; i<supportedTokens.length; i++) {
          supportedTokens[i].transfer(liquidityProvider, tokenAmountWithdrawn[i]);
      }
  }
  
  function tokenAmountWithdrawnCalc(Shell shell, uint capitalRemoved) private view returns(uint[] memory) {
      ERC20[] memory supportedTokens = shell.getSupportedTokens();
      uint[] memory tokenAmountWithdrawn = new uint[](supportedTokens.length);
      uint totalCapital = getTotalCapital(shell);
      for(uint i=0; i<supportedTokens.length; i++) {
          //currently getting the stablecoins of the exchange contract
          //need to update and get the stablecoins of the shell
          tokenAmountWithdrawn[i] = multiplyDivide(capitalRemoved, 
                                    shells[address(shell)][address(supportedTokens[i])], 
                                    totalCapital);
      }
      return(tokenAmountWithdrawn);
  }
 
 /////////////////////////////////
 ///UTILITY FUNCTIONS FOR SHELL///
 /////////////////////////////////
 
 //current function gets balance of exchange contract, not the Shell
 //need to change!
   function getTotalCapital(address shellAddress) private view returns (uint totalCapital) {
     ERC20[] memory supportedTokens = Shell(shellAddress).getSupportedTokens();
     for(uint i=0; i<supportedTokens.length; i++) {
         totalCapital = totalCapital.add(shells[shellAddress][supportedTokens[i]]); 
     }
     return(totalCapital);
 }
  
  //updates the shell's balance as recorded on the exchange (called when depositing capital) 
  function depositShellBalance(Shell shell, uint amount) private {
      ERC20[] memory supportedTokens = shell.getSupportedTokens();
      address shellAddress = address(shell);
      uint currentBalance;
      for(uint i=0; i<supportedTokens.length; i++) {
          currentBalance = shells[shellAddress][address(supportedTokens[i])];
          shells[shellAddress][address(supportedTokens[i])] = currentBalance.add(amount);
      }
  }
  
  //function is incorrect. We want to use tokenAmountWithdrawn[] so that each balance
  //is incremented differently, not by the same amount 
  function withdrawShellBalance(address shellAddress, uint[] memory tokenAmountWithdrawn) private {
      ERC20[] memory supportedTokens = Shell(shellAddress).getSupportedTokens();
      uint currentBalance;
      for(uint i=0; i<supportedTokens.length; i++) {
          currentBalance = shells[shellAddress][address(supportedTokens[i])];
          shells[shellAddress][address(supportedTokens[i])] = currentBalance.add(tokenAmountWithdrawn[i]);
      }
  }
  
   //the address balance of shell tokens (not the shell's balance of stablecoins) 
 function getShellBalance(uint index, address _address) public view returns(uint) {
     return(shellList[index].balanceOf(_address));
 }
  
  /*
  function getShellSupportedTokens(uint index) public view returns(ERC20[] memory) {
     Shell shell = shellList[index];
     return(shell.getSupportedTokens());
 }*/
 
 /*
 function checkShellMinter(uint index, address _minter) public view returns(bool) {
     Shell shell = shellList[index];
     return(shell.isMinter(_minter));
 }*/
 
 /*function mintShellTokens(Shell shell, address recipient, uint amount) private {
     Shell shell = shellList[index];
     shell.mint(recipient, amount);
 }*/
 
 /*function burnFromShellTokens(Shell shell, address account, uint amount) private {
     shell.testBurn(account, amount); //using an unsafe function rn bc its hard to set allowance
 }*/
 
 //before burning a token (for liquidity withrawal), approve the exchange contract
 /*function approveShellForBurn(uint index, uint amount) public {
     Shell shell = shellList[index];
     shell.approve(address(this), amount);
 }*/
 

 
 ////////////////////////////////
 ///UTILITY FUNCTIONS FOR MATH///
 ////////////////////////////////
 
 
 //multiplying two numbers and dividing by a third 
 function multiplyDivide(uint firstNum, uint secondNum, uint thirdNum) private pure returns (uint result) {
     uint numerator = firstNum.mul(secondNum);
     return(numerator.div(thirdNum));
 }
 
 function addThreeNumbers(uint firstNum, uint secondNum, uint thirdNum) private pure returns (uint result) {
     uint intermediateNum = firstNum.add(secondNum);
     return(intermediateNum.add(thirdNum));
 }
}


/*  function updateShellBalancesForSwap(address targetCurrency, uint swapAmountTarget, Shell[] memory shells, uint[] memory shellContribution) private {
      address shellAddress;
      for(uint i=0; i<shells.length; i++) {
          shellAddress = shells[i].getShellAddress();
          shells[shellAddress][targetCurrency] = 
      }
  }*/
 
  //For testing: way to check how many tokens the contract supports
  /*function howManySupportedTokens() public view returns(uint result) {
     result = supportedTokens.length;
     return(result);
 }*/


/*     //creating trading pairs
     address[] originTokens;
     address[] targetTokens;
     for(uint i=0; i<supportedTokens.length; i++) {
         for(uint j=1; j<supportedTokens.length - 1; j++) {
             originTokens.push(supportedTokens[i]);
             targetTokens.push(supportedTokens[j+1]);
         }
     }*/
/*/*function swapRateCalc(uint originSupply, uint targetSupply, uint swapAmountOrigin) private view returns(uint swapAmountTarget){
     swapAmountTarget = multiplyDivide(swapAmountOrigin, targetSupply, swapAmountOrigin.add(originSupply));
     return(swapAmountTarget);
  }*/
  /*
  //should I update the shell balances here? (No) 
  function getLiquidity(address originCurrency, address targetCurrency) public returns(uint[2] memory liquidity) {
      Shell[] shells = pairsToShells[originCurrency][targetCurrency]; 
      address shellAddress;
      for(uint i=0; i<shells.length; i++) {
          shellAddress = shells[i].getShellAddress();
          //entry 0 is origin balance, entry 1 is target balance
          liquidity[0] = liquidity[0].add(shells[shellAddress][originCurrency]);
          liquidity[1] = liquidity[1].add(shells[shellAddress][targetCurrency]);
      }
      return(liquidity)
  }
  
  function getShellContribution(address targetCurrency, uint targetLiquidity) public returns(uint[] memory contribution) {
      Shell[] shells = pairsToShells[originCurrency][targetCurrency];
      address shellAddress;
      for(uint i=0; i<shells.length; i++) {
          shellAddress = shells[i].getShellAddress();
          //.mul(10000) is so that the integer reflects parts in ten thousand 
          contribution[i] = shells[shellAddress][targetCurrency].mul(10000).div(targetLiquidity);
      }
      return(contribution);
  }*/