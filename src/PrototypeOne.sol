pragma solidity ^0.5.0;

import "ds-math/math.sol";
import "./Shell.sol";
import "./ERC20Token.sol";

contract PrototypeOne is DSMath {

    address[] supportedTokens;
    Shell[] public shellList;
    mapping(address => mapping(address => Shell[])) public pairsToShells;
    mapping(address => mapping(address => address[])) public pairsToShellAddresses;
    mapping(address => mapping(address => uint)) public shells;

    event balanceOf(bytes32, uint256);
    event log_named_uint(bytes32, uint256);
    event log_named_uint_arr(bytes32, uint256[]);
    event log(bytes32, string);

    function __init__ (address[] memory _tokens) public {
        supportedTokens = _tokens;
    }

    function getTokens () public view returns (address[] memory) {
        return supportedTokens;
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
        uint tokensNumber = shell.getTokens().length;
        uint liqTokensMinted = 0;

        if(shell.totalSupply() > 0){
            uint capitalDeposited = mul(tokensNumber, amount);
            liqTokensMinted = wdiv(wmul(shell.totalSupply(), capitalDeposited), getTotalCapital(shell));
        } else {
            liqTokensMinted = mul(tokensNumber, amount);
        }

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

    function pow(uint x, uint n) internal pure returns (uint z) {
        z = n % 2 != 0 ? x : 1;

        for (n /= 2; n != 0; n /= 2) {
            x = mul(x, x);

            if (n % 2 != 0) {
                z = mul(z, x);
            }
        }
    }

    function withdrawLiquidity(address shellAddress, uint liquidityTokensToBurn) public returns (uint256[] memory) {
        Shell shell = Shell(shellAddress);
        uint256 totalCapital = getTotalCapital(shell);
        uint256 totalShellSupply = shell.totalSupply();
        uint256 capitalWithdrawn = wdiv(wmul(totalCapital, liquidityTokensToBurn), totalShellSupply);
        // uint256 capitalWithdrawn = multiplyDivide(getTotalCapital(shell), liquidityTokensToBurn, shell.totalSupply());

        ERC20Token[] memory tokens = Shell(shellAddress).getTokens();
        uint256[] memory amountsWithdrawn = new uint256[](tokens.length);
        for(uint i = 0; i < tokens.length; i++) {

            // capital withdrawn * balance of coin for shell / amount of all coins in shell combined
            amountsWithdrawn[i] = wdiv(
                wmul(capitalWithdrawn, shells[address(shell)][address(tokens[i])]),
                totalCapital
            );

            amountsWithdrawn[i] = adjustedTransfer(
                tokens[i],
                msg.sender,
                amountsWithdrawn[i]
            );

            shells[address(shell)][address(tokens[i])] = sub(
                shells[address(shell)][address(tokens[i])],
                amountsWithdrawn[i]
            );

        }

        Shell(shellAddress).testBurn(msg.sender, liquidityTokensToBurn);

        return amountsWithdrawn;
    }

    function calculateOriginPrice (uint256 originAmount, uint256 originLiquidity, uint256 targetLiquidity) private pure returns (uint256) {
        return wdiv(
            wmul(originAmount, targetLiquidity),
            add(originAmount, originLiquidity)
        );
    }

    function calculateTargetPrice (uint256 targetAmount, uint256 originLiquidity, uint256 targetLiquidity) private pure returns (uint256) {
        return wdiv(
            wmul(targetAmount, originLiquidity),
            sub(targetLiquidity, targetAmount)
        );
    }

    function getOriginPrice (uint256 originAmount, address origin, address target) public view returns (uint256) {
        address[] memory _shells = pairsToShellAddresses[origin][target];
        (uint256 originLiquidity, uint256 targetLiquidity) = getPairLiquidity(_shells, origin, target);
        return calculateOriginPrice(originAmount, originLiquidity, targetLiquidity);
    }

    function getTargetPrice (uint256 targetAmount, address origin, address target) public view returns (uint256) {
        address[] memory _shells = pairsToShellAddresses[origin][target];
        (uint256 originLiquidity, uint256 targetLiquidity) = getPairLiquidity(_shells, origin, target);
        return calculateTargetPrice(targetAmount, originLiquidity, targetLiquidity);
    }


    function executeOriginTrade (uint256 originAmount, address origin, address target, address recipient) private returns (uint256) {

        address[] memory _shells = pairsToShellAddresses[origin][target];
        (uint256 originLiquidity, uint256 targetLiquidity) = getPairLiquidity(_shells, origin, target);

        uint256 targetAmount = calculateOriginPrice(originAmount, originLiquidity, targetLiquidity);
        balanceShells(_shells, origin, originAmount, target, targetAmount, targetLiquidity);

        adjustedTransferFrom(ERC20Token(origin), recipient, originAmount);
        return adjustedTransfer(ERC20Token(target), recipient, targetAmount);

    }

    function executeTargetTrade (uint256 targetAmount, address origin, address target, address recipient) private returns (uint256) {

        address[] memory _shells = pairsToShellAddresses[origin][target];
        (uint256 originLiquidity, uint256 targetLiquidity) = getPairLiquidity(_shells, origin, target);

        uint256 originAmount = calculateTargetPrice(targetAmount, originLiquidity, targetLiquidity);
        balanceShells(_shells, origin, originAmount, target, targetAmount, targetLiquidity);

        adjustedTransfer(ERC20Token(target), recipient, targetAmount);
        return adjustedTransferFrom(ERC20Token(origin), recipient, originAmount);

    }

    function swapByTarget (uint256 amount, address origin, address target) public returns (uint256) {
        return executeTargetTrade(amount, origin, target, msg.sender);
    }

    function swapByOrigin (uint256 amount, address origin, address target) public returns (uint256) {
        return executeOriginTrade(amount, origin, target, msg.sender);
    }

    function transferByTarget (uint256 amount, address origin, address target, address recipient) public returns (uint256) {
        return executeTargetTrade(amount, origin, target, recipient);
    }

    function transferByOrigin (uint256 amount, address origin, address target, address recipient) public returns (uint256) {
        return executeOriginTrade(amount, origin, target, recipient);
    }

    function getPairLiquidity (address[] memory _shells, address origin, address target) private view returns (uint256, uint256) {
        uint256 originLiquidity;
        uint256 targetLiquidity;

        for (uint8 i = 0; i < _shells.length; i++) {
            originLiquidity += shells[_shells[i]][origin];
            targetLiquidity += shells[_shells[i]][target];
        }

        return (originLiquidity, targetLiquidity);

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

    function swap(address originCurrency, address targetCurrency, uint originAmount) public returns (uint256) {
        address[] memory _shells = pairsToShellAddresses[originCurrency][targetCurrency];

        uint originLiquidity = 0; //total supply of originCurrency in shells that support the trading pair
        uint targetLiquidity = 0; //total supply of targetCurrency in shells that support the trading pair
        for (uint i = 0; i < _shells.length; i++) {
            originLiquidity = add(originLiquidity, shells[_shells[i]][originCurrency]);
            targetLiquidity = add(targetLiquidity, shells[_shells[i]][targetCurrency]);
        }

        //calculating the swap amount for the target currency
        uint targetAmount = wdiv(
            wmul(originAmount, targetLiquidity),
            add(originAmount, originLiquidity)
        );

        //calculating the % contribution and updating the shell balances
        uint originBalance; //balance of originCurrency in a given shell
        uint targetBalance; //balance of targetCurrency in a given shell
        for(uint i = 0; i < _shells.length; i++) {

            targetBalance = shells[_shells[i]][targetCurrency];
            shells[_shells[i]][targetCurrency] = sub(
                targetBalance,
                wdiv(
                    wmul(targetAmount, targetBalance),
                    targetLiquidity
                )
            );

            originBalance = shells[_shells[i]][originCurrency];
            shells[_shells[i]][originCurrency] = add(
                originBalance,
                wdiv(
                    wmul(originAmount, targetBalance),
                    targetLiquidity
                )
            );

        }

        adjustedTransferFrom(
            ERC20Token(originCurrency),
            msg.sender,
            originAmount
        );

        return adjustedTransfer(
            ERC20Token(targetCurrency),
            msg.sender,
            targetAmount
        );

    }

    function adjustedTransferFrom (ERC20Token token, address source, uint256 amount) private returns (uint256) {

        uint256 decimals = token.decimals();
        uint256 adjustedAmount = decimals <= 18
            ? amount / pow(10, 18 - decimals)
            : mul(amount, pow(10, decimals - 18));

        token.transferFrom(
            source,
            address(this),
            adjustedAmount
        );

        return adjustedAmount;

    }

    function adjustedTransfer (ERC20Token token, address recipient, uint256 amount) private returns (uint256) {

        uint256 decimals = token.decimals();
        uint256 adjustedAmount = decimals <= 18
            ? amount / pow(10, 18 - decimals)
            : mul(amount, pow(10, decimals - 18));

        token.transfer(
            recipient,
            adjustedAmount
        );

        return adjustedAmount;

    }

    function getShellBalanceOf(address _shell, address _token) public view returns (uint) {
        return shells[_shell][_token];
    }

    ////////////////////////////////////
    ///UTILITY FUNCTIONS FOR EXCHANGE///
    ////////////////////////////////////

    function depositTokens(Shell shell, address liquidityProvider, uint amount) private {
        ERC20Token[] memory tokens = shell.getTokens();
        for(uint i = 0; i < tokens.length; i++) {
            tokens[i].transferFrom(liquidityProvider, address(this), amount);
        }
    }

    function withdrawTokens(address shellAddress, address liquidityProvider, uint[] memory tokenAmountWithdrawn) private {
        ERC20Token[] memory tokens = Shell(shellAddress).getTokens();
        for(uint i = 0; i < tokens.length; i++) {
            tokens[i].transfer(liquidityProvider, tokenAmountWithdrawn[i]);
        }
    }

  function tokenAmountWithdrawnCalc(Shell shell, uint capitalRemoved) private returns(uint[] memory) {
        ERC20Token[] memory tokens = shell.getTokens();
        uint[] memory tokenAmountWithdrawn = new uint[](tokens.length);
        uint totalCapital = getTotalCapital(shell);
        for(uint i = 0; i < tokens.length; i++) {
            //currently getting the stablecoins of the exchange contract
            //need to update and get the stablecoins of the shell
            tokenAmountWithdrawn[i] = wdiv(
                wmul(capitalRemoved, shells[address(shell)][address(tokens[i])]),
                totalCapital
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
        address[] memory tokens = shell.getTokenAddresses();
        for (uint i = 0; i < tokens.length; i++) {
            totalCapital = add(totalCapital, shells[address(shell)][tokens[i]]);
        }
        return(totalCapital);
    }

    //updates the shell's balance as recorded on the exchange (called when depositing capital)
    function depositShellBalance(Shell shell, uint amount) private {
        ERC20Token[] memory tokens = shell.getTokens();
        address shellAddress = address(shell);
        uint currentBalance;
        for (uint i = 0; i < tokens.length; i++) {
            currentBalance = shells[shellAddress][address(tokens[i])];
            shells[shellAddress][address(tokens[i])] = add(currentBalance, amount);
        }
    }

    //function is incorrect. We want to use tokenAmountWithdrawn[] so that each balance
    //is incremented differently, not by the same amount
    function withdrawShellBalance(address shellAddress, uint[] memory tokenAmountWithdrawn) private {
        ERC20Token[] memory tokens = Shell(shellAddress).getTokens();
        uint currentBalance;
        for(uint i = 0; i < tokens.length; i++) {
            currentBalance = shells[shellAddress][address(tokens[i])];
            shells[shellAddress][address(tokens[i])] = sub(currentBalance, tokenAmountWithdrawn[i]);
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