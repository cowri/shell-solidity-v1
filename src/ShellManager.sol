// pragma solidity ^0.5.0;

// import "./Shell.sol";

// contract ShellManager {

//     function createShell (address[] memory _tokens) external returns (address) {

//     }

//     function activateShell (address _shell) public {

//         require(hasSufficientCapital(shellAddress) == true);

//         Shell shell = Shell(shellAddress); //need to rationalize use of shell vs. shellAddress
//         shellList.push(shell);
//         address[] memory coins = shell.getTokens();

//         for (uint8 i = 0; i < coins.length; i++) {

//             for (uint8 j = i + 1; j < coins.length; j++){
//                 pairsToShells[coins[i]][coins[j]].push(shell);
//                 pairsToShells[coins[j]][coins[i]].push(shell);
//                 pairsToShellAddresses[coins[j]][coins[i]].push(shellAddress);
//                 pairsToShellAddresses[coins[i]][coins[j]].push(shellAddress);
//             }
//             //shells[address(shell)][coins[i]] = 0; //shell balances in the mapping default to zero, I think
//         }
//         addSupportedTokens(coins);

//     }

//     function deactivateShell (address _shell) public {
//         require(hasSufficientCapital(shellAddress) == false);
//         require(isInShellList(shellAddress) == true);

//         Shell shell = Shell(_shell);
//         address[] memory tokens = shell.getTokens();

//         for (uint8 i = 0; i < coins.length; i++) {
//             for (uint8 j = i + 1; j < coins.length; j++){
//                 //remove shell from pairsToShells and pairsToShellAddresses
//             }
//         }
//     }

//     function hasSufficientCapital(address shellAddress) public view returns(bool) {

//         uint256 capital = Shell(shellAddress).totalSupply();
//         uint256 numberOfStablecoins = Shell(shellAddress).getTokens().length;

//         if(wdiv(capital, numberOfStablecoins) >= minCapital) {
//             //this means the individual stablecoin balance is greater than minCapital
//             return(true);
//         } else {
//             return(false);
//         }
//     }

//     function isInShellList(address shellAddress) public view returns(bool) {
//         for(uint8 i = 0; i<shellList.length; i++) {
//             if(address(shellList[i]) == shellAddress) return(true);
//         }
//         return(false);
//     }

//     function sortAddresses (address[] memory _addresses) internal pure returns (address[] memory) {
//         for(int i = 0 ; i < _addresses.length;i++) {
//             for(int j = i+1 ; j < _addresses.length;j++) {
//                 if (uint256(_addresses[i]) > uint256(_addresses[j])) {
//                     int temp = _addresses[i];
//                     _addresses[i] = _addresses[j];
//                     _addresses[j] = temp;
//                 }
//             }
//         }
//         return _addresses 
//     }

//     function isDuplicateShell(address[] memory _addresses) public view returns(bool) {
//         address[] memory otherCoins; //need a better name for the coins supported by other shells

//         _addresses = sortAddresses(_addresses);

//         Shell[] shells = pairsToShells[_tokens[0]][_tokens[1]];

//         for (uint8 i = 0; i < shells.length; i++) {
//             addresses[] memory comparisons = shells[i].getTokens();
//             if (comparisons.length != _addresses.length) continue;
//             for (uint8 j = 0; j <= comparisons.length; j++) {
//                 if (j != comparisons.length) {
//                     if (_addresses[j] != comparisons[j]) break;
//                 } else {
//                     return true;
//                 }
//             }
//         }

//         return false; 
//     }

//     function setMinCapital(uint256 _minCapital) public { //this function should be onlyOwner or something like that
//         //these require() calls ensure that the minimum capital is within a certain range, that way
//         //we couldn't set the _minTokens to something egregiously low (e.g. 0) or egregiously high (e.g. a trillion)
//         require(_minCapital >= 10000000000000000000000); //greater than 10 thousand tokens (decimals = 18
//         require(_minCapital <= 1000000000000000000000000); //less than 1 million tokens (decimals = 18
//         minCapital = _minCapital;
//     }

//     function addSupportedTokens(address[] memory coins) private {
//         bool supportedToken;
//         for(uint8 i=0; i<coins.length; i++) {
//             supportedToken = true;
//             for(uint8 j=0; j<supportedTokens.length; j++) {
//                 if(coins[i] == supportedTokens[j]) {
//                     supportedToken = false;
//                 }
//             }
//             if(supportedToken == true) supportedTokens.push(coins[i]);
//         }
//     }

// }