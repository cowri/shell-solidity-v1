
pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "../PrototypeOne.sol";
import "../Prototype.sol";
import "../Shell.sol";
import "../TOKEN.sol";
import "../CowriState.sol";

contract DappTest is DSTest {
    Prototype pool;
    TOKEN TEST1;
    TOKEN TEST2;
    TOKEN TEST3;
    TOKEN TEST4;
    TOKEN TEST5;
    TOKEN TEST6;
    TOKEN TEST7;
    TOKEN TEST8;
    TOKEN TEST9;
    TOKEN TEST10;
    TOKEN TEST11;
    TOKEN TEST12;
    TOKEN TEST13;
    TOKEN TEST14;
    TOKEN TEST15;
    TOKEN TEST16;
    TOKEN TEST17;
    address shell1;
    address shell2;
    address shell3;
    address shell4;
    address shell5;

    event log_addr_arr           (bytes32 key, address[] val);
    event log_addr           (bytes32 key, address val);

    function setUp() public {

        uint256 tokenAmount = 1000000000 * (10 ** 18);
        TEST1 = new TOKEN("TEST ONE", "TEST1", 18, tokenAmount);
        TEST2 = new TOKEN("TEST TWO", "TEST2", 18, tokenAmount);
        TEST3 = new TOKEN("TEST THREE", "TEST3", 18, tokenAmount);
        TEST4 = new TOKEN("TEST THREE", "TEST3", 18, tokenAmount);
        TEST5 = new TOKEN("TEST THREE", "TEST3", 18, tokenAmount);
        TEST6 = new TOKEN("TEST THREE", "TEST3", 18, tokenAmount);
        TEST7 = new TOKEN("TEST THREE", "TEST3", 18, tokenAmount);
        TEST8 = new TOKEN("TEST THREE", "TEST3", 18, tokenAmount);
        TEST9 = new TOKEN("TEST THREE", "TEST3", 18, tokenAmount);
        TEST10 = new TOKEN("TEST THREE", "TEST3", 18, tokenAmount);
        TEST11 = new TOKEN("TEST THREE", "TEST3", 18, tokenAmount);
        TEST12 = new TOKEN("TEST THREE", "TEST3", 18, tokenAmount);
        TEST13 = new TOKEN("TEST THREE", "TEST3", 18, tokenAmount);
        TEST14 = new TOKEN("TEST THREE", "TEST3", 18, tokenAmount);
        TEST15 = new TOKEN("TEST THREE", "TEST3", 18, tokenAmount);
        TEST16 = new TOKEN("TEST THREE", "TEST3", 18, tokenAmount);
        TEST17 = new TOKEN("TEST THREE", "TEST3", 18, tokenAmount);

        pool = new Prototype();

        TEST1.approve(address(pool), tokenAmount);
        TEST2.approve(address(pool), tokenAmount);
        TEST3.approve(address(pool), tokenAmount);
        TEST4.approve(address(pool), tokenAmount);
        TEST5.approve(address(pool), tokenAmount);
        TEST6.approve(address(pool), tokenAmount);
        TEST7.approve(address(pool), tokenAmount);
        TEST8.approve(address(pool), tokenAmount);
        TEST9.approve(address(pool), tokenAmount);
        TEST10.approve(address(pool), tokenAmount);
        TEST11.approve(address(pool), tokenAmount);
        TEST12.approve(address(pool), tokenAmount);
        TEST13.approve(address(pool), tokenAmount);
        TEST14.approve(address(pool), tokenAmount);
        TEST15.approve(address(pool), tokenAmount);
        TEST16.approve(address(pool), tokenAmount);
        TEST17.approve(address(pool), tokenAmount);

        address[] memory shell1Addrs = new address[](3);
        shell1Addrs[0] = address(TEST1);
        shell1Addrs[1] = address(TEST2);
        shell1Addrs[2] = address(TEST3);

        address[] memory shell2Addrs = new address[](2);
        shell2Addrs[0] = address(TEST1);
        shell2Addrs[1] = address(TEST2);

        address[] memory shell3Addrs = new address[](11);
        shell3Addrs[0] = address(TEST1);
        shell3Addrs[1] = address(TEST2);
        shell3Addrs[2] = address(TEST3);
        shell3Addrs[3] = address(TEST4);
        shell3Addrs[4] = address(TEST5);
        shell3Addrs[5] = address(TEST6);
        shell3Addrs[6] = address(TEST7);
        shell3Addrs[7] = address(TEST8);
        shell3Addrs[8] = address(TEST9);
        shell3Addrs[9] = address(TEST10);
        shell3Addrs[10] = address(TEST11);
        // shell3Addrs[11] = address(TEST12);
        // shell3Addrs[12] = address(TEST13);
        // shell3Addrs[13] = address(TEST14);
        // shell3Addrs[14] = address(TEST15);

        address[] memory shell4Addrs = new address[](16);
        shell4Addrs[0] = address(TEST1);
        shell4Addrs[1] = address(TEST2);
        shell4Addrs[2] = address(TEST3);
        shell4Addrs[3] = address(TEST4);
        shell4Addrs[4] = address(TEST5);
        shell4Addrs[5] = address(TEST6);
        shell4Addrs[6] = address(TEST7);
        shell4Addrs[7] = address(TEST8);
        shell4Addrs[8] = address(TEST9);
        shell4Addrs[9] = address(TEST10);
        shell4Addrs[10] = address(TEST11);
        shell4Addrs[11] = address(TEST12);
        shell4Addrs[12] = address(TEST13);
        shell4Addrs[13] = address(TEST14);
        shell4Addrs[14] = address(TEST15);
        shell4Addrs[15] = address(TEST16);

        address[] memory shell5Addrs = new address[](17);
        shell5Addrs[0] = address(TEST1);
        shell5Addrs[1] = address(TEST2);
        shell5Addrs[2] = address(TEST3);
        shell5Addrs[3] = address(TEST4);
        shell5Addrs[4] = address(TEST5);
        shell5Addrs[5] = address(TEST6);
        shell5Addrs[6] = address(TEST7);
        shell5Addrs[7] = address(TEST8);
        shell5Addrs[8] = address(TEST9);
        shell5Addrs[9] = address(TEST10);
        shell5Addrs[10] = address(TEST11);
        shell5Addrs[11] = address(TEST12);
        shell5Addrs[12] = address(TEST13);
        shell5Addrs[13] = address(TEST14);
        shell5Addrs[14] = address(TEST15);
        shell5Addrs[15] = address(TEST16);
        shell5Addrs[16] = address(TEST17);

        shell1 = pool.createShell(shell1Addrs);
        shell2 = pool.createShell(shell2Addrs);
        shell3 = pool.createShell(shell3Addrs);
        shell4 = pool.createShell(shell4Addrs);
        shell5 = pool.createShell(shell5Addrs);

        pool.setMinCapital(10000 * (10 ** 18));

    }

    function testShellsCreated () public {

        uint shell1Balance1 = pool.getShellBalanceOf(shell1, address(TEST1));
        assertEq(shell1Balance1, 0);
        uint shell1Balance2 = pool.getShellBalanceOf(shell1, address(TEST2));
        assertEq(shell1Balance2, 0);
        uint shell1Balance3 = pool.getShellBalanceOf(shell1, address(TEST3));
        assertEq(shell1Balance3, 0);

        uint shell2Balance1 = pool.getShellBalanceOf(shell2, address(TEST1));
        assertEq(shell2Balance1, 0);
        uint shell2Balance2 = pool.getShellBalanceOf(shell2, address(TEST2));
        assertEq(shell2Balance2, 0);

        uint256 amounts = 100 * (10 ** 18);
        pool.depositLiquidity(shell1, amounts);
        pool.depositLiquidity(shell2, amounts);

        shell1Balance1 = pool.getShellBalanceOf(shell1, address(TEST1));
        assertEq(shell1Balance1, amounts);

        shell1Balance1 = pool.getShellBalanceOf(shell1, address(TEST1));
        assertEq(shell1Balance1, amounts);
        shell1Balance2 = pool.getShellBalanceOf(shell1, address(TEST2));
        assertEq(shell1Balance2, amounts);
        shell1Balance3 = pool.getShellBalanceOf(shell1, address(TEST3));
        assertEq(shell1Balance3, amounts);

        shell2Balance1 = pool.getShellBalanceOf(shell2, address(TEST1));
        assertEq(shell2Balance1, amounts);
        shell2Balance2 = pool.getShellBalanceOf(shell2, address(TEST2));
        assertEq(shell2Balance2, amounts);

    }

    function testActivateShells() public {

        uint256 amounts = 100000 * (10 ** 18);
        pool.depositLiquidity(shell1, amounts);
        pool.depositLiquidity(shell2, amounts);

        pool.activateShell(shell1);
        pool.activateShell(shell2);

        address[] memory oneToTwoAddresses = pool.getActiveShellsForPair(address(TEST1), address(TEST2));

        assertEq(oneToTwoAddresses.length, 2);

        assertEq(oneToTwoAddresses[0], shell1);
        assertEq(oneToTwoAddresses[1], shell2);

        address[] memory twoToOneAddresses = pool.getActiveShellsForPair(address(TEST2), address(TEST1));

        assertEq(twoToOneAddresses.length, 2);
        assertEq(twoToOneAddresses[0], shell1);
        assertEq(twoToOneAddresses[1], shell2);

        address[] memory oneToThreeAddresses = pool.getActiveShellsForPair(address(TEST1), address(TEST3));

        assertEq(oneToThreeAddresses.length, 1);
        assertEq(oneToThreeAddresses[0], shell1);

    }

    function testDuplicateShell () public {

        address[] memory shell1Addrs = new address[](3);
        shell1Addrs[0] = address(TEST1);
        shell1Addrs[1] = address(TEST2);
        shell1Addrs[2] = address(TEST3);

        bool isDuplicateShell = pool.isDuplicateShell(shell1Addrs);

        assert(isDuplicateShell);

    }

    function testActivateShellWithoutLiquidity () public {

        ( bool success, bytes memory returnData ) = address(pool).call(
                abi.encodePacked(
                    pool.activateShell.selector,
                    abi.encode(shell1)
                )
            );
        assert(!success);

    }

    function testDeactivateShell () public {

        uint256 amounts = 10000 * (10 ** 18);
        pool.depositLiquidity(shell1, amounts);
        pool.depositLiquidity(shell2, amounts);

        pool.activateShell(shell1);
        pool.activateShell(shell2);

        uint256 totalCapital1 = pool.getTotalShellCapital(shell1);
        emit log_named_uint("total cap#1", totalCapital1);

        pool.withdrawLiquidity(shell1, amounts * 3);
        pool.withdrawLiquidity(shell2, amounts * 2);

        uint256 totalCapital2 = pool.getTotalShellCapital(shell1);
        pool.deactivateShell(shell1);

        address[] memory activeShellsForPairAtoB = pool.getActiveShellsForPair(address(TEST1), address(TEST2));
        address[] memory activeShellsForPairBtoA = pool.getActiveShellsForPair(address(TEST2), address(TEST1));

        assertEq(activeShellsForPairAtoB.length, 1);
        assertEq(activeShellsForPairBtoA.length, 1);

        pool.deactivateShell(shell2);
        activeShellsForPairAtoB = pool.getActiveShellsForPair(address(TEST1), address(TEST2));
        activeShellsForPairBtoA = pool.getActiveShellsForPair(address(TEST2), address(TEST1));

        assertEq(activeShellsForPairAtoB.length, 0);
        assertEq(activeShellsForPairBtoA.length, 0);

    }

    function testDeactivateShellWithTonsOfTokens () public {

        uint256 amounts = 10000 * (10 ** 18);

        // pool.depositLiquidity(shell1, amounts);
        // pool.depositLiquidity(shell2, amounts);
        // pool.depositLiquidity(shell3, amounts);
        // pool.depositLiquidity(shell4, amounts);
        pool.depositLiquidity(shell5, amounts);

        // pool.activateShell(shell1);
        // pool.activateShell(shell2);
        pool.activateShell(shell3);
        // pool.activateShell(shell4);
        // pool.activateShell(shell5);

        address[] memory pair1to2_no1 = pool.getActiveShellsForPair(address(TEST1), address(TEST2));
        address[] memory pair2to1_no1 = pool.getActiveShellsForPair(address(TEST2), address(TEST1));

        assertEq(pair1to2_no1.length, 1);
        assertEq(pair2to1_no1.length, 1);

        // pool.withdrawLiquidity(shell3, amounts * 11);
        // pool.withdrawLiquidity(shell4, amounts * 16);
        pool.withdrawLiquidity(shell5, amounts * 17);

        // pool.deactivateShell(shell3);
        // pool.deactivateShell(shell4);
        pool.deactivateShell(shell5);

        // address[] memory pair1to2_no2 = pool.getActiveShellsForPair(address(TEST1), address(TEST2));
        // address[] memory pair2to1_no2 = pool.getActiveShellsForPair(address(TEST2), address(TEST1));

        // assertEq(pair1to2_no2.length, 2);
        // assertEq(pair2to1_no2.length, 2);

    }

    function testDeactivateShellWithTooMuchCapital () public {

        uint256 amounts = 1000000 * (10 ** 18);
        pool.depositLiquidity(shell1, amounts);
        ( bool success, bytes memory returnData ) = address(pool).call(
                abi.encodePacked(
                    pool.deactivateShell.selector,
                    abi.encode(shell1)
                )
            );
        assert(!success);

    }

}