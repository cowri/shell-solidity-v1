pragma solidity ^0.5.0;

import "./Shell.sol";
import "./CowriRoot.sol";

contract ShellGovernance is CowriRoot {

    event shellRegistered(address indexed shell, address[] indexed tokens);
    event shellActivated(address indexed shell, address[] indexed tokens);
    event shellDeactivated(address indexed shell, address[] indexed tokens);

    function createShell (address[] memory tokens) public returns (address) {
        tokens = sortAddresses(tokens);
        address shell = delegateShellCreation(tokens);
        shells[shell] = true;
        return shell;
    }

    function delegateShellCreation (address[] memory tokens) private returns (address) {
        address _shellFactory = shellFactory;

        // solium-disable-next-line security/no-inline-assembly
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize)
            let result := delegatecall(gas, _shellFactory, ptr, calldatasize, 0, 0)
            let size := returndatasize
            returndatacopy(ptr, 0, size)

            switch result
                case 0 { revert(ptr, size) }
                default { return(ptr, size) }
        }

    }

    modifier isOfficialShell (address shell) {
        require(shells[shell], "Must be an official Cowri Shell.");
        _;
    }

    function registerShell (address shell) public returns (address) {
        address[] memory tokens = Shell(shell).getTokens();
        require(!isDuplicateShell(tokens), "Must not be a duplicate of a registered shell.");

        for (uint8 i = 0; i < tokens.length; i++) {
            for (uint8 j = i + 1; j < tokens.length; j++){
                uint256 pairKey = makeKey(tokens[i], tokens[j]);
                pairsToAllShells[pairKey].push(shell);
            }
        }

        emit shellRegistered(shell, tokens);

    }

    function activateShell (address _shell) public returns (bool) {
        require(hasSufficientCapital(_shell), "Shell must have sufficient capital");

        Shell shell = Shell(_shell);
        address[] memory tokens = shell.getTokens();

        for (uint8 i = 0; i < tokens.length; i++) {
            for (uint8 j = i + 1; j < tokens.length; j++){
                uint256 pairKey = makeKey(tokens[i], tokens[j]);
                pairsToActiveShells[pairKey].push(_shell);
            }
        }

        shellList.push(_shell);
        addSupportedTokens(tokens);

        emit shellActivated(shell, tokens);

        return true;

    }

    function deactivateShell (address _shell) public {
        require(!hasSufficientCapital(_shell), "Must not have sufficient capital");
        require(isInShellList(_shell), "Shell must be in shell list.");

        Shell shell = Shell(_shell);
        address[] memory tokens = shell.getTokens();

        for (uint8 i = 0; i < tokens.length; i++) {
            for (uint8 j = i + 1; j < tokens.length; j++) {

                bool skipped;
                uint256 pairKey = makeKey(tokens[i], tokens[j]);
                address[] memory replacement = new address[](pairsToActiveShells[pairKey].length - 1);

                for (uint8 k = 0; k < pairsToActiveShells[pairKey].length; k++) {
                    if (address(pairsToActiveShells[pairKey][k]) == _shell) {
                        skipped = true;
                    } else if (skipped) {
                        replacement[k-1] = pairsToActiveShells[pairKey][k];
                    } else {
                        replacement[k] = pairsToActiveShells[pairKey][k];
                    }
                }

                pairsToActiveShells[pairKey] = replacement;

            }
        }

        emit shellDeactivated(shell, tokens);

    }

    function hasSufficientCapital(address _shell) public  returns(bool) {

        Shell shell = Shell(_shell);

        uint256 capital = wdiv(
            shell.totalSupply(),
            shell.getTokens().length
        );

        if (capital >= shellActivationThreshold) return true;

        return false;

    }

    function isInShellList(address _shell) public view returns(bool) {
        for (uint8 i = 0; i < shellList.length; i++) if (address(shellList[i]) == _shell) return true;
        return false;
    }

    function sortAddresses (address[] memory _addresses) internal pure returns (address[] memory) {
        for(uint8 i = 0 ; i < _addresses.length;i++) {
            for(uint8 j = i+1 ; j < _addresses.length;j++) {
                if (uint256(_addresses[i]) > uint256(_addresses[j])) {
                    address swapper = _addresses[i];
                    _addresses[i] = _addresses[j];
                    _addresses[j] = swapper;
                }
            }
        }
        return _addresses;
    }

    function findShellByTokens (address[] memory _addresses) public returns (address) {

        uint256 pairKey = makeKey(_addresses[0], _addresses[1]);
        address[] memory shells = pairsToAllShells[pairKey];
        address[] memory addresses = sortAddresses(_addresses);

        for (uint8 i = 0; i < shells.length; i++) {
            address[] memory comparisons = Shell(shells[i]).getTokens();
            if (comparisons.length != addresses.length) continue;
            for (uint8 j = 0; j <= comparisons.length; j++) {
                if (j == comparisons.length) return address(shells[i]);
                if (addresses[j] != comparisons[j]) break;
            }
        }

        return address(0);

    }

    function isDuplicateShell (address[] memory _addresses) public  returns(bool) {

        if (findShellByTokens(_addresses) == address(0)) return false;
        return true;

    }

    function setShellActivationThreshold(uint256 threshold) public onlyOwner {
        require(threshold >= 10000 * ( 10 ** 18), 'Minimum capital must be more than 10 thousand');
        require(threshold <= 1000000 * (10 ** 18), 'Minimum capital must be no more than 1 million');
        shellActivationThreshold = threshold;
    }

    function addSupportedTokens(address[] memory tokens) private {
        bool supportedToken;
        for (uint8 i = 0; i < tokens.length; i++) {
            supportedToken = true;
            for (uint8 j = 0; j < supportedTokens.length; j++) {
                if (tokens[i] == supportedTokens[j]) {
                    supportedToken = false;
                }
            }
            if (supportedToken == true) supportedTokens.push(tokens[i]);
        }
    }

    function getAllShellsForPair (address one, address two) public view returns (address[] memory) {
        uint256 pairKey = makeKey(one, two);
        return pairsToAllShells[pairKey];
    }

    function getActiveShellsForPair (address one, address two) public view returns (address[] memory) {
        uint256 pairKey = makeKey(one, two);
        return pairsToActiveShells[pairKey];
    }

    function getShellBalance(address _shell) public view returns(uint) {
        return Shell(_shell).totalSupply();
    }

    function getShellBalanceOf(address _shell, address _token) public view returns (uint) {
        uint256 pairKey = makeKey(_shell, _token);
        return shellBalances[pairKey];
    }

    function getTotalShellCapital(address shell) public view returns (uint) {

        address[] memory tokens = Shell(shell).getTokens();
        uint256 totalCapital;
        for (uint i = 0; i < tokens.length; i++) {
            uint256 balanceKey = makeKey(shell, tokens[i]);
            totalCapital = add(totalCapital, shellBalances[balanceKey]);
        }

        return totalCapital;

    }

}