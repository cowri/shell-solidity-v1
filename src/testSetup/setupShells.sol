pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "./setupTokens.sol";

contract ShellSetup is TokenSetup {


    function setupShellAB () public returns (address) {
        address[] memory shellAddrs = new address[](2);
        shellAddrs[0] = address(testA);
        shellAddrs[1] = address(testB);
        return pool.createShell(shellAddrs);
    }

    function setupShellAC () public returns (address) {
        address[] memory shellAddrs = new address[](2);
        shellAddrs[0] = address(testA);
        shellAddrs[1] = address(testC);
        return pool.createShell(shellAddrs);
    }

    function setupShellABC () public returns (address) {
        address[] memory shellAddrs = new address[](3);
        shellAddrs[0] = address(testA);
        shellAddrs[1] = address(testB);
        shellAddrs[2] = address(testC);
        return pool.createShell(shellAddrs);
    }

    function setupShellABD () public returns (address) {
        address[] memory shellAddrs = new address[](3);
        shellAddrs[0] = address(testA);
        shellAddrs[1] = address(testB);
        shellAddrs[2] = address(testC);
        return pool.createShell(shellAddrs);
    }

    function setupShellABE () public returns (address) {
        address[] memory shellAddrs = new address[](3);
        shellAddrs[0] = address(testA);
        shellAddrs[1] = address(testB);
        shellAddrs[2] = address(testE);
        return pool.createShell(shellAddrs);
    }

    function setupShellABF () public returns (address) {
        address[] memory shellAddrs = new address[](3);
        shellAddrs[0] = address(testA);
        shellAddrs[1] = address(testB);
        shellAddrs[2] = address(testF);
        return pool.createShell(shellAddrs);
    }

    function setupShellABG () public returns (address) {
        address[] memory shellAddrs = new address[](3);
        shellAddrs[0] = address(testA);
        shellAddrs[1] = address(testB);
        shellAddrs[2] = address(testG);
        return pool.createShell(shellAddrs);
    }
    
    function setupShellACD () public returns (address) {
        address[] memory shellAddrs = new address[](3);
        shellAddrs[0] = address(testA);
        shellAddrs[1] = address(testC);
        shellAddrs[2] = address(testD);
        return pool.createShell(shellAddrs);
    }

    function setupShellBCD () public returns (address) {
        address[] memory shellAddrs = new address[](3);
        shellAddrs[0] = address(testB);
        shellAddrs[1] = address(testC);
        shellAddrs[2] = address(testD);
        return pool.createShell(shellAddrs);
    }

    function setupShellABCD () public returns (address) {
        address[] memory shellAddrs = new address[](4);
        shellAddrs[0] = address(testA);
        shellAddrs[1] = address(testB);
        shellAddrs[2] = address(testC);
        shellAddrs[3] = address(testD);
        return pool.createShell(shellAddrs);
    }

    function setupShellABDE () public returns (address) {
        address[] memory shellAddrs = new address[](4);
        shellAddrs[0] = address(testA);
        shellAddrs[1] = address(testB);
        shellAddrs[2] = address(testD);
        shellAddrs[3] = address(testE);
        return pool.createShell(shellAddrs);
    }

    function setupShellABEF () public returns (address) {
        address[] memory shellAddrs = new address[](4);
        shellAddrs[0] = address(testA);
        shellAddrs[1] = address(testB);
        shellAddrs[2] = address(testE);
        shellAddrs[3] = address(testF);
        return pool.createShell(shellAddrs);
    }

    function setupShellABCDE () public returns (address) {
        address[] memory shellAddrs = new address[](5);
        shellAddrs[0] = address(testA);
        shellAddrs[1] = address(testB);
        shellAddrs[2] = address(testC);
        shellAddrs[3] = address(testD);
        shellAddrs[4] = address(testE);
        return pool.createShell(shellAddrs);
    }

    function setupShellABDEF () public returns (address) {
        address[] memory shellAddrs = new address[](5);
        shellAddrs[0] = address(testA);
        shellAddrs[1] = address(testB);
        shellAddrs[2] = address(testD);
        shellAddrs[3] = address(testE);
        shellAddrs[4] = address(testF);
        return pool.createShell(shellAddrs);
    }

    function setupShellABEFG () public returns (address) {
        address[] memory shellAddrs = new address[](5);
        shellAddrs[0] = address(testA);
        shellAddrs[1] = address(testB);
        shellAddrs[2] = address(testE);
        shellAddrs[3] = address(testF);
        shellAddrs[4] = address(testG);
        return pool.createShell(shellAddrs);
    }



    function setupShellABCDEF () public returns (address) {
        address[] memory shellAddrs = new address[](6);
        shellAddrs[0] = address(testA);
        shellAddrs[1] = address(testB);
        shellAddrs[2] = address(testC);
        shellAddrs[3] = address(testD);
        shellAddrs[4] = address(testE);
        shellAddrs[5] = address(testF);
        return pool.createShell(shellAddrs);
    }

    function setupShellABCDEFG () public returns (address) {
        address[] memory shellAddrs = new address[](7);
        shellAddrs[0] = address(testA);
        shellAddrs[1] = address(testB);
        shellAddrs[2] = address(testC);
        shellAddrs[3] = address(testD);
        shellAddrs[4] = address(testE);
        shellAddrs[5] = address(testF);
        shellAddrs[6] = address(testG);
        return pool.createShell(shellAddrs);
    }

    function setupShellABCDEFGH () public returns (address) {
        address[] memory shellAddrs = new address[](8);
        shellAddrs[0] = address(testA);
        shellAddrs[1] = address(testB);
        shellAddrs[2] = address(testC);
        shellAddrs[3] = address(testD);
        shellAddrs[4] = address(testE);
        shellAddrs[5] = address(testF);
        shellAddrs[6] = address(testG);
        shellAddrs[7] = address(testH);
        return pool.createShell(shellAddrs);
    }

    function setupShellABDEFGHI () public returns (address) {
        address[] memory shellAddrs = new address[](8);
        shellAddrs[0] = address(testA);
        shellAddrs[1] = address(testB);
        shellAddrs[2] = address(testD);
        shellAddrs[3] = address(testE);
        shellAddrs[4] = address(testF);
        shellAddrs[5] = address(testG);
        shellAddrs[6] = address(testH);
        shellAddrs[7] = address(testI);
        return pool.createShell(shellAddrs);
    }

    function setupShellABCDEFGHI () public returns (address) {
        address[] memory shellAddrs = new address[](9);
        shellAddrs[0] = address(testA);
        shellAddrs[1] = address(testB);
        shellAddrs[2] = address(testC);
        shellAddrs[3] = address(testD);
        shellAddrs[4] = address(testE);
        shellAddrs[5] = address(testF);
        shellAddrs[6] = address(testG);
        shellAddrs[7] = address(testH);
        shellAddrs[8] = address(testI);
        return pool.createShell(shellAddrs);
    }

    function setupShellABCDEFGHIJK () public returns (address) {
        address[] memory shellAddrs = new address[](11);
        shellAddrs[0] = address(testA);
        shellAddrs[1] = address(testB);
        shellAddrs[2] = address(testC);
        shellAddrs[3] = address(testD);
        shellAddrs[4] = address(testE);
        shellAddrs[5] = address(testF);
        shellAddrs[6] = address(testG);
        shellAddrs[7] = address(testH);
        shellAddrs[8] = address(testI);
        shellAddrs[9] = address(testJ);
        shellAddrs[10] = address(testK);
        return pool.createShell(shellAddrs);
    }

    function setupShellABCDEFGHIJKLMN () public returns (address) {
        address[] memory shellAddrs = new address[](14);
        shellAddrs[0] = address(testA);
        shellAddrs[1] = address(testB);
        shellAddrs[2] = address(testC);
        shellAddrs[3] = address(testD);
        shellAddrs[4] = address(testE);
        shellAddrs[5] = address(testF);
        shellAddrs[6] = address(testG);
        shellAddrs[7] = address(testH);
        shellAddrs[8] = address(testI);
        shellAddrs[9] = address(testJ);
        shellAddrs[10] = address(testK);
        shellAddrs[11] = address(testL);
        shellAddrs[12] = address(testM);
        shellAddrs[13] = address(testN);
        return pool.createShell(shellAddrs);
    }

    function setupShellABCDEFGHIJKLMNO () public returns (address) {
        address[] memory shellAddrs = new address[](15);
        shellAddrs[0] = address(testA);
        shellAddrs[1] = address(testB);
        shellAddrs[2] = address(testC);
        shellAddrs[3] = address(testD);
        shellAddrs[4] = address(testE);
        shellAddrs[5] = address(testF);
        shellAddrs[6] = address(testG);
        shellAddrs[7] = address(testH);
        shellAddrs[8] = address(testI);
        shellAddrs[9] = address(testJ);
        shellAddrs[10] = address(testK);
        shellAddrs[11] = address(testL);
        shellAddrs[12] = address(testM);
        shellAddrs[13] = address(testN);
        shellAddrs[14] = address(testO);
        return pool.createShell(shellAddrs);
    }

    function setupShellABCDEFGHIJKLMNOPQ () public returns (address) {
        address[] memory shellAddrs = new address[](17);
        shellAddrs[0] = address(testA);
        shellAddrs[1] = address(testB);
        shellAddrs[2] = address(testC);
        shellAddrs[3] = address(testD);
        shellAddrs[4] = address(testE);
        shellAddrs[5] = address(testF);
        shellAddrs[6] = address(testG);
        shellAddrs[7] = address(testH);
        shellAddrs[8] = address(testI);
        shellAddrs[9] = address(testJ);
        shellAddrs[10] = address(testK);
        shellAddrs[11] = address(testL);
        shellAddrs[12] = address(testM);
        shellAddrs[13] = address(testN);
        shellAddrs[14] = address(testO);
        shellAddrs[15] = address(testP);
        shellAddrs[16] = address(testQ);
        return pool.createShell(shellAddrs);
    }
}