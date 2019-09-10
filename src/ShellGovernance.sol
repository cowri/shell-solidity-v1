pragma solidity ^0.5.0;

import "./Shell.sol";
import "./CowriState.sol";
import "ds-math/math.sol";

contract ShellGovernance is DSMath, CowriState {

        event log_named_address      (bytes32 key, address val);

    function createShell (address[] memory _tokens) public returns (address) {
        _tokens = sortAddresses(_tokens);
        require(!isDuplicateShell(_tokens), "Must not be a duplicate shell.");
        Shell shell = new Shell(_tokens);
        emit log_named_address("shell", address(shell));
        return(address(shell));
    }

    function activateShell (address _shell) public {

        require(hasSufficientCapital(_shell), "Shell must have sufficient capital");

        Shell shell = Shell(_shell);
        shellList.push(shell);
        address[] memory tokens = shell.getTokenAddresses();

        for (uint8 i = 0; i < tokens.length; i++) {
            for (uint8 j = i + 1; j < tokens.length; j++){
                pairsToShells[tokens[i]][tokens[j]].push(shell);
                pairsToShells[tokens[j]][tokens[i]].push(shell);
                pairsToShellAddresses[tokens[j]][tokens[i]].push(_shell);
                pairsToShellAddresses[tokens[i]][tokens[j]].push(_shell);
            }
        }

        addSupportedTokens(tokens);

    }

    function deactivateShell (address _shell) public {
        require(hasSufficientCapital(_shell), "Must not have sufficient capital");
        require(isInShellList(_shell), "Shell must be in shell list.");

        Shell shell = Shell(_shell);
        address[] memory tokens = shell.getTokenAddresses();

        for (uint8 i = 0; i < tokens.length; i++) {
            for (uint8 j = i + 1; j < tokens.length; j++){
                //remove shell from pairsToShells and pairsToShellAddresses
            }
        }
    }

    function hasSufficientCapital(address shellAddress) public view returns(bool) {

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

    function isDuplicateShell (address[] memory _addresses) public view returns(bool) {

        address[] memory addresses = sortAddresses(_addresses);
        Shell[] memory shells = pairsToShells[_addresses[0]][_addresses[1]];

        for (uint8 i = 0; i < shells.length; i++) {
            address[] memory comparisons = shells[i].getTokenAddresses();
            if (comparisons.length != addresses.length) continue;
            for (uint8 j = 0; j <= comparisons.length; j++) {
                if (j == comparisons.length) return true;
                if (addresses[j] != comparisons[j]) break;
            }
        }

        return false;
    }

    function setMinCapital(uint256 _minCapital) public {
        require(_minCapital >= 10000000000000000000000, 'Minimum capital must be more than 10 thousand');
        require(_minCapital <= 1000000000000000000000000, 'Minimum capital must be no more than 1 million');
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

    function getShellBalance(uint index, address _address) public view returns(uint) {
        return(shellList[index].balanceOf(_address));
    }

    function getShellBalanceOf(address _shell, address _token) public view returns (uint) {
        return shells[_shell][_token];
    }


}