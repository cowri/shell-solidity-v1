pragma solidity ^0.5.6;

import "./Shell.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract PrototypeTwo is ERC20 {
    using SafeMath for uint256;

    address[] public coins;
    mapping(address => mapping(address => address[]) ) public pairsToShells;
    mapping(address => mapping(address => uint256) ) public shells;

    constructor (address[] memory _coins) public {
        coins = _coins;
    }

    function createShell (address[] memory _coins) public returns (Shell) {

        Shell shell = new Shell(_coins);

        for (uint8 i = 0; i < _coins.length; i++) {
            for (uint8 j = i + 1; j < coins.length; j++){
                pairsToShells[coins[i]][coins[j]].push(address(shell));
                pairsToShells[coins[j]][coins[i]].push(address(shell));
            }
            shells[address(shell)][coins[i]] = 0;
        }

        return shell;

    }

    function depositLiquidity(address shellAddress, uint256 amount) public returns (uint256) {

      Shell shell = Shell(shellAddress);

      address[] memory shellTokens = shell.getSupportedTokens();
      uint256 liqTokensMinted = 0;

      uint256 totalCapital = 0;
      for (uint8 i = 0; i < shellTokens.length; i++) {
          totalCapital += ERC20(shellTokens[i]).balanceOf(address(this));
          ERC20(shellTokens[i]).balanceOf(msg.sender);
          ERC20(shellTokens[i]).transferFrom(msg.sender, address(this), amount);
          shells[address(shell)][shellTokens[i]] += amount;
      }
      if (shell.totalSupply() > 0) {
        uint256 capitalDeposited = amount.mul(shellTokens.length);
        uint256 numerator = shell.totalSupply().mul(capitalDeposited);
        uint256 denominator = totalCapital;
        liqTokensMinted = numerator.div(denominator);
      } else {
        liqTokensMinted = amount.mul(shellTokens.length);
      }

      shell.mint(msg.sender, liqTokensMinted);

      return liqTokensMinted;

    }

    function withdrawLiquidity (address shell, uint256 liquidityTokensToBurn) public {



    }

    function depositTokens (Shell shell, address liquidityProvider, uint256 amount) private {
      ERC20[] memory supportedTokens = shell.getSupportedTokens();
      for(uint i = 0; i < supportedTokens.length; i++) {
          supportedTokens[i].transferFrom(liquidityProvider, address(this), amount);
      }
    }

    function withdrawTokens(address shellAddress, address liquidityProvider, uint[] memory tokenAmountWithdrawn) private {
      ERC20[] memory supportedTokens = Shell(shellAddress).getSupportedTokens();
      for(uint i = 0; i < supportedTokens.length; i++) {
          supportedTokens[i].transfer(liquidityProvider, tokenAmountWithdrawn[i]);
      }
    }

    function getTotalShellCapital (address shellAddress) private view returns (uint256) {

        ERC20[] memory shellTokens = Shell(shellAddress).getSupportedTokens();

        uint256 totalCapital = 0;
        for (uint i = 0; i < shellTokens.length; i++) {
            totalCapital = totalCapital.add(shells[shellAddress][shellTokens[i]]);
        }

        return totalCapital;
    }



    function getCoins() public view returns (address[] memory) {
        return coins;
    }

}
