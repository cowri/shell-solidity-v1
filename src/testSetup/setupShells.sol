


pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "./setupTokens.sol";

contract ShellSetup is TokenSetup {

    function setup2TokenShell () public returns (address) {
        address[] memory shellAddrs = new address[](2);
        shellAddrs[0] = address(TEST1);
        shellAddrs[1] = address(TEST2);
        return pool.createShell(shellAddrs);
    }

    function setup3TokenShell () public returns (address) {
        address[] memory shellAddrs = new address[](3);
        shellAddrs[0] = address(TEST1);
        shellAddrs[1] = address(TEST2);
        shellAddrs[2] = address(TEST3);
        return pool.createShell(shellAddrs);
    }

    function setup4TokenShell () public returns (address) {
        address[] memory shellAddrs = new address[](4);
        shellAddrs[0] = address(TEST1);
        shellAddrs[1] = address(TEST2);
        shellAddrs[2] = address(TEST3);
        shellAddrs[3] = address(TEST4);
        return pool.createShell(shellAddrs);
    }

    function setup5TokenShell () public returns (address) {

        address[] memory shellAddrs = new address[](5);
        shellAddrs[0] = address(TEST1);
        shellAddrs[1] = address(TEST2);
        shellAddrs[2] = address(TEST3);
        shellAddrs[3] = address(TEST4);
        shellAddrs[4] = address(TEST5);

        return pool.createShell(shellAddrs);

    }

    function setup6TokenShell () public returns (address) {

        address[] memory shellAddrs = new address[](6);
        shellAddrs[0] = address(TEST1);
        shellAddrs[1] = address(TEST2);
        shellAddrs[2] = address(TEST3);
        shellAddrs[3] = address(TEST4);
        shellAddrs[4] = address(TEST5);
        shellAddrs[5] = address(TEST6);

        return pool.createShell(shellAddrs);

    }

    function setup7TokenShell () public returns (address) {

        address[] memory shellAddrs = new address[](7);
        shellAddrs[0] = address(TEST1);
        shellAddrs[1] = address(TEST2);
        shellAddrs[2] = address(TEST3);
        shellAddrs[3] = address(TEST4);
        shellAddrs[4] = address(TEST5);
        shellAddrs[5] = address(TEST6);
        shellAddrs[6] = address(TEST7);

        return pool.createShell(shellAddrs);

    }


    function setup8TokenShell () public returns (address) {

        address[] memory shellAddrs = new address[](8);
        shellAddrs[0] = address(TEST1);
        shellAddrs[1] = address(TEST2);
        shellAddrs[2] = address(TEST3);
        shellAddrs[3] = address(TEST4);
        shellAddrs[4] = address(TEST5);
        shellAddrs[5] = address(TEST6);
        shellAddrs[6] = address(TEST7);
        shellAddrs[7] = address(TEST8);

        return pool.createShell(shellAddrs);

    }

    function setup11TokenShell () public returns (address) {

        address[] memory shellAddrs = new address[](11);
        shellAddrs[0] = address(TEST1);
        shellAddrs[1] = address(TEST2);
        shellAddrs[2] = address(TEST3);
        shellAddrs[3] = address(TEST4);
        shellAddrs[4] = address(TEST5);
        shellAddrs[5] = address(TEST6);
        shellAddrs[6] = address(TEST7);
        shellAddrs[7] = address(TEST8);
        shellAddrs[8] = address(TEST9);
        shellAddrs[9] = address(TEST10);
        shellAddrs[10] = address(TEST11);

        return pool.createShell(shellAddrs);

    }

    function setup14TokenShell () public returns (address) {

        address[] memory shellAddrs = new address[](14);
        shellAddrs[0] = address(TEST1);
        shellAddrs[1] = address(TEST2);
        shellAddrs[2] = address(TEST3);
        shellAddrs[3] = address(TEST4);
        shellAddrs[4] = address(TEST5);
        shellAddrs[5] = address(TEST6);
        shellAddrs[6] = address(TEST7);
        shellAddrs[7] = address(TEST8);
        shellAddrs[8] = address(TEST9);
        shellAddrs[9] = address(TEST10);
        shellAddrs[10] = address(TEST11);
        shellAddrs[11] = address(TEST12);
        shellAddrs[12] = address(TEST13);
        shellAddrs[13] = address(TEST14);

        return pool.createShell(shellAddrs);

    }

    function setup17TokenShell () public returns (address) {

        address[] memory shellAddrs = new address[](17);
        shellAddrs[0] = address(TEST1);
        shellAddrs[1] = address(TEST2);
        shellAddrs[2] = address(TEST3);
        shellAddrs[3] = address(TEST4);
        shellAddrs[4] = address(TEST5);
        shellAddrs[5] = address(TEST6);
        shellAddrs[6] = address(TEST7);
        shellAddrs[7] = address(TEST8);
        shellAddrs[8] = address(TEST9);
        shellAddrs[9] = address(TEST10);
        shellAddrs[10] = address(TEST11);
        shellAddrs[11] = address(TEST12);
        shellAddrs[12] = address(TEST13);
        shellAddrs[13] = address(TEST14);
        shellAddrs[14] = address(TEST15);
        shellAddrs[15] = address(TEST16);
        shellAddrs[16] = address(TEST17);

        return pool.createShell(shellAddrs);
    }
}