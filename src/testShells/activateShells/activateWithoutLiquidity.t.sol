

pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../../Prototype.sol";
import "../../ERC20Token.sol";
import "../../ShellFactory.sol";
import "../../Shell.sol";
import "../../testSetup/setupShells.sol";

contract DappTest is DSTest, ShellSetup {
    address shell;

    function setUp () public {

        setupPool();
        setupTokens();
        shell = setupShellAB();
        pool.setMinCapital(10000 * (10 ** 18));

    }

        function testActivateShellWithoutLiquidity () public {

        ( bool success, bytes memory returnData ) = address(pool).call(
                abi.encodePacked(
                    pool.activateShell.selector,
                    abi.encode(shell) 
                )
            );
        assert(!success);

    }

}