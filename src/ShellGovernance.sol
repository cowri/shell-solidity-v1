pragma solidity ^0.5.0;

import "./Shell.sol";
import "./CowriState.sol";
import "ds-math/math.sol";

contract ShellGovernance is DSMath, CowriState {

        event log_addr      (bytes32 key, address val);
        event log_addr_arr      (bytes32 key, address[] val);
        event log_shell_arr      (bytes32 key, Shell[] val);
        event log_named_uint      (bytes32 key, uint val);
        event log_erc20_arr (bytes32 key, ERC20Token[] val);

    function createShell (address[] memory tokens) public returns (address) {
        address _shellFactory = shellFactory;
        tokens = sortAddresses(tokens);

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

    function registerShell (address[] memory tokens) public returns (address) {
        require(!isDuplicateShell(tokens), "Must not be a duplicate shell.");
        // Shell shell = new Shell(tokens);

        for (uint8 i = 0; i < tokens.length; i++) {
            for (uint8 j = i + 1; j < tokens.length; j++){
                pairsToAllShells[tokens[i]][tokens[j]].push(address(this));
                pairsToAllShells[tokens[j]][tokens[i]].push(address(this));
            }
        }

        return(address(this));
    }

    function activateShell (address _shell) public returns (bool) {
        require(hasSufficientCapital(_shell), "Shell must have sufficient capital");

        Shell shell = Shell(_shell);
        address[] memory tokens = shell.getTokens();

        emit log_addr_arr("tokens", tokens);

        for (uint8 i = 0; i < tokens.length; i++) {
            for (uint8 j = i + 1; j < tokens.length; j++){
                pairsToActiveShells[tokens[i]][tokens[j]].push(_shell);
                pairsToActiveShells[tokens[j]][tokens[i]].push(_shell);
            }
        }

        shellList.push(_shell);
        addSupportedTokens(tokens);

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

                address[] memory replacementShellsItoJ = new address[](pairsToActiveShells[tokens[i]][tokens[j]].length - 1);

                for (uint8 k = 0; k < pairsToActiveShells[tokens[i]][tokens[j]].length; k++) {
                    if (address(pairsToActiveShells[tokens[i]][tokens[j]][k]) == _shell) {
                        skipped = true;
                    } else if (skipped) {
                        replacementShellsItoJ[k-1] = pairsToActiveShells[tokens[i]][tokens[j]][k];
                    } else {
                        replacementShellsItoJ[k] = pairsToActiveShells[tokens[i]][tokens[j]][k];
                    }
                }

                address[] memory replacementShellsJtoI = new address[](pairsToActiveShells[tokens[j]][tokens[i]].length - 1);

                for (uint8 k = 0; k < pairsToActiveShells[tokens[j]][tokens[i]].length; k++) {
                    if (address(pairsToActiveShells[tokens[j]][tokens[i]][k]) == _shell) {
                        skipped = true;
                    } else if (skipped) {
                        replacementShellsJtoI[k-1] = pairsToActiveShells[tokens[i]][tokens[j]][k];
                    } else {
                        replacementShellsJtoI[k] = pairsToActiveShells[tokens[j]][tokens[i]][k];
                    }
                }

                pairsToActiveShells[tokens[i]][tokens[j]] = replacementShellsItoJ;
                pairsToActiveShells[tokens[j]][tokens[i]] = replacementShellsJtoI;

            }
        }

    }

    function hasSufficientCapital(address _shell) public  returns(bool) {

        Shell shell = Shell(_shell);

        uint256 capital = wdiv(
            shell.totalSupply(),
            shell.getTokens().length
        );

        if (capital >= minCapital) return true;

        return false;

    }

    function isInShellList(address _shell) public view returns(bool) {
        for (uint8 i = 0; i<shellList.length; i++) if (address(shellList[i]) == _shell) return true;
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

        address[] memory addresses = sortAddresses(_addresses);
        address[] memory shells = pairsToAllShells[addresses[0]][addresses[1]];

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

    function setMinCapital(uint256 _minCapital) public {
        require(_minCapital >= 10000 * ( 10 ** 18), 'Minimum capital must be more than 10 thousand');
        require(_minCapital <= 1000000 * (10 ** 18), 'Minimum capital must be no more than 1 million');
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

    function getAllShellsForPair (address one, address two) public view returns (address[] memory) {
        return pairsToActiveShells[one][two];
    }

    function getActiveShellsForPair (address one, address two) public  returns (address[] memory) {
        return pairsToActiveShells[one][two];
    }

    function getShellBalance(address _shell, address _token) public view returns(uint) {
        return shells[_shell][_token];
    }

    function getShellBalanceOf(address _shell, address _token) public view returns (uint) {
        return shells[_shell][_token];
    }

    function getTotalShellCapital(address shell) public  returns (uint) {

        address[] memory tokens = Shell(shell).getTokens();
        uint256 totalCapital;
        for (uint i = 0; i < tokens.length; i++) {
            totalCapital = add(totalCapital, shells[shell][address(tokens[i])]);
        }

        return totalCapital;

    }

}