
pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../PrototypeOne.sol";
import "../Shell.sol";
import "../TOKEN.sol";

contract DappTest is PrototypeOne, DSTest {
    TOKEN TEST1;
    TOKEN TEST2;
    TOKEN TEST3;
    TOKEN TEST4;
    address shell1;
    address shell2;

    function setUp() public {

        TEST1 = new TOKEN("TEST ONE", "TEST1", 18, 500);
        TEST2 = new TOKEN("TEST TWO", "TEST2", 18, 500);
        TEST3 = new TOKEN("TEST THREE", "TEST3", 18, 500);
        TEST4 = new TOKEN("TEST FOUR", "TEST4", 18, 500);

        address[] memory shell1Addrs = new address[](3);
        shell1Addrs[0] = address(TEST1);
        shell1Addrs[1] = address(TEST2);
        shell1Addrs[2] = address(TEST3);

        address[] memory shell2Addrs = new address[](2);
        shell2Addrs[0] = address(TEST1);
        shell2Addrs[1] = address(TEST2);

        shell1 = createShell(shell1Addrs);
        shell2 = createShell(shell2Addrs);

    }

    function testAddedShells() public {

        address[] memory oneToTwoAddresses = pairsToShellAddresses[address(TEST1)][address(TEST2)];
        Shell[] memory oneToTwoShells = pairsToShells[address(TEST1)][address(TEST2)];

        assertEq(oneToTwoAddresses.length, 2);
        assertEq(oneToTwoShells.length, 2);

        assertEq(oneToTwoAddresses[0], shell1);
        assertEq(address(oneToTwoShells[0]), shell1);
        assertEq(oneToTwoAddresses[1], shell2);
        assertEq(address(oneToTwoShells[1]), shell2);

        address[] memory twoToOneAddresses = pairsToShellAddresses[address(TEST2)][address(TEST1)];
        Shell[] memory twoToOneShells = pairsToShells[address(TEST2)][address(TEST1)];

        assertEq(twoToOneAddresses.length, 2);
        assertEq(twoToOneShells.length, 2);

        assertEq(twoToOneAddresses[0], shell1);
        assertEq(address(twoToOneShells[0]), shell1);
        assertEq(twoToOneAddresses[1], shell2);
        assertEq(address(twoToOneShells[1]), shell2);

        address[] memory oneToThreeAddresses = pairsToShellAddresses[address(TEST1)][address(TEST3)];
        Shell[] memory oneToThreeShells = pairsToShells[address(TEST1)][address(TEST3)];

        assertEq(oneToThreeAddresses.length, 1);
        assertEq(oneToThreeShells.length, 1);
        assertEq(oneToThreeAddresses[0], shell1);
        assertEq(address(oneToThreeShells[0]), shell1);

        address[] memory threeToOneAddresses = pairsToShellAddresses[address(TEST3)][address(TEST1)];
        Shell[] memory threeToOneShells = pairsToShells[address(TEST3)][address(TEST1)];

        assertEq(threeToOneAddresses.length, 1);
        assertEq(threeToOneShells.length, 1);
        assertEq(threeToOneAddresses[0], shell1);
        assertEq(address(threeToOneShells[0]), shell1);

        address[] memory twoToThreeAddresses = pairsToShellAddresses[address(TEST2)][address(TEST3)];
        Shell[] memory twoToThreeShells = pairsToShells[address(TEST2)][address(TEST3)];

        assertEq(twoToThreeAddresses.length, 1);
        assertEq(twoToThreeShells.length, 1);
        assertEq(twoToThreeAddresses[0], shell1);
        assertEq(address(twoToThreeShells[0]), shell1);

        address[] memory fourToOneAddresses = pairsToShellAddresses[address(TEST4)][address(TEST1)];
        Shell[] memory fourToOneShells = pairsToShells[address(TEST4)][address(TEST1)];

        assertEq(fourToOneAddresses.length, 0);
        assertEq(fourToOneShells.length, 0);

    }

}