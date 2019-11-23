pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "ds-math/math.sol";
import "./root.sol";

contract DappTest is DSTest, DSMath {

    bytes16 f_one;
    bytes16 f_two;
    bytes16 f_three;
    bytes16 f_half;

    bytes16 private constant magic_right = 0x407cfff7a3bea91d9b1b79d909f1f149;
    bytes16 private constant ten = 0x40202a05f20000000000000000000000;

    uint128 private constant magic_square = 0x1FFF7A3BF21E95ED3CAEDCF7BD3B5F51;
    uint128 private constant magic_cube = 0x2AA9F84FE36D22424A276B7ED41B75A7;
    uint128 private constant magic_quad = 0x2FFF3759DFDAC68A936C58EEAE9EE45C;
    uint128 private constant magic_quint = 0x33325D2CAA82F5E925C8E764FE8759FB;
    uint128 private constant magic_hex = 0x35547663DC486AD2DCB1465E89225311;
    uint128 private constant magic_eight = 0x37FF15E8DA7F3CF70153BD1676640A6B;
    uint128 private constant magic_fifteen = 0x3BBAC2097198C990016A634B28F33E50;

    function setUp () public {

    }

    // function newton (bytes16 g, bytes16 i, uint256 root, uint256 iterations) public pure returns (bytes16) {

    //     for (uint q = 0; q < iterations; q++) {

    //         bytes16 denominatorExp = g;
    //         bytes16 denominatorMultiplier = root.fromUInt();
    //         for (uint j = 1; j < root - 1; j++) denominatorExp = denominatorExp.mul(g);
    //         bytes16 numeratorExp = denominatorExp.mul(g);

    //         bytes16 fraction = numeratorExp.sub(i).div(denominatorExp .mul(denominatorMultiplier));

    //         g = g.sub(fraction);

    //     }

    //     return g;

    // }


    // function approximate2Root (uint256 base, uint256 root) public pure returns (uint256) {

    //     bytes16 sqr_f_x = base.fromUInt();
    //     uint128 sqr_int_x = uint128(sqr_f_x);
    //     uint128 sqr_int_x_magicked = magic_square + (sqr_int_x / uint128(root));
    //     bytes16 g = bytes16(sqr_int_x_magicked);
    //     g = newton(g, sqr_f_x, 2, 3);
    //     uint256 sqr_root = g.mul(ten).toUInt();
    //     return sqr_root;

    // }
    // function approximate3Root (uint256 base, uint256 root) public returns (uint256) {

    //     bytes16 cb_f_x = base.fromUInt();
    //     uint128 cb_int_x_for_magic = uint128(cb_f_x);
    //     uint128 cb_int_magicked = magic_cube + (cb_int_x_for_magic / uint128(3));
    //     bytes16 cb_f_magicked = bytes16(cb_int_magicked);
    //     uint256 cb_root = cb_f_magicked.mul(ten).toUInt();
    //     return cb_root;

    // }

    // function approximate4Root (uint256 base, uint256 root) public returns (uint256) {

    //     bytes16 qd_f_x = base.fromUInt();
    //     uint128 qd_int_x_for_magic = uint128(qd_f_x);
    //     uint128 qd_int_magicked = magic_quad + (qd_int_x_for_magic / uint128(4));
    //     bytes16 qd_f_magicked = bytes16(qd_int_magicked);
    //     uint256 qd_root = qd_f_magicked.mul(ten).toUInt();
    //     return qd_root;

    // }
    // function approximate5Root (uint256 base, uint256 root) public returns (uint256) {
    //     bytes16 qrt_f_x = base.fromUInt();
    //     uint128 qrt_int_x_for_magic = uint128(qrt_f_x);
    //     uint128 qrt_int_magicked = magic_quint + (qrt_int_x_for_magic / uint128(5));
    //     bytes16 qrt_f_magicked = bytes16(qrt_int_magicked);
    //     uint256 qrt_root = qrt_f_magicked.mul(ten).toUInt();
    //     return qrt_root;
    // }

    // function approximate6Root(uint256 base, uint256 root) public returns (uint256) {

    //     bytes16 hex_f_x = base.fromUInt();
    //     uint128 hex_int_x_for_magic = uint128(hex_f_x);
    //     uint128 hex_int_magicked = magic_hex + (hex_int_x_for_magic / uint128(6));
    //     bytes16 hex_f_magicked = bytes16(hex_int_magicked);
    //     uint256 hex_root = hex_f_magicked.mul(ten).toUInt();
    //     return hex_root;

    // }
    // function approximate8Root(uint256 base, uint256 root) public returns (uint256) {

    //     bytes16 oct_f_x = base.fromUInt();
    //     uint128 oct_int_x_for_magic = uint128(oct_f_x);
    //     uint128 oct_int_magicked = magic_eight + (oct_int_x_for_magic / uint128(8));
    //     bytes16 oct_f_magicked = bytes16(oct_int_magicked);
    //     uint256 oct_root = oct_f_magicked.mul(ten).toUInt();
    //     return oct_root;

    // }

    // function approximate15Root(uint256 base, uint256 root) public returns (uint256) {

    //     bytes16 fifteen_f_x = base.fromUInt();
    //     uint128 fifteen_int_x_for_magic = uint128(fifteen_f_x);
    //     uint128 fifteen_int_magicked = magic_fifteen + (fifteen_int_x_for_magic / uint128(15));
    //     bytes16 fifteen_f_magicked = bytes16(fifteen_int_magicked);
    //     uint256 fifteen_root = fifteen_f_magicked.mul(ten).toUInt();
    //     return fifteen_root;
    // }

    // function calculateConstantAndApproximateRoot (uint256 base, uint256 root) public pure returns (uint256) {

    //     bytes16 floatbase = base.fromUInt();
    //     bytes16 magic_left = (root - 1).fromUInt().div(root.fromUInt());
    //     uint256 magic = magic_left.mul(magic_right).toUInt();
    //     // emit log_named_uint("magic", magic);
    //     uint128 uintbase = uint128(floatbase);
    //     uintbase = uint128(magic) + (uintbase / uint128(root));
    //     bytes16 approximate = bytes16(uintbase);
    //     approximate = newton(approximate, floatbase, root, 3);
    //     return approximate.toUInt();

    // }

    event log_bytes16(bytes16);


    // function test_aprx_root () public {


        // uint256 ubase = 524152641342549;
        // bytes16 wad = Root.fromUInt(10**18);
        // emit  log_bytes16(wad);

        // for (uint i = 0; i < 200; i++) {
        //     ubase++;

            // bytes16 base = Root.fromUInt(ubase);
            // bytes16 root = Root.fast_aprx_root(base, 6);
            // uint256 uroot = Root.toUInt(Root.mul(root, wad));
            // uroot = refine_root(uroot, ubase * WAD, 6, 100);
            // emit log_named_uint("uroot", uroot);

        // }

        // bytes16 base = Root.fromUInt(ubase);
        // bytes16 root = Root.fast_aprx_root(base, 6);
        // uint256 uroot = Root.toUInt(Root.mul(root, wad));
        // uroot = uintNewton(uroot, ubase * WAD, 6, 100);
        // // root = Root.find_root(root, base, 15, 10);
        // // uint256 uroot = Root.toUInt(root);
        // emit log_named_uint("uroot", uroot);
        // uint256 uroot = Root.toUInt(broot);
        // emit log_named_uint("uroot", uroot);
        // uint256 uroot = Root.toUInt(Root.mul(root,))

    // }


    function refine_root (uint256 guess, uint256 base, uint256 root, uint256 max_iterations) public returns (uint256) {

        for (uint32 i = 0; i < max_iterations; i++) {

            uint256 guessed = wpow(guess, root);

            if (guessed / WAD == base / WAD) return guess;

            if (guessed < base) {
                uint256 divisor = sub(base, guessed);
                uint256 dividend = wmul(root, wpow(guess, root - 1));
                uint256 quotient = wdiv(divisor, dividend * WAD);
                guess = add(guess, quotient);
            } else {
                uint256 divisor = sub(guessed, base);
                uint256 dividend = wmul(root, wpow(guess, root - 1));
                uint256 quotient = wdiv(divisor, dividend * WAD);
                guess = sub(guess, quotient);
            }

        }

        return guess;
    }

    // function testRoot () public {

        // uint256 sq_rt = approximate2Root(69584350245632, 2);
        // emit log_named_uint("sq_rt", sq_rt);
        // uint256 sq_rt_calc_const = calculateConstantAndApproximateRoot(5241526413425413, 2);
        // emit log_named_uint("sq_rt_calc_const", sq_rt_calc_const);

        // uint256 cb_rt = approximate3Root(33760903168, 3);
        // emit log_named_uint("cb_rt", cb_rt);
        // uint256 cb_rt_calc_const = calculateConstantAndApproximateRoot(33760903168, 3);
        // emit log_named_uint("cb_rt_calc_const", cb_rt_calc_const);

        // uint256 qd_rt = approximate4Root(52204938256, 4);
        // emit log_named_uint("qd_rt", qd_rt);
        // uint256 qd_rt_calc_const = calculateConstantAndApproximateRoot(52204938256, 4);
        // emit log_named_uint("qd_rt_calc_const", qd_rt_calc_const);

        // uint256 qrt_rt = approximate5Root(86617093024, 5);
        // emit log_named_uint("qrt_rt", qrt_rt);
        // uint256 qrt_rt_calc_const = calculateConstantAndApproximateRoot(86617093024, 5);
        // emit log_named_uint("qrt_rt_calc_const", qrt_rt_calc_const);


        // uint256 hex_rt = approximate6Root(5654356432, 6);
        // emit log_named_uint("hex_rt", hex_rt);
        // uint256 hex_rt_calc_const = calculateConstantAndApproximateRoot(5654356432, 6);
        // emit log_named_uint("hex_rt_calc_const", hex_rt_calc_const);

        // uint256 oct_rt = approximate8Root(6543456543, 8);
        // emit log_named_uint("oct_rt", oct_rt);
        // uint256 oct_rt_calc_const = calculateConstantAndApproximateRoot(6543456543, 8);
        // emit log_named_uint("oct_rt_calc_const", oct_rt_calc_const);

        // uint256 fifteen_rt = approximate15Root(65432315599, 15);
        // emit log_named_uint("fifteen_rt", fifteen_rt);
        // uint256 fifteen_rt_calc_const = calculateConstantAndApproximateRoot(65432315599, 15);
        // emit log_named_uint("fifteen_rt_calc_const", fifteen_rt_calc_const);

    // }

}