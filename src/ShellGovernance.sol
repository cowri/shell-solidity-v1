pragma solidity ^0.5.0;

import "./Shell.sol";
import "./CowriState.sol";
import "ds-math/math.sol";

contract ShellGovernance is DSMath, CowriState {

        event log_named_address      (bytes32 key, address val);
<<<<<<< HEAD
        event log_addr_arr      (bytes32 key, address[] val);
        event log_shell_arr      (bytes32 key, Shell[] val);
        event log_named_uint      (bytes32 key, uint val);
        event log_erc20_arr (bytes32 key, ERC20Token[] val);

    function createShell (address[] memory tokens) public returns (address) {
        tokens = sortAddresses(tokens);
        require(!isDuplicateShell(tokens), "Must not be a duplicate shell.");
        Shell shell = new Shell(tokens);

        for (uint8 i = 0; i < tokens.length; i++) {
            for (uint8 j = i + 1; j < tokens.length; j++){
                pairsToAllShells[tokens[i]][tokens[j]].push(shell);
                pairsToAllShells[tokens[j]][tokens[i]].push(shell);
                pairsToAllShellAddresses[tokens[i]][tokens[j]].push(address(shell));
                pairsToAllShellAddresses[tokens[j]][tokens[i]].push(address(shell));
            }
        }

        return(address(shell));
    }

    function activateShell (address _shell) public returns (bool) {
=======

    function createShell (address[] memory _tokens) public returns (address) {
        _tokens = sortAddresses(_tokens);
        require(!isDuplicateShell(_tokens), "Must not be a duplicate shell.");
        Shell shell = new Shell(_tokens);
        emit log_named_address("shell", address(shell));
        return(address(shell));
    }

    function activateShell (address _shell) public {
>>>>>>> master

        require(hasSufficientCapital(_shell), "Shell must have sufficient capital");

        Shell shell = Shell(_shell);
        shellList.push(shell);
        address[] memory tokens = shell.getTokenAddresses();

        for (uint8 i = 0; i < tokens.length; i++) {
            for (uint8 j = i + 1; j < tokens.length; j++){
<<<<<<< HEAD
                pairsToActiveShells[tokens[i]][tokens[j]].push(shell);
                pairsToActiveShells[tokens[j]][tokens[i]].push(shell);
                pairsToActiveShellAddresses[tokens[j]][tokens[i]].push(_shell);
                pairsToActiveShellAddresses[tokens[i]][tokens[j]].push(_shell);
=======
                pairsToShells[tokens[i]][tokens[j]].push(shell);
                pairsToShells[tokens[j]][tokens[i]].push(shell);
                pairsToShellAddresses[tokens[j]][tokens[i]].push(_shell);
                pairsToShellAddresses[tokens[i]][tokens[j]].push(_shell);
>>>>>>> master
            }
        }

        addSupportedTokens(tokens);

<<<<<<< HEAD
        return true;

    }

    function deactivateShell (address _shell) public {
        require(!hasSufficientCapital(_shell), "Must not have sufficient capital");
=======
    }

    function deactivateShell (address _shell) public {
        require(hasSufficientCapital(_shell), "Must not have sufficient capital");
>>>>>>> master
        require(isInShellList(_shell), "Shell must be in shell list.");

        Shell shell = Shell(_shell);
        address[] memory tokens = shell.getTokenAddresses();

        for (uint8 i = 0; i < tokens.length; i++) {
<<<<<<< HEAD
            for (uint8 j = i + 1; j < tokens.length; j++) {

                bool skipped;

                address[] memory replacementShellAddressesItoJ = new address[](pairsToActiveShellAddresses[tokens[i]][tokens[j]].length - 1);
                Shell[] memory replacementShellsItoJ = new Shell[](pairsToActiveShells[tokens[i]][tokens[j]].length - 1);

                for (uint8 k = 0; k < pairsToActiveShellAddresses[tokens[i]][tokens[j]].length; k++) {
                    if (pairsToActiveShellAddresses[tokens[i]][tokens[j]][k] == _shell) {
                        skipped = true;
                    } else if (skipped) {
                        replacementShellAddressesItoJ[k-1] = pairsToActiveShellAddresses[tokens[i]][tokens[j]][k];
                        replacementShellsItoJ[k-1] = pairsToActiveShells[tokens[i]][tokens[j]][k];
                    } else {
                        replacementShellAddressesItoJ[k] = pairsToActiveShellAddresses[tokens[i]][tokens[j]][k];
                        replacementShellsItoJ[k] = pairsToActiveShells[tokens[i]][tokens[j]][k];
                    }
                }

                address[] memory replacementShellAddressesJtoI = new address[](pairsToActiveShellAddresses[tokens[j]][tokens[i]].length - 1);
                Shell[] memory replacementShellsJtoI = new Shell[](pairsToActiveShells[tokens[j]][tokens[i]].length - 1);

                for (uint8 k = 0; k < pairsToActiveShellAddresses[tokens[j]][tokens[i]].length; k++) {
                    if (pairsToActiveShellAddresses[tokens[j]][tokens[i]][k] == _shell) {
                        skipped = true;
                    } else if (skipped) {
                        replacementShellAddressesJtoI[k-1] = pairsToActiveShellAddresses[tokens[j]][tokens[i]][k];
                        replacementShellsJtoI[k-1] = pairsToActiveShells[tokens[i]][tokens[j]][k];
                    } else {
                        replacementShellAddressesJtoI[k] = pairsToActiveShellAddresses[tokens[j]][tokens[i]][k];
                        replacementShellsJtoI[k] = pairsToActiveShells[tokens[j]][tokens[i]][k];
                    }
                }

                pairsToActiveShellAddresses[tokens[i]][tokens[j]] = replacementShellAddressesItoJ;
                pairsToActiveShells[tokens[i]][tokens[j]] = replacementShellsItoJ;
                pairsToActiveShellAddresses[tokens[j]][tokens[i]] = replacementShellAddressesJtoI;
                pairsToActiveShells[tokens[j]][tokens[i]] = replacementShellsJtoI;

            }
        }

    }

    function hasSufficientCapital(address shellAddress) public  returns(bool) {
=======
            for (uint8 j = i + 1; j < tokens.length; j++){
                //remove shell from pairsToShells and pairsToShellAddresses
            }
        }
    }

    function hasSufficientCapital(address shellAddress) public view returns(bool) {
>>>>>>> master

        uint256 capital = wdiv(
            Shell(shellAddress).totalSupply(),
            Shell(shellAddress).getTokens().length
        );

        if (capital >= minCapital) return true;

        return false;

    }

    function isInShellList(address shellAddress) public view returns(bool) {
        for (uint8 i = 0; i<shellList.length; i++) {
            if(address(shellList[i]) == shellAddress) return true;
        }
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

<<<<<<< HEAD
    function findShellByTokens (address[] memory _addresses) public returns (address) {

        address[] memory addresses = sortAddresses(_addresses);
        Shell[] memory shells = pairsToAllShells[addresses[0]][addresses[1]];
=======
    function isDuplicateShell (address[] memory _addresses) public view returns(bool) {

        address[] memory addresses = sortAddresses(_addresses);
        Shell[] memory shells = pairsToShells[_addresses[0]][_addresses[1]];
>>>>>>> master

        for (uint8 i = 0; i < shells.length; i++) {
            address[] memory comparisons = shells[i].getTokenAddresses();
            if (comparisons.length != addresses.length) continue;
            for (uint8 j = 0; j <= comparisons.length; j++) {
<<<<<<< HEAD
                if (j == comparisons.length) return address(shells[i]);
=======
                if (j == comparisons.length) return true;
>>>>>>> master
                if (addresses[j] != comparisons[j]) break;
            }
        }

<<<<<<< HEAD
        return address(0);

    }

    function isDuplicateShell (address[] memory _addresses) public  returns(bool) {

        if (findShellByTokens(_addresses) == address(0)) return false;
        return true;

    }

    function setMinCapital(uint256 _minCapital) public {
        require(_minCapital >= 10000 * ( 10 ** 18), 'Minimum capital must be more than 10 thousand');
        require(_minCapital <= 1000000 * (10 ** 18), 'Minimum capital must be no more than 1 million');
=======
        return false;
    }

    function setMinCapital(uint256 _minCapital) public {
        require(_minCapital >= 10000000000000000000000, 'Minimum capital must be more than 10 thousand');
        require(_minCapital <= 1000000000000000000000000, 'Minimum capital must be no more than 1 million');
>>>>>>> master
        minCapital = _minCapital;
    }

    function addSupportedTokens(address[] memory tokens) private {
        bool supportedToken;
        for (uint8 i = 0; i < tokens.length; i++) {
            supportedToken = true;
            for (uint8 j = 0; j < supportedTokens.length; j++) {
                if(tokens[i] == supportedTokens[j]) {
                    supportedToken = false;
                }
            }
            if(supportedToken == true) supportedTokens.push(tokens[i]);
        }
    }

<<<<<<< HEAD
    function getAllShellsForPair (address one, address two) public view returns (address[] memory) {
        return pairsToAllShellAddresses[one][two];
    }

    function getActiveShellsForPair (address one, address two) public  returns (address[] memory) {
        return pairsToActiveShellAddresses[one][two];
    }

=======
>>>>>>> master
    function getShellBalance(uint index, address _address) public view returns(uint) {
        return(shellList[index].balanceOf(_address));
    }

    function getShellBalanceOf(address _shell, address _token) public view returns (uint) {
        return shells[_shell][_token];
    }

<<<<<<< HEAD
    function getTotalShellCapital(address shell) public  returns (uint) {

        address[] memory tokens = Shell(shell).getTokenAddresses();
        emit log_addr_arr("erc20s", tokens);
        uint256 totalCapital;
        emit log_named_uint("totes cap",totalCapital);
        for (uint i = 0; i < tokens.length; i++) {
            totalCapital = add(totalCapital, shells[shell][address(tokens[i])]);
        }

        return totalCapital;

    }
=======
>>>>>>> master

}